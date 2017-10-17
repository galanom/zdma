#pragma once

#include <linux/ioctl.h>
#include "param.h"

#ifndef u32
typedef uint32_t u32;
#endif

#ifndef u16
typedef uint16_t u16;
#endif

struct zdma_client_config {
	size_t	tx_size, rx_size;		// TX, RX buffer sizes
	u32	flags;				// various flags
	int	pri;				// task priority
	char	core_name[CORE_NAME_LEN];	// requested core
	u32	core_param[CORE_PARAM_CNT];	// core parameters
		// do not change type without modifying iowriteXX()'s in driver
};

struct zdma_core_config {
	char	name[CORE_NAME_LEN];	// core name in ASCII (utf8 not tested)
	size_t	size;			// bitstream size
	void	*bitstream;		// the bitstream to load
	u16	reg_off[CORE_PARAM_CNT];// configuration register offsets 
				// counted from core base addr, zero for unused
				// 64k space ought to be enough for everybody
};

#define MAGIC 'Z'

enum module_ioctl {
	ZDMA_DEBUG		= _IO (MAGIC, 0x01),
	ZDMA_CORE_REGISTER	= _IOW(MAGIC, 0x02, struct core_config *),
	ZDMA_CORE_UNREGISTER	= _IO (MAGIC, 0x03),
	ZDMA_CLIENT_CONFIG	= _IOW(MAGIC, 0x10, struct client_config *),
	ZDMA_CLIENT_ENQUEUE	= _IO (MAGIC, 0x11),
	ZDMA_CLIENT_BARRIER	= _IO (MAGIC, 0x12),
};

