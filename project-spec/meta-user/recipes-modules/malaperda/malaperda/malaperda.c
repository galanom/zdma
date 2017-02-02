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

#include <linux/of_address.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>
#include <asm/cacheflush.h>
#include <asm/outercache.h>

#define WAIT 	1
#define NO_WAIT 0
#define DRIVER_NAME "malaperda"

unsigned length = 4096*1024;
//module_param(length, unsigned, S_IRUGO);

struct dma_xfer {
	struct dma_chan *chan;
	struct dma_async_tx_descriptor *chan_desc;
	dma_addr_t handle;
	dma_cookie_t cookie;
	struct completion cmp;
	enum dma_data_direction dir;
/*	int irq;
	unsigned long mem_start;
	unsigned long mem_end;
	void __iomem *base_addr;*/
	size_t size;
	void *buf;
} tx, rx;

struct dma_transfer {
	bool coherent;			// coherent or streaming API
	struct {
		dma_addr_t bus_addr;	// DMA address in bus address space
		void *virt_addr;	// DMA buffer address in virtual address space
//		enum dma_data_direction ddir;		// for dma_(un)map_single()
//		enum dma_transfer_direction tdir;	// for dmaengine_prep_slave_single()
//		unsigned long flags;
		struct dma_chan *chan;			// Hardware DMA channel
		struct dma_async_tx_descriptor *desc;	// Transfer descriptor
		struct completion cmp;
	} tx, rx;
	size_t size;
} dma;


int dma_transfer_prepare(struct dma_transfer *transaction, bool coherent, size_t size)
{
	transaction->coherent = coherent;
	transaction->size = size;

	if (coherent) {
		transaction->tx.virt_addr = dma_alloc_coherent(
			tx.chan->device->dev, tx.size, &tx.handle, GFP_KERNEL)
	} else {
	}
}


/* Handle a callback and indicate the DMA transfer is complete to another
 * thread of control
 */
static void sync_callback(void *completion)
{
	/* Step 9, indicate the DMA transaction completed to allow the other
	 * thread of control to finish processing
	 */ 

	complete(completion);

}

/* Start a DMA transfer that was previously submitted to the DMA engine and then
 * wait for it complete, timeout or have an error
 */
static cycles_t start_transfer(struct dma_chan *chan, struct completion *cmp, 
					dma_cookie_t cookie, int wait)
{
	unsigned long timeout = msecs_to_jiffies(3000);
	enum dma_status status;
	cycles_t t1=-1, t0=-1;

	/* Step 7, initialize the completion before using it and then start the 
	 * DMA transaction which was previously queued up in the DMA engine
	 */

	init_completion(cmp);
	t0 = get_cycles();
	dma_async_issue_pending(chan);
	if (wait) {
		pr_info("Waiting for DMA to complete...\n");

		/* Step 8, wait for the transaction to complete, timeout, or get
		 * get an error
		 */

		timeout = wait_for_completion_timeout(cmp, timeout);
		t1 = get_cycles();
		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);

		/* Determine if the transaction completed without a timeout and
		 * withtout any errors
		 */
		if (timeout == 0)  {
			pr_err("wait_for_completion_timeout(): DMA timed out!\n");
		} else if (status != DMA_COMPLETE) {
			pr_err("dma_async_is_tx_complete(): DMA returned completion callback status of: %s\n",
			       status == DMA_ERROR ? "error" : "in progress");
		}
		pr_info("leaving with time diff = %lu\n", t1-t0);
		return t1-t0;
	}
	pr_info("leaving with no wait\n");
	return 0;
}

static int test_transfer(void)
{
	u32 *p;
	u32 d=0xdeadbeef;
	int i, err_count=0, err_first=-1;
	cycles_t cc;

	tx.buf = kmalloc(tx.size, GFP_KERNEL);
	rx.buf = kmalloc(rx.size, GFP_KERNEL);
	if (tx.buf == NULL || rx.buf == NULL) {
		pr_err("failed to allocate buffer memory!\n");
		return -1;
	}
/*
	tx.buf = dma_alloc_coherent(tx.chan->device->dev, tx.size, &tx.handle, GFP_KERNEL);
	if (tx.buf == NULL) {
		pr_err("fatal: dma_alloc_coherent() returned NULL!\n");
		return -1;
	}
	rx.buf = dma_alloc_coherent(rx.chan->device->dev, rx.size, &rx.handle, GFP_KERNEL);
	if (rx.buf == NULL) {
		pr_err("fatal: dma_alloc_coherent() returned NULL!\n");
		dma_free_coherent(tx.chan->device->dev, tx.size, tx.buf, tx.handle);
		return -1;
	}
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
	for (i = 0; i < tx.size/8; i++) ((s64 *)tx.buf)[i] = i;

	/* Step 4, since the CPU is done with the buffers, transfer ownership to the DMA and don't
	 * touch the buffers til the DMA is done, transferring ownership may involve cache operations

*/
	tx.handle = dma_map_single(tx.chan->device->dev, tx.buf, tx.size, tx.dir = DMA_TO_DEVICE);	
	if (dma_mapping_error(tx.chan->device->dev, tx.handle)) {
		pr_err("dma_mapping_error() returned an error condition on TX buffer mapping!\n");
		return -1;
	};

	rx.handle = dma_map_single(rx.chan->device->dev, rx.buf, rx.size, rx.dir = DMA_FROM_DEVICE);
	if (dma_mapping_error(rx.chan->device->dev, rx.handle)) {
		pr_err("dma_mapping_error() returned an error condition on RX buffer mapping!\n");
		dma_unmap_single(tx.chan->device->dev, tx.handle, tx.size, tx.dir);
		return -1;
	};

//	pr_info("dma_map_single() handles: tx: %8x, rx: %8x (size %d)\n", tx.handle, rx.handle, sizeof(tx.handle));

	/* Prepare the DMA buffers and the DMA transactions to be performed and make sure there was not
	 * any errors
	 */
	pr_info("mapping: tx.buf=%p, rx.buf=%p, tx.handle=%x, rx.handle=%x.\n",
		tx.buf, rx.buf, tx.handle, rx.handle);

	tx.chan_desc = dmaengine_prep_slave_single(tx.chan, tx.handle, tx.size, 
		DMA_MEM_TO_DEV, DMA_CTRL_ACK|DMA_PREP_INTERRUPT);
	if (tx.chan_desc == NULL) {
		pr_err("dmaengine_prep_slave_single() returned NULL!\n");
		return tx.cookie = -EBUSY;
	}
	rx.chan_desc = dmaengine_prep_slave_single(rx.chan, rx.handle, rx.size, 
		DMA_DEV_TO_MEM, DMA_CTRL_ACK|DMA_PREP_INTERRUPT);
	if (rx.chan_desc == NULL) {
		pr_err("dmaengine_prep_slave_single() returned NULL!\n");
		return rx.cookie = -EBUSY;
	}

	tx.chan_desc->callback = rx.chan_desc->callback = sync_callback;
	tx.chan_desc->callback_param = &tx.cmp;
	rx.chan_desc->callback_param = &rx.cmp;
	__cpuc_flush_dcache_area(&tx, sizeof(tx));
	__cpuc_flush_dcache_area(&rx, sizeof(rx));
	__cpuc_flush_dcache_area(tx.buf, tx.size);
	outer_clean_range(virt_to_phys(&tx), virt_to_phys(&tx+sizeof(tx)));
	outer_clean_range(virt_to_phys(&rx), virt_to_phys(&rx+sizeof(rx)));
	outer_clean_range(virt_to_phys(tx.buf), virt_to_phys(tx.buf+tx.size));
	mb();
	dma_sync_single_for_device(tx.chan->device->dev, tx.handle, tx.size, tx.dir);
	tx.cookie = dmaengine_submit(tx.chan_desc);
	rx.cookie = dmaengine_submit(rx.chan_desc);

	if (dma_submit_error(tx.cookie) || dma_submit_error(rx.cookie)) {
		pr_err("prep_buffer(): dma_submit_error(): rx/tx cookie contains error!\n");
		return -1;
	}
	
	pr_info("starting transfers...\n");

	/* Start both DMA transfers and wait for them to complete
	 */
	start_transfer(rx.chan, &rx.cmp, rx.cookie, NO_WAIT);
	cc = start_transfer(tx.chan, &tx.cmp, tx.cookie, WAIT);
	if (cc) pr_info("DMA size: %4d kiB, time: %7ld cycles, thoughput: %3ld MB/s\n", 
		tx.size/1024, cc, CPU_FREQ*(tx.size/1000)/(cc/1000));
	else pr_err("start_transfer(): returned zero cycle count!\n");
	mb();
	dma_sync_single_for_cpu(rx.chan->device->dev, rx.handle, rx.size, rx.dir);
	/* Step 10, the DMA is done with the buffers so transfer ownership back to the CPU so that
	 * any cache operations needed are done
	 */
	
////	pr_info("TX[0]=%d, RX[0]=%d\n", ioread32(p), ioread32(p+tx.size/4));

///	dma_free_coherent(tx.chan->device->dev, tx.size, tx.buf, tx.handle);
////	dma_free_coherent(rx.chan->device->dev, rx.size, rx.buf, rx.handle);
	dma_unmap_single(rx.chan->device->dev, rx.handle, rx.size, DMA_FROM_DEVICE);	
	dma_unmap_single(tx.chan->device->dev, tx.handle, tx.size, DMA_TO_DEVICE);
	outer_clean_range(virt_to_phys(rx.buf), virt_to_phys(rx.buf+rx.size));
	__cpuc_flush_dcache_area(rx.buf, rx.size);

	/* Verify the data in the destination buffer matches the source buffer 
	 */
	for (i = 0; i < tx.size/8; i++) if (((s64 *)rx.buf)[i] != ((s64 *)tx.buf)[i]) {
		err_count++;
		if (err_first == -1) err_first = i;
	}
	if (err_count == 0) pr_info("Data check successful.\n");
	else pr_info("*** DATA MISMATCH - error count %d of %d, first at %d. ***\n", 
		err_count, tx.size/8, err_first);
	kfree(tx.buf);
	kfree(rx.buf);
	return 0;
}

static int malaperda_remove(struct platform_device *pdev)
{
	pr_info("module being removed...\n");
//	struct device *dev = &pdev->dev;
//	struct malaperda_local *lp = dev_get_drvdata(dev);
//	free_irq(lp->irq, lp);
//	release_malaperda_region(lp->malaperda_start, lp->malaperda_end - lp->malaperda_start + 1);
//	kfree(lp);
	dev_set_drvdata(&pdev->dev, NULL);
	return 0;
}

#ifdef CONFIG_OF
static struct of_device_id malaperda_of_match[] = {
	{ .compatible = "peokroustis,malaperda", },
	{ /* end of list */ },
};
MODULE_DEVICE_TABLE(of, malaperda_of_match);
#else
# define malaperda_of_match
#endif

static int malaperda_probe(struct platform_device *pdev)
{
	pr_info("module probing...\n");

	// Request the transmit and receive channels for the AXI DMA from the DMA engine
	tx.chan = dma_request_slave_channel(&pdev->dev, "axidma_mm2s");
	if (!tx.chan) { 
		pr_err("dma_request_slave_channel() failed for TX channel (addr: %8p). "
			"Did you load xilinx_dma?\n", tx.chan);
		return -1;
	}

	rx.chan = dma_request_slave_channel(&pdev->dev, "axidma_s2mm");
	if (!rx.chan) { 
		pr_err("dma_request_slave_channel() failed for RX channel (addr: %8p). "
			"Did you load xilinx_dma?\n", rx.chan);
		dma_release_channel(tx.chan);
		return -1;
	}

	pr_info("dma_request_slave_channel() done.\n");
	
	test_transfer();

	pr_info("all tests complete, releasing channels...\n");
	dma_release_channel(tx.chan);
	dma_release_channel(rx.chan);
	return 0;
}

static struct platform_driver malaperda_driver = {
	.driver = {
		.name = DRIVER_NAME,
		.owner = THIS_MODULE,
		.of_match_table = malaperda_of_match,

	},
	.probe = malaperda_probe,
	.remove = malaperda_remove,
};

static void __exit malaperda_exit(void)
{
	platform_driver_unregister(&malaperda_driver);
	pr_info("module exiting...\n");
}


static int __init malaperda_init(void)
{
	pr_info("module starting...\n");
	tx.size = rx.size = length;
//	p=ioremap(0x40000000, 128);
//	iowrite32(d0, p);
//	d1 = ioread32(p);
//	pr_info("wrote %8x, read back %8x\n", d0, d1);	

	return platform_driver_register(&malaperda_driver);
}


module_init(malaperda_init);
module_exit(malaperda_exit);
MODULE_LICENSE("GPL");

