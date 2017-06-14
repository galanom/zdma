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

#include <linux/of_dma.h>
#include <linux/of_address.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>
#include <linux/of_reserved_mem.h>

#include "zdma.h"
#include "zdma_ioctl.h"

#ifndef CONFIG_OF
#error "OpenFirmware is not configured in kernel\n"
#endif

extern int xilinx_vdma_channel_set_config(void *, void *);	// FIXME dependency?

//module_param(length, unsigned, S_IRUGO);

static struct {
	int dmac_count, zone_count;
	struct {
		struct dma_chan *txchanp, *rxchanp;
		struct device txdev, rxdev;
		int load;
	} *dmac;
	struct {
		size_t sz_total, sz_used;
		struct device_node *nodep;
		phys_addr_t phys;
	} *zone;
} hw;

static struct driver {
	dev_t dev_num;
	struct platform_device *pdev;
	struct cdev cdev;
	struct file_operations fops;
	int nrOpen;
} driver;

struct client {
	int dmac;
	struct {
		size_t size;
		void *buf;
		dma_addr_t handle;
		struct dma_async_tx_descriptor *descp;
		struct dma_slave_config conf;
		dma_cookie_t cookie;
		struct completion cmp;
	} tx, rx;
};


static int dev_open(struct inode *inodep, struct file *filep)
{
	int idx = 0;
	pr_info("step 1\n");
	for (int i = 1, min = hw.dmac[0].load; i < hw.dmac_count; ++i) {
		if (hw.dmac[i].load < min)
			min = hw.dmac[idx=i].load;
	}
	pr_info("(%s) ptr: %p\n", driver.pdev->name, &driver.pdev->dev);
	if ((filep->private_data = devm_kzalloc(&driver.pdev->dev, sizeof(struct client), GFP_KERNEL)) == NULL) {
		pr_err("error allocating memory for client private data!\n");
		return -ENOMEM;
	}
	pr_info("pd=%p\n", filep->private_data);
	((struct client *)filep->private_data)->dmac = idx;
	++hw.dmac[idx].load;
	pr_info("zdma open()\'ed for client %d, served by DMAC %d\n", ++driver.nrOpen, idx);
	return 0;
}


static int dev_release(struct inode *inodep, struct file *filep)
{
	pr_info("zdma release()\'ed for client %d\n", driver.nrOpen--);
	--hw.dmac[((struct client *)filep->private_data)->dmac].load;
	devm_kfree(&driver.pdev->dev, filep->private_data);
	return 0;
}


static long dev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
{
	struct client *p = filep->private_data;
	pr_info("zdma ioctl cmd=%x arg=%lu\n", cmd, arg);
	switch (cmd) {
	case ZDMA_IO_DEBUG:
		break;
	case ZDMA_IO_SET_DMA_SIZE:
		// TODO FIXME WARNING !!! FREE ALREADY ALLOCATED MEMORY !!!
		p->tx.size = 1024*(arg>>16);
		p->rx.size = 1024*(arg && 0xffff);
		pr_info("request to set DMA TX buffer size to TX: %u, RX: %u\n", p->tx.size, p->rx.size);
		
		if (of_reserved_mem_device_init_by_idx(&hw.dmac[p->dmac].txdev, hw.zone[0].nodep, 0)) {
			pr_err("fatal: cannot initialize TX port memory region for DMAC\n");
			return -ENOMEM;
		}
		if (of_reserved_mem_device_init_by_idx(&hw.dmac[p->dmac].rxdev, hw.zone[1].nodep, 0)) {
			pr_err("fatal: cannot initialize RX port memory region for DMAC\n");
			return -ENOMEM;
		}
		if ((p->tx.buf = dma_alloc_coherent(&hw.dmac[p->dmac].txdev, p->tx.size, &p->tx.handle, GFP_KERNEL)) == NULL) {
			pr_err("error: unable to allocate memory for TX channel\n");
			return -EAGAIN;
		}
	
		if ((p->rx.buf = dma_alloc_coherent(&hw.dmac[p->dmac].rxdev, p->rx.size, &p->rx.handle, GFP_KERNEL)) == NULL) {
			pr_err("error: unable to allocate memory for RX channel\n");
			return -EAGAIN;
		}
	
		pr_info("DMA mapping: dmac=%d, virt: %p->%p, dma: %#x->%#x.\n",
			p->dmac, p->tx.buf, p->rx.buf, p->tx.handle, p->rx.handle);
		break;
	default:
		pr_err("uknown ioctl command (cmd: %x, arg: %lu\n", cmd, arg);
		return -ENOTTY;
	}
	return 0l;
}


static int dev_mmap(struct file *filep, struct vm_area_struct *vma)
{
	struct client *p = filep->private_data;
	phys_addr_t off = vma->vm_pgoff << PAGE_SHIFT,
		phys = p->tx.handle,
		vsize = vma->vm_end - vma->vm_start,
		psize = p->tx.size - off;

	if (p->tx.buf == NULL) {
		pr_err("DMA buffers have not yet been allocated\n.");
		return -ENOMEM;
	}

	*(u32 *)p->tx.buf = 0xdeadbeef;
	pr_info("zdma mmap: off=%tx, phys=%#tx, vsize=%#tx, psize=%#tx\n", off, phys, vsize, psize);
	if (vsize > psize) {
		pr_err("virtual space is larger than physical buffer!\n");
		return -EINVAL;
	}


	if (dma_mmap_coherent(&hw.dmac[p->dmac].txdev, vma, p->tx.buf, p->tx.handle, vsize) < 0) {
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


/*static void dma_buffer_fill(struct dma_transaction *tr, int seed)
{
	for (int i = 0; i < tr->size/4; i++) ((s32 *)tr->tx.buf)[i] = seed+i;
	return;
}*/

/*static int dma_buffer_verify(struct dma_transaction *tr)
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
}*/

/*
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
*//*


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
*/

/*static void dma_release_memory(struct dma_transaction *tr)
{
	dma_free_coherent(tr->tx.chanp->device->dev, tr->size, tr->tx.buf, tr->tx.handle);
	dma_free_coherent(tr->rx.chanp->device->dev, tr->size, tr->rx.buf, tr->rx.handle);
	return;
}*/

static int sched_remove(struct platform_device *pdev)
{
	pr_info("scheduler shutting down...\n");
//	dev_set_drvdata(&pdev->dev, NULL);	//TODO understand what this does
	
	while (hw.dmac_count--) {
		pr_info("releasing dmac[%d]\n", hw.dmac_count);
		dma_release_channel(hw.dmac[hw.dmac_count].rxchanp);
		dma_release_channel(hw.dmac[hw.dmac_count].txchanp);
		device_del(&hw.dmac[hw.dmac_count].rxdev);
		device_del(&hw.dmac[hw.dmac_count].txdev);
		put_device(&hw.dmac[hw.dmac_count].rxdev);
		put_device(&hw.dmac[hw.dmac_count].txdev);
	}
	return 0;
}

static int sched_probe(struct platform_device *pdev)
{
	int i, res;

	pr_info("scheduler starting...\n");
	
	driver.pdev = pdev;
	// find dma clients in device tree
	struct device_node *np = NULL, *tnp = NULL;
	for_each_compatible_node(np, NULL, "tuc,dma-client") ++hw.dmac_count;
	if (!hw.dmac_count) {
		pr_err("devicetree: unable to find any compatible DMA controller!\n");
		return -ENODEV;
	}
	pr_info("devicetree: found %d compatible DMA controllers\n", hw.dmac_count);

	if ((hw.dmac = devm_kcalloc(&pdev->dev, hw.dmac_count, sizeof(*hw.dmac), GFP_KERNEL)) == NULL) {
		pr_err("unable to allocate %d bytes for DMA controller hardware description structures!\n", hw.dmac_count*sizeof(*hw.dmac));
		return -ENOMEM;
	}

	i = 0;
	np = NULL;
	for_each_compatible_node(np, NULL, "tuc,dma-client") {
		device_initialize(&hw.dmac[i].txdev);
		device_initialize(&hw.dmac[i].rxdev);
		dev_set_name(&hw.dmac[i].txdev, "%s:dmac%d:tx", dev_name(&pdev->dev), i);
		dev_set_name(&hw.dmac[i].rxdev, "%s:dmac%d:rx", dev_name(&pdev->dev), i);
		hw.dmac[i].txdev.parent = hw.dmac[i].rxdev.parent = &pdev->dev;
		hw.dmac[i].txdev.bus = hw.dmac[i].rxdev.bus = pdev->dev.bus;
		hw.dmac[i].txdev.coherent_dma_mask = hw.dmac[i].rxdev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
		hw.dmac[i].txdev.dma_mask = hw.dmac[i].rxdev.dma_mask = pdev->dev.dma_mask;
		hw.dmac[i].txdev.release = hw.dmac[i].rxdev.release = of_reserved_mem_device_release;
		if ((res = device_add(&hw.dmac[i].txdev))) {
			pr_err("dmac[%d]: error registering TX channel dev\n", i);
			return res;
		}
		if ((res = device_add(&hw.dmac[i].rxdev))) {
			pr_err("dmac[%d]: error registering RX channel dev\n", i);
			return res;
		}

		hw.dmac[i].txchanp = of_dma_request_slave_channel(np, "tx");
		if (IS_ERR_OR_NULL(hw.dmac[i].txchanp)) {
			pr_err("dmac[%d]: failed to reserve TX channel -- devicetree misconfiguration, DMA controller not present or driver not loaded.\n", i);
			while (i--) {
				dma_release_channel(hw.dmac[i].txchanp);
				dma_release_channel(hw.dmac[i].rxchanp);
			}
			return -ENODEV;	// FIXME DOES NOT EXIT GRACEFULLY FIXME
		}
		hw.dmac[i].rxchanp = of_dma_request_slave_channel(np, "rx");
		if (IS_ERR_OR_NULL(hw.dmac[i].rxchanp)) {
			pr_err("dmac[%d]: failed to reserve RX channel -- devicetree misconfiguration, DMA controller not present or driver not loaded.\n", i);
			dma_release_channel(hw.dmac[i].txchanp);
			while (i--) {
				dma_release_channel(hw.dmac[i].txchanp);
				dma_release_channel(hw.dmac[i].rxchanp);
			}
			return -ENODEV;
		}
		hw.dmac[i].load = 0;
		++i;
	}
	pr_info("%d channel pairs initialized\n", i);

	// find reserved memory regions
	np = NULL;
	for_each_compatible_node(np, NULL, "tuc,zone") ++hw.zone_count;

	if (hw.zone_count == 0) {
		pr_err("devicetree: no suitable memory zones are defined!\n");
		return -ENODEV;
	}
	pr_info("devicetree: found %d memory regions\n", hw.zone_count);

	if ((hw.zone = devm_kcalloc(&pdev->dev, hw.zone_count, sizeof(*hw.zone), GFP_KERNEL)) == NULL) {
		pr_err("unable to allocate %d bytes for memory region description structures!\n", hw.zone_count*sizeof(*hw.zone));
		return -ENOMEM;
	}

	// re-walk the memory region, now in order to save parameters 
	i = 0;
	np = NULL;
	u64 size;
	for_each_compatible_node(np, NULL, "tuc,zone") {
		BUG_ON(i >= hw.zone_count);
		tnp = of_parse_phandle(np, "memory-region", 0);
		if (!tnp) {
			pr_err("devicetree: memory region node %d does not contain a phandle to a memory bank\n", i);
			return -ENODEV;
		}
		hw.zone[i].phys = of_translate_address(tnp, of_get_address(tnp, 0, &size, NULL));
		hw.zone[i].nodep = np;
		hw.zone[i].sz_used = 0;
		hw.zone[i].sz_total = size;
		BUG_ON((u64)hw.zone[i].sz_total != size);
		pr_info("memory region %d: %#10tx-%#10tx, size: %#10tx (%6dkiB)\n", 
			i, hw.zone[i].phys, hw.zone[i].phys+hw.zone[i].sz_total-1, hw.zone[i].sz_total, hw.zone[i].sz_total/1024);
		++i;
	}


	
/*	if (dma_init(&dma, pdev, 4*1024*1024) != 0) return -1;
	if (dma_reserve_channels(&dma) != 0) return -1;
	if (dma_reserve_memory(&dma) != 0) {
//		dma_release_channels(&dma);
		return -1;
	}
	dma_buffer_fill(&dma, 0);

	if (dma_setup(&dma) != 0) {
//		dma_release_channels(&dma);
		dma_release_memory(&dma);
		return -1;
	}
	dma_issue(&dma);
	dma_buffer_verify(&dma);
//	dma_release_memory(&dma);
//	dma_release_channels(&dma);
*/	
	return 0;
}

static struct of_device_id sched_of_match[] = {
	{ .compatible = "tuc,sched", },
	{ /* end of list */ },
};
MODULE_DEVICE_TABLE(of, sched_of_match);


static struct platform_driver sched_driver = {
	.driver = {
		.name = "sched",
		.owner = THIS_MODULE,
		.of_match_table = sched_of_match,
	},
	.probe = sched_probe,
	.remove = sched_remove,
};


static void __exit mod_exit(void)
{
	platform_driver_unregister(&sched_driver);
	cdev_del(&driver.cdev);
	unregister_chrdev_region(driver.dev_num, 1 /* count */);
	pr_info("module exiting...\n");
}


static int __init mod_init(void)
{
	pr_info("module initializing...\n");

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
	if (platform_driver_register(&sched_driver)) {
		pr_err("error registering scheduler platform driver\n");
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
