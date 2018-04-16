#pragma once

#include <linux/ioctl.h>
#include "param.h"

#ifndef __KERNEL__
#include <stdint.h>
#include <stdlib.h>
typedef uint32_t u32;
typedef uint16_t u16;
typedef int8_t s8;
#endif /* __KERNEL__ */


enum config {
	CONFIG_ALLOC_BITMAP_FIRST_FIT,
	CONFIG_ALLOC_BITMAP_BEST_FIT,
	CONFIG_ALLOC_ZONE_DEFAULT,
	CONFIG_SECURITY_IOCTL_ALLOW_USER,
	CONFIG_SECURITY_IOCTL_BLOCK_USER,
	CONFIG_SECURITY_BUFFER_KEEP,
	CONFIG_SECURITY_BUFFER_CLEAR,
	//CONFIG_SCHED_PRIORITY_ENABLE,
	//CONFIG_SCHED_PRIORITY_DISABLE,
	CONFIG_SCHED_BEST_FIT,
	CONFIG_SCHED_FIRST_FIT,
	CONFIG_SCHED_VICTIM_FIRST,
	CONFIG_SCHED_VICTIM_PRI,
	CONFIG_SCHED_VICTIM_LP,
	CONFIG_SCHED_VICTIM_FIFO,
	CONFIG_SCHED_VICTIM_LRU,
	CONFIG_SCHED_VICTIM_LFU,
	
	// default values
	CONFIG_ALLOC_BITMAP_DEFAULT = CONFIG_ALLOC_BITMAP_FIRST_FIT,
	CONFIG_SECURITY_IOCTL_DEFAULT = CONFIG_SECURITY_IOCTL_ALLOW_USER,
	CONFIG_SECURITY_BUFFER_DEFAULT = CONFIG_SECURITY_BUFFER_CLEAR,
	//CONFIG_SCHED_PRIORITY_DEFAULT = CONFIG_SCHED_PRIORITY_ENABLE,
	CONFIG_SCHED_ALGO = CONFIG_SCHED_BEST_FIT,
	CONFIG_SCHED_VICTIM_ALGO = CONFIG_SCHED_VICTIM_LP,
};

struct zdma_task_config {
	size_t	tx_size, rx_size;		// TX, RX buffer sizes
//	u32	flags;				// various flags
	unsigned long affinity;			// task affinity to pblock
	char	core_name[CORE_NAME_LEN];	// requested core
	u32	core_param[CORE_PARAM_CNT];	// core parameters
	int	core_param_count;
};

struct zdma_core_config {
	char	name[CORE_NAME_LEN];	// core name in ASCII (utf8 not tested)
	unsigned long			// pblock id if registering,
		pblock;			// pblock set if unregistering
	size_t	size;			// bitstream size (initially compressed)
	void	*bitstream;		// the bitstream to load
	s8	priority;
};

#define MAGIC 'Z'

enum module_ioctl {
	ZDMA_DEBUG		= _IO (MAGIC, 0x01),
	ZDMA_BARRIER		= _IO (MAGIC, 0x02),
	ZDMA_CONFIG		= _IOW(MAGIC, 0x03, long),
	ZDMA_CORE_REGISTER	= _IOW(MAGIC, 0x10, struct core_config *),
	ZDMA_CORE_UNREGISTER	= _IOW(MAGIC, 0x11, const char *),
	ZDMA_CLIENT_CONFIG	= _IOW(MAGIC, 0x20, struct task_config *),
	ZDMA_CLIENT_ENQUEUE_BLOCK	= _IO (MAGIC, 0x21),
	ZDMA_CLIENT_ENQUEUE_NOBLOCK	= _IO (MAGIC, 0x22),
	ZDMA_CLIENT_WAIT	= _IO (MAGIC, 0x23),
};

