#include <linux/ioctl.h>

#define ZDMA_IO_MAGIC 'Z'

enum module_ioctl {
	ZDMA_IOCTL_DEBUG 	= _IO (ZDMA_IO_MAGIC, 0x01),
	ZDMA_IOCTL_SET_DMA_SIZE	= _IOW(ZDMA_IO_MAGIC, 0x10, int),
//	ZDMA_IO_SET_DMA_TX_SIZE	= _IOW(ZDMA_IO_MAGIC, 0x11, int),
//	ZDMA_IO_SET_DMA_RX_SIZE	= _IOW(ZDMA_IO_MAGIC, 0x12, int),
};

