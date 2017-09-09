#include <linux/ioctl.h>

#ifndef u32
typedef uint32_t u32;
#endif

struct dma_config {
	size_t	tx_size, rx_size;
	u32	flags;
};

#define MAGIC 'Z'

enum module_ioctl {
	ZDMA_IOCTL_DEBUG	= _IO (MAGIC, 0x01),
	ZDMA_IOCTL_CONFIG	= _IOW(MAGIC, 0x10, struct dma_config *),
	ZDMA_IOCTL_ISSUE	= _IO (MAGIC, 0x11),
};

