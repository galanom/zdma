#define pr_fmt(fmt) "[" KBUILD_MODNAME "] %s():%d: " fmt, __func__, __LINE__

#include <linux/module.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/slab.h>
#include <linux/timex.h>
#include <linux/cdev.h>

#include <linux/dmaengine.h>
#include <linux/dma-mapping.h>
#include <linux/dma-contiguous.h>
#include <linux/genalloc.h>
#include <linux/uaccess.h>

#include <linux/of_dma.h>
#include <linux/of_address.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>
#include <linux/of_reserved_mem.h>

#include "zdma.h"
#include "zdma_ioctl.h"
#include "macro.h"

#ifndef CONFIG_OF
#error "OpenFirmware is not configured in kernel\n"
#endif

extern int xilinx_vdma_channel_set_config(void *, void *);	// FIXME dependency?

enum state {
	INITIALIZING=1,
	OFFLINE,
	ONLINE,
	SHUTTING_DOWN,
};

//module_param(length, unsigned, S_IRUGO);

static struct {
	int dmac_count, zone_count;
	struct gen_pool *mempool;
	struct dma_controller {
		struct dma_chan *txchanp, *rxchanp;
		int id;
		atomic_t load;
	} *dmac;
	struct dma_zone {
		int id;
		struct device dev;
	} *zone;
} hw;


static struct driver {
	atomic_t state;
	spinlock_t mem_lock;
	dev_t dev_num;
	struct device *devp;
	struct cdev cdev;
	struct file_operations fops;
	int clients;
} driver;


struct client {
	struct dma_controller *dmac;
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
};

static inline size_t chunk_size(const struct gen_pool_chunk *chunk)
{
	return chunk->end_addr - chunk->start_addr + 1;
}


static int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
{
	unsigned long val, nval;

	nval = *addr;
	do {
		val = nval;
		if (val & mask_to_set)
			return -EBUSY;
		cpu_relax();
	} while ((nval = cmpxchg(addr, val, val | mask_to_set)) != val);

	return 0;
}

static int clear_bits_ll(unsigned long *addr, unsigned long mask_to_clear)
{
	unsigned long val, nval;

	nval = *addr;
	do {
		val = nval;
		if ((val & mask_to_clear) != mask_to_clear)
			return -EBUSY;
		cpu_relax();
	} while ((nval = cmpxchg(addr, val, val & ~mask_to_clear)) != val);

	return 0;
}

static int bitmap_set_ll(unsigned long *map, int start, int nr)
{
	unsigned long *p = map + BIT_WORD(start);
	const int size = start + nr;
	int bits_to_set = BITS_PER_LONG - (start % BITS_PER_LONG);
	unsigned long mask_to_set = BITMAP_FIRST_WORD_MASK(start);

	while (nr - bits_to_set >= 0) {
		if (set_bits_ll(p, mask_to_set))
			return nr;
		nr -= bits_to_set;
		bits_to_set = BITS_PER_LONG;
		mask_to_set = ~0UL;
		p++;
	}
	if (nr) {
		mask_to_set &= BITMAP_LAST_WORD_MASK(size);
		if (set_bits_ll(p, mask_to_set))
			return nr;
	}

	return 0;
}

/*
 * bitmap_clear_ll - clear the specified number of bits at the specified position
 * @map: pointer to a bitmap
 * @start: a bit position in @map
 * @nr: number of bits to set
 *
 * Clear @nr bits start from @start in @map lock-lessly. Several users
 * can set/clear the same bitmap simultaneously without lock. If two
 * users clear the same bit, one user will return remain bits,
 * otherwise return 0.
 */
static int bitmap_clear_ll(unsigned long *map, int start, int nr)
{
	unsigned long *p = map + BIT_WORD(start);
	const int size = start + nr;
	int bits_to_clear = BITS_PER_LONG - (start % BITS_PER_LONG);
	unsigned long mask_to_clear = BITMAP_FIRST_WORD_MASK(start);

	while (nr - bits_to_clear >= 0) {
		if (clear_bits_ll(p, mask_to_clear))
			return nr;
		nr -= bits_to_clear;
		bits_to_clear = BITS_PER_LONG;
		mask_to_clear = ~0UL;
		p++;
	}
	if (nr) {
		mask_to_clear &= BITMAP_LAST_WORD_MASK(size);
		if (clear_bits_ll(p, mask_to_clear))
			return nr;
	}

	return 0;
}

static struct gen_pool_chunk *addr_in_gen_pool_chunk(struct gen_pool *pool, unsigned long vaddr)
{
	bool found = false;
	struct gen_pool_chunk *chunk;
	rcu_read_lock();
	list_for_each_entry_rcu(chunk, &(pool)->chunks, next_chunk) {
		if (vaddr >= chunk->start_addr && vaddr <= chunk->end_addr) {
			found = true;
			break;
		}
	}
	rcu_read_unlock();
	if (found) return chunk;
	return NULL;
}


//static int find_

static void sync_callback(void *completion)
{
	// Indicate the DMA transaction completed to allow the other thread to finish processing
	complete(completion);
	return;
}


static int client_dmac_alloc(struct client *p)
{
	if (atomic_read(&driver.state) != ONLINE) return -EBUSY;
	BUG_ON(IS_ERR_OR_NULL(p));

	if (p->dmac != NULL) {
		// FIXME wait for pending transfers
		// FIXME channel release?
		atomic_dec(&p->dmac->load);
	}

	p->dmac = &hw.dmac[0];
	for (int i = 1, min = atomic_read(&hw.dmac[0].load); i < hw.dmac_count; ++i) {
		int curr = atomic_read(&hw.dmac[i].load);
		if (curr < min) {
			p->dmac = &hw.dmac[i];
			min = curr;	// FIXME hmm...
		}
	}
	atomic_inc(&p->dmac->load);			// increase usage counter of selected DMAC
	pr_info("reserved DMAC %d with load %d\n", p->dmac->id, atomic_read(&p->dmac->load));
	return 0;
}



static int client_mem_alloc(struct client *p, size_t tx_size, size_t rx_size)
{
	if (atomic_read(&driver.state) != ONLINE) return -EBUSY;

	BUG_ON(IS_ERR_OR_NULL(p));

	if (p->dmac == NULL) client_dmac_alloc(p);

	if (p->tx.size != 0 && p->rx.size != 0) client_dmac_alloc(p);

	if (p->tx.vaddr) gen_pool_free(hw.mempool, (unsigned long)p->tx.vaddr, p->tx.size);
	if (p->rx.vaddr) gen_pool_free(hw.mempool, (unsigned long)p->rx.vaddr, p->rx.size);

	if (tx_size == 0 && rx_size == 0) {
		atomic_dec(&p->dmac->load);
		return 0;
	}

	int curr_avail = 0, max_avail = 0;
	int order = hw.mempool->min_alloc_order;
	struct gen_pool_chunk *bank, *small, *big;
	int nbits_big, nbits_small;
	if (tx_size > rx_size) {
		big = p->tx.bank;
		small = p->rx.bank;
		nbits_big = (tx_size + (1ul << order) - 1) >> order;
		nbits_small = (rx_size + (1ul << order) - 1) >> order;
		pr_info("tx is bigger, nbits tx: %d, rx: %d\n", nbits_big, nbits_small);
	} else {
		big = p->rx.bank;
		small = p->tx.bank;
		nbits_big = (rx_size + (1ul << order) - 1) >> order;
		nbits_small = (tx_size + (1ul << order) - 1) >> order;	
		pr_info("rx is bigger, nbits tx: %d, rx: %d\n", nbits_small, nbits_big);
	}
	int start_bit, end_bit, remain;
	rcu_read_lock();
	list_for_each_entry_rcu(bank, &hw.mempool->chunks, next_chunk) {
		curr_avail = atomic_read(&bank->avail);
		if (curr_avail >= max_avail) {
			end_bit = chunk_size(bank) >> order;
			start_bit = hw.mempool->algo(bank->bits, end_bit, 0, nbits_big, hw.mempool->data, hw.mempool);
			if (start_bit < end_bit) {
				max_avail = curr_avail;
				small = big;
				big = bank;
			} else {
				start_bit = hw.mempool->algo(bank->bits, end_bit, 0, nbits_small, hw.mempool->data, hw.mempool);
				if (start_bit < end_bit) {
					small = bank;
				}
			}
		}
	}
	
	end_bit = chunk_size(big) >> order;
	int start_bit_big = hw.mempool->algo(big->bits, end_bit, 0, nbits_big, hw.mempool->data, hw.mempool);
	spin_lock(&driver.mem_lock);
	remain = bitmap_set_ll(big->bits, start_bit_big, nbits_big);
	spin_unlock(&driver.mem_lock);
	if (remain) {
		bitmap_clear_ll(big->bits, start_bit_big, nbits_big);
		pr_err("internal error: failed to allocate from memory pool!\n");
		return -ENOMEM;
	}
	
	end_bit = chunk_size(small) >> order;
	int start_bit_small = hw.mempool->algo(small->bits, end_bit, 0, nbits_small, hw.mempool->data, hw.mempool);
	spin_lock(&driver.mem_lock);
	remain = bitmap_set_ll(small->bits, start_bit_small, nbits_small);
	spin_unlock(&driver.mem_lock);
	if (remain) {
		bitmap_clear_ll(small->bits, start_bit_small, nbits_small);
		pr_err("internal error: failed to allocate from memory pool!\n");
		return -ENOMEM; // FIXME we are in a corrupt state
	}
	
	if (tx_size > rx_size) {
		p->tx.vaddr = (void *)(big->start_addr + ((unsigned long)start_bit_big << order));
		p->rx.vaddr = (void *)(small->start_addr + ((unsigned long)start_bit_small << order));
	} else {
		p->rx.vaddr = (void *)(big->start_addr + ((unsigned long)start_bit_big << order));
		p->tx.vaddr = (void *)(small->start_addr + ((unsigned long)start_bit_small << order));
	}
	atomic_sub(nbits_big << order, &big->avail);
	atomic_sub(nbits_small << order, &small->avail);
	rcu_read_unlock();
	p->tx.handle = gen_pool_virt_to_phys(hw.mempool, (unsigned long)p->tx.vaddr);
	p->rx.handle = gen_pool_virt_to_phys(hw.mempool, (unsigned long)p->rx.vaddr);

	pr_info("big buf=%lx, small=%lx\n", big->start_addr, small->start_addr);
	pr_info("TX=%p, RX=%p\n", p->tx.vaddr, p->rx.vaddr);

	pr_info("request to set DMA buffer size to TX: %zukiB, RX: %zukiB\n", tx_size/Ki, rx_size/Ki);
	
//	p->tx.vaddr = gen_pool_dma_alloc(hw.mempool, tx_size, &p->tx.handle);
	if (!p->tx.vaddr) {
		pr_warn("unable to allocate %zuKi of DMA memory for client TX buffer\n", tx_size/Ki);
		return -ENOMEM;
	}
//	p->rx.vaddr = gen_pool_dma_alloc(hw.mempool, rx_size, &p->rx.handle);
	if (!p->rx.vaddr) {
		pr_warn("unable to allocate %zuKi of DMA memory for client RX buffer\n", rx_size/Ki);
		gen_pool_free(hw.mempool, (unsigned long)p->tx.vaddr, tx_size);
		return -ENOMEM;
	}
	
	// if no error...
	p->tx.size = tx_size;
	p->rx.size = rx_size;

	return 0;
}

static int dma_controller_add(struct device_node *np)
{
	if (atomic_read(&driver.state) == ONLINE) return -EBUSY; // will never happen

	void *q = devm_kcalloc(driver.devp, hw.dmac_count+1, sizeof(*hw.dmac), GFP_KERNEL);
	if (q == NULL) {
		pr_err("unable to allocate %zu bytes for DMA-C description structures!\n", 
			(hw.dmac_count+1)*sizeof(*hw.dmac));
		return -ENOMEM;
	}
	memcpy(q, hw.dmac, hw.dmac_count*sizeof(*hw.dmac));
	devm_kfree(driver.devp, hw.dmac);
	hw.dmac = q;
	hw.dmac_count++;
	struct dma_controller *dmac = &hw.dmac[hw.dmac_count - 1];
	dmac->id = hw.dmac_count - 1;
	atomic_set(&dmac->load, 0);
	//
	dmac->txchanp = of_dma_request_slave_channel(np, "tx");
	if (IS_ERR_OR_NULL(dmac->txchanp)) {
		pr_err("dmac[%d]: failed to reserve TX channel -- devicetree misconfiguration, "
			"DMA controller not present or driver not loaded.\n", dmac->id);
		return -ENODEV;	// FIXME DOES NOT EXIT GRACEFULLY FIXME // (later) TODO why not?
	}
	dmac->rxchanp = of_dma_request_slave_channel(np, "rx");
	if (IS_ERR_OR_NULL(dmac->rxchanp)) {
		pr_err("dmac[%d]: failed to reserve RX channel -- devicetree misconfiguration, "
			"DMA controller not present or driver not loaded.\n", dmac->id);
		dma_release_channel(dmac->txchanp);
		return -ENODEV;
	}
	return 0;
}

static int dma_zone_add(struct device_node *np, phys_addr_t paddr, size_t size)
{
	if (atomic_read(&driver.state) != INITIALIZING) return -EBUSY;	// this will never happen
	// reserve new memory
	void *q = devm_kcalloc(driver.devp, hw.zone_count+1, sizeof(*hw.zone), GFP_KERNEL);
	if (q == NULL) {
		pr_err("unable to allocate %zu bytes for memory region description structures!\n", 
			(hw.zone_count+1)*sizeof(*hw.zone));
		return -ENOMEM;
	}
	memcpy(q, hw.zone, hw.zone_count*sizeof(*hw.zone));
	devm_kfree(driver.devp, hw.zone);
	hw.zone = q;
	hw.zone_count++;
	struct dma_zone *zone = &hw.zone[hw.zone_count - 1];
	
	// create zone structure
	// Attention: Should dma_zone_add() is ever implemented to be called anywhere except for initialization,
	// proper locking is needed for whole structure, not just zone->used.
	zone->id = hw.zone_count-1;

	// create pseudo device structure
	device_initialize(&zone->dev);
	dev_set_name(&zone->dev, "%s@%d", "zone", zone->id);
	zone->dev.parent		= driver.devp; // do not inherit bus!
	zone->dev.coherent_dma_mask	= driver.devp->coherent_dma_mask;
	zone->dev.dma_mask		= driver.devp->dma_mask;
	zone->dev.release		= of_reserved_mem_device_release;
	int res = device_add(&zone->dev);
	if (res != 0) {
		pr_err("error %d while registering device for zone %d\n", res, zone->id);
		return res;
	}
	
	// seek to desired zone...
	if (of_reserved_mem_device_init_by_idx(&zone->dev, np, 0)) {
		pr_err("error: cannot initialize detected zone reserved memory!\n");
		return -ENOMEM;
	}

	// dmam_alloc_attrs() is implemented in 4.13, port when possible -- FIXME look for release
	dma_addr_t handle;
	void *vaddr = dma_alloc_attrs(&zone->dev, size, &handle, 
		GFP_KERNEL, DMA_ATTR_NO_KERNEL_MAPPING /*TODO check if this is wise in genpool */);
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

	// update memory pool
	BUG_ON(IS_ERR_OR_NULL(hw.mempool));
	gen_pool_add_virt(hw.mempool, (unsigned long)vaddr, handle, size, -1);
//	zone->chunk = find_chunk_by_virt(hw.mempool, (unsigned long)vaddr);
//	pr_info("double check %p vs %lu\n", handle, zone->chunk->start_addr);

	return 0;
}


static int dma_issue(struct client *p)
{
	if (atomic_read(&driver.state) != ONLINE) return -EAGAIN;

	if ((p->tx.descp = dmaengine_prep_slave_single(p->dmac->txchanp, p->tx.handle, p->tx.size, 
			DMA_MEM_TO_DEV, DMA_CTRL_ACK|DMA_PREP_INTERRUPT)) == NULL) {
		pr_err("dmaengine_prep_slave_single() returned NULL!\n");
		return p->tx.cookie = -EBUSY;
	}
	
	if ((p->rx.descp = dmaengine_prep_slave_single(p->dmac->rxchanp, p->rx.handle, p->rx.size,
			DMA_DEV_TO_MEM, DMA_CTRL_ACK|DMA_PREP_INTERRUPT)) == NULL) {
		pr_err("dmaengine_prep_slave_single() returned NULL!\n");
		return p->rx.cookie = -EBUSY;
	}

	p->tx.descp->callback = p->rx.descp->callback = sync_callback;
	p->tx.descp->callback_param = &p->tx.cmp;
	p->rx.descp->callback_param = &p->rx.cmp;

	p->tx.cookie = dmaengine_submit(p->tx.descp);
	p->rx.cookie = dmaengine_submit(p->rx.descp);

	if (dma_submit_error(p->tx.cookie) || dma_submit_error(p->rx.cookie)) {
		pr_err("cookie contains error!\n");
		return -EIO;
	}
	
	// initialize the completion before using it and then start the DMA transaction
	// which was previously queued up in the DMA engine
	init_completion(&p->tx.cmp);
	init_completion(&p->rx.cmp);

	//

	unsigned long timeout = 3000;
	enum dma_status status;
	cycles_t t0, t1;

	dma_async_issue_pending(p->dmac->txchanp);
	dma_async_issue_pending(p->dmac->rxchanp);

	t0 = get_cycles();
	timeout = wait_for_completion_timeout(&p->tx.cmp, msecs_to_jiffies(timeout));
	timeout = wait_for_completion_timeout(&p->rx.cmp, msecs_to_jiffies(timeout));
	t1 = get_cycles();

	status = dma_async_is_tx_complete(p->dmac->txchanp, p->tx.cookie, NULL, NULL);

	// determine if the transaction completed without a timeout and withtout any errors
	if (timeout == 0) {
		pr_crit("*** DMA OPERATION TIMED OUT ***\n");
		return -ETIMEDOUT;
	} 
	if (status != DMA_COMPLETE) {
		pr_err("DMA returned completion callback status of: %s\n", 
			status == DMA_ERROR ? "error" : "in progress");
		return -EIO;
	}

	if (t1-t0) pr_info("DMA size: %4zu->%4zu kiB, time (cycles): %lu\n", 
		p->tx.size/Ki, p->rx.size/Ki, t1-t0);
	else pr_warn("this kernel does not support get_cycles()\n");
	return 0;
}


static int dev_open(struct inode *inodep, struct file *filep)
{
	struct client *p;
	if ((p = filep->private_data = devm_kzalloc(driver.devp, sizeof(struct client), GFP_KERNEL)) == NULL) {
		pr_err("error allocating memory for client private data!\n");
		return -ENOMEM;
	}
	p->dmac = NULL;
	pr_info("zdma open()\'ed for client %d\n", ++driver.clients);
	return 0;
}


static int dev_release(struct inode *inodep, struct file *filep)
{
	pr_info("zdma release()\'ed for client %d\n", driver.clients--);
	client_mem_alloc(filep->private_data, 0, 0);
	devm_kfree(driver.devp, filep->private_data);
	return 0;
}


static long dev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
{
	if (atomic_read(&driver.state) != ONLINE) return -EAGAIN;
	struct client *p = filep->private_data;
	struct dma_config conf;

	switch (cmd) {
	case ZDMA_IOCTL_DEBUG:
		break;
	case ZDMA_IOCTL_CONFIG:
		if (copy_from_user(&conf, (void __user *)arg, sizeof(conf))) {
			pr_err("could not read all configuration data, ioctl ignored\n");
			return -EIO;
		}
		if (client_mem_alloc(p, conf.tx_size, conf.rx_size)) {
			pr_err("error allocating new buffers\n");
			return -ENOMEM;
		}
		p->tx.size = conf.tx_size;
		p->rx.size = conf.rx_size;
		//p->conf.flags = conf.flags;
		break;	
	case ZDMA_IOCTL_ISSUE:
		return dma_issue(p);
		break;
	default:
		pr_err("unknown ioctl: command %x, argument %lu\n", cmd, arg);
		return -ENOTTY;
	}
	return 0l;
}


static int dev_mmap(struct file *filep, struct vm_area_struct *vma)
{
	if (atomic_read(&driver.state) != ONLINE) {
		pr_info("system is not yet online.\n");
		return -EAGAIN;
	}

	struct client *p = filep->private_data;
	if ((vma->vm_flags & VM_READ) == (vma->vm_flags & VM_WRITE)) {
		pr_err("invalid protection flags -- please use MAP_WRITE for TX or MAP_READ for RX\n");
		return -EINVAL;
	}
	
	struct dma_channel *chan = (vma->vm_flags & VM_WRITE) ? &p->tx : &p->rx;
	phys_addr_t off = vma->vm_pgoff << PAGE_SHIFT,
		paddr = dma_to_phys(driver.devp, chan->handle),
		vsize = vma->vm_end - vma->vm_start,
		psize = chan->size - off;
	
	pr_info("zdma mmap: [%s] off=%zu, phys=%p, vsize=%zu, psize=%zu\n", 
		(vma->vm_flags & VM_WRITE) ? "TX" : "RX", (size_t)off, (void *)paddr, (size_t)vsize, (size_t)psize);
	BUG_ON(vsize != ALIGN(psize, PAGE_SIZE));

	if (!chan->handle) {
		pr_err("Internal error: DMA buffer has not yet been allocated!\n.");
		return -ENOMEM;
	}

	if (dma_mmap_attrs(driver.devp, vma, p->tx.vaddr, p->tx.handle, vsize, DMA_ATTR_NO_KERNEL_MAPPING) < 0) {
			pr_err("failed to map user buffer!\n");
			return -ENOMEM;
	}

	return 0;
}


static int zdma_remove(struct platform_device *pdev)
{
	atomic_set(&driver.state, SHUTTING_DOWN);
	pr_info("zdma shutting down...\n");
//	dev_set_drvdata(&pdev->dev, NULL);	//TODO understand what this does
	
	while (hw.dmac_count--) {
		pr_info("releasing dmac[%d]\n", hw.dmac_count);
		dma_release_channel(hw.dmac[hw.dmac_count].rxchanp);
		dma_release_channel(hw.dmac[hw.dmac_count].txchanp);
	}
	while (hw.zone_count--) {
		pr_info("releasing zone[%d]\n", hw.zone_count);
		// FIXME delete zones
		device_del(&hw.zone[hw.zone_count].dev);
		put_device(&hw.zone[hw.zone_count].dev);
		// platform?
	}
	//FIXME clear pools also
//		dma_free_attrs(&zone->dev, zone->limit, zone->virt_addr, zone->dma_addr, DMA_ATTR_NO_KERNEL_MAPPING);
	atomic_set(&driver.state, OFFLINE);
	return 0;
}


static int zdma_probe(struct platform_device *pdev)
{
	int res;
//	while (atomic_read(&driver.state) == SHUTTING_DOWN); //wait to finish shutdown

	if (atomic_read(&driver.state) == ONLINE) {
		pr_crit("\n"
			"***   An unexpected attempt was made to initialize an already running system.  ***\n"
			"***              This may have happened due to several reasons:                ***\n"
			"***   1. Device-tree misconfiguration, i.e. multiple zdma instance entries.    ***\n"
			"***   2. Device-tree corruption at run-time from userland actors.              ***\n"
			"***   3. An improper or incomplete module removal and re-insertion after a     ***\n"
			"***    kernel bug or hardware failure. This should not have happened.          ***\n"
			"***   The request will be ignored but the system may be in an unstable state   ***\n");
		return -EBUSY;
	}

	driver.devp = &pdev->dev;

	// basic data structure initialization
	hw.dmac_count = 0;
	hw.dmac = NULL;
	hw.zone_count = 0;
	hw.zone = NULL;
	hw.mempool = devm_gen_pool_create(driver.devp, PAGE_SHIFT, NUMA_NO_NODE, NULL);

	// find dma clients in device tree
	struct device_node *np = NULL, *tnp = NULL;

	for_each_compatible_node(np, NULL, "tuc,dma-client") {
		res = dma_controller_add(np);
		if (res) return res;
	}
	if (!hw.dmac_count) {
		pr_err("devicetree: no DMA controllers were detected\n");
		return -ENODEV;
	}
	
	// discover memory region info
	np = NULL;
	for_each_compatible_node(np, NULL, "tuc,zone") {
		tnp = of_parse_phandle(np, "memory-region", 0);
		if (!tnp) {
			pr_err("devicetree: memory region %d does not contain a phandle to a memory bank\n", hw.zone_count);
			return -ENODEV;
		}
		u64 size;
		phys_addr_t paddr = of_translate_address(tnp, of_get_address(tnp, 0, &size, NULL));
		res = dma_zone_add(np, paddr, (size_t)size);
		if (res) return res;
	}
	
	if (!hw.zone_count) {
		pr_err("devicetree: no suitable memory zones are defined!\n");
		return -ENODEV;
	}
	
	pr_info("devicetree: found %d DMA controller(s) and %d memory zone(s)\n", hw.dmac_count, hw.zone_count);

	atomic_set(&driver.state, ONLINE);
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
	platform_driver_unregister(&zdma_driver);
	cdev_del(&driver.cdev);
	unregister_chrdev_region(driver.dev_num, 1 /* count */);
	pr_info("module exiting...\n");
}


static int __init mod_init(void)
{
	atomic_set(&driver.state, INITIALIZING);
	pr_info("module initializing...\n");

	spin_lock_init(&driver.mem_lock);

	// create character device
	driver.fops.owner = THIS_MODULE;
	driver.fops.open = dev_open;
	driver.fops.release = dev_release;
	driver.fops.mmap = dev_mmap;
	driver.fops.unlocked_ioctl = dev_ioctl;

	if (alloc_chrdev_region(&driver.dev_num, 0 /* first minor */, 1 /* count */, KBUILD_MODNAME) < 0) {
		pr_err("error registering /dev entry\n");
		return -ENOSPC;
	}
	
	cdev_init(&driver.cdev, &driver.fops);
	if (cdev_add(&driver.cdev, driver.dev_num, 1 /* count */)) {
		pr_err("error registering character device\n");
		return -ENOSPC;
	}

	// register the driver to the kernel
	if (platform_driver_register(&zdma_driver)) {
		pr_err("error registering zdma platform driver\n");
		return -1;
	}

	return 0;
}


module_init(mod_init);
module_exit(mod_exit);
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Ioannis Galanommatis");
MODULE_DESCRIPTION("DMA client to xilinx_dma");
MODULE_VERSION("0.2");

