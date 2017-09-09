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

//module_param(length, unsigned, S_IRUGO);

static struct {
	int dmac_count, zone_count;
	struct dma_controller {
		struct dma_chan *txchanp, *rxchanp;
		int load;
		unsigned id;
	} *dmac;
	struct dma_zone {
		int id;
		dma_addr_t dma_addr;	// FIXME drop this
		phys_addr_t phys_addr;
		unsigned long virt_addr;
		size_t size, limit, used;
		struct platform_device *pdev;
	} *zone;
} hw;


static struct driver {
	struct gen_pool *mempool;
	dev_t dev_num;
	struct platform_device *pdev;
	struct cdev cdev;
	struct file_operations fops;
	int clients;
} driver;


struct client {
	struct dma_controller *dmac;
	struct dma_config conf;
	struct {
		struct dma_zone *zone;
		phys_addr_t phys_addr;
		dma_addr_t dma_addr;
		unsigned long virt_addr;
		struct dma_async_tx_descriptor *descp;
		struct dma_slave_config conf;
		dma_cookie_t cookie;
		struct completion cmp;
	} tx, rx;
};


static void sync_callback(void *completion)
{
	// Indicate the DMA transaction completed to allow the other thread to finish processing
	complete(completion);
	return;
}


static void client_dmac_alloc(struct client *p)
{
	BUG_ON(IS_ERR_OR_NULL(p));

	if (p->dmac != NULL) {
		// FIXME wait for pending transfers
		// FIXME channel release?
		p->dmac->load--;
	}

	p->dmac = &hw.dmac[0];
	for (int i = 1, min = hw.dmac[0].load; i < hw.dmac_count; ++i) {
		if (hw.dmac[i].load < min) {
			p->dmac = &hw.dmac[i];
			min = hw.dmac[i].load;	// pick i-th DMAC
		}
	}
	p->dmac->load++;			// increase usage counter of selected DMAC
	pr_info("reserved DMAC %d with load %d\n", p->dmac->id, p->dmac->load);
	return;
}



static int client_mem_alloc(struct client *p, size_t tx_size, size_t rx_size)
{
	BUG_ON(IS_ERR_OR_NULL(p));

	if (p->dmac == NULL) client_dmac_alloc(p);

	if (p->conf.tx_size != 0 && p->conf.rx_size != 0) client_dmac_alloc(p);

	if (p->tx.zone) {
		gen_pool_free(driver.mempool, p->tx.virt_addr, p->conf.tx_size);
		p->tx.zone->used -= p->conf.tx_size;
	}
	if (p->rx.zone) {
		gen_pool_free(driver.mempool, p->rx.virt_addr, p->conf.rx_size);
		p->rx.zone->used -= p->conf.rx_size; /* ATOMIC FIXME */
	}

	if (tx_size == 0 && rx_size == 0) {
		p->dmac->load--;
		return 0;
	}

	// step 1: pick zone
	p->tx.zone = p->rx.zone = &hw.zone[0];
	for (int i = 1, max = hw.zone[0].limit - hw.zone[0].used; i < hw.zone_count; ++i) {
		if (hw.zone[i].limit - hw.zone[i].used >= max) {	// keep equal for 2nd max
			max = hw.zone[i].limit - hw.zone[i].used;
			p->tx.zone = p->rx.zone;
			p->rx.zone = &hw.zone[i];
		}
	}
	
	pr_info("request to set DMA buffer size to TX: %zukiB, RX: %zukiB\n", tx_size/Ki, rx_size/Ki);
	
	p->tx.virt_addr = (unsigned long)gen_pool_dma_alloc(driver.mempool, tx_size, &p->tx.dma_addr);
	if (!p->tx.virt_addr) {
		// TODO implement memory defragmentation
		pr_warn("unable to allocate %zuKi of DMA memory for client TX buffer\n", tx_size/Ki);
		return -ENOMEM;
	}
	p->rx.virt_addr = (unsigned long)gen_pool_dma_alloc(driver.mempool, rx_size, &p->rx.dma_addr);
	if (!p->rx.virt_addr) {
		pr_warn("unable to allocate %zuKi of DMA memory for client RX buffer\n", rx_size/Ki);
		gen_pool_free(driver.mempool, p->tx.virt_addr, tx_size);
		return -ENOMEM;
	}
	
	p->tx.phys_addr = dma_to_phys(&p->tx.zone->pdev->dev, p->tx.dma_addr);
	p->rx.phys_addr = dma_to_phys(&p->rx.zone->pdev->dev, p->rx.dma_addr);

	p->tx.zone->used += tx_size;
	p->rx.zone->used += rx_size;
	
	// if no error...
	p->conf.tx_size = tx_size;
	p->conf.rx_size = rx_size;

	return 0;
}

static int dma_zone_add(struct device_node *np, phys_addr_t paddr, size_t limit, size_t size)
{
	// reserve new memory
	void *q = devm_kcalloc(&driver.pdev->dev, hw.zone_count+1, sizeof(*hw.zone), GFP_KERNEL);
	if (q == NULL) {
		pr_err("unable to allocate %zu bytes for memory region description structures!\n", 
			hw.zone_count*sizeof(*hw.zone));
		return -ENOMEM;
	}
	memcpy(q, hw.zone, hw.zone_count*sizeof(*hw.zone));
	devm_kfree(&driver.pdev->dev, hw.zone);
	hw.zone = q;
	hw.zone_count++;
	struct dma_zone *zone = &hw.zone[hw.zone_count - 1];
	
	// create zone structure
	zone->id = hw.zone_count-1;
	zone->phys_addr = paddr;
	zone->used = 0;
	zone->limit = limit;
	zone->size = size;

	// create pseudo device structure
	zone->pdev = platform_device_alloc("zone", zone->id);
	if (zone->pdev == NULL) {
		pr_err("unable to allocate memory for platform device\n");
		return -ENOMEM;
	}

	dev_set_name(&zone->pdev->dev, "%s@%d", "zone", zone->id);
	zone->pdev->dev.parent			= &driver.pdev->dev;
	zone->pdev->dev.bus			= driver.pdev->dev.bus;
	zone->pdev->dev.coherent_dma_mask	= driver.pdev->dev.coherent_dma_mask;
	zone->pdev->dev.dma_mask		= driver.pdev->dev.dma_mask;
	zone->pdev->dev.release			= of_reserved_mem_device_release;
	int res = device_add(&zone->pdev->dev);
	if (res != 0) {
		pr_err("error %d while registering device for zone %d\n", res, zone->id);
		return res;
	}
	
	// seek to desired zone...
	if (of_reserved_mem_device_init_by_idx(&zone->pdev->dev, np, 0)) {
		pr_err("error: cannot initialize detected zone reserved memory!\n");
		return -ENOMEM;
	}

	// dmam_alloc_attrs() is implemented in 4.13, port when possible -- FIXME look for release
	zone->virt_addr = (unsigned long)dma_alloc_attrs(&zone->pdev->dev, limit, &zone->dma_addr, 
		GFP_KERNEL, DMA_ATTR_NO_KERNEL_MAPPING);
	if (!zone->virt_addr) {
		pr_err("error: cannot claim reserved memory of size %zuKiB\n", limit/Ki);
		return -ENOMEM;
	}

	// update memory pool
	BUG_ON(IS_ERR_OR_NULL(driver.mempool));
	gen_pool_add_virt(driver.mempool, zone->virt_addr, zone->phys_addr, zone->limit, -1);

/*	pr_info("memory region %d: %zx-%zx, mapped at %p, dma handle %x, size: %zu (%zuKiB)\n", 
		hw.zone_count-1,
		zone->phys_addr, 
		zone->phys_addr + zone->limit - 1,
		(void *)zone->virt_addr, 
		zone->dma_addr, 
		zone->limit, 
		zone->limit/Ki);
*/
	return 0;
}


static int dma_issue(struct client *p)
{
	if ((p->tx.descp = dmaengine_prep_slave_single(p->dmac->txchanp, p->tx.dma_addr, p->conf.tx_size, 
			DMA_MEM_TO_DEV, DMA_CTRL_ACK|DMA_PREP_INTERRUPT)) == NULL) {
		pr_err("dmaengine_prep_slave_single() returned NULL!\n");
		return p->tx.cookie = -EBUSY;
	}
	
	if ((p->rx.descp = dmaengine_prep_slave_single(p->dmac->rxchanp, p->rx.dma_addr, p->conf.rx_size,
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

//	pr_info("Issueing DMA request...\n");
	dma_async_issue_pending(p->dmac->txchanp);
	dma_async_issue_pending(p->dmac->rxchanp);

	// wait for the transaction to complete, timeout, or get get an error
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
		p->conf.tx_size/Ki, p->conf.rx_size/Ki, t1-t0);
	else pr_warn("this kernel does not support get_cycles()\n");
	return 0;
}


static int dev_open(struct inode *inodep, struct file *filep)
{
	struct client *p;
	if ((p = filep->private_data = devm_kzalloc(&driver.pdev->dev, sizeof(struct client), GFP_KERNEL)) == NULL) {
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
	devm_kfree(&driver.pdev->dev, filep->private_data);
	return 0;
}


static long dev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
{
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
		p->conf.flags = conf.flags;
		break;	
	case ZDMA_IOCTL_ISSUE:
		dma_issue(p);
		break;
	default:
		pr_err("unknown ioctl: command %x, argument %lu\n", cmd, arg);
		return -ENOTTY;
	}
	return 0l;
}


static int dev_mmap(struct file *filep, struct vm_area_struct *vma)
{
	struct client *p = filep->private_data;
	bool tx = vma->vm_flags & VM_WRITE;

	phys_addr_t off = vma->vm_pgoff << PAGE_SHIFT,
		phys = tx ? p->tx.phys_addr : p->rx.phys_addr,
		vsize = vma->vm_end - vma->vm_start,
		psize = tx ? p->conf.tx_size : p->conf.rx_size - off;

	pr_info("zdma mmap: [%s] off=%zu, phys=%p, vsize=%zu, psize=%zu\n", 
		tx ? "TX" : "RX", (size_t)off, (void *)phys, (size_t)vsize, (size_t)psize); // FIXME
	BUG_ON(vsize != ALIGN(psize, PAGE_SIZE));

	if (tx == (vma->vm_flags & VM_READ)) {
		pr_err("invalid protection flags -- please use MAP_WRITE for TX or MAP_READ for RX\n");
		return -EINVAL;
	}
	
	if (!(tx ? p->tx.dma_addr : p->rx.dma_addr)) {
		pr_err("%s DMA buffer has not yet been allocated\n.", tx ? "TX" : "RX");
		return -ENOMEM;
	}

	if ( tx && (dma_mmap_attrs(&p->tx.zone->pdev->dev, vma, (void *)p->tx.virt_addr, p->tx.dma_addr, 
		vsize, DMA_ATTR_NO_KERNEL_MAPPING) < 0)) {
			pr_err("failed to map user TX buffer!\n");
			return -ENOSPC;//FIXME
	}
	if (!tx && (dma_mmap_attrs(&p->rx.zone->pdev->dev, vma, (void *)p->rx.virt_addr, p->rx.dma_addr, 
		vsize, DMA_ATTR_NO_KERNEL_MAPPING) < 0)) {
			pr_err("failed to map user RX buffer!\n");
			return -ENOSPC;//FIXME
	}
	return 0;
}


static int sched_remove(struct platform_device *pdev)
{
	pr_info("scheduler shutting down...\n");
//	dev_set_drvdata(&pdev->dev, NULL);	//TODO understand what this does
	
	while (hw.dmac_count--) {
		pr_info("releasing dmac[%d]\n", hw.dmac_count);
		dma_release_channel(hw.dmac[hw.dmac_count].rxchanp);
		dma_release_channel(hw.dmac[hw.dmac_count].txchanp);
	}
	while (hw.zone_count--) {
		pr_info("releasing zone[%d]\n", hw.zone_count);
		// FIXME delete zones
		device_del(&hw.zone[hw.zone_count].pdev->dev);
		put_device(&hw.zone[hw.zone_count].pdev->dev);
		// platform?
	}
	//FIXME clear pools also
//		dma_free_attrs(&zone->dev, zone->limit, zone->virt_addr, zone->dma_addr, DMA_ATTR_NO_KERNEL_MAPPING);
	return 0;
}


static int sched_probe(struct platform_device *pdev)
{
	int i, res;
	driver.pdev = pdev;

	pr_info("scheduler starting... pdev=%p, pdev->name=%s, &pdev->dev=%p\n", pdev, pdev->name, &pdev->dev);
	
	// basic data structure initialization
	hw.dmac_count = 0;
	hw.dmac = NULL;
	hw.zone_count = 0;
	hw.zone = NULL;
	driver.mempool = devm_gen_pool_create(&driver.pdev->dev, PAGE_SHIFT, NUMA_NO_NODE, NULL);

	// find dma clients in device tree
	struct device_node *np = NULL, *tnp = NULL;
	for_each_compatible_node(np, NULL, "tuc,dma-client") ++hw.dmac_count;
	if (!hw.dmac_count) {
		pr_err("devicetree: unable to find any compatible DMA controller!\n");
		return -ENODEV;
	}
	pr_info("devicetree: found %d compatible DMA controllers\n", hw.dmac_count);

	if ((hw.dmac = devm_kcalloc(&driver.pdev->dev, hw.dmac_count, sizeof(*hw.dmac), GFP_KERNEL)) == NULL) {
		pr_err("unable to allocate %zu bytes for DMA controller hardware description structures!\n", 
			hw.dmac_count*sizeof(*hw.dmac));
		return -ENOMEM;
	}
	i = 0;
	np = NULL;
	for_each_compatible_node(np, NULL, "tuc,dma-client") {

		hw.dmac[i].txchanp = of_dma_request_slave_channel(np, "tx");
		if (IS_ERR_OR_NULL(hw.dmac[i].txchanp)) {
			pr_err("dmac[%d]: failed to reserve TX channel -- devicetree misconfiguration, "
				"DMA controller not present or driver not loaded.\n", i);
			while (i--) {
				dma_release_channel(hw.dmac[i].txchanp);
				dma_release_channel(hw.dmac[i].rxchanp);
			}
			return -ENODEV;	// FIXME DOES NOT EXIT GRACEFULLY FIXME
		}
		hw.dmac[i].rxchanp = of_dma_request_slave_channel(np, "rx");
		if (IS_ERR_OR_NULL(hw.dmac[i].rxchanp)) {
			pr_err("dmac[%d]: failed to reserve RX channel -- devicetree misconfiguration, "
				"DMA controller not present or driver not loaded.\n", i);
			dma_release_channel(hw.dmac[i].txchanp);
			while (i--) {
				dma_release_channel(hw.dmac[i].txchanp);
				dma_release_channel(hw.dmac[i].rxchanp);
			}
			return -ENODEV;
		}
		hw.dmac[i].id = i;
		hw.dmac[i].load = 0;
		++i;
	}
	pr_info("%d channel pairs initialized\n", i);

	// discover memory region info
	np = NULL;
	for_each_compatible_node(np, NULL, "tuc,zone") {
		tnp = of_parse_phandle(np, "memory-region", 0);
		if (!tnp) {
			pr_err("devicetree: memory region node %d does not contain a phandle to a memory bank\n", i);
			return -ENODEV;
		}
		u64 size;
		phys_addr_t paddr = of_translate_address(tnp, of_get_address(tnp, 0, &size, NULL));
		res = dma_zone_add(np, paddr, (size_t)size /* limit */, (size_t)size /* total */);
		if (res) return res;
	}

	if (!hw.zone_count) {
		pr_err("devicetree: no suitable memory zones are defined!\n");
		return -ENODEV;
	}

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

