#pragma once

#include <linux/ioctl.h>

#ifndef u32
typedef uint32_t u32;
#endif

#define CORE_NAME_LEN 16

struct zdma_client_config {
	size_t	tx_size, rx_size;
	u32	flags;
	int	pri;
	char	core_name[CORE_NAME_LEN];
};

struct zdma_core_config {
	char	name[CORE_NAME_LEN];
	size_t	size;
	void	*bitstream;
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

