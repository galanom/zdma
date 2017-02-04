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

/*struct dma_xfer {
	struct dma_chan *chan;
	struct dma_async_tx_descriptor *chan_desc;
	dma_addr_t handle;
	dma_cookie_t cookie;
	struct completion cmp;
	enum dma_data_direction dir;
	int irq;
	unsigned long mem_start;
	unsigned long mem_end;
	void __iomem *base_addr;
	size_t size;
	void *buf;
} tx, rx;
*/
struct dma_transaction {
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
		dma_cookie_t cookie;
		struct completion cmp;
	} tx, rx;
} dma;

/* Handle a callback and indicate the DMA transfer is complete to another
 * thread of control
 */
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


static void sync_callback(void *completion)
{
	/* Step 9, indicate the DMA transaction completed to allow the other
	 * thread of control to finish processing
	 */ 

	complete(completion);

}


int dma_init(struct dma_transaction *tr, struct platform_device *pdev, bool coherent, size_t size)
{
	if (tr == NULL) return -EINVAL;
	tr->dmac = pdev;
	tr->coherent = coherent;
	tr->size = size;
	return 0;
}

int dma_reserve_channels(struct dma_transaction *tr)
{
	// Request the transmit and receive channels for the AXI DMA from the DMA engine
	tr->tx.chan = dma_request_slave_channel(&tr->dmac->dev, "axidma_mm2s");
	if (!tr->tx.chan) { 
		pr_err("dma_request_slave_channel() failed for TX channel (addr: %8p). "
			"Did you load xilinx_dma kernel module?\n", tr->tx.chan);
		return -EBUSY;
	}

	tr->rx.chan = dma_request_slave_channel(&tr->dmac->dev, "axidma_s2mm");
	if (!tr->rx.chan) { 
		pr_err("dma_request_slave_channel() failed for RX channel (addr: %8p) but not for TX!\n", tr->rx.chan);
		dma_release_channel(tr->tx.chan);
		return -EBUSY;
	}

	pr_info("DMA channel reservation successful.\n");
	return 0;
}

int dma_reserve_memory(struct dma_transaction *tr)
{
	if (tr->coherent) {
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
	} else {
		tr->tx.buf = kmalloc(tr->size, GFP_KERNEL);
		tr->rx.buf = kmalloc(tr->size, GFP_KERNEL);

		if (tr->tx.buf == NULL || tr->rx.buf == NULL) {
			pr_err("kmalloc() failed to allocate buffer memory!\n");
			return -EAGAIN;
		}

		tr->tx.handle = dma_map_single(tr->tx.chan->device->dev, tr->tx.buf, tr->size, DMA_TO_DEVICE);	
		if (dma_mapping_error(tr->tx.chan->device->dev, tr->tx.handle)) {
			pr_err("dma_mapping_error() returned an error condition on TX buffer mapping!\n");
			return -EAGAIN;
		};

		tr->rx.handle = dma_map_single(tr->rx.chan->device->dev, tr->rx.buf, tr->size, DMA_FROM_DEVICE);
		if (dma_mapping_error(tr->rx.chan->device->dev, tr->rx.handle)) {
			pr_err("dma_mapping_error() returned an error condition on RX buffer mapping!\n");
			dma_unmap_single(tr->tx.chan->device->dev, tr->tx.handle, tr->size, DMA_TO_DEVICE);
			return -EAGAIN;
		};
	}
	pr_info("mapping: tx.buf=%p, rx.buf=%p, tx.handle=%x, rx.handle=%x.\n",
		tr->tx.buf, tr->rx.buf, tr->tx.handle, tr->rx.handle);
	return 0;
}

void dma_buffer_prepare(struct dma_transaction *tr, int seed)
{
	int i;
	for (i = 0; i < tr->size/4; i++) ((s32 *)tr->tx.buf)[i] = seed+i;
	return;
}

int dma_buffer_verify(struct dma_transaction *tr)
{
	int i, err_count = 0, err_first = -1;

	for (i = 0; i < tr->size/4; i++) if (((s32 *)tr->rx.buf)[i] != ((s32 *)tr->tx.buf)[i]) {
		err_count++;
		if (err_first == -1) err_first = i;
	}

	if (err_count != 0) {
		pr_err("****** DATA MISMATCH ****** error count %d of %d, first at %d. ***\n", 
			err_count, tr->size/4, err_first);
		return -EIO;
	}

	pr_info("Data check successful.\n");
	return 0;
}


int dma_setup(struct dma_transaction *tr)
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

	// DEBUG BLOCK
	__cpuc_flush_dcache_area(tr, sizeof(*tr));
	__cpuc_flush_dcache_area(tr->tx.buf, tr->size);
	outer_clean_range(virt_to_phys(tr), virt_to_phys((void*)tr+sizeof(tr)));
	outer_clean_range(virt_to_phys(tr->tx.buf), virt_to_phys(tr->tx.buf+tr->size));
	mb();

	dma_sync_single_for_device(tr->tx.chan->device->dev, tr->tx.handle, tr->size, DMA_TO_DEVICE);
	tr->tx.cookie = dmaengine_submit(tr->tx.desc);
	tr->rx.cookie = dmaengine_submit(tr->rx.desc);

	if (dma_submit_error(tr->tx.cookie) || dma_submit_error(tr->rx.cookie)) {
		pr_err("prep_buffer(): dma_submit_error(): rx/tx cookie contains error!\n");
		return -EIO;
	}
	
	return 0;
}

int dma_fire(struct dma_transaction *tr)
{
		u32 *p;
	u32 d=0xdeadbeef;
	cycles_t cc;

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

	pr_info("starting transfers...\n");

	/* Start both DMA transfers and wait for them to complete
	 */
	start_transfer(tr->rx.chan, &tr->rx.cmp, tr->rx.cookie, NO_WAIT);
	cc = start_transfer(tr->tx.chan, &tr->tx.cmp, tr->tx.cookie, WAIT);
	if (cc) pr_info("DMA size: %4d kiB, time: %7ld cycles, thoughput: %3ld MB/s\n", 
		tr->size/1024, cc, CPU_FREQ*(tr->size/1000)/(cc/1000));
	else pr_err("start_transfer(): returned zero cycle count!\n");
	/* Step 10, the DMA is done with the buffers so transfer ownership back to the CPU so that
	 * any cache operations needed are done
	 */
	
////	pr_info("TX[0]=%d, RX[0]=%d\n", ioread32(p), ioread32(p+tx.size/4));


	return 0;
}

void dma_cleanup(struct dma_transaction *tr)
{
	mb();
	dma_sync_single_for_cpu(tr->rx.chan->device->dev, tr->rx.handle, tr->size, DMA_FROM_DEVICE);
	outer_clean_range(virt_to_phys(tr->rx.buf), virt_to_phys(tr->rx.buf+tr->size));
	__cpuc_flush_dcache_area(tr->rx.buf, tr->size);
	return;
}

void dma_release_memory(struct dma_transaction *tr)
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

void dma_release_channels(struct dma_transaction *tr)
{
	dma_release_channel(tr->tx.chan);
	dma_release_channel(tr->rx.chan);
	return;
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
	dma_init(&dma, pdev, false, 1024*1024);
	dma_reserve_channels(&dma);
	dma_reserve_memory(&dma);
	dma_buffer_prepare(&dma, 0);
	dma_setup(&dma);
	dma_fire(&dma);
	dma_cleanup(&dma);
	dma_buffer_verify(&dma);
	dma_release_memory(&dma);
	dma_release_channels(&dma);

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
//	p=ioremap(0x40000000, 128);
//	iowrite32(d0, p);
//	d1 = ioread32(p);
//	pr_info("wrote %8x, read back %8x\n", d0, d1);	

	return platform_driver_register(&malaperda_driver);
}


module_init(malaperda_init);
module_exit(malaperda_exit);
MODULE_LICENSE("GPL");

