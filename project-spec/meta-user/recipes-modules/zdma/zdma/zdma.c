#define pr_fmt(fmt) "[" KBUILD_MODNAME "] %s():%d: " fmt, __func__, __LINE__
#define CPU_FREQ 667

#include <linux/module.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/slab.h>
#include <linux/timex.h>

#include <linux/dmaengine.h>
#include <linux/dma-mapping.h>
#include <linux/dma-contiguous.h>

#include <linux/of_address.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>
#include <linux/of_reserved_mem.h>

#define DMAC_COUNT 4

#ifndef CONFIG_OF
#error "OpenFirmware is not configured in Linux kernel\n"
#endif

extern int xilinx_vdma_channel_set_config(void *, void *);	// FIXME dependency?

//module_param(length, unsigned, S_IRUGO);

static struct dma_transaction {
	struct platform_device *dmac;
	size_t size;
	struct {
		dma_addr_t handle;			// DMA address in bus address space
		void *buf;				// DMA buffer address in virtual address space
		struct dma_chan *chan;			// Hardware DMA channel
		struct dma_async_tx_descriptor *desc;	// Transfer descriptor
		struct dma_slave_config conf;
		dma_cookie_t cookie;
		struct completion cmp;
	} tx, rx;
} dma;

static struct dma_driver {
	dev_t dev;
	int nrOpen;
} driver = {.nrOpen = 0};

static int dev_open(struct inode *inodep, struct file *filep)
{
	pr_info("zdma open()\'ed for client %d\n", ++driver.nrOpen);
	return 0;
}

static int dev_release(struct inode *inodep, struct file *filep)
{
	pr_info("zdma release()\'ed for client %d\n", driver.nrOpen--);
	return 0;
}
static long dev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
{
	pr_info("zdma ioctl cmd=%u arg=%lu\n", cmd, arg);
	return 0l;
}

static struct file_operations fops = {
	.owner = THIS_MODULE,
	.open = dev_open,
	.release = dev_release,
	.unlocked_ioctl = dev_ioctl,
};

static void sync_callback(void *completion)
{
	// Indicate the DMA transaction completed to allow the other thread to finish processing
	complete(completion);
	return;
}


static int dma_init(struct dma_transaction *tr, struct platform_device *pdev, size_t size)
{
	if (tr == NULL) return -EINVAL;
	tr->dmac = pdev;
	tr->size = size;
	pr_info("DMAC init success\n");
	return 0;
}

static int dma_reserve_memory(struct dma_transaction *tr)
{
	int res;

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
	
	pr_info("DMA mapping: virt: %p->%p, dma: %#x->%#x.\n",
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
	unsigned long timeout = 3000;
	enum dma_status status;
	cycles_t t0, t1;
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
///	dma_sync_single_for_cpu(tr->rx.chan->device->dev, tr->rx.handle, tr->size, DMA_FROM_DEVICE);
	return 0;
}

static void dma_release_memory(struct dma_transaction *tr)
{
	dma_free_coherent(tr->tx.chan->device->dev, tr->size, tr->tx.buf, tr->tx.handle);
	dma_free_coherent(tr->rx.chan->device->dev, tr->size, tr->rx.buf, tr->rx.handle);
	return;
}

static void dma_release_channels(struct dma_transaction *tr)
{
	dma_release_channel(tr->tx.chan);
	dma_release_channel(tr->rx.chan);
	return;
}


static int dmac_remove(struct platform_device *pdev)
{
	pr_info("DMA controller going down...\n");
	dev_set_drvdata(&pdev->dev, NULL);	//TODO understand what this does
	return 0;
}

static int dmac_probe(struct platform_device *pdev)
{
	pr_info("Probing for DMACs...\n");

	if (dma_init(&dma, pdev, 4*1024*1024) != 0) return -1;
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


static void __exit mod_exit(void)
{
	platform_driver_unregister(&dmac_driver);
	unregister_chrdev_region(driver.dev, 1 /* count */);
	pr_info("module exiting...\n");
}


static int __init mod_init(void)
{
	int err;
	pr_info("module initializing...\n");
	err = alloc_chrdev_region(&driver.dev, 0 /* first minor */, 1 /* count */, "zdma");
	if (err) {
		pr_err("error registering /dev entry\n");
		return -ENOSPC;
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
MODULE_VERSION("0.2");
