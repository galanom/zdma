#include <linux/ioctl.h>

#define MAGIC 'Z'

enum module_ioctl {
	ZDMA_IOCTL_DEBUG	= _IO (MAGIC, 0x01),
	ZDMA_IOCTL_SET_SIZE	= _IOW(MAGIC, 0x10, int),
	ZDMA_IOCTL_PREP		= _IO (MAGIC, 0x11),
	ZDMA_IOCTL_ISSUE	= _IO (MAGIC, 0x12),
};

