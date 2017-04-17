#pragma once
#define CPU_FREQ 667
#define DMAC_COUNT 4

enum module_ioctl {
	ZDMA_DEBUG =	0x0001,
	ZDMA_INIT,
	ZDMA_EXIT,
};
