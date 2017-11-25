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

bool debug = true;
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

enum zdma_core_state {
	CORE_INIT = 0,
	CORE_START = 1<<0,
	CORE_DONE = 1<<1,
	CORE_IDLE = 1<<2,
	CORE_READY = 1<<3,
	CORE_AUTOSTART = 1<<7,
};

static struct system {
	enum zdma_system_state state;
	atomic_t	pblock_count,
			zone_count,
			client_count;
	spinlock_t	pblocks_lock,
			cores_lock,
			zones_lock,
			mem_lock,
			clients_lock;
	
	struct workqueue_struct *workqueue;
//	wait_queue_head_t waitqueue;

	struct zdma_pblock {
		atomic_t state;
		spinlock_t lock;
		struct list_head node;
		struct zdma_core *core;
		phys_addr_t	pbase,
				psize;
		void __iomem	*vbase;
		char name[DT_NAME_LEN];
		struct dma_chan	*txchanp,
				*rxchanp;
		struct clk *clk_mm2s, *clk_s2mm;
	} pblocks;

	struct zdma_core {
		struct list_head node;
		char name[CORE_NAME_LEN];
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
	} zones;

	struct gen_pool *mem;
	struct zdma_client {
		int id;
		atomic_t state;
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


struct zdma_pblock *pblock_lookup(char *pblock_name)
{
	struct zdma_pblock *pblock, *pblock_sel = NULL;
	rcu_read_lock();
	list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
		if (strncmp(pblock->name, pblock_name, DT_NAME_LEN) == 0) {
			pblock_sel = pblock;
			break;
		}
	}
	rcu_read_unlock();
	return pblock_sel;

}

struct zdma_bitstream *bitstream_lookup_by_name(struct zdma_core *core, char *pblock_name)
{
	struct zdma_bitstream *bitstream, *bitstream_sel = NULL;
	rcu_read_lock();
	list_for_each_entry_rcu(bitstream, &core->bitstreams.node, node) {
		if (strncmp(bitstream->pblock->name, pblock_name, DT_NAME_LEN) == 0) {
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
	struct gen_pool_chunk *chunk;
	struct zdma_core *core;
	struct zdma_client *client;
	struct zdma_bitstream *bitstream;
	
	pr_info("------------------------------------------------------\n");
	rcu_read_lock();
	list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
		pr_info("PBLOCK %s: core: %s, state: %d\n", 
			pblock->name, pblock->core->name, atomic_read(&pblock->state));
	}

	list_for_each_entry_rcu(core, &sys.cores.node, node) {
		pr_info("CORE %s: ", core->name);
		if (&core->bitstreams.node == core->bitstreams.node.next)
			printk("<EMPTY>");
		list_for_each_entry_rcu(bitstream, &core->bitstreams.node, node) {
			pr_cont("<%s> ", bitstream->pblock->name);
		}
		pr_cont("\n");
	}
	
	list_for_each_entry_rcu(chunk, &sys.mem->chunks, next_chunk) {
		pr_info("MEM phys %#lx mapped at %#lx, size: %lu avail: %d\n", 
			(long)chunk->phys_addr,
			chunk->start_addr, 
			(chunk->end_addr - chunk->start_addr + 1)/Ki,
			atomic_read(&chunk->avail)/Ki);
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
int xdevcfg_program(dma_addr_t, size_t, bool);

static int pblock_setup(struct zdma_pblock *pblock, struct zdma_core *core)
{
	struct zdma_bitstream *bitstream, *bitstream_sel = NULL;
	BUG_ON(IS_ERR_OR_NULL(pblock));
	BUG_ON(IS_ERR_OR_NULL(core));
	rcu_read_lock();
	list_for_each_entry_rcu(bitstream, &core->bitstreams.node, node) {
		if (bitstream->pblock == pblock) {
			bitstream_sel = bitstream;	// TODO test if it can be simplified
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

	pblock->core = core;
	return 0;
}


static struct zdma_pblock *pblock_reserve(struct zdma_core *core)
{
	struct zdma_pblock *pblock, *pblock_sel = NULL;
	do {
		// at first, try to lock an already running core
		rcu_read_lock();
		list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
			if (pblock->core == core) {
				if (atomic_cmpxchg(&pblock->state, PBLOCK_FREE, PBLOCK_BUSY) == PBLOCK_FREE) {
					pblock_sel = pblock;
					break;
				}
			}
		}
		rcu_read_unlock();
		
		if (pblock_sel) 
			return pblock_sel;
		// if a running core was not available, program the
		// first free pblock for which a bitstream is available
		rcu_read_lock();
		list_for_each_entry_rcu(pblock, &sys.pblocks.node, node) {
			if (bitstream_lookup_by_pointer(core, pblock) == NULL) continue;
			if (atomic_cmpxchg(&pblock->state, PBLOCK_FREE, PBLOCK_BUSY) == PBLOCK_FREE) {
				pblock_sel = pblock;
				break;
			}
		}
		rcu_read_unlock();

		// if we found a free pblock, try to program it if a bitstream is available
		// FIXME unecessary performance penalty if a core is not loadable on all cores
		if (pblock_sel) {
			int err = pblock_setup(pblock, core);
			if (err) 
				pblock_sel = NULL;	// free pblock but had no bitstream available
		}
		
		// either no free pblock or no bitstream for the chosen pblock
		// concede cpu to other task to wait a bit and then redo from start
		if (pblock_sel == NULL) schedule();
	} while (pblock_sel == NULL);
	return pblock_sel;
}

static void pblock_release(struct zdma_pblock *pblock)
{
	atomic_set(&pblock->state, PBLOCK_FREE);
	return;
}


static int psram_alloc(struct zdma_client *p, size_t tx_size, size_t rx_size)
{
	if (sys.state != SYS_UP)
		return -EBUSY;
	
	if (p->tx.vaddr)
		gen_pool_free(sys.mem, (unsigned long)p->tx.vaddr, p->tx.size);
	if (p->rx.vaddr)
		gen_pool_free(sys.mem, (unsigned long)p->rx.vaddr, p->rx.size);
	if (tx_size == 0 || rx_size == 0)
		return 0;

	if (gen_pool_dma_alloc_pair(sys.mem,
			tx_size, &p->tx.vaddr, &p->tx.handle, 
			rx_size, &p->rx.vaddr, &p->rx.handle)) {
		pr_warn("unable to allocate %zu+%zu KiB for DMA buffers\n", 
			tx_size/Ki, rx_size/Ki);
		atomic_set(&p->state, CLIENT_ERROR_MEMORY);
		return -ENOMEM;
	}
	memset(p->tx.vaddr, 0x00, tx_size);
	memset(p->rx.vaddr, 0x00, rx_size);
	p->tx.size = tx_size;
	p->rx.size = rx_size;
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
	char *s = strrchr(of_node_full_name(np), '/') + 1;
	strncpy(pblock->name, s, DT_NAME_LEN);
	*strrchr(pblock->name, '@') = '_';


	// discover the DMA controller responsible for the core of this pblock
	struct device_node *dma_client_np = of_parse_phandle(np, "transport", 0);
	if (!dma_client_np) {
		pr_err("devicetree: %s does not contain a phandle to a data transporter.\n",
			pblock->name);
		err = -EINVAL;
		goto pblock_add_error;
	}

	// configure the DMA controller for this pblock
	pblock->txchanp = of_dma_request_slave_channel(dma_client_np, "tx");
	if (IS_ERR_OR_NULL(pblock->txchanp)) {
		pr_err("%s: failed to reserve TX DMA channel -- devicetree misconfiguration, "
			"DMA controller not present or driver not loaded.\n", pblock->name);
		err = -ENODEV;
		goto pblock_add_error;
	}

	pblock->rxchanp = of_dma_request_slave_channel(dma_client_np, "rx");
	if (IS_ERR_OR_NULL(pblock->rxchanp)) {
		pr_err("%s: failed to reserve RX DMA channel -- devicetree misconfiguration, "
			"DMA controller not present or driver not loaded.\n", pblock->name);
		dma_release_channel(pblock->txchanp);
		err = -ENODEV;
		goto pblock_add_error;
	}

	// discover the core's configuration address space
	struct device_node *core_np = of_parse_phandle(np, "core", 0);
	if (!core_np) {
		pr_err("devicetree: %s does not contain a phandle to a core definition.\n",
			pblock->name);
		goto pblock_add_error_late;
	}

	// configure the pblock's register space
	u64 size;
	const __be32 * addr;
	pblock->pbase = of_translate_address(core_np, addr = of_get_address(core_np, 0, &size, NULL));
	pblock->psize = (size_t)size;
	if (pblock->pbase == (long)OF_BAD_ADDR || !size) {
		pr_err("devicetree: %s: range entry is invalid:\n"
			"base: %p, translated: %#zx, size: %#llx.\n", 
			pblock->name, addr, pblock->pbase, size);
		err = -EINVAL;
		goto pblock_add_error_late;
	}
	
	if (!devm_request_mem_region(sys.devp, pblock->pbase, pblock->psize, pblock->name)) {
		pr_err("%s: failed to reserve I/O space at %#zx, size: %#zx\n", 
			pblock->name, pblock->pbase, pblock->psize);
			err = -ENOSPC;
		goto pblock_add_error_late;
	}
	pblock->vbase = devm_ioremap(sys.devp, pblock->pbase, pblock->psize);
	
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


static int dma_zone_add(struct device_node *np, phys_addr_t paddr, size_t size)
{
	if (sys.state != SYS_INIT) return -EBUSY;	// this will never happen
	struct zdma_zone *zone = devm_kzalloc(sys.devp, sizeof(struct zdma_zone), GFP_KERNEL);
	if (unlikely(zone == NULL)) {
		pr_err("unable to allocate %zu bytes for zone description\n",
			sizeof(*zone));
		return -ENOMEM;
	}
	
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
	void *vaddr = dmam_alloc_coherent(&zone->dev, size, &handle, GFP_KERNEL);
	if (!vaddr) {
		pr_err("error: cannot claim reserved memory of size %zuKiB\n", size/Ki);
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
		"*** a configuration. Use at your own risk!!!               ***\n");
	}

	spin_lock(&sys.zones_lock);
	list_add_tail_rcu(&zone->node, &sys.zones.node);
	spin_unlock(&sys.zones_lock);
	atomic_inc(&sys.zone_count);
	
	BUG_ON(IS_ERR_OR_NULL(sys.mem));
	gen_pool_add_virt(sys.mem, (unsigned long)vaddr, handle, size, -1);
	return 0;
}


static void dma_issue(struct work_struct *work)
{
	s32 ret;
	struct zdma_client *p = container_of(work, struct zdma_client, work);
	atomic_set(&p->state, CLIENT_INPROGRESS);

	struct zdma_pblock *pblock = pblock_reserve(p->core);
//	zoled_print("Issue %s@%c\n", p->core->name, pblock->name[7]);

	u32 csr;
	iowrite32(CORE_INIT, pblock->vbase + CORE_CSR);
	csr = ioread32(pblock->vbase + CORE_CSR);
	if (!(csr & CORE_IDLE)) {
		pr_emerg("core %s at %s is in an unexpected state: "
			"ap_idle is not asserted. CSR=%x\n",
			p->core->name, pblock->name, csr);
		goto dma_error;
	}

	for (int i = 0; i < p->core_param_count; ++i) {
		/*pr_info("pblock: %s, reg: %zu, val: %zu\n", pblock->name, 
			CORE_PARAM_BASE + i*CORE_PARAM_STEP, p->core_param[i]);*/
		iowrite32(p->core_param[i], pblock->vbase + CORE_PARAM_BASE + i*CORE_PARAM_STEP);
	}
	iowrite32(CORE_START, pblock->vbase + CORE_CSR); // ap_start = 1
	csr = ioread32(pblock->vbase + CORE_CSR);

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

	unsigned long tx_timeout = msecs_to_jiffies(2000), rx_timeout = msecs_to_jiffies(2000);

	dma_async_issue_pending(pblock->txchanp);
	dma_async_issue_pending(pblock->rxchanp);

	tx_timeout = wait_for_completion_timeout(&p->tx.cmp, tx_timeout);
	rx_timeout = wait_for_completion_timeout(&p->rx.cmp, rx_timeout);
	
	struct dma_tx_state tx_state, rx_state;
	enum dma_status 
		tx_status = dmaengine_tx_status(pblock->txchanp, p->tx.cookie, &tx_state),
		rx_status = dmaengine_tx_status(pblock->txchanp, p->tx.cookie, &tx_state);

	// determine if the transaction completed without a timeout and withtout any errors
	if (!tx_timeout || !rx_timeout) {
		pr_crit("*** DMA operation timed out at controller %s, core %s, client %d, chan %s.\n",
			pblock->name, pblock->core->name, p->id,
			!tx_timeout && !rx_timeout ? "TX and RX" :
			!tx_timeout ? "TX" : "RX");
			//goto dma_error;
	}

	if (tx_status != DMA_COMPLETE || rx_status != DMA_COMPLETE) {
		pr_crit("*** DMA status at %s/%s, client %d: "
			"TX: %s [res %u], RX: %s [res %u] ***\n", 
			pblock->name, pblock->core->name, p->id,
			tx_status == DMA_ERROR ? "ERROR" : 
			tx_status == DMA_IN_PROGRESS ? "IN PROGRESS" : "PAUSED",
			tx_state.residue,
			rx_status == DMA_ERROR ? "ERROR" : 
			rx_status == DMA_IN_PROGRESS ? "IN PROGRESS" : "PAUSED",
			rx_state.residue);

		goto dma_error;
	}
	
	// mostly debug, register somewhere a non-zero
	ret = ioread32(pblock->vbase + CORE_PARAM_RET);
	if (ret < 0)
		pr_warn("core %s at %s return value %d\n", p->core->name, pblock->name, ret);

	csr = ioread32(pblock->vbase + CORE_CSR);
	if (!(csr & CORE_DONE)) {
		pr_emerg("core %s at %s is in an unexpected state: "
			"ap_done is not asserted. CSR=%x\n",
			p->core->name, pblock->name, csr);
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
	flush_work(&p->work);
	psram_alloc(p, 0, 0);

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
	if (sys.state != SYS_UP) return -EAGAIN;
	struct zdma_client *p = filep->private_data;
	struct zdma_core *core;
	struct zdma_bitstream *bitstream = NULL;

	switch (cmd) {
	case ZDMA_DEBUG:
		zdma_debug();
		break;
	case ZDMA_CORE_REGISTER:
		if (!capable(CAP_SYS_ADMIN))
			return -EACCES;
		struct zdma_core_config core_conf;
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
			spin_lock_init(&core->bitstreams_lock);
			INIT_LIST_HEAD(&core->bitstreams.node);
			spin_lock(&sys.cores_lock);
			list_add_tail_rcu(&core->node, &sys.cores.node);
			spin_unlock(&sys.cores_lock);
		} else {
			bitstream = bitstream_lookup_by_name(core, core_conf.pblock_name);
			if (bitstream) {
				pr_warn("this bitstream is already registered for this core\n");
				return -EEXIST;
			}
		}

		bitstream = devm_kmalloc(sys.devp, sizeof(struct zdma_bitstream), GFP_KERNEL);
		if (!bitstream) {
			pr_err("could not allocate %zu bytes for bitstream %s/%s structures\n",
				sizeof(struct zdma_bitstream), core_conf.pblock_name, core_conf.name);
			return -ENOMEM;
		}
		
		bitstream->pblock = pblock_lookup(core_conf.pblock_name);
		if (!bitstream->pblock) {
			pr_warn("core %s contains bitstream for pblock %s that does not exist, ignoring.\n",
				core_conf.name, core_conf.pblock_name);
			devm_kfree(sys.devp, bitstream);
			return -ENODEV;
		}
		
		bitstream->size = core_conf.size;
		void *buffer = devm_kmalloc(sys.devp, core_conf.size, GFP_KERNEL);
		if (!buffer) {
			devm_kfree(sys.devp, bitstream);
			pr_err("could not allocate %zu bytes for compressed bitstream %s/%s data\n",
				core_conf.size, core_conf.pblock_name, core_conf.name);
			return -ENOMEM;
		}
		if (copy_from_user(buffer, (void __user *)core_conf.bitstream, core_conf.size)) {
			pr_err("could not load user bitstream to kernel memory\n");
			return -EIO;
		}

		bitstream->data = dmam_alloc_coherent(sys.devp, PARTIAL_SIZE_MAX, &bitstream->dma_handle, GFP_KERNEL);
		if (!bitstream->data) {
			devm_kfree(sys.devp, bitstream);
			devm_kfree(sys.devp, buffer);
			pr_err("could not allocate %zu bytes for bitstream %s/%s data\n",
				PARTIAL_SIZE_MAX, core_conf.pblock_name, core_conf.name);
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


		spin_lock(&core->bitstreams_lock);
		list_add_tail_rcu(&bitstream->node, &core->bitstreams.node);
		spin_unlock(&core->bitstreams_lock);

		pr_info("core %s for pblock %s with size %zdKi registered\n", 
			core->name, bitstream->pblock->name, bitstream->size/Ki);
		break;
	case ZDMA_CLIENT_CONFIG:
		;
		pr_info("entry\n");
		struct zdma_client_config client_conf;
		if (copy_from_user(&client_conf, (void __user *)arg, sizeof(client_conf))) {
			pr_err("could not read all configuration data, ioctl ignored\n");
			return -EIO;
		}
		for (int i = 0; i < (p->core_param_count = client_conf.core_param_count); ++i) {
			p->core_param[i] = client_conf.core_param[i];
		}

		if (psram_alloc(p, client_conf.tx_size, client_conf.rx_size)) {
			pr_err("error allocating new buffers\n");
			return -ENOMEM;
		}
		p->tx.size = client_conf.tx_size;
		p->rx.size = client_conf.rx_size;

		p->core = core_lookup(client_conf.core_name);
		if (p->core == NULL) {
			pr_warn("requested core [%s] is not registered\n", client_conf.core_name);
			return -EINVAL;
		}
		atomic_set(&p->state, CLIENT_CONFIGURED);
		break;	
	case ZDMA_CLIENT_ENQUEUE:
		if (atomic_cmpxchg(&p->state, CLIENT_READY, CLIENT_INPROGRESS) != CLIENT_READY)
			return -EAGAIN;
		queue_work(sys.workqueue, &p->work);
		break;
	case ZDMA_CLIENT_BARRIER:
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
	if (!debug) zoled_disable();

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
	sys.mem = devm_gen_pool_create(sys.devp, PAGE_SHIFT, NUMA_NO_NODE, NULL);
	gen_pool_set_algo(sys.mem, gen_pool_first_fit, NULL);
	gen_pool_set_chunk_algo(sys.mem, gen_chunk_least_used);

	// find dma clients in device tree
	struct device_node *np = NULL, *tnp = NULL;

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
		tnp = of_parse_phandle(np, "memory-region", 0);
		if (!tnp) {
			pr_err("devicetree: memory region %d does not contain a phandle to a memory bank\n",
				atomic_read(&sys.zone_count));
			return -ENODEV;
		}
		u64 size;
		phys_addr_t paddr = of_translate_address(tnp, of_get_address(tnp, 0, &size, NULL));
		res = dma_zone_add(np, paddr, (size_t)size);
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

	// register the driver to the kernel
	if (platform_driver_register(&zdma_driver)) {
		pr_err("error registering zdma platform driver\n");
		return -1;
	}

	return 0;
}


module_init(mod_init);
module_exit(mod_exit);

