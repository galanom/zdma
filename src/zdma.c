#define pr_fmt(fmt) "%s[%d] " fmt, __func__, __LINE__

#include <linux/module.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/slab.h>
#include <linux/timex.h>
#include <linux/miscdevice.h>

#include <linux/dma/xilinx_dma.h>
#include <linux/dmaengine.h>
#include <linux/dma-mapping.h>
#include <linux/dma-contiguous.h>
#include <linux/genalloc.h>
#include <linux/uaccess.h>
#include <linux/wait.h>
#include <linux/delay.h>
#include <linux/swab.h>
#include <linux/xz.h>
#include <linux/string.h>
#include <linux/soc/xilinx/xdevcfg.h>
#include <linux/cred.h>

#include <linux/of_dma.h>
#include <linux/of_address.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>
#include <linux/of_reserved_mem.h>

#include "param.h"
#include "glue.h"
#include "macro.h"
#include "zoled.h"

#ifndef CONFIG_OF
#error "OpenFirmware is not configured in kernel\n"
#endif

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Ioannis Galanommatis");
MODULE_DESCRIPTION("DMA client to xilinx_dma");
MODULE_VERSION("1.0");

bool debug = false;
module_param(debug, bool, 0);

enum zdma_system_state {
	SYS_DOWN = 0,
	SYS_INIT,
	SYS_UP,
	SYS_DEINIT,
};

enum zdma_client_state {
	CLIENT_OPENED = 0,
	CLIENT_CONFIGURED,
	CLIENT_MMAP_TX_DONE,
	CLIENT_MMAP_RX_DONE,
	CLIENT_READY,
	CLIENT_INPROGRESS,
	CLIENT_DONE,
	CLIENT_CLOSING,
	CLIENT_ERROR_CONFIG,
	CLIENT_ERROR_MMAP,
	CLIENT_ERROR_MEMORY,
	CLIENT_ERROR_DMA,
};

enum zdma_pblock_state {
	PBLOCK_FREE = 0,
	PBLOCK_BUSY,
};


enum zdma_core_csr {
	CORE_CSR_INIT = 0,
	CORE_CSR_START = 1<<0,
	CORE_CSR_DONE = 1<<1,
	CORE_CSR_IDLE = 1<<2,
	CORE_CSR_READY = 1<<3,
	CORE_CSR_AUTOSTART = 1<<7,
};

static struct system {
	enum zdma_system_state state;
	atomic_t	pblock_count,
			zone_count,
			client_count;
	spinlock_t	pblocks_lock,
			cores_lock,
			zones_lock,
			clients_lock;
	
	struct workqueue_struct *workqueue;

	struct zdma_pblock {
		atomic_t state,
			creation_age,
			access_age,
			hits,
			popularity;
		unsigned long id;
		spinlock_t lock;
		struct list_head node;
		struct zdma_core *core;
		phys_addr_t	pbase,
				psize;
		void __iomem	*vbase;
		struct dma_chan	*txchanp,
				*rxchanp;
	} pblocks;

	struct zdma_core {
		struct list_head node;
		char name[CORE_NAME_LEN];
		s8 priority;
		unsigned long availability;
		struct zdma_bitstream {
			struct list_head node;
			struct zdma_pblock *pblock;
			void *data;
			dma_addr_t dma_handle;
			size_t size;
		} bitstreams;
		spinlock_t bitstreams_lock;
	} cores;

	struct zdma_zone {
		struct list_head node;
		struct device dev;
		spinlock_t lock;
		unsigned bandwidth;
		unsigned long 
			reader_mask,
			writer_mask;
		atomic_long_t avail;
		atomic_t users;
		phys_addr_t phys;
		void	*start,
			*end;
		unsigned long map[0];

	} zones;

	struct zdma_client {
		int id;
		uid_t uid;
		atomic_t state;
		unsigned long req_affinity, eff_affinity;
		struct list_head node;
		struct zdma_core *core;
		u32 core_param[CORE_PARAM_CNT];
		int core_param_count;
		struct work_struct work;
		struct dma_channel {
			struct gen_pool_chunk *bank;
			dma_addr_t handle;
			size_t size;
			void *vaddr;
			struct dma_async_tx_descriptor *descp;
			struct dma_slave_config conf;
			dma_cookie_t cookie;
			struct completion cmp;
		} tx, rx;
	} clients;

	struct zdma_config {
		bool	clear_buffer,
			block_user_ioctl,
			sched_bestfit;
		struct zdma_pblock 
			*(*algo)(unsigned long mask),
			*(*victim_algo)(unsigned long mask);
		unsigned alloc_order;
		int (*alloc_score_func)(struct zdma_zone *, size_t, unsigned long);
		genpool_algo_t alloc_bitmap_algo;
	} config;

	struct device *devp;
	struct miscdevice miscdev;
	struct xz_dec *decompressor;
} sys;


static void sync_callback(void *completion)
{
	// Indicate the DMA transaction completed to allow the other thread to finish processing
	complete(completion);
	return;
}


struct zdma_core *core_lookup(char *name)
{
	struct zdma_core *core, *core_sel = NULL;
	rcu_read_lock();
	list_for_each_entry_rcu(core, &sys.cores.node, node) {
		if (strncmp(core->name, name, CORE_NAME_LEN) == 0) {
			core_sel = core;
			break;
		}
	}
	rcu_read_unlock();
	return core_sel;
}


struct zdma_pblock *pblock_lookup(unsigned long id)
{
	struct zdma_pblock *pblock, *pblock_sel = NULL;
	rcu_read_lock();
	list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
		if (pblock->id == id) {
			pblock_sel = pblock;
			break;
		}
	}
	rcu_read_unlock();
	return pblock_sel;

}

struct zdma_bitstream *bitstream_lookup_by_id(struct zdma_core *core, unsigned long id)
{
	struct zdma_bitstream *bitstream, *bitstream_sel = NULL;
	rcu_read_lock();
	list_for_each_entry_rcu(bitstream, &core->bitstreams.node, node) {
		if (bitstream->pblock->id == id) {
			bitstream_sel = bitstream;
			break;
		}
	}
	rcu_read_unlock();
	return bitstream_sel;
}


struct zdma_bitstream *bitstream_lookup_by_pointer(struct zdma_core *core, struct zdma_pblock *pblock)
{
	struct zdma_bitstream *bitstream, *bitstream_sel = NULL;
	rcu_read_lock();
	list_for_each_entry_rcu(bitstream, &core->bitstreams.node, node) {
		if (bitstream->pblock == pblock) {
			bitstream_sel = bitstream;
			break;
		}
	}
	rcu_read_unlock();
	return bitstream_sel;
}


static void zdma_debug(void)
{
	struct zdma_pblock *pblock;
	struct zdma_core *core;
	struct zdma_zone *zone;
	struct zdma_client *client;
	struct zdma_bitstream *bitstream;
	
	pr_info("------------------------------------------------------\n");
	rcu_read_lock();
	list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
		pr_info("PBLOCK %lu: core: %s, popularity: %d, state: %d\n", 
			__fls(pblock->id), pblock->core->name, 
			atomic_read(&pblock->popularity), 
			atomic_read(&pblock->state));
	}

	list_for_each_entry_rcu(core, &sys.cores.node, node) {
		pr_info("CORE %s: mask=0x%lx ", core->name, core->availability);
		list_for_each_entry_rcu(bitstream, &core->bitstreams.node, node)
			pr_cont("<%lu> ", __fls(bitstream->pblock->id));
		pr_cont("\n");
	}
	
	list_for_each_entry_rcu(zone, &sys.zones.node, node) {
		pr_info("MEM phys 0x%#x mapped at 0x%p, size: %u avail: %ld\n", 
			zone->phys,
			zone->start, 
			(zone->end - zone->start + 1)/Ki,
			atomic_long_read(&zone->avail)/Ki);
	}
	
	list_for_each_entry_rcu(client, &sys.clients.node, node) {
		pr_info("CLIENT %d: core: %s, mem: %#x->%#x, size: %zu->%zu KiB, state: %d\n",
			client->id, client->core->name, client->tx.handle, client->rx.handle,
			client->tx.size/Ki, client->rx.size/Ki, atomic_read(&client->state));
	}

	rcu_read_unlock();
	pr_info("------------------------------------------------------\n");
	return;
}


static int pblock_setup(struct zdma_pblock *pblock, struct zdma_core *core)
{
	struct zdma_bitstream *bitstream, *bitstream_sel = NULL;
	BUG_ON(IS_ERR_OR_NULL(pblock));
	BUG_ON(IS_ERR_OR_NULL(core));

	if (pblock->core == core)
		return 0;

	rcu_read_lock();
	list_for_each_entry_rcu(bitstream, &core->bitstreams.node, node) {
		if (bitstream->pblock == pblock) {
			bitstream_sel = bitstream;
			break;
		}
	}
	rcu_read_unlock();
	
	if (!bitstream_sel) {
		atomic_set(&pblock->state, PBLOCK_FREE);
		return -EEXIST;
	}

	int err = xdevcfg_program(bitstream_sel->dma_handle, bitstream_sel->size, true);
	if (err) {
		pr_crit("Error %d during FPGA reconfiguration!\n", err);
		return -EIO;
	}

	err = xilinx_dma_reset_intr(pblock->txchanp);
	if (err) {
		pr_crit("failed to initialize DMA controller -- system may hang after PR!\n");
		return -EIO;
	}

	atomic_set(&pblock->creation_age, 0);
	atomic_set(&pblock->access_age, 0);
	atomic_set(&pblock->hits, 2);
	pblock->core = core;
	return 0;
}


static struct zdma_pblock *algo_lp(unsigned long mask)
{
	struct zdma_pblock *pblock, *pblock_sel = NULL;
	int min_popularity = 999999;
	rcu_read_lock();
	list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
		if ((pblock->id & mask) == 0 || (atomic_read(&pblock->state) == PBLOCK_BUSY))
			continue;
		if (atomic_read(&pblock->popularity) <= min_popularity) {
			min_popularity = atomic_read(&pblock->popularity);
			pblock_sel = pblock;
		}
	}
	rcu_read_unlock();
	return pblock_sel;
}


static struct zdma_pblock *algo_lfu(unsigned long mask)
{
	struct zdma_pblock *pblock, *pblock_sel = NULL;
	int max_period = -1;
	rcu_read_lock();
	list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
		if ((pblock->id & mask) == 0 || (atomic_read(&pblock->state) == PBLOCK_BUSY))
			continue;
		int curr_period = atomic_read(&pblock->access_age) / atomic_read(&pblock->hits);
		if (curr_period > max_period) {
			pblock_sel = pblock;
			max_period = curr_period;
		}
	}
	rcu_read_unlock();
	return pblock_sel;
}


static struct zdma_pblock *algo_lru(unsigned long mask)
{
	struct zdma_pblock *pblock, *pblock_sel = NULL;
	int max_access_age = -1;
	rcu_read_lock();
	list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
		if ((pblock->id & mask) == 0 || (atomic_read(&pblock->state) == PBLOCK_BUSY))
			continue;
		if (atomic_read(&pblock->access_age) > max_access_age) {
			pblock_sel = pblock; 
			max_access_age = atomic_read(&pblock->access_age);
		}

	}
	rcu_read_unlock();
	return pblock_sel;
}


static struct zdma_pblock *algo_fifo(unsigned long mask)
{
	struct zdma_pblock *pblock, *pblock_sel = NULL;
	int max_creation_age = -1;
	rcu_read_lock();
	list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
		if ((pblock->id & mask) == 0 || (atomic_read(&pblock->state) == PBLOCK_BUSY))
			continue;
		if (atomic_read(&pblock->creation_age) > max_creation_age) {
			pblock_sel = pblock; 
			max_creation_age = atomic_read(&pblock->creation_age);
		}

	}
	rcu_read_unlock();
	return pblock_sel;
}


static struct zdma_pblock *algo_pri(unsigned long mask)
{
	struct zdma_pblock *pblock, *pblock_sel = NULL;
	int max_pri = -1, curr_pri = 1;
	rcu_read_lock();
	list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
		if ((pblock->id & mask) == 0 || (atomic_read(&pblock->state) == PBLOCK_BUSY))
			continue;
		if (pblock->core)
			curr_pri = pblock->core->priority;
		if (curr_pri > max_pri) {
			pblock_sel = pblock;
			max_pri = curr_pri;
		}
	}
	rcu_read_unlock();
	return pblock_sel;
}


static struct zdma_pblock *algo_first(unsigned long mask)
{
	struct zdma_pblock *pblock, *pblock_sel = NULL;
	rcu_read_lock();
	list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
		if ((pblock->id & mask) == 0 || (atomic_read(&pblock->state) == PBLOCK_BUSY))
			continue;
		pblock_sel = pblock;
		break;
	}
	rcu_read_unlock();
	return pblock_sel;
}


static struct zdma_pblock *pblock_reserve(struct zdma_client *client)
{
//	struct zdma_core *core = client->core;
	struct zdma_pblock *pblock, *pblock_sel = NULL;

	rcu_read_lock();
	list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
		if (pblock->core) {
			atomic_add(pblock->core->priority, &pblock->creation_age);
			atomic_add(pblock->core->priority, &pblock->access_age);
		}
	}
	rcu_read_unlock();

	do {
		// at first, try to lock an already running core
		unsigned long same_core = 0ul;
		rcu_read_lock();
		list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
			if (pblock->core == client->core)
				same_core |= pblock->id;
		}
		pblock_sel = sys.config.algo(same_core & client->eff_affinity);
		rcu_read_unlock();
		//pr_info("called with same mask=%lx, effaff=%lx\n", same_core, client->eff_affinity);
		
		// if a free pblock with the requested core was found,
		// attempt to lock it and exit the loop
		if (pblock_sel) {
			if (atomic_cmpxchg(&pblock_sel->state, PBLOCK_FREE, PBLOCK_BUSY) == PBLOCK_FREE) {
				atomic_inc(&pblock_sel->hits);
				break;
			} else {	// another client grabbed the pblock since last check
				pblock_sel = NULL; // TODO check if a redo is worth the effort
			}
		}
		
		// if there was no pblock with the requested core,
		// or if it was not free, try to find a free pblock
		// to reconfigure it with our new core
		pblock_sel = sys.config.victim_algo(client->core->availability & client->eff_affinity);

		// If the chosen pblock got locked since initial check
		// in previous lock, release it. This will never happen.
		if (pblock_sel && atomic_cmpxchg(&pblock_sel->state, PBLOCK_FREE, PBLOCK_BUSY) != PBLOCK_FREE)
			pblock_sel = NULL;
			

		// if we found a free pblock, try to program it if a bitstream is available
		// FIXME unecessary performance penalty if a core is not loadable on all cores
		if (pblock_sel) {
			if (debug)
				pr_info("programming pblock %lu, creation age %d, access age %d, pop %d, core %s->%s\n", 
					__fls(pblock_sel->id), 
					atomic_read(&pblock_sel->creation_age), 
					atomic_read(&pblock_sel->access_age), 
					atomic_read(&pblock_sel->popularity),
					pblock_sel->core->name, 
					client->core->name);
			int err = pblock_setup(pblock_sel, client->core);
			BUG_ON(err);
		}
		
		// either no free pblock or no bitstream for the chosen pblock
		// concede cpu to other task to wait a bit and then redo from start
		if (pblock_sel == NULL) 
			schedule();
	} while (pblock_sel == NULL);

	atomic_set(&pblock_sel->access_age, 0);

	return pblock_sel;
}


static void pblock_release(struct zdma_pblock *pblock)
{
	atomic_set(&pblock->state, PBLOCK_FREE);
	return;
}

static int allocator_score_default(
	struct zdma_zone *zone, size_t req_size, unsigned long affinity)
{
	int	memory_availability = atomic_long_read(&zone->avail) / req_size,
		schedulability = hweight_long(affinity),
		zone_occupancy = atomic_read(&zone->users),
		score;
	if (schedulability == 0 || !memory_availability)
		score = 0;
	else
		score = (zone->bandwidth/(1+zone_occupancy)) * (memory_availability/8 + schedulability);
	
	if (debug)
		pr_info("bw: %d, occ: %d, mem_av: %d, sch: %d, final score = %d\n",
			zone->bandwidth, zone_occupancy, memory_availability, schedulability, score);
	
	return score;
}


void *allocator_reserve(size_t size, enum dma_data_direction dir,
	unsigned long *client_affinity, unsigned long core_availability, dma_addr_t *handle)
{
	struct zdma_zone *zone, *zone_sel = NULL, *zone_prev = NULL;
	unsigned long pblock_affinity, pblock_affinity_sel;
	int score, score_prev = 0, score_max = 0;
	bool found_prev = false;
	int	start_bit, end_bit,
		nbits = (size + (1ul << sys.config.alloc_order) - 1) >> sys.config.alloc_order;

	for (int i = 0; i < atomic_read(&sys.zone_count); ++i) {
		rcu_read_lock();
		list_for_each_entry_rcu(zone, &sys.zones.node, node) {
			if (zone == zone_prev) {
				found_prev = true;
				continue;
			}

			pblock_affinity = dir == DMA_TO_DEVICE ? zone->reader_mask
				: dir == DMA_FROM_DEVICE ? zone->writer_mask
				: zone->reader_mask & zone->writer_mask;
			if (debug)
				pr_info("passing affinity pblockaffz=%lx (dir=%d, reader=%lx, writer=%lx), client=%lx, coreavail=%lx\n",
				pblock_affinity, 
				dir, zone->reader_mask, zone->writer_mask,
				*client_affinity, core_availability);
			score = sys.config.alloc_score_func(zone, size, 
				pblock_affinity & *client_affinity & core_availability);

			if (score == score_prev && found_prev) {
				zone_sel = zone;
				break;
			}

			if (score > score_max) {
				score_max = score;
				zone_sel = zone;
				pblock_affinity_sel = pblock_affinity;
			}
		}
		rcu_read_unlock();

		// if no eligible zone was found, abort
		if (!zone_sel)
			break;

		if (debug)
			pr_info(">>>>>>>>>>> SELECTED ZONE %x, score %u\n", zone_sel->phys, score);

		// perform the allocation (modified from Linux genalloc.c)
		end_bit = (zone_sel->end - zone_sel->start + 1) >> sys.config.alloc_order;

		spin_lock(&zone_sel->lock);
		start_bit = sys.config.alloc_bitmap_algo(zone_sel->map, 
			end_bit, 0 /*start_bit*/, nbits, NULL, NULL);
		if (start_bit >= end_bit) {
			spin_unlock(&zone_sel->lock);
			zone_prev = zone_sel;
			score_prev = score_max;
			zone_sel = NULL;
			continue;
		}
		
		bitmap_set(zone_sel->map, start_bit, nbits);
		spin_unlock(&zone_sel->lock);
		break;
	}

	if (!zone_sel)
		return NULL;

	atomic_long_sub(nbits << sys.config.alloc_order, &zone_sel->avail);
	atomic_inc(&zone_sel->users);
	#pragma GCC diagnostic push
	#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
	*client_affinity &= pblock_affinity_sel;
	off_t offset = (unsigned long)start_bit << sys.config.alloc_order;
	*handle = zone_sel->phys + offset;
	return zone_sel->start + offset;
	#pragma GCC diagnostic pop
}

void allocator_free(void *buf, size_t size)
{
	struct zdma_zone *zone;
	if (sys.config.clear_buffer)
		memset(buf, 0x00, size);

	int nbits = (size + (1ul << sys.config.alloc_order) - 1) >> sys.config.alloc_order;

	rcu_read_lock();
	list_for_each_entry_rcu(zone, &sys.zones.node, node) {
		if (buf >= zone->start && buf <= zone->end) {
			int start_bit = 
				((unsigned long)buf - (unsigned long)zone->start) 
				>> sys.config.alloc_order;
			BUG_ON(buf + size - 1 > zone->end);
			bitmap_clear(zone->map, start_bit, nbits);
			atomic_long_add(nbits << sys.config.alloc_order, &zone->avail);
			atomic_dec(&zone->users);
			break;
		}
	}
	rcu_read_unlock();
}

static int allocator(struct zdma_client *p, size_t tx_size, size_t rx_size)
{
	if (sys.state != SYS_UP)
		return -EBUSY;	
	
	void *tx_vaddr, *rx_vaddr;
	dma_addr_t tx_handle, rx_handle;
	struct zdma_pblock *pblock;
	
	if (p->tx.vaddr || p->rx.vaddr) {
		rcu_read_lock();
		list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
			if (pblock->id & p->core->availability & p->eff_affinity)
				atomic_dec(&pblock->popularity);
		}
		rcu_read_unlock();
	}

	if (p->tx.vaddr) {
		allocator_free(p->tx.vaddr, p->tx.size);
		p->tx.vaddr = NULL;
		p->tx.size = 0;
	}
	if (p->rx.vaddr) {
		allocator_free(p->rx.vaddr, p->rx.size);
		p->rx.vaddr = NULL;
		p->rx.size = 0;
	}

	// first, allocate reader
	if (tx_size) {
		BUG_ON(p->core == NULL);
		tx_vaddr = allocator_reserve(tx_size, DMA_TO_DEVICE, &p->eff_affinity, p->core->availability, &tx_handle);
		if (!tx_vaddr) {
			pr_warn("unable to allocate %zu bytes for TX buffer\n", tx_size);
			return -ENOMEM;
		}
	}
	#pragma GCC diagnostic push
	#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"

	// secondly, allocate writer
	if (rx_size) {
		rx_vaddr = allocator_reserve(rx_size, DMA_FROM_DEVICE, &p->eff_affinity, p->core->availability, &rx_handle);
		if (!rx_vaddr) {
			// RX allocation failed -- try allocating RX first and then TX
			if (!tx_size)
				return -ENOMEM;	// there was no TX allocation
			
			allocator_free(tx_vaddr, tx_size);
			
			rx_vaddr = allocator_reserve(rx_size, DMA_FROM_DEVICE, &p->eff_affinity, p->core->availability, &rx_handle);
			if (!rx_vaddr) {
			pr_warn("unable to allocate %zu bytes for RX buffer\n", rx_size);
				// RX allocation failed again, giving up
				return -ENOMEM;
			}

			tx_vaddr = allocator_reserve(tx_size, DMA_TO_DEVICE, &p->eff_affinity, p->core->availability, &tx_handle);
			if (!tx_vaddr) {
				pr_warn("unable to allocate %zu bytes for TX buffer, 2\n", tx_size);
				// RX succeeded but now TX failed. Abort.
				allocator_free(rx_vaddr, rx_size);
				return -ENOMEM;
			}
		}
	}

	// everything is ok, register the allocation
	if (sys.config.clear_buffer) {
		if (tx_size)
			memset(tx_vaddr, 0x00, tx_size);
		if (rx_size)
			memset(rx_vaddr, 0x00, rx_size);
	}
	p->tx.vaddr = tx_vaddr;
	p->rx.vaddr = rx_vaddr;
	p->tx.handle = tx_handle;
	p->rx.handle = rx_handle;
	p->tx.size = tx_size;
	p->rx.size = rx_size;
	#pragma GCC diagnostic pop

	rcu_read_lock();
	list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
		if (pblock->id & p->core->availability & p->eff_affinity)
			atomic_inc(&pblock->popularity);
	}
	rcu_read_unlock();

	return 0;
}

static int pblock_add(struct device_node *np)
{
	int err = 0;
	if (sys.state != SYS_INIT) return -EBUSY;

	struct zdma_pblock *pblock = devm_kzalloc(sys.devp, sizeof(struct zdma_pblock), GFP_KERNEL);
	if (unlikely(pblock == NULL)) {
		pr_err("unable to allocate %zu bytes for pblock description structure\n", 
			sizeof(*pblock));
		return -ENOMEM;
	}
	spin_lock_init(&pblock->lock);
	
	atomic_set(&pblock->state, PBLOCK_FREE);
	char *pblock_name = strrchr(of_node_full_name(np), '/') + 1;
	int id;
	err = kstrtoint(strrchr(of_node_full_name(np), '@') + 1, 10, &id);
	if (err) {
		pr_err("devicetree: error parsing pblock address unit, %s\n", pblock_name);
		return -EINVAL;
	}
	pblock->id = 1ul << id;
	pr_info("adding pblock %d (%s)\n", id, pblock_name);


	// discover the DMA controller responsible for the core of this pblock
	struct device_node *dma_client_np = of_parse_phandle(np, "transport", 0);
	if (!dma_client_np) {
		pr_err("devicetree: pblock %d does not contain a phandle to a data transporter.\n", id);
		err = -EINVAL;
		goto pblock_add_error;
	}

	// configure the DMA controller for this pblock
	pblock->txchanp = of_dma_request_slave_channel(dma_client_np, "tx");
	if (IS_ERR_OR_NULL(pblock->txchanp)) {
		pr_err("pblock %d: failed to reserve TX DMA channel -- devicetree misconfiguration, "
			"DMA controller not present or driver not loaded.\n", id);
		err = -ENODEV;
		goto pblock_add_error;
	}

	pblock->rxchanp = of_dma_request_slave_channel(dma_client_np, "rx");
	if (IS_ERR_OR_NULL(pblock->rxchanp)) {
		pr_err("pblock %d: failed to reserve RX DMA channel -- devicetree misconfiguration, "
			"DMA controller not present or driver not loaded.\n", id);
		dma_release_channel(pblock->txchanp);
		err = -ENODEV;
		goto pblock_add_error;
	}

	// discover the core's configuration address space
	struct device_node *core_np = of_parse_phandle(np, "core", 0);
	if (!core_np) {
		pr_err("devicetree: pblock %d does not contain a phandle to a core definition.\n", id);
		goto pblock_add_error_late;
	}

	// configure the pblock's register space
	u64 size;
	const __be32 * addr;
	pblock->pbase = of_translate_address(core_np, addr = of_get_address(core_np, 0, &size, NULL));
	pblock->psize = (size_t)size;
	if (pblock->pbase == (long)OF_BAD_ADDR || !size) {
		pr_err("devicetree: pblock %d: range entry is invalid:\n"
			"base: %p, translated: %#zx, size: %#llx.\n", 
			id, addr, pblock->pbase, size);
		err = -EINVAL;
		goto pblock_add_error_late;
	}

	if (!devm_request_mem_region(sys.devp, pblock->pbase, pblock->psize, pblock_name)) {
		pr_err("%s: failed to reserve I/O space at %#zx, size: %#zx\n", 
			pblock_name, pblock->pbase, pblock->psize);
		err = -ENOSPC;
		goto pblock_add_error_late;
	}
	pblock->vbase = devm_ioremap(sys.devp, pblock->pbase, pblock->psize);
	if (!pblock->vbase) {
		pr_err("%s: failed to map I/O space\n", pblock_name);
		err = -ENOSPC;
		goto pblock_add_error_late;
	}
	atomic_set(&pblock->creation_age, 0);
	atomic_set(&pblock->access_age, 0);
	atomic_set(&pblock->popularity, 0);
	atomic_set(&pblock->hits, 1);

	// now add the pblock to the list
	spin_lock(&sys.pblocks_lock);
	list_add_tail_rcu(&pblock->node, &sys.pblocks.node);
	spin_unlock(&sys.pblocks_lock);
	atomic_inc(&sys.pblock_count);
	return 0;
pblock_add_error_late:
	dma_release_channel(pblock->txchanp);
	dma_release_channel(pblock->rxchanp);
pblock_add_error:
	devm_kfree(sys.devp, pblock);
	return err;	
}


static int zone_add(struct device_node *np)
{
	struct device_node *tnp;

	// find out the physical address and size of the zone
	tnp = of_parse_phandle(np, "memory-region", 0);
	if (!tnp) {
		pr_err("devicetree: memory region %d does not contain a phandle to a memory bank\n",
			atomic_read(&sys.zone_count));
		return -ENODEV;
	}
	u64 size;
	phys_addr_t paddr = of_translate_address(tnp, of_get_address(tnp, 0, &size, NULL));
	of_node_put(tnp);

	// FIXME leak on error
	struct zdma_zone *zone = devm_kzalloc(sys.devp, 
		sizeof(struct zdma_zone) + sizeof(long)*BITS_TO_LONGS(size >> sys.config.alloc_order), GFP_KERNEL);
	if (unlikely(zone == NULL)) {
		pr_err("unable to allocate %zu bytes for zone description\n",
			sizeof(struct zdma_zone) + (size_t)BITS_TO_LONGS(size >> sys.config.alloc_order));
		return -ENOMEM;
	}
	

	// discover memory zone connectivity
	int err, id;
	int readers = 0, writers = 0;

	while ((tnp = of_parse_phandle(np, "readers", readers++))) {
		err = kstrtoint(strrchr(of_node_full_name(tnp), '@') + 1, 10, &id);
		BUG_ON(err);
		zone->reader_mask |= 1ul << id;
		of_node_put(tnp);
	}

	while ((tnp = of_parse_phandle(np, "writers", writers++))) {
		err |= kstrtoint(strrchr(of_node_full_name(tnp), '@') + 1, 10, &id);
		BUG_ON(err);
		zone->writer_mask |= 1ul << id;
		of_node_put(tnp);
	}
	if (err)
		return -EINVAL;

	err = of_property_read_u32(np, "bandwidth", &zone->bandwidth);
	if (err)
		return err;

	// create pseudo device structure -- FIXME will be leaked on error!!!
	device_initialize(&zone->dev);
	dev_set_name(&zone->dev, "%s@%p", "zone", zone);
	zone->dev.parent		= sys.devp; // do not inherit bus!
	zone->dev.coherent_dma_mask	= sys.devp->coherent_dma_mask;
	zone->dev.dma_mask		= sys.devp->dma_mask;
	zone->dev.release		= of_reserved_mem_device_release;
	int res = device_add(&zone->dev);
	if (res != 0) {
		pr_err("error %d while registering device for zone %p\n", res, zone);
		return res;
	}

	// seek to desired zone...
	if (of_reserved_mem_device_init_by_idx(&zone->dev, np, 0)) {
		pr_err("error: cannot initialize detected zone reserved memory!\n");
		return -ENOMEM;
	}

	dma_addr_t handle;
	zone->start = dmam_alloc_coherent(&zone->dev, size, &handle, GFP_KERNEL);
	if (!zone->start) {
		pr_err("error: cannot claim reserved memory of size %lluKiB\n", size/Ki);
		return -ENOMEM;
	}
	if (handle != phys_to_dma(&zone->dev, paddr)) {
		pr_crit("\n"
		"***              ARCHITECTURE INCOMPATIBILITY              ***\n"
		"*** The DMA addresses are different from physical address! ***\n"
		"*** In Xilinx Zynq UltraScale+ (Cortex-A53, ARM64) it may  ***\n"
		"*** have been caused by an IOMMU remapping of DMA space.   ***\n"
		"*** In Xilinx Zynq 7000 (Cortex-A9, ARM32) this should not ***\n"
		"*** really be happening due to the lack of IOMMU hardware. ***\n"
		"*** Current version of this driver is not tested for such  ***\n"
		"*** a configuration. Use at your own risk.                 ***\n");
	}
	zone->phys = paddr;
	zone->end = zone->start + size - 1;
	atomic_long_set(&zone->avail, size);
	atomic_set(&zone->users, 0);
	spin_lock_init(&zone->lock);
	pr_info("created zone @%zx %p-%p\n", zone->phys, zone->start, zone->end);

	spin_lock(&sys.zones_lock);
	list_add_tail_rcu(&zone->node, &sys.zones.node);
	spin_unlock(&sys.zones_lock);
	atomic_inc(&sys.zone_count);
	
	return 0;
}


static void dma_issue(struct work_struct *work)
{
	s32 ret;
	struct zdma_client *p = container_of(work, struct zdma_client, work);
	atomic_set(&p->state, CLIENT_INPROGRESS);

	struct zdma_pblock *pblock = pblock_reserve(p);

	u32 csr;
	iowrite32(CORE_CSR_INIT, pblock->vbase + CORE_CSR);
	csr = ioread32(pblock->vbase + CORE_CSR);
	if (!(csr & CORE_CSR_IDLE)) {
		pr_emerg("core %s/%lu is in an unexpected state: "
			"ap_idle is not asserted. CSR=%x\n",
			p->core->name, __fls(pblock->id), csr);
		goto dma_error;
	}

	for (int i = 0; i < p->core_param_count; ++i) {
		/*pr_info("pblock: %lu, reg: %zu, val: %zu\n", __fls(pblock->id),
			CORE_PARAM_BASE + i*CORE_PARAM_STEP, p->core_param[i]);*/
		iowrite32(p->core_param[i], pblock->vbase + CORE_PARAM_BASE + i*CORE_PARAM_STEP);
	}
	iowrite32(CORE_CSR_START, pblock->vbase + CORE_CSR); // ap_start = 1
//	udelay(100);
//	csr = ioread32(pblock->vbase + CORE_CSR);
//	if (debug)
//		pr_info("core sent init CSR, reply val %x\n", csr);
	
	if ((p->tx.descp = dmaengine_prep_slave_single(
			pblock->txchanp, p->tx.handle, p->tx.size, 
			DMA_MEM_TO_DEV, DMA_CTRL_ACK|DMA_PREP_INTERRUPT)) == NULL) {

		pr_err("failed to prepare TX DMA chan 0x%p, handle %#zx, size %zuKiB\n", 
			pblock->txchanp, p->tx.handle, p->tx.size/Ki);
		p->tx.cookie = -EBUSY;

		goto dma_error;
	}
	
	if ((p->rx.descp = dmaengine_prep_slave_single(
			pblock->rxchanp, p->rx.handle, p->rx.size,
			DMA_DEV_TO_MEM, DMA_CTRL_ACK|DMA_PREP_INTERRUPT)) == NULL) {

		pr_err("failed to prepare RX DMA chan 0x%p, handle %#zx, size %zuKiB\n", 
			pblock->rxchanp, p->rx.handle, p->rx.size/Ki);

		p->rx.cookie = -EBUSY;
		goto dma_error;
	}
	/*if (debug)
		pr_info("%s/%lu: channels %p->%p, handles %zx->%zx\n", 
			p->core->name, __fls(pblock->id),
			pblock->txchanp, pblock->rxchanp, p->tx.handle, p->rx.handle);*/

	p->tx.descp->callback = p->rx.descp->callback = sync_callback;
	p->tx.descp->callback_param = &p->tx.cmp;
	p->rx.descp->callback_param = &p->rx.cmp;

	p->tx.cookie = dmaengine_submit(p->tx.descp);
	p->rx.cookie = dmaengine_submit(p->rx.descp);

	if (dma_submit_error(p->tx.cookie) || dma_submit_error(p->rx.cookie)) {
		pr_err("cookie contains error!\n");
		goto dma_error;
	}
	
	// initialize the completion before using it and then start the DMA transaction
	// which was previously queued up in the DMA engine
	init_completion(&p->tx.cmp);
	init_completion(&p->rx.cmp);

	unsigned long	tx_timeout = msecs_to_jiffies(2000),
			rx_timeout = msecs_to_jiffies(2000);

	dma_async_issue_pending(pblock->txchanp);
	dma_async_issue_pending(pblock->rxchanp);

	tx_timeout = wait_for_completion_timeout(&p->tx.cmp, tx_timeout);
	rx_timeout = wait_for_completion_timeout(&p->rx.cmp, rx_timeout);
	
	struct dma_tx_state /*tx_state,*/ rx_state;
	enum dma_status 
		rx_status = dmaengine_tx_status(pblock->rxchanp, p->rx.cookie, &rx_state);
	
	// determine if the transaction completed without a timeout and withtout any errors
	if (!rx_timeout) {
		pr_crit("*** DMA operation timed out for core %s/%lu, client %d.\n",
			pblock->core->name, __fls(pblock->id), p->id);
		//	!tx_timeout && !rx_timeout ? "TX and RX" :
		//	!tx_timeout ? "TX" : "RX");
			//goto dma_error;
	}

	if (rx_status != DMA_COMPLETE) {
		pr_crit("*** DMA status at %s/%lu, client %d: "
			"%s [res %u] ***\n", 
			pblock->core->name, __fls(pblock->id), p->id,
	//		tx_status == DMA_ERROR ? "ERROR" : 
	//		tx_status == DMA_IN_PROGRESS ? "IN PROGRESS" : "PAUSED",
	//		tx_state.residue,
			rx_status == DMA_ERROR ? "ERROR" : 
			rx_status == DMA_IN_PROGRESS ? "IN PROGRESS" : "PAUSED",
			rx_state.residue);

		goto dma_error;
	}
	
	// mostly debug, register somewhere a non-zero
	ret = ioread32(pblock->vbase + CORE_PARAM_RET);
	if (ret < 0)
		pr_warn("core %s/%lu return value %d\n", p->core->name, __fls(pblock->id), ret);

	csr = ioread32(pblock->vbase + CORE_CSR);
	if (!(csr & CORE_CSR_DONE)) {
		pr_emerg("core %s/%lu is in an unexpected state: ap_done is "
			"not asserted. CSR=%x\n", p->core->name, __fls(pblock->id), csr);
		goto dma_error;
	}
	
	atomic_set(&p->state, CLIENT_READY);
	pblock_release(pblock);
	return;

dma_error:
	atomic_set(&p->state, CLIENT_ERROR_DMA);
	pblock_release(pblock);
	zoled_print("!\n");
	return;
}


static int dev_open(struct inode *inodep, struct file *filep)
{
	static atomic_t id = ATOMIC_INIT(0);
	if (sys.state != SYS_UP) return -EAGAIN;
	struct zdma_client *p;
	if ((p = filep->private_data = devm_kzalloc(sys.devp, 
			sizeof(struct zdma_client), GFP_KERNEL)) == NULL) {
		pr_err("error allocating memory for client private data!\n");
		return -ENOMEM;
	}
	INIT_WORK(&p->work, dma_issue);
	p->uid = current_uid().val;
	spin_lock(&sys.clients_lock);
	list_add_tail_rcu(&p->node, &sys.clients.node);
	spin_unlock(&sys.clients_lock);
	atomic_inc(&sys.client_count);
	p->id = atomic_inc_return(&id);
	return 0;
}


static int dev_release(struct inode *inodep, struct file *filep)
{
	struct zdma_client *p = filep->private_data;
	struct zdma_pblock *pblock;

	rcu_read_lock();
	list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
		if (p->core == NULL)
			continue;
		if (pblock->id & p->core->availability & p->eff_affinity)
			atomic_dec(&pblock->popularity);
	}
	rcu_read_unlock();
	
	flush_work(&p->work);
	if (p->tx.vaddr)
		allocator_free(p->tx.vaddr, p->tx.size);
	if (p->rx.vaddr)
		allocator_free(p->rx.vaddr, p->rx.size);

	spin_lock(&sys.clients_lock);
	list_del_rcu(&p->node);
	spin_unlock(&sys.clients_lock);
	synchronize_rcu(); // TODO learn what this does and also call_rcu
	
	devm_kfree(sys.devp, p);
	atomic_dec(&sys.client_count);
	return 0;
}


static long dev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
{
	struct zdma_core *core;
	struct zdma_bitstream *bitstream = NULL;
	struct zdma_core_config core_conf;
	struct zdma_client_config client_conf;
	struct zdma_client *p = NULL;
	if (filep) 
		p = filep->private_data;

	switch (cmd) {
	case ZDMA_DEBUG:
		zdma_debug();
		break;
	case ZDMA_BARRIER:
		pr_info("flushing queue\n");
		flush_workqueue(sys.workqueue);
		break;
	case ZDMA_CONFIG:
		if (sys.config.block_user_ioctl && !capable(CAP_SYS_ADMIN))
			return -EACCES;

		switch (arg) {
		case CONFIG_ALLOC_BITMAP_FIRST_FIT:
			sys.config.alloc_bitmap_algo = gen_pool_first_fit;
			break;
		case CONFIG_ALLOC_BITMAP_BEST_FIT:
			sys.config.alloc_bitmap_algo = gen_pool_best_fit;
			break;
		case CONFIG_ALLOC_ZONE_DEFAULT:
			sys.config.alloc_score_func = allocator_score_default;
			break;
		case CONFIG_SECURITY_IOCTL_ALLOW_USER:
			sys.config.block_user_ioctl = false;
			break;
		case CONFIG_SECURITY_IOCTL_BLOCK_USER:
			sys.config.block_user_ioctl = true;
			break;
		case CONFIG_SECURITY_BUFFER_KEEP:
			sys.config.clear_buffer = false;
			break;
		case CONFIG_SECURITY_BUFFER_CLEAR:
			sys.config.clear_buffer = true;
			break;
		case CONFIG_SCHED_BEST_FIT:
			sys.config.algo = algo_lp;
			break;
		case CONFIG_SCHED_FIRST_FIT:
			sys.config.algo = algo_first;
			break;
		case CONFIG_SCHED_VICTIM_FIRST:
			sys.config.victim_algo = algo_first;
			break;
		case CONFIG_SCHED_VICTIM_PRI:
			sys.config.victim_algo = algo_pri;
			break;
		case CONFIG_SCHED_VICTIM_LP:
			sys.config.victim_algo = algo_lp;
			break;
		case CONFIG_SCHED_VICTIM_FIFO:
			sys.config.victim_algo = algo_fifo;
			break;
		case CONFIG_SCHED_VICTIM_LRU:
			sys.config.victim_algo = algo_lru;
			break;
		case CONFIG_SCHED_VICTIM_LFU:
			sys.config.victim_algo = algo_lfu;
			break;
		default:
			return -ENOTTY;	
		};
		break;
	case ZDMA_CORE_REGISTER:
		if (sys.config.block_user_ioctl && !capable(CAP_SYS_ADMIN))
			return -EACCES;
		if (copy_from_user(&core_conf, (void __user *)arg, sizeof(core_conf))) {
			pr_err("could not read all configuration data, ioctl ignored\n");
			return -EIO;
		}

		core = core_lookup(core_conf.name);
		
		if (core == NULL) {
			core = devm_kmalloc(sys.devp, sizeof(struct zdma_core), GFP_KERNEL);
			if (core == NULL) {
				pr_err("could allocate memory for core descriptor\n");
				return -ENOMEM;
			}
			strncpy(core->name, core_conf.name, CORE_NAME_LEN);
			core->priority = core_conf.priority;
			core->availability = 0;
			spin_lock_init(&core->bitstreams_lock);
			INIT_LIST_HEAD(&core->bitstreams.node);
			spin_lock(&sys.cores_lock);
			list_add_tail_rcu(&core->node, &sys.cores.node);
			spin_unlock(&sys.cores_lock);
		} else {
			if (core->availability & core_conf.pblock) {
				//pr_warn("this bitstream is already registered for this core\n");
				return -EEXIST;
			}
		}

		bitstream = devm_kmalloc(sys.devp, sizeof(struct zdma_bitstream), GFP_KERNEL);
		if (!bitstream) {
			pr_err("could not allocate %zu bytes for bitstream %s/%lu structures\n",
				sizeof(struct zdma_bitstream), core_conf.name, core_conf.pblock);
			return -ENOMEM;
		}
		
		bitstream->pblock = pblock_lookup(core_conf.pblock);
		if (!bitstream->pblock) {
			pr_warn("core %s contains bitstream for pblock id %lu that does not exist, ignoring.\n",
				core_conf.name, __fls(core_conf.pblock));
			devm_kfree(sys.devp, bitstream);
			return -ENODEV;
		}
		
		bitstream->size = core_conf.size;
		void *buffer = devm_kmalloc(sys.devp, core_conf.size, GFP_KERNEL);
		if (!buffer) {
			pr_err("could not allocate %zu bytes for compressed bitstream %s/%lu data\n",
				core_conf.size, core_conf.name, __fls(core_conf.pblock));
			devm_kfree(sys.devp, bitstream);
			return -ENOMEM;
		}
		if (copy_from_user(buffer, (void __user *)core_conf.bitstream, core_conf.size)) {
			pr_err("could not load user bitstream to kernel memory\n");
			return -EIO;
		}

		bitstream->data = dmam_alloc_coherent(sys.devp, PARTIAL_SIZE_MAX, &bitstream->dma_handle, GFP_KERNEL);
		if (!bitstream->data) {
			pr_err("could not allocate %zu bytes for bitstream %s/%lu data\n",
				PARTIAL_SIZE_MAX, core_conf.name, __fls(core_conf.pblock));
			devm_kfree(sys.devp, bitstream);
			devm_kfree(sys.devp, buffer);
			return -ENOMEM;
		}
		struct xz_buf xz_ctrl;
		xz_ctrl.in = buffer;
		xz_ctrl.in_pos = 0;
		xz_ctrl.in_size = core_conf.size;
		xz_ctrl.out = bitstream->data;
		xz_ctrl.out_pos = 0;
		xz_ctrl.out_size = PARTIAL_SIZE_MAX;
		enum xz_ret dec_ret = xz_dec_run(sys.decompressor, &xz_ctrl);
		devm_kfree(sys.devp, buffer);
		if (dec_ret != XZ_STREAM_END) {
			pr_err("error decompressing bitstream (xz decoder ret = %d)\n", dec_ret);
			dmam_free_coherent(sys.devp, PARTIAL_SIZE_MAX, bitstream->data, bitstream->dma_handle);
			devm_kfree(sys.devp, bitstream);
			return -ENOMEM;
		}
		bitstream->size = xz_ctrl.out_pos;

		size_t pos;
		bool swap = false;
		for (pos = 0; pos < bitstream->size - sizeof(u32); ++pos) {
			u32 *ptr = bitstream->data + pos;
			if (*ptr == be32_to_cpu(0x665599AA))
				break;
			if (*ptr == le32_to_cpu(0x665599AA)) {
				swap = true;
				break;
			}
		}

		if (pos >= bitstream->size - sizeof(u32)) {
			pr_warn("Failed to detect bitstream magic number; aborting...");
			dmam_free_coherent(sys.devp, PARTIAL_SIZE_MAX, bitstream->data, bitstream->dma_handle);
			devm_kfree(sys.devp, bitstream);
			return -EINVAL;
		}

		bitstream->size -= pos;
		memmove(bitstream->data, bitstream->data + pos, bitstream->size);

		if (swap) for (int i = 0; i < bitstream->size - sizeof(u32); i += sizeof(u32)) {
			*(u32 *)(bitstream->data + i) = swab32(*(u32 *)(bitstream->data + i));
		}

		core->availability |= bitstream->pblock->id;

		spin_lock(&core->bitstreams_lock);
		list_add_tail_rcu(&bitstream->node, &core->bitstreams.node);
		spin_unlock(&core->bitstreams_lock);

		//pr_info("Registered core [%s] at pblock %lu, priority %d, size %zdKi\n",
		//	core->name, __fls(bitstream->pblock->id), core->priority, bitstream->size/Ki);
		break;
	case ZDMA_CORE_UNREGISTER:
		if (sys.config.block_user_ioctl && !capable(CAP_SYS_ADMIN))
			return -EACCES;
		if (copy_from_user(&core_conf, (void __user *)arg, sizeof(core_conf))) {
			pr_err("could not read all configuration data, ioctl ignored\n");
			return -EIO;
		}

		core = core_lookup(core_conf.name);
		
		if (core == NULL) {
			pr_warn("core %s is not currently registered\n", core_conf.name);
			return -EEXIST;
		}

		while (true) {
			rcu_read_lock();
			struct zdma_bitstream *victim = NULL;
			list_for_each_entry_rcu(bitstream, &core->bitstreams.node, node) {
				if (core_conf.pblock & bitstream->pblock->id) {
					victim = bitstream;
					while (atomic_cmpxchg(&victim->pblock->state, PBLOCK_FREE, PBLOCK_BUSY) != PBLOCK_FREE)
						;
					victim->pblock->core->availability &= ~victim->pblock->id;
					
					spin_lock(&core->bitstreams_lock);
					list_del_rcu(&victim->node);
					spin_unlock(&core->bitstreams_lock);
					
					atomic_set(&victim->pblock->state, PBLOCK_FREE);
					break;
				}
			}
			rcu_read_unlock();
			if (!victim)
				break;
			synchronize_rcu();
			dmam_free_coherent(sys.devp, PARTIAL_SIZE_MAX, victim->data, victim->dma_handle); 
			devm_kfree(sys.devp, bitstream);
		}

		if (list_empty(&core->bitstreams.node)) {
			spin_lock(&sys.cores_lock);
			list_del_rcu(&core->node);
			spin_unlock(&sys.cores_lock);
			synchronize_rcu();
			devm_kfree(sys.devp, core);
		}
		break;
	case ZDMA_CLIENT_CONFIG:
		if (copy_from_user(&client_conf, (void __user *)arg, sizeof(client_conf))) {
			pr_err("could not read all configuration data, ioctl ignored\n");
			return -EIO;
		}

		p->core_param_count = client_conf.core_param_count;
		for (int i = 0; i < client_conf.core_param_count; ++i) {
			p->core_param[i] = client_conf.core_param[i];
		}

		p->req_affinity = client_conf.affinity;
		p->eff_affinity = p->req_affinity;
		p->tx.size = client_conf.tx_size;
		p->rx.size = client_conf.rx_size;

		p->core = core_lookup(client_conf.core_name);
		if (p->core == NULL) {
			pr_warn("requested core [%s] is not registered\n", client_conf.core_name);
			return -EINVAL;
		}

		// keep this last, it needs p->core->availability
		if (allocator(p, client_conf.tx_size, client_conf.rx_size)) {
			pr_err("error allocating new buffers\n");
			return -ENOMEM;
		}

		atomic_set(&p->state, CLIENT_CONFIGURED);
		break;
	case ZDMA_CLIENT_ENQUEUE_BLOCK:
		if (atomic_read(&p->state) == CLIENT_INPROGRESS)
			flush_work(&p->work);
		// Delibarate fall-through to _NOBLOCK variant
	case ZDMA_CLIENT_ENQUEUE_NOBLOCK:
		if ((p->eff_affinity & p->core->availability) == 0) {
			pr_warn("client affinity prohibits scheduling to any available pblock\n");
			return -EPERM;
		}
			
		if (atomic_cmpxchg(&p->state, CLIENT_READY, CLIENT_INPROGRESS) != CLIENT_READY)
			return -EAGAIN;
		queue_work(sys.workqueue, &p->work);
		break;
	case ZDMA_CLIENT_WAIT:
		flush_work(&p->work);
		break;
	default:
		pr_err("unknown ioctl: command %x, argument %lu\n", cmd, arg);
		return -ENOTTY;
	}
	return 0l;
}


static int dev_mmap(struct file *filep, struct vm_area_struct *vma)
{
	if (sys.state != SYS_UP) 
		return -EAGAIN;
	struct zdma_client *p = filep->private_data;
	
	if (	atomic_read(&p->state) != CLIENT_CONFIGURED && 
		atomic_read(&p->state) != CLIENT_MMAP_TX_DONE && 
		atomic_read(&p->state) != CLIENT_MMAP_RX_DONE) 
		return -EAGAIN;
	if ((vma->vm_flags & VM_READ) == (vma->vm_flags & VM_WRITE)) {
		pr_warn("invalid protection flags -- please use MAP_WRITE for TX or MAP_READ for RX\n");
		return -EINVAL;
	}
	if (((vma->vm_flags & VM_WRITE) && (atomic_read(&p->state) == CLIENT_MMAP_TX_DONE)) ||
		(((vma->vm_flags & VM_READ) && (atomic_read(&p->state) == CLIENT_MMAP_RX_DONE)))) {
		pr_warn("channel already mapped\n");
		return -EINVAL;
	}	

	struct dma_channel *chan = (vma->vm_flags & VM_WRITE) ? &p->tx : &p->rx;

	phys_addr_t	vsize = vma->vm_end - vma->vm_start,
			psize = chan->size - (vma->vm_pgoff << PAGE_SHIFT);
	
	if (chan->size == 0) {
		pr_warn("attempt to map a zero length channel buffer\n");
		return -EINVAL;
	}

	BUG_ON(vsize != ALIGN(psize, PAGE_SIZE));

	if (!chan->handle) {
		pr_warn("Internal error: DMA buffer has not yet been allocated!\n.");
		return -ENOMEM;
	}

	if (dma_mmap_coherent(sys.devp, vma, chan->vaddr, chan->handle, vsize) < 0) {
		pr_warn("failed to map user buffer!\n");
		return -ENOMEM;
	}
	
	if (atomic_read(&p->state) == CLIENT_CONFIGURED) {
		atomic_set(&p->state, (vma->vm_flags & VM_WRITE) ? 
			CLIENT_MMAP_TX_DONE : CLIENT_MMAP_RX_DONE);
	} else 	atomic_set(&p->state, CLIENT_READY);

	return 0;
}


static int zdma_remove(struct platform_device *pdev)
{
	sys.state = SYS_DEINIT;
	destroy_workqueue(sys.workqueue);
	//dev_set_drvdata(&pdev->dev, NULL);

	struct zdma_zone *zone;
	list_for_each_entry(zone, &sys.zones.node, node) {
		device_unregister(&zone->dev);
	}

	struct zdma_pblock *pblock;
	list_for_each_entry(pblock, &sys.pblocks.node, node) {
		if (pblock->txchanp) dma_release_channel(pblock->txchanp);
		if (pblock->rxchanp) dma_release_channel(pblock->rxchanp);
	}
	sys.state = SYS_DOWN;
	pr_info("zdma is down\n");
	return 0;
}



static int zdma_probe(struct platform_device *pdev)
{
	int res;
	if (!debug)
		zoled_disable();

	if (sys.state == SYS_UP) {
		pr_crit("\n"
	"***  An unexpected attempt was made to initialize an already running system. ***\n"
	"***             This may have happened due to several reasons:               ***\n"
	"***  1. Device-tree misconfiguration, i.e. multiple zdma instance entries.   ***\n"
	"***  2. Device-tree corruption at run-time from userland actors.             ***\n"
	"***  3. An improper or incomplete module removal and re-insertion after a    ***\n"
	"***   kernel bug or hardware failure. This should not have happened.         ***\n"
	"***  The request will be ignored but the system may be in an unstable state  ***\n");
		return -EBUSY;
	}

	sys.devp = &pdev->dev;

	// basic data structure initialization
	sys.workqueue = alloc_workqueue("zdma", WQ_FREEZABLE, 0);
	INIT_LIST_HEAD(&sys.pblocks.node);
	INIT_LIST_HEAD(&sys.pblocks.node);
	INIT_LIST_HEAD(&sys.cores.node);
	INIT_LIST_HEAD(&sys.zones.node);
	INIT_LIST_HEAD(&sys.clients.node);
	atomic_set(&sys.pblock_count, 0);
	atomic_set(&sys.zone_count, 0);
	atomic_set(&sys.client_count, 0);
	dev_ioctl(NULL, ZDMA_CONFIG, CONFIG_ALLOC_BITMAP_DEFAULT);
	dev_ioctl(NULL, ZDMA_CONFIG, CONFIG_ALLOC_ZONE_DEFAULT);

	struct device_node *np = NULL;
	
	for_each_compatible_node(np, NULL, "tuc,pblock") {
		res = pblock_add(np);
		if (res) return res;
	}
	if (atomic_read(&sys.pblock_count) == 0) {
		pr_err("devicetree: no DMA controllers were detected\n");
		return -ENODEV;
	}
	
	// discover memory region info
	np = NULL;
	for_each_compatible_node(np, NULL, "tuc,zone") {
		res = zone_add(np);
		if (res) return res;
	}
	
	if (atomic_read(&sys.zone_count) == 0) {
		pr_err("devicetree: no suitable memory zones are defined!\n");
		return -ENODEV;
	}
	
	pr_info("ZDMA initialized. Detected %d partition block(s) and %d memory banks(s)\n", 
		atomic_read(&sys.pblock_count), atomic_read(&sys.zone_count));

	sys.state = SYS_UP;
	return 0;
}

static struct of_device_id zdma_of_match[] = {
	{ .compatible = "tuc,zdma", },
	{ /* end of list */ },
};
MODULE_DEVICE_TABLE(of, zdma_of_match);


static struct platform_driver zdma_driver = {
	.driver = {
		.name = "zdma",
		.owner = THIS_MODULE,
		.of_match_table = zdma_of_match,
	},
	.probe = zdma_probe,
	.remove = zdma_remove,
};


static void __exit mod_exit(void)
{
	xz_dec_end(sys.decompressor);
	platform_driver_unregister(&zdma_driver);
	misc_deregister(&sys.miscdev);
	return;
}


static int __init mod_init(void)
{
	sys.state = SYS_INIT;

	spin_lock_init(&sys.pblocks_lock);
	spin_lock_init(&sys.zones_lock);
	spin_lock_init(&sys.cores_lock);
	spin_lock_init(&sys.clients_lock);

	static struct file_operations fops;
	fops.owner = THIS_MODULE;
	fops.open = dev_open;
	fops.release = dev_release;
	fops.mmap = dev_mmap;
	fops.unlocked_ioctl = dev_ioctl;

	// create character device
	sys.miscdev.minor = MISC_DYNAMIC_MINOR;
	sys.miscdev.name = "zdma";
	sys.miscdev.fops = &fops;

	int ret = misc_register(&sys.miscdev);
	if (ret) {
		pr_err("error registering /dev entry\n");
		return -ENOSPC;
	}

	sys.decompressor = xz_dec_init(XZ_SINGLE, 0);

	dev_ioctl(NULL, ZDMA_CONFIG, CONFIG_SECURITY_IOCTL_DEFAULT);
	dev_ioctl(NULL, ZDMA_CONFIG, CONFIG_SECURITY_BUFFER_DEFAULT);
	dev_ioctl(NULL, ZDMA_CONFIG, CONFIG_SCHED_ALGO);
	dev_ioctl(NULL, ZDMA_CONFIG, CONFIG_SCHED_VICTIM_ALGO);
//	dev_ioctl(NULL, ZDMA_CONFIG, CONFIG_SCHED_PRIORITY_DEFAULT);
	sys.config.alloc_order = ALLOC_ORDER;

	// register the driver to the kernel
	if (platform_driver_register(&zdma_driver)) {
		pr_err("error registering zdma platform driver\n");
		return -1;
	}

	return 0;
}


module_init(mod_init);
module_exit(mod_exit);

