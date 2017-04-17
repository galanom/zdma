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

#include <linux/of_address.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>
#include <linux/of_reserved_mem.h>

#include "zdma.h"

#ifndef CONFIG_OF
#error "OpenFirmware is not configured in kernel\n"
#endif

extern int xilinx_vdma_channel_set_config(void *, void *);	// FIXME dependency?

//module_param(length, unsigned, S_IRUGO);

static struct dma_transaction {
	struct platform_device *dmac;
	size_t size;
	struct {
		dma_addr_t handle;			// DMA address in bus address space
		void *buf;				// DMA buffer address in virtual address space
		struct dma_chan *chanp;			// Hardware DMA channel
		struct dma_async_tx_descriptor *descp;	// Transfer descriptor
		struct dma_slave_config conf;
		dma_cookie_t cookie;
		struct completion cmp;
	} tx, rx;
} dma;

static int dev_open(struct inode *inodep, struct file *filep);
static int dev_release(struct inode *inodep, struct file *filep);
static long dev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
static int dev_mmap(struct file *filep, struct vm_area_struct *vma);

static struct dma_driver {
	dev_t dev;
	struct cdev cdev;
	struct file_operations fops;
	int nrOpen;
} driver = {
	.fops = {
		.owner = THIS_MODULE,
		.open = dev_open,
		.release = dev_release,
		.mmap = dev_mmap,
		.unlocked_ioctl = dev_ioctl,
	},
	.nrOpen = 0,
};

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

static int dev_mmap(struct file *filep, struct vm_area_struct *vma)
{
	*(u32 *)dma.tx.buf = 0xdeadbeef;
	size_t off = vma->vm_pgoff << PAGE_SHIFT;
	phys_addr_t phys = dma.tx.handle;
	size_t vsize = vma->vm_end - vma->vm_start;
	size_t psize = dma.size - off;

	pr_info("zdma mmap: off=%lu, phys=%#x, vsize=%lu, psize=%lu\n", off, phys, vsize, psize);
	if (vsize > psize) {
		pr_err("virtual space is larger than physical buffer!\n");
		return -EINVAL;
	}

	if (dma_mmap_coherent(dma.tx.chanp->device->dev, vma, dma.tx.buf, dma.tx.handle, vsize) < 0) {
		pr_err("failed to map user buffer!\n");
		return -ENOSPC;//FIXME
	}

	return 0;
}

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
	if (of_reserved_mem_device_init_by_idx(tr->tx.chanp->device->dev, tr->dmac->dev.of_node, 0)) {
		pr_err("fatal: cannot initialize TX port memory region for DMAC\n");
		return -ENOMEM;
	}

	if (of_reserved_mem_device_init_by_idx(tr->rx.chanp->device->dev, tr->dmac->dev.of_node, 1)) {
		pr_err("fatal: cannot initialize RX port memory region for DMAC\n");
		return -ENOMEM;
	}
	
	if ((tr->tx.buf = dma_alloc_coherent(tr->tx.chanp->device->dev, tr->size, &tr->tx.handle, GFP_KERNEL)) == NULL) {
		pr_err("fatal: dma_alloc_coherent() returned NULL!\n");
		return -EAGAIN;
	}
	
	if ((tr->rx.buf = dma_alloc_coherent(tr->rx.chanp->device->dev, tr->size, &tr->rx.handle, GFP_KERNEL)) == NULL) {
		pr_err("fatal: dma_alloc_coherent() returned NULL!\n");
		dma_free_coherent(tr->tx.chanp->device->dev, tr->size, tr->tx.buf, tr->tx.handle);
		return -EAGAIN;
	}
	
	pr_info("DMA mapping: virt: %p->%p, dma: %#x->%#x.\n", tr->tx.buf, tr->rx.buf, tr->tx.handle, tr->rx.handle);
	return 0;
}


static int dma_reserve_channels(struct dma_transaction *tr)
{
	// Request the transmit and receive channels for the AXI DMA from the DMA engine
	if ((tr->tx.chanp = dma_request_slave_channel(&tr->dmac->dev, "tx")) == NULL) {
		pr_err("TX channel reservation failure. "
			"Did you load xilinx_dma kernel module?\n");
		return -EBUSY;
	}

	if ((tr->rx.chanp = dma_request_slave_channel(&tr->dmac->dev, "rx")) == NULL) {
		pr_err("RX channel reservation failure (TX was successful).\n");
		dma_release_channel(tr->tx.chanp);
		return -EBUSY;
	}

	pr_info("DMA channel reservation successful.\n");
	
	return 0;
}


static void dma_buffer_fill(struct dma_transaction *tr, int seed)
{
	for (int i = 0; i < tr->size/4; i++) ((s32 *)tr->tx.buf)[i] = seed+i;
	return;
}

static int dma_buffer_verify(struct dma_transaction *tr)
{
	int err_count = 0, err_first = -1;

	for (int i = 0; i < tr->size/4; i++) if (((s32 *)tr->rx.buf)[i] != ((s32 *)tr->tx.buf)[i]) {
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
	if ((tr->tx.descp = dmaengine_prep_slave_single(tr->tx.chanp, tr->tx.handle, tr->size, 
		DMA_MEM_TO_DEV, DMA_CTRL_ACK|DMA_PREP_INTERRUPT)) == NULL) {
		pr_err("dmaengine_prep_slave_single() returned NULL!\n");
		return tr->tx.cookie = -EBUSY;
	}

	if ((tr->rx.descp = dmaengine_prep_slave_single(tr->rx.chanp, tr->rx.handle, tr->size,
		DMA_DEV_TO_MEM, DMA_CTRL_ACK|DMA_PREP_INTERRUPT)) == NULL) {
		pr_err("dmaengine_prep_slave_single() returned NULL!\n");
		return tr->rx.cookie = -EBUSY;
	}

	tr->tx.descp->callback = tr->rx.descp->callback = sync_callback;
	tr->tx.descp->callback_param = &tr->tx.cmp;
	tr->rx.descp->callback_param = &tr->rx.cmp;

	tr->tx.cookie = dmaengine_submit(tr->tx.descp);
	tr->rx.cookie = dmaengine_submit(tr->rx.descp);

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
	
	pr_info("Issueing DMA request...\n");
	dma_async_issue_pending(tr->tx.chanp);
	dma_async_issue_pending(tr->rx.chanp);
	
	t0 = get_cycles();
	// wait for the transaction to complete, timeout, or get get an error
	timeout = wait_for_completion_timeout(&tr->tx.cmp, msecs_to_jiffies(timeout));
	t1 = get_cycles();
	status = dma_async_is_tx_complete(tr->tx.chanp, tr->tx.cookie, NULL, NULL);

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
	return 0;
}

static void dma_release_memory(struct dma_transaction *tr)
{
	dma_free_coherent(tr->tx.chanp->device->dev, tr->size, tr->tx.buf, tr->tx.handle);
	dma_free_coherent(tr->rx.chanp->device->dev, tr->size, tr->rx.buf, tr->rx.handle);
	return;
}

static void dma_release_channels(struct dma_transaction *tr)
{
	dma_release_channel(tr->tx.chanp);
	dma_release_channel(tr->rx.chanp);
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
	cdev_del(&driver.cdev);
	unregister_chrdev_region(driver.dev, 1 /* count */);
	pr_info("module exiting...\n");
}


static int __init mod_init(void)
{
	pr_info("module initializing...\n");
	
	if (alloc_chrdev_region(&driver.dev, 0 /* first minor */, 1 /* count */, KBUILD_MODNAME) < 0) {
		pr_err("error registering /dev entry\n");
		return -ENOSPC;
	}
	
	cdev_init(&driver.cdev, &driver.fops);
	if (cdev_add(&driver.cdev, driver.dev, 1 /* count */)) {
		pr_err("error registering character device\n");
		return -ENOSPC;
	}

	if (platform_driver_register(&dmac_driver)) {
		pr_err("error registering DMAC platform driver\n");
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

