/* AXI DMA Example
*
* This small example is intended to simply llustate how to use the DMA engine 
* of Linux to take advantage of DMA in the PL. The hardware design is intended
* to be an AXI DMA without scatter gather and with the transmit channel looped
* back to the receive channel. 
*
*/
#define pr_fmt(fmt) "[" KBUILD_MODNAME "] %s():%d: " fmt, __func__, __LINE__
#define CPU_FREQ 667

#include <linux/dmaengine.h>
#include <linux/module.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/dma-mapping.h>
#include <linux/slab.h>
#include <linux/timex.h>
//#include <linux/list.h>
#include <linux/rculist.h>
#include <linux/genalloc.h>
#include <linux/dma-contiguous.h>

#include <linux/of_address.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>
#include <linux/of_reserved_mem.h>

// TODO FIXME Take care of this!
#include <asm/cacheflush.h>
#include <asm/outercache.h>

#define DMAC_COUNT 4

#ifndef CONFIG_OF
#error "OpenFirmware is not configured in Linux kernel\n"
#endif

// FIXME dependency?
extern int xilinx_vdma_channel_set_config(void *, void *);

//module_param(length, unsigned, S_IRUGO);

static struct dma_transaction {
	struct platform_device *dmac;
	bool coherent;			// coherent or streaming API
	size_t size;
	struct {
		dma_addr_t handle;			// DMA address in bus address space
		void *buf;				// DMA buffer address in virtual address space
//		enum dma_data_direction ddir;		// for dma_(un)map_single()
//		enum dma_transfer_direction tdir;	// for dmaengine_prep_slave_single()
//		unsigned long flags;
		struct dma_chan *chan;			// Hardware DMA channel
		struct dma_async_tx_descriptor *desc;	// Transfer descriptor
		struct dma_slave_config conf;
		dma_cookie_t cookie;
		struct completion cmp;
	} tx, rx;
} dma;
/*static struct {
	void *base;
	size_t size;
	struct list_head list;
} bram;*/

static struct gen_pool *bram_pool = NULL;

static void sync_callback(void *completion)
{
	// Indicate the DMA transaction completed to allow the other thread of control to finish processing
	complete(completion);
	return;
}


static int dma_init(struct dma_transaction *tr, struct platform_device *pdev, bool coherent, size_t size)
{
	if (tr == NULL) return -EINVAL;
	tr->dmac = pdev;
	tr->coherent = coherent;
	tr->size = size;
	pr_info("DMAC init success\n");
	return 0;
}

static int dma_reserve_memory(struct dma_transaction *tr)
{
	int res;
	/*if (!dma_declare_contiguous(&tr->dmac->dev, 32*1024*1024, 0x18000000, 0)) {
		pr_err(	"fatal: dma_declare_contiguous() failed to reclaim reserved memory!\n"
			"Was it really reserved on machine initialization?\n");
		return -ENOMEM;
	}*/

	if (tr->coherent) {
		res = of_reserved_mem_device_init_by_idx(tr->tx.chan->device->dev, tr->dmac->dev.of_node, 0);
		if (res != 0) {
			pr_err("fatal: cannot initialize TX port memory region for DMAC\n");
			return -ENOMEM;
		}
		res = of_reserved_mem_device_init_by_idx(tr->rx.chan->device->dev, tr->dmac->dev.of_node, 1);
		if (res != 0) {
			pr_err("fatal: cannot initialize RX port memory region for DMAC\n");
			return -ENOMEM;
		}
		tr->tx.buf = dma_alloc_coherent(tr->tx.chan->device->dev, tr->size, &tr->tx.handle, GFP_KERNEL);
		if (tr->tx.buf == NULL) {
			pr_err("fatal: dma_alloc_coherent() returned NULL!\n");
			return -EAGAIN;
		}
		tr->rx.buf = dma_alloc_coherent(tr->rx.chan->device->dev, tr->size, &tr->rx.handle, GFP_KERNEL);
		if (tr->rx.buf == NULL) {
			pr_err("fatal: dma_alloc_coherent() returned NULL!\n");
			dma_free_coherent(tr->tx.chan->device->dev, tr->size, tr->tx.buf, tr->tx.handle);
			return -EAGAIN;
		}
/*		tr->tx.handle = 0x18000000;
		tr->rx.handle = 0x18000000 + tr->size;
		tr->tx.buf = ioremap(tr->tx.handle, tr->size);
		tr->rx.buf = ioremap(tr->rx.handle, tr->size);*/
	} else {
		tr->tx.buf = kmalloc(tr->size, GFP_KERNEL);
		if (tr->tx.buf == NULL) {
			pr_err("kmalloc() failed to allocate TX buffer memory!\n");
			return -EAGAIN;
		}

		tr->rx.buf = kmalloc(tr->size, GFP_KERNEL);
		if (tr->rx.buf == NULL) {
			pr_err("kmalloc() failed to allocate RX buffer memory!\n");
			kfree(tr->tx.buf);
			return -EAGAIN;
		}

		tr->tx.handle = dma_map_single(tr->tx.chan->device->dev, tr->tx.buf, tr->size, DMA_TO_DEVICE);	
		if (dma_mapping_error(tr->tx.chan->device->dev, tr->tx.handle)) {
			pr_err("dma_mapping_error() returned an error condition on TX buffer mapping!\n");
			kfree(tr->tx.buf);
			kfree(tr->rx.buf);
			return -EAGAIN;
		};

		tr->rx.handle = dma_map_single(tr->rx.chan->device->dev, tr->rx.buf, tr->size, DMA_FROM_DEVICE);
		if (dma_mapping_error(tr->rx.chan->device->dev, tr->rx.handle)) {
			pr_err("dma_mapping_error() returned an error condition on RX buffer mapping!\n");
			dma_unmap_single(tr->tx.chan->device->dev, tr->tx.handle, tr->size, DMA_TO_DEVICE);
			kfree(tr->tx.buf);
			kfree(tr->rx.buf);
			return -EAGAIN;
		};
	}
	pr_info("DMA mapping: virt: %p->%p, phys: %p->%p.\n",
		tr->tx.buf, tr->rx.buf, tr->tx.handle, tr->rx.handle);
	return 0;
}


static int dma_reserve_channels(struct dma_transaction *tr)
{
	// Request the transmit and receive channels for the AXI DMA from the DMA engine
	tr->tx.chan = dma_request_slave_channel(&tr->dmac->dev, "tx");
	if (!tr->tx.chan) { 
		pr_err("TX channel reservation failure. "
			"Did you load xilinx_dma kernel module?\n");
		return -EBUSY;
	}

	tr->rx.chan = dma_request_slave_channel(&tr->dmac->dev, "rx");
	if (!tr->rx.chan) { 
		pr_err("RX channel reservation failure (TX was successful).\n");
		dma_release_channel(tr->tx.chan);
		return -EBUSY;
	}

	pr_info("DMA channel reservation successful.\n");
	
//	tr->tx.conf.direction = DMA_MEM_TO_DEV;	// obsolete
//	tr->tx.conf.src_addr = tr->tx.handle;
//	tr->tx.conf.dst_addr
	return 0;
}


static void dma_buffer_fill(struct dma_transaction *tr, int seed)
{
	int i;
	for (i = 0; i < tr->size/4; i++) ((s32 *)tr->tx.buf)[i] = seed+i;
	return;
}

static int dma_buffer_verify(struct dma_transaction *tr)
{
	int i, err_count = 0, err_first = -1;

	for (i = 0; i < tr->size/4; i++) if (((s32 *)tr->rx.buf)[i] != ((s32 *)tr->tx.buf)[i]) {
		err_count++;
		if (err_first == -1) err_first = i;
	}

	if (err_count != 0) {
		pr_err("****** DATA MISMATCH ****** error count %d of %d, first occurence at %d.\n", 
			err_count, tr->size/4, err_first);
		return -EIO;
	}

	pr_info("Data check successful.\n");
	return 0;
}


static int dma_setup(struct dma_transaction *tr)
{
	tr->tx.desc = dmaengine_prep_slave_single(tr->tx.chan, tr->tx.handle, tr->size, 
		DMA_MEM_TO_DEV, DMA_CTRL_ACK|DMA_PREP_INTERRUPT);
	if (tr->tx.desc == NULL) {
		pr_err("dmaengine_prep_slave_single() returned NULL!\n");
		return tr->tx.cookie = -EBUSY;
	}

	tr->rx.desc = dmaengine_prep_slave_single(tr->rx.chan, tr->rx.handle, tr->size,
		DMA_DEV_TO_MEM, DMA_CTRL_ACK|DMA_PREP_INTERRUPT);
	if (tr->rx.desc == NULL) {
		pr_err("dmaengine_prep_slave_single() returned NULL!\n");
		return tr->rx.cookie = -EBUSY;
	}

	tr->tx.desc->callback = tr->rx.desc->callback = sync_callback;
	tr->tx.desc->callback_param = &tr->tx.cmp;
	tr->rx.desc->callback_param = &tr->rx.cmp;

	tr->tx.cookie = dmaengine_submit(tr->tx.desc);
	tr->rx.cookie = dmaengine_submit(tr->rx.desc);

	if (dma_submit_error(tr->tx.cookie) || dma_submit_error(tr->rx.cookie)) {
		pr_err("prep_buffer(): dma_submit_error(): rx/tx cookie contains error!\n");
		return -EIO;
	}

	// initialize the completion before using it and then start the DMA transaction
	// which was previously queued up in the DMA engine
	init_completion(&tr->tx.cmp);
	init_completion(&tr->rx.cmp);

	return 0;
}

static int dma_issue(struct dma_transaction *tr)
{
//	u32 *p;
//	u32 d=0xdeadbeef;

/*
*/
/*	tx.size = rx.size = 64;
	tx.handle = 0xc0000000;
	rx.handle = tx.handle + tx.size;
	tx.buf = ioremap(tx.handle, tx.size);
	rx.buf = ioremap(rx.handle, rx.size);
	p = ioremap(0x40000000, tx.size+rx.size);
	
	pr_info("TX[0]=%d, RX[0]=%d\n", ioread32(p), ioread32(p+tx.size/4));
	pr_info("ioremap to %p\n", p);
	iowrite32(d, p);
	pr_info("iowrite32() ok\n");

	pr_info("TX[0]=%d, RX[0]=%d\n", ioread32(p), ioread32(p+tx.size/4));
*/
	/* Initialize the source buffer with known data to allow the destination buffer to
	 * be checked for success
	 */

	/* Step 4, since the CPU is done with the buffers, transfer ownership to the DMA and don't
	 * touch the buffers til the DMA is done, transferring ownership may involve cache operations

*/
//	pr_info("dma_map_single() handles: tx: %8x, rx: %8x (size %d)\n", tx.handle, rx.handle, sizeof(tx.handle));

	/* Prepare the DMA buffers and the DMA transactions to be performed and make sure there was not
	 * any errors
	 */
	unsigned long timeout = 3000;
	enum dma_status status;
	cycles_t t0, t1;
	// DEBUG BLOCK
	//__cpuc_flush_dcache_area(tr, sizeof(*tr));
//	__cpuc_flush_dcache_area(tr->tx.buf, tr->size);
//	outer_clean_range(virt_to_phys(tr), virt_to_phys((void*)tr+sizeof(tr)));
//	outer_clean_range(virt_to_phys(tr->tx.buf), virt_to_phys(tr->tx.buf+tr->size));
//	mb();

//	dma_sync_single_for_device(tr->tx.chan->device->dev, tr->tx.handle, tr->size, DMA_TO_DEVICE);

	
	pr_info("Issueing DMA request...\n");
	dma_async_issue_pending(tr->tx.chan);
	dma_async_issue_pending(tr->rx.chan);
	
	t0 = get_cycles();
	// wait for the transaction to complete, timeout, or get get an error
	timeout = wait_for_completion_timeout(&tr->tx.cmp, msecs_to_jiffies(timeout));
	t1 = get_cycles();
	status = dma_async_is_tx_complete(tr->tx.chan, tr->tx.cookie, NULL, NULL);

	// determine if the transaction completed without a timeout and withtout any errors
	if (timeout == 0) {
		pr_err("DMA timeout after %dms\n", 3000); //FIXME
		return -ETIMEDOUT;
	} 
	if (status != DMA_COMPLETE) {
		pr_err("dma_async_is_tx_complete(): DMA returned completion callback status of: %s\n", 
			status == DMA_ERROR ? "error" : "in progress");
		return -EIO;
	}

	if (t1-t0) pr_info("DMA size: %4d kiB, time: %7ld cycles, thoughput: %3ld MB/s\n", 
		tr->size/1024, t1-t0, CPU_FREQ*(tr->size/1000)/((t1-t0)/1000));
	else pr_warn("this kernel does not support get_cycles()\n");
////	pr_info("TX[0]=%d, RX[0]=%d\n", ioread32(p), ioread32(p+tx.size/4));
//	mb();
	//if (tr->coherent) 
///	dma_sync_single_for_cpu(tr->rx.chan->device->dev, tr->rx.handle, tr->size, DMA_FROM_DEVICE);
///	outer_clean_range(virt_to_phys(tr->rx.buf), virt_to_phys(tr->rx.buf+tr->size));
//	__cpuc_flush_dcache_area(tr->rx.buf, tr->size);
	return 0;
}

static void dma_release_memory(struct dma_transaction *tr)
{
	if (tr->coherent) {
		dma_free_coherent(tr->tx.chan->device->dev, tr->size, tr->tx.buf, tr->tx.handle);
		dma_free_coherent(tr->rx.chan->device->dev, tr->size, tr->rx.buf, tr->rx.handle);

	} else {
		dma_unmap_single(tr->rx.chan->device->dev, tr->rx.handle, tr->size, DMA_FROM_DEVICE);	
		dma_unmap_single(tr->tx.chan->device->dev, tr->tx.handle, tr->size, DMA_TO_DEVICE);
		kfree(tr->tx.buf);
		kfree(tr->rx.buf);
	}
	return;
}

static void dma_release_channels(struct dma_transaction *tr)
{
	dma_release_channel(tr->tx.chan);
	dma_release_channel(tr->rx.chan);
	return;
}


static int bram_remove(struct platform_device *pdev)
{
	int ret;
	struct resource bram;
	unsigned long bram_virt;
	struct gen_pool_chunk *chunk = NULL;

	pr_info("BRAM controller going down...\n");

	ret = of_address_to_resource(pdev->dev.of_node, 0, &bram);
	if (ret) {
		pr_err("failed to detect BRAM memory address\n");
		return -ENOMEM;
	}

	// find relevant chunk in BRAM pool
	rcu_read_lock();
	list_for_each_entry_rcu(chunk, &bram_pool->chunks, next_chunk)
		if (chunk->phys_addr == bram.start) break;
	rcu_read_unlock();

	// if chunk is found
	if (chunk != NULL) {
		bram_virt = chunk->start_addr;
		list_del_rcu(chunk);
		synchronize_rcu();
		pr_info("BRAM pool chunk removed, current availabe BRAM: %d of %d bytes.\n", 
			gen_pool_avail(bram_pool), gen_pool_size(bram_pool));
	} else pr_err("Unable to associate BRAM controller with BRAM pool chunk! That should not happen.\n");

	iounmap(bram_virt);
	release_mem_region(bram.start, bram.end-bram.start+1);

	if (gen_pool_size(bram_pool) == 0) {
		gen_pool_destroy(bram_pool);
		pr_info("All BRAM controllers are down, BRAM pool destroyed.\n");
	}

	return 0;
}

static int dmac_remove(struct platform_device *pdev)
{
	pr_info("DMA controller going down...\n");
//	struct device *dev = &pdev->dev;
//	struct malaperda_local *lp = dev_get_drvdata(dev);
	dev_set_drvdata(&pdev->dev, NULL);	//TODO understand what this does
	return 0;
}

static int bram_probe(struct platform_device *pdev)
{
	int ret;
	struct resource bram;
	unsigned long bram_virt;
	size_t bram_size;
	
	pr_info("BRAM controller detected, probing...\n");

	ret = of_address_to_resource(pdev->dev.of_node, 0, &bram);
	if (ret) {
		pr_err("failed to detect BRAM memory address\n");
		return -ENOMEM;
	}

	bram_size = bram.end-bram.start+1;
	if  (!request_mem_region(bram.start, bram_size, "bram")) {
		pr_err("error reserving BRAM address range\n");
		return -EAGAIN;
	}

	bram_virt = (unsigned long)ioremap(bram.start, bram_size); //TODO: double check
	if (bram_virt == 0) {
		pr_err("error mapping BRAM memory\n");
		return -ENOMEM;
	}

	pr_info("Detected BRAM at %p, size %d, mapped at %p\n", 
		(void *)bram.start, bram.end-bram.start+1, bram_virt);
	if (bram_pool == NULL) bram_pool = gen_pool_create(5, -1);
	if (bram_pool == NULL) {
		pr_err("error allocating BRAM pool\n");
		return -ENOMEM;
	}
	ret = gen_pool_add_virt(bram_pool, bram_virt, bram.start, bram.end-bram.start+1, -1);
	if (ret != 0) {
		pr_err("error adding to BRAM pool\n");
		return -ENOMEM;
	}

	pr_info("BRAM pool chunk added, current availabe BRAM: %d of %d bytes.\n", 
			gen_pool_avail(bram_pool), gen_pool_size(bram_pool));


	/* p = gen_pool_alloc(bram_pool, 1024);
	if (p == NULL) {
		pr_err("error allocating bram pool\n");
		return -ENOMEM;
	}
	pr_info("succefully allocated bram at virt: %p, phys: %x\n", 
		p, gen_pool_virt_to_phys(bram_pool, (unsigned long)p));
	*/
	return 0;
}

static int dmac_probe(struct platform_device *pdev)
{
	pr_info("Probing for DMACs...\n");

	if (dma_init(&dma, pdev, true, 4*1024*1024) != 0) return -1;
	if (dma_reserve_channels(&dma) != 0) return -1;
	if (dma_reserve_memory(&dma) != 0) {
		dma_release_channels(&dma);
		return -1;
	}
	dma_buffer_fill(&dma, 0);

	if (dma_setup(&dma) != 0) {
		dma_release_channels(&dma);
		dma_release_memory(&dma);
		return -1;
	}
	dma_issue(&dma);
	dma_buffer_verify(&dma);
	dma_release_memory(&dma);
	dma_release_channels(&dma);
	pr_info("module probe success.\n");
	return 0;
}
static struct of_device_id bram_of_match[] = {
//	{ .compatible = "xlnx,axi-bram-ctrl-4.0", },
	{ .compatible = "tuc,bram", },
	{},
};
MODULE_DEVICE_TABLE(of, bram_of_match);

static struct of_device_id dmac_of_match[] = {
	{ .compatible = "tuc,dma-client", },
	{ /* end of list */ },
};
MODULE_DEVICE_TABLE(of, dmac_of_match);


static struct platform_driver dmac_driver = {
	.driver = {
		.name = "dmac",
		.owner = THIS_MODULE,
		.of_match_table = dmac_of_match,

	},
	.probe = dmac_probe,
	.remove = dmac_remove,
};


static struct platform_driver bram_driver = {
	.driver = {
		.name = "bram",
		.owner = THIS_MODULE,
		.of_match_table = bram_of_match,

	},
	.probe = bram_probe,
	.remove = bram_remove,
};


static void __exit mod_exit(void)
{
	platform_driver_unregister(&dmac_driver);
	platform_driver_unregister(&bram_driver);
	pr_info("module exiting...\n");
}


static int __init mod_init(void)
{
	int err;
	pr_info("module initializing...\n");
//	p=ioremap(0x40000000, 128);
//	iowrite32(d0, p);
//	d1 = ioread32(p);
//	pr_info("wrote %8x, read back %8x\n", d0, d1);	
	err = platform_driver_register(&bram_driver);
	if (err) {
		pr_err("error %d while registering BRAM platform driver\n", err);
		return -1;
	}

	err = platform_driver_register(&dmac_driver);
	if (err) {
		pr_err("error %d while registering DMAC platform driver\n", err);
		return -1;
	}
	return 0;
}


module_init(mod_init);
module_exit(mod_exit);
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Ioannis Galanommatis");
MODULE_DESCRIPTION("DMA client to xilinx_dma");
MODULE_VERSION("0.1");

