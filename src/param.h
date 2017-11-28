#pragma once

#define CPU_FREQ 667
#define PARTIAL_SIZE_MAX 1048576

// Core register offset from base
#define CORE_CSR	0x00
#define CORE_GIE	0x04
#define CORE_IER	0x08
#define CORE_ISR	0x0c
#define CORE_PARAM_BASE	0x20
#define CORE_PARAM_STEP	0x10
#define CORE_PARAM_RET	0xC0

#define CORE_DIRECTORY	"/lib/firmware/zdma/"

#define CORE_PARAM_CNT	((CORE_PARAM_RET - CORE_PARAM_BASE)/CORE_PARAM_STEP)
#define CORE_NAME_LEN	16
#define DT_NAME_LEN	32
#define TEMP_BUF_SIZE	256
