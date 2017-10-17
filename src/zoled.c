/*  zoled.c - Driver for OLED IP core of Ali Aljaani, TAMUQ Univ.

* Copyright (C) 2017 Ioannis Galanommatis
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation; either version 2 of the License, or
*   (at your option) any later version.

*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License along
*   with this program. If not, see <http://www.gnu.org/licenses/>.

*/

#define pr_fmt(__fmt__) "[" KBUILD_MODNAME "] %s():%d: " __fmt__, __func__, __LINE__

#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/io.h>
#include <linux/cdev.h>
#include <linux/uaccess.h>

#include <linux/of_address.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>

#include "macro.h"
#include "zoled.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Ioannis Galanommatis");
MODULE_VERSION("0.1");
MODULE_DESCRIPTION("Driver for OLED IP Core of Ali Aljaani, TAMUQ Univ.");

#define DRIVER_NAME "zoled"

#define OLED_ROWS 4
#define OLED_COLS 16
#define FMT_LEN (OLED_COLS*OLED_ROWS*4)

struct {
	bool enabled;
	dev_t cdev_num;
	struct cdev cdev;
	struct file_operations cdev_fops;

	phys_addr_t base;
	unsigned long size;
	void __iomem *vaddr;
	char data[OLED_ROWS][OLED_COLS];
	int r, c;
} zoled;

void zoled_enable(void)
{
	zoled.enabled = true;
	return;
}
EXPORT_SYMBOL_GPL(zoled_enable);

void zoled_disable(void)
{
	zoled.enabled = false;
	return;
}
EXPORT_SYMBOL_GPL(zoled_disable);

void zoled_clrln(int r)
{
	zoled_move(r, 0);
	for (int i = 0; i < OLED_COLS/4; ++i) zoled_addstr("    ");
	zoled_move(r, 0);
	return;
}
EXPORT_SYMBOL_GPL(zoled_clrln);


void zoled_clrscr(void)
{
	for (int j = OLED_ROWS-1; j >= 0; j--) zoled_clrln(j);
	return;
}
EXPORT_SYMBOL_GPL(zoled_clrscr);


void zoled_refresh(void)
{
	if (!zoled.enabled) return;
	for (int r = 0; r < OLED_ROWS; ++r) 
		for (int c = 0; c < OLED_COLS; c += sizeof(u32))
			iowrite32(*(u32 *)&zoled.data[r][c], zoled.vaddr + r*OLED_COLS + c);
	for (int i = 0; i < 10*K; ++i) iowrite32(1, zoled.vaddr+64);
	for (int i = 0; i < 10*K; ++i) iowrite32(0, zoled.vaddr+64);
	return;
}
EXPORT_SYMBOL_GPL(zoled_refresh);


void zoled_move(int r, int c)
{
	if (r >= OLED_ROWS) {
		// memcpy() requires buffers do not overlap, but YOLO!
		memmove(&zoled.data, 
			&zoled.data[1], 
			(OLED_ROWS-1)*OLED_COLS);
		if (r == OLED_ROWS) zoled_clrln(r-1);
		zoled_move(r-1, c);
	} else if (c > OLED_COLS) {
		zoled.r = r;
		zoled.c = OLED_COLS-1;
	} else {
		zoled.r = r;
		zoled.c = c;
	}
	return;
}


void zoled_addch(char ch)
{
	static bool eol = false;
	if (ch == '\n') {
		eol = true;
	} else {
		if (eol) {
			eol = false;
			zoled_move(zoled.r+1, 0);
		}
		if (zoled.c == OLED_COLS) return;
		zoled.data[zoled.r][zoled.c] = ch;
		zoled_move(zoled.r, zoled.c+1);
	}
	return;
}
EXPORT_SYMBOL_GPL(zoled_addch);


void zoled_mvaddch(int r, int c, char ch)
{
	zoled_move(r, c);
	zoled_addch(ch);
	return;
}
EXPORT_SYMBOL_GPL(zoled_mvaddch);


void zoled_addstr(char *s)
{
	while (*s) zoled_addch(*s++);
	return;
}
EXPORT_SYMBOL_GPL(zoled_addstr);


void zoled_print(char *s, ...)
{
	if (!zoled.enabled) return;
	char buf[FMT_LEN];
	va_list args;

	va_start(args, s);
	vsnprintf(buf, FMT_LEN, s, args);
	va_end(args);
	
	zoled_addstr(buf);
	zoled_refresh();
}
EXPORT_SYMBOL_GPL(zoled_print);


void zoled_mvprint(int r, int c, char *s, ...)
{
	zoled_move(r, c);
	va_list args;
	va_start(args, s);
	zoled_print(s, args);
	va_end(args);
	return;
}
EXPORT_SYMBOL_GPL(zoled_mvprint);


static ssize_t dev_write(struct file *f, const __user char *buffer, size_t len, loff_t *offset)
{
	int r, c, res;

	char kbuf[FMT_LEN];
	long pos = strncpy_from_user(kbuf, buffer, MIN(len, FMT_LEN-1));
	kbuf[pos] = '\0';
	
	if (pos < 0) {
		pr_warn("unable to access user buffer\n");
		return -EACCES;
	} else if (pos == 0) {
		pr_warn("no data\n");
		return -EINVAL;
	}

	char *p = kbuf, *q = p;
	pr_info("user input %s of size %d\n", p, len);
	do {
		if (*q == '\033' && *(q+1) == '[') {
			res = sscanf(q, "\033[%d;%df", &r, &c);
			if (res != 2) {
				pr_warn("could not understand ANSII escape sequence, ignoring input\n");
				return -EINVAL;
			}
			zoled_move(r, c);
			q = strchr(q, 'f') + 1;
			
		}
		BUG_ON(q-p>8);
		*p++ = *q++;
	} while (*q);
	*p = '\0';
	pr_info("parsed input %s\n", kbuf);
	zoled_print(kbuf);
	*offset += len;
	return len;
}


static int dev_open(struct inode *inodep, struct file *filep)
{
	return 0;
}


static int dev_release(struct inode *inodep, struct file *filep)
{
	return 0;
}


static int zoled_probe(struct platform_device *pdev)
{
	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	if (!mem) {
		pr_err("error getting Zedboard OLED AXI memory range\n");
		return -ENODEV;
	}
	zoled.base = mem->start;
	zoled.size = mem->end - mem->start + 1;

	if (!devm_request_mem_region(&pdev->dev, zoled.base, zoled.size, DRIVER_NAME)) {
		pr_err("error locking memory region at %p\n",
			(void *)zoled.base);
		return -EBUSY;
	}

	zoled.vaddr = devm_ioremap(&pdev->dev, zoled.base, zoled.size);
	if (zoled.vaddr == NULL) {
		pr_err("error mapping IO memory\n");
		return -EIO;
	}
	zoled_clrscr();
	zoled.r = 0;
	zoled.c = 0;
	zoled.enabled = true;
	pr_info("Zedboard OLED driver probing done\n");
	return 0;
}


static int zoled_remove(struct platform_device *pdev)
{
	pr_info("Zedboard OLED driver is removed\n");
	//release_mem_region(zoled.base, zoled.size);
	return 0;
}


#ifdef CONFIG_OF
static struct of_device_id zoled_of_match[] = {
	{ .compatible = "xlnx,ZedboardOLED-1.0", },
	{ /* end of list */ },
};
MODULE_DEVICE_TABLE(of, zoled_of_match);
#else
# define zoled_of_match
#endif


static struct platform_driver zoled_driver = {
	.driver = {
		.name = DRIVER_NAME,
		.owner = THIS_MODULE,
		.of_match_table	= zoled_of_match,
	},
	.probe		= zoled_probe,
	.remove		= zoled_remove,
};


static int __init zoled_init(void)
{
	zoled.enabled = false;
	pr_info("Zedboard OLED driver initializing...\n");
	zoled.cdev_fops.owner = THIS_MODULE;
	zoled.cdev_fops.open = dev_open;
	zoled.cdev_fops.write = dev_write;
	zoled.cdev_fops.release = dev_release;

	if (alloc_chrdev_region(&zoled.cdev_num, 0 /* first minor */, 1 /* count */, KBUILD_MODNAME) < 0) {
		pr_err("error registering /dev entry\n");
		return -ENOSPC;
	}
	
	cdev_init(&zoled.cdev, &zoled.cdev_fops);
	if (cdev_add(&zoled.cdev, zoled.cdev_num, 1 /* count */)) {
		pr_err("error registering character device\n");
		return -ENOSPC;
	}

	return platform_driver_register(&zoled_driver);
}


static void __exit zoled_exit(void)
{
	cdev_del(&zoled.cdev);
	unregister_chrdev_region(zoled.cdev_num, 1 /* count */);
	platform_driver_unregister(&zoled_driver);
	pr_info("Zedboard OLED driver exiting...\n");
	return;
}

module_init(zoled_init);
module_exit(zoled_exit);

