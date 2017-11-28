#pragma once

#include <linux/ioctl.h>
#include "param.h"

#ifndef __KERNEL__
#include <stdint.h>
#include <stdlib.h>
typedef uint32_t u32;
typedef uint16_t u16;
#endif /* __KERNEL__ */


enum config {
	CONFIG_GENALLOC_BITMAP_FIRST_FIT,
	CONFIG_GENALLOC_BITMAP_BEST_FIT,
	CONFIG_GENALLOC_CHUNK_FIRST_FIT,
	CONFIG_GENALLOC_CHUNK_MAX_AVAIL,
	CONFIG_GENALLOC_CHUNK_LEAST_USED,
	CONFIG_SECURITY_IOCTL_ALLOW_USER,
	CONFIG_SECURITY_IOCTL_BLOCK_USER,
	CONFIG_SECURITY_BUFFER_KEEP,
	CONFIG_SECURITY_BUFFER_CLEAR_NONUSER, // not implemented
	CONFIG_SECURITY_BUFFER_CLEAR,
	CONFIG_SCHEDULER_FIRST_FIT,
	CONFIG_SCHEDULER_STATIC_PRI,
	CONFIG_SCHEDULER_DYNAMIC_PRI,
	// default values -- obviously, any change requires recompilation
	CONFIG_GENALLOC_BITMAP_DEFAULT = CONFIG_GENALLOC_BITMAP_FIRST_FIT,
	CONFIG_GENALLOC_CHUNK_DEFAULT = CONFIG_GENALLOC_CHUNK_MAX_AVAIL,
	CONFIG_SECURITY_IOCTL_DEFAULT = CONFIG_SECURITY_IOCTL_BLOCK_USER,
	CONFIG_SECURITY_BUFFER_DEFAULT = CONFIG_SECURITY_BUFFER_CLEAR,
	CONFIG_SCHEDULER_DEFAULT = CONFIG_SCHEDULER_FIRST_FIT,
};

/*struct zdma_config {
	int		
};*/

struct zdma_client_config {
	size_t	tx_size, rx_size;		// TX, RX buffer sizes
	u32	flags;				// various flags
//	int	pri;				// task priority
	char	core_name[CORE_NAME_LEN];	// requested core
	u32	core_param[CORE_PARAM_CNT];	// core parameters
	int	core_param_count;
};

struct zdma_task {
	int fd;
	void *tx_buf, *rx_buf;
	struct zdma_client_config conf;
};

struct zdma_core_config {
	char	name[CORE_NAME_LEN];	// core name in ASCII (utf8 not tested)
	char	pblock_name[DT_NAME_LEN];	// pblock name
	size_t	size;			// bitstream size (initially compressed)
	void	*bitstream;		// the bitstream to load
	int	priority;
};

#define MAGIC 'Z'

enum module_ioctl {
	ZDMA_DEBUG		= _IO (MAGIC, 0x01),
	ZDMA_BARRIER		= _IO (MAGIC, 0x02),
	ZDMA_CONFIG		= _IOW(MAGIC, 0x03, long),
	ZDMA_CORE_REGISTER	= _IOW(MAGIC, 0x10, struct core_config *),
	ZDMA_CORE_UNREGISTER	= _IOW(MAGIC, 0x11, const char *),
	ZDMA_CLIENT_CONFIG	= _IOW(MAGIC, 0x20, struct client_config *),
	ZDMA_CLIENT_ENQUEUE	= _IO (MAGIC, 0x21),
	ZDMA_CLIENT_WAIT	= _IO (MAGIC, 0x22),
};

