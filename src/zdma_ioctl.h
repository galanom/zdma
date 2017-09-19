#include <linux/ioctl.h>

#ifndef u32
typedef uint32_t u32;
#endif

typedef enum { LOOPBACK } ipcore_t;

struct dma_config {
	size_t		tx_size, rx_size;
	u32		flags;
	ipcore_t	ipcore;
};

#define MAGIC 'Z'

enum module_ioctl {
	ZDMA_IOCTL_DEBUG	= _IO (MAGIC, 0x01),
	ZDMA_IOCTL_CONFIG	= _IOW(MAGIC, 0x10, struct dma_config *),
	ZDMA_IOCTL_ENQUEUE	= _IO (MAGIC, 0x11),
};

