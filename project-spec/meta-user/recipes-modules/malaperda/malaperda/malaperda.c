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

static struct dma_chan *tx_chan;
static struct dma_chan *rx_chan;
static struct completion tx_cmp;
static struct completion rx_cmp;
static dma_cookie_t tx_cookie;
static dma_cookie_t rx_cookie;
static dma_addr_t tx_dma_handle;
static dma_addr_t rx_dma_handle;

#define WAIT 	1
#define NO_WAIT 0
#define DRIVER_NAME "malaperda"

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

/* Prepare a DMA buffer to be used in a DMA transaction, submit it to the DMA engine 
 * to queued and return a cookie that can be used to track that status of the 
 * transaction
 */
static dma_cookie_t prep_buffer(struct dma_chan *chan, dma_addr_t buf, size_t len, 
				enum dma_transfer_direction dir, struct completion *cmp) 
{
	enum dma_ctrl_flags flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
	struct dma_async_tx_descriptor *chan_desc;
	dma_cookie_t cookie;

	/* Step 5, create a buffer (channel)  descriptor for the buffer since only a  
	 * single buffer is being used for this transfer
	 */

	chan_desc = dmaengine_prep_slave_single(chan, buf, len, dir, flags);

	/* Make sure the operation was completed successfully
	 */
	if (!chan_desc) {
		pr_err("dmaengine_prep_slave_single() returned NULL\n");
		cookie = -EBUSY;
	} else {
		chan_desc->callback = sync_callback;
		chan_desc->callback_param = cmp;

		/* Step 6, submit the transaction to the DMA engine so that it's queued
		 * up to be processed later and get a cookie to track it's status
		 */
		pr_info("will submit descriptor...\n");
		cookie = dmaengine_submit(chan_desc);
	
	}
	return cookie;
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

static void test_transfer(int dma_length)
{
	int i;
	cycles_t cc;

	/* Step 3, allocate cached memory for the transmit and receive buffers to use for DMA
	 * zeroing the destination buffer
	 */

	char *src_dma_buffer = kmalloc(dma_length, GFP_KERNEL);
	char *dst_dma_buffer = kzalloc(dma_length, GFP_KERNEL);

	pr_info("dma_length=%d, src_dma_buffer=%8p, dst_dma_buffer=%8p\n", dma_length, src_dma_buffer, dst_dma_buffer);

	if (!src_dma_buffer || !dst_dma_buffer) {
		pr_err("kmalloc() returned NULL!\n");
		return;
	}

	/* Initialize the source buffer with known data to allow the destination buffer to
	 * be checked for success
	 */
	for (i = 0; i < dma_length/sizeof(src_dma_buffer[0]); i++) 
		src_dma_buffer[i] = i;

	/* Step 4, since the CPU is done with the buffers, transfer ownership to the DMA and don't
	 * touch the buffers til the DMA is done, transferring ownership may involve cache operations
	 */
	debug_dma_mapping_error(tx_chan->device->dev, tx_dma_handle);
	debug_dma_mapping_error(rx_chan->device->dev, rx_dma_handle);
	tx_dma_handle = dma_map_single(tx_chan->device->dev, src_dma_buffer, dma_length, DMA_TO_DEVICE);	
	rx_dma_handle = dma_map_single(rx_chan->device->dev, dst_dma_buffer, dma_length, DMA_FROM_DEVICE);
	
	if (dma_mapping_error(tx_chan->device->dev, tx_dma_handle)) {
		pr_err("dma_mapping_error() returned an error condition on TX buffer mapping!\n");
	};
	if (dma_mapping_error(rx_chan->device->dev, rx_dma_handle)) {
		pr_err("dma_mapping_error() returned an error condition on RX buffer mapping!\n");
	};

	//debug_dma_dump_map_errors
	pr_info("dma_map_single() returned tx_dma_handle: %8x, rx_dma_handle: %8x\n", tx_dma_handle, rx_dma_handle);

	
	/* Prepare the DMA buffers and the DMA transactions to be performed and make sure there was not
	 * any errors
	 */
	rx_cookie = prep_buffer(rx_chan, rx_dma_handle, dma_length, DMA_DEV_TO_MEM, &rx_cmp);
	tx_cookie = prep_buffer(tx_chan, tx_dma_handle, dma_length, DMA_MEM_TO_DEV, &tx_cmp);

	if (dma_submit_error(rx_cookie) || dma_submit_error(tx_cookie)) {
		pr_err("prep_buffer(): dma_submit_error(): rx/tx cookie contains error!\n");
		return;
	}

	pr_info("starting transfers...\n");

	/* Start both DMA transfers and wait for them to complete
	 */
	start_transfer(rx_chan, &rx_cmp, rx_cookie, NO_WAIT);
	cc = start_transfer(tx_chan, &tx_cmp, tx_cookie, WAIT);
	if (cc) pr_info("DMA size: %4d kiB, time: %7ld cycles, thoughput: %3ld MB/s\n", dma_length/1024, cc, CPU_FREQ*dma_length/cc);
	else pr_err("start_transfer(): returned zero cycle count!\n");

	/* Step 10, the DMA is done with the buffers so transfer ownership back to the CPU so that
	 * any cache operations needed are done
	 */

	dma_unmap_single(rx_chan->device->dev, rx_dma_handle, dma_length, DMA_FROM_DEVICE);	
	dma_unmap_single(tx_chan->device->dev, tx_dma_handle, dma_length, DMA_TO_DEVICE);

	/* Verify the data in the destination buffer matches the source buffer 
	 */
	for (i = 0; i < dma_length/sizeof(dst_dma_buffer[0]); i++) {
		if (dst_dma_buffer[i] != src_dma_buffer[i]) {
			pr_err("transfer data check mismatch at i=%d\n", i);
			break;	
		}
	}

	/* Step 11, free the buffers used for DMA back to the kernel
	 */

	kfree(src_dma_buffer);
	kfree(dst_dma_buffer);	

}

static int malaperda_remove(struct platform_device *pdev)
{
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
	int i;
//	dma_cap_mask_t mask;

	pr_info("module probing...\n");

	/* Step 1, zero out the capability mask then initialize
	 * it for a slave channel that is private
	 */

//	dma_cap_zero(mask);
//	dma_cap_set(DMA_SLAVE | DMA_PRIVATE, mask);
	
	/* Step 2, request the transmit and receive channels for the AXI DMA
	 * from the DMA engine
	 */
	
	tx_chan = dma_request_slave_channel(&pdev->dev, "axidma_mm2s");
	if (tx_chan == NULL) { 
		pr_err("dma_request_slave_channel() failed for TX channel (addr: %8p). Did you load xilinx_dma?\n", tx_chan);
		return -1;
	}

	rx_chan = dma_request_slave_channel(&pdev->dev, "axidma_s2mm");
	if (rx_chan == NULL) { 
		pr_err("dma_request_slave_channel() failed for RX channel (addr: %8p). Did you load xilinx_dma?\n", rx_chan);
		dma_release_channel(tx_chan);
		return -1;
	}


	pr_info("dma_request_channel() done, calling test_transfer()...\n");
	for (i = 1; i <= 1; i*=2) test_transfer(i*1024*1024);

	/* Step 12, release the DMA channels back to the DMA engine
	 */
	pr_info("all tests complete, releasing channels...\n");
	dma_release_channel(tx_chan);
	dma_release_channel(rx_chan);
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
	pr_info("module started.\n");
	return platform_driver_register(&malaperda_driver);
}


module_init(malaperda_init);
module_exit(malaperda_exit);
MODULE_LICENSE("GPL");

