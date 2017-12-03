#pragma once
#include "glue.h"

#ifdef __cplusplus
extern "C" {
#endif

extern int buffer_fill(void *p, int len);
extern int buffer_compare(void *p, void *q, int len);
extern int zdma_core_register(const char *name, 
		signed char priority, unsigned long affinity);
extern int zdma_core_unregister(const char *name, unsigned long affinity);
extern int zdma_config(enum config arg);
extern int zdma_debug(void);
extern int zdma_task_init(struct zdma_task *task);
extern int zdma_task_configure(struct zdma_task *task, const char *core_name,
		unsigned long affinity, int tx_size, int rx_size, int argc, ...);
extern int zdma_task_enqueue(struct zdma_task *task);
extern int zdma_task_enqueue_nb(struct zdma_task *task);
extern int zdma_task_waitfor(struct zdma_task *task);
extern int zdma_task_verify(struct zdma_task *task);
extern void zdma_task_destroy(struct zdma_task *task);

#ifdef __cplusplus
}
#endif
