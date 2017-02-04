/* CPU <-> PL Communication Example
*
* This small example is designed to show how to communicate between the CPU and the PL
* without using DMA. For some applications the amount of data being transferred may be 
* small enough that is quicker to not use DMA.  
*
* This example assumes a BRAM is on the PL for the testing at a specific address. 
* It includes several test methods, cached and non-cached, to compare the performance. 
* There are likely more optimization methods that could be applied as this is not 
* intended to be that (such as LDM/STRM). This BRAM is connected to the GP0 and GP1
* master interfaces of the PS such that it can be used with a cached and non-cached
* mapping at the same time. This allows the cached operations to be verified using 
* the non-cached interface. 
*
* This is a kernel module that is inserted into the kernel to run a single test, then
* removed and reinserted to run another test. It has module parameters that can be 
* set from the command line to cause different behavior such as cached or not, and
* write combined (for non-cached). All the parameters are optional as they default
* to specific values which can be seen in the code.
*
* cpu-pl-test.ko transfer_length=<length> cached=<0,1> write_combined=<0,1>
*
* An ILA can be used in the PL to review the AXI transactions that result from
* each of the transfers.
*
* Notes:
*
* 1. The time differencing for the performance numbers needs work for when the usec
* wraps around to zero such that you might randomly see a very large time number.
*
* 2. There are no memory barriers being used in this application and they might be
* needed in a real application.
*/

#include <linux/dmaengine.h>
#include <linux/module.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/slab.h>
#include <asm/cacheflush.h>
#include <asm/outercache.h>


static void __iomem *test_bram_p;
static void __iomem *test_bram_uncached_p;

unsigned int transfer_length = 1024;
module_param(transfer_length, int, S_IRUGO);

unsigned int cached = 1;
module_param(cached, int, S_IRUGO);

unsigned int write_combined  = 0;
module_param(write_combined, int, S_IRUGO);

unsigned int zero = 1;
module_param(zero, int, S_IRUGO);

#define TEST_BRAM_ADDRESS 		0x40000000
#define TEST_BRAM_UNCACHED_ADDRESS 	0x80000000
#define TEST_BRAM_SIZE_BYTES	(256 * 1024)	

int test_cached_cpu_accesses(void)
{
	int i;
	struct timeval time1, time2;
	u32  *src_buffer;
	u32  *dest_buffer;
	u32 *p;

	/* Create buffers to use for testing so that the BRAM is not operated 
 	 * on except where needed to minimize cache side affects
 	 */
	src_buffer = kmalloc(transfer_length, GFP_KERNEL);
	dest_buffer = kzalloc(transfer_length, GFP_KERNEL);

	if (!src_buffer || !dest_buffer) {
		printk(KERN_ERR "Allocating DMA memory failed\n");
		return -1;
	}

	/* Initialize a source buffer with known data that is easy to see
 	 * on the ILA from AXI
 	 */
	for (i = 0; i < transfer_length/4; i++)
		src_buffer[i] = i;

	/* Map the BRAM into the virtual address space as uncached memory 
 	 * so that it's as fast as possible
 	 */
	test_bram_uncached_p = ioremap(TEST_BRAM_UNCACHED_ADDRESS, TEST_BRAM_SIZE_BYTES);
        if (!test_bram_uncached_p) {
                printk("Could not map physical memory to virtual\n");
                return -1;
        }
	printk("bram uncached virtual address: %08X\n", (unsigned int)test_bram_uncached_p);

	p = test_bram_uncached_p;
	for (i = 0; i < transfer_length/4; i++)
		__raw_writel(0, p++);

	/* Map the BRAM into the virtual address space as cached memory 
 	 * so that it's as fast as possible
 	 */
	test_bram_p = ioremap_cache(TEST_BRAM_ADDRESS, TEST_BRAM_SIZE_BYTES);
        if (!test_bram_p) {
                printk("Could not map physical memory to virtual\n");
                return -1;
        }
	printk("bram virtual address: %08X\n", (unsigned int)test_bram_p);

	p = test_bram_uncached_p;
	for (i = 0; i < transfer_length/4; i++)
		if (__raw_readl(p++) != 0) 
			printk("Error: BRAM not zeroed\n");

	/* Initialize the BRAM from the source buffer and then make sure it's
	 * written out from the cache to the memory (L1, then L2)
	 */
	p = test_bram_p;
	do_gettimeofday(&time1);

	for (i = 0; i < transfer_length/4; i++)
		__raw_writel(src_buffer[i], p++);
	
	do_gettimeofday(&time2);
     	printk(KERN_INFO "cpu write time [us]: %ld\n", (time2.tv_usec - time1.tv_usec));

	/* Ideally BRAM is still zero, but some of the cache could have been written
 	 * to memory if some lines needed to be evicted. It would be nice to test to test
 	 * that memory is still zero but that can't be done.
	 */

	/* Write the caches (L1 then L2) out to the BRAM, note the order of this
	 * is important as for writes caches operations must be done to the cache 
	 * closest to CPU 1st
	 */	
	do_gettimeofday(&time1);

	__cpuc_flush_dcache_area(test_bram_p, transfer_length);
	outer_clean_range(TEST_BRAM_ADDRESS, TEST_BRAM_ADDRESS + (transfer_length - 1));

	do_gettimeofday(&time2);
     	printk(KERN_INFO "cpu write cache time [us]: %ld\n", (time2.tv_usec - time1.tv_usec));

	/* Verify the BRAM was written correctly to ensure that the caches were
 	 * written
 	 */
	p = test_bram_uncached_p;
	for (i = 0; i < transfer_length/4; i++)
		if (__raw_readl(p++) != src_buffer[i]) 
			printk("Error: BRAM not written at address %08X\n", p - 1);

	/* Initialize a source buffer with known different data to write to the BRAM 
	 * without using the cache
 	 */
	for (i = 0; i < transfer_length/4; i++)
		src_buffer[i] = (transfer_length/4) - i;

	/* Write new data (different) to the BRAM thru the non-cached interface to verify that
 	 * cache operations to invalidate it are working
 	 */
	p = test_bram_uncached_p;
	for (i = 0; i < TEST_BRAM_SIZE_BYTES/4; i++)
		__raw_writel(src_buffer[i], p++);

	/* Invalidate the caches (L2, then L1) so that then next reads of the BRAM in cache should 
 	 * cause it to be fetched from memory, note for reads cache operations must be done to the
 	 * cache closest to the memory 1st
 	 */
	do_gettimeofday(&time1);

	outer_inv_range(TEST_BRAM_ADDRESS, TEST_BRAM_ADDRESS + (transfer_length - 1));
	__cpuc_flush_dcache_area(test_bram_p, transfer_length);

	do_gettimeofday(&time2);
     	printk(KERN_INFO "cpu read cache time [us]: %ld\n", (time2.tv_usec - time1.tv_usec));

	/* Read from the BRAM into a buffer */

	p = test_bram_p;
	do_gettimeofday(&time1);

	for (i = 0; i < transfer_length/4; i++)
		dest_buffer[i] = __raw_readl(p++);

	do_gettimeofday(&time2);
     	printk(KERN_INFO "cpu read time [us]: %ld\n", (time2.tv_usec - time1.tv_usec));

	/* Verify the data was correct */

	for (i = 0; i < transfer_length/4; i++) {
		if (dest_buffer[i] != src_buffer[i]) { 
			printk("index = %d, src = %02X, dest = %02X\n", i, src_buffer[i], dest_buffer[i]);
		}
	}
	printk("Transferred %d bytes\n", transfer_length);

	iounmap(test_bram_uncached_p);
	iounmap(test_bram_p);

	kfree(src_buffer);
	kfree(dest_buffer);	

	return 0;
} 

int test_noncached_cpu_accesses(void)
{
	int i;
	struct timeval time1, time2;
	u32  *src_buffer;
	u32  *dest_buffer;
	u32 *p;

	/* Create buffers to use for testing so that the BRAM is not operated 
 	 * on except where needed to minimize cache side affects
 	 */
	src_buffer = kmalloc(transfer_length, GFP_KERNEL);
	dest_buffer = kzalloc(transfer_length, GFP_KERNEL);

	if (!src_buffer || !dest_buffer) {
		printk(KERN_ERR "Allocating DMA memory failed\n");
		return -1;
	}

	/* Initialize a source buffer with known data that is easy to see
 	 * on the ILA from AXI
 	 */
	for (i = 0; i < transfer_length/4; i++) {
		src_buffer[i] = i;
	}

	/* Map the BRAM into the virtual address space as non-cached memory 
 	 * as normal device memory or device memory that is write combined
 	 * so that writes are much faste
 	 */
	if (write_combined)
		test_bram_p = ioremap_wc(TEST_BRAM_ADDRESS, TEST_BRAM_SIZE_BYTES);
	else
		test_bram_p = ioremap(TEST_BRAM_ADDRESS, TEST_BRAM_SIZE_BYTES);
        if (!test_bram_p) {
                printk("Could not map physical memory to virtual\n");
                return -1;
        }
	printk("bram virtual address: %08X\n", (unsigned int)test_bram_p);

	/* Write the data to the BRAM and measure the time */

	do_gettimeofday(&time1);
	p = test_bram_p;
	for (i = 0; i < transfer_length/4; i++)
		__raw_writel(src_buffer[i], p++);

	do_gettimeofday(&time2);
     	printk(KERN_INFO "cpu write time [us]: %ld\n", (time2.tv_usec - time1.tv_usec));

	/* Read the data back from the BRAM and measure the time */

	p = test_bram_p;
	do_gettimeofday(&time1);
	for (i = 0; i < transfer_length/4; i++)
		dest_buffer[i] = __raw_readl(p++);

	do_gettimeofday(&time2);
     	printk(KERN_INFO "cpu read time [us]: %ld\n", (time2.tv_usec - time1.tv_usec));

	/* Verify the data was correct */

	for (i = 0; i < transfer_length/4; i++) {
		if (dest_buffer[i] != src_buffer[i]) { 
			printk("index = %d, src = %02X, dest = %02X\n", i, src_buffer[i], dest_buffer[i]);
		}
	}
	printk("Transferred %d bytes\n", transfer_length);
	
	iounmap(test_bram_p);

	kfree(src_buffer);
	kfree(dest_buffer);	

	return 0;
} 
static int __init cpu_test_init(void)
{
	printk(KERN_INFO "CPU<->PL test module initialized\n");
	printk(KERN_INFO "transfer length: %d cached: %d write combined: %d\n", 
			transfer_length, cached, write_combined);

	if (cached)
		test_cached_cpu_accesses();
	else
		test_noncached_cpu_accesses();
	return 0;
}

static void __exit cpu_test_exit(void)
{
	printk(KERN_INFO "CPU<->PL test module exited\n");
}

module_init(cpu_test_init);
module_exit(cpu_test_exit);
MODULE_LICENSE("GPL");
