#pragma once
#include "glue.h"

#ifdef __cplusplus
extern "C" {
#endif

struct zdma_task {
	int fd;
	void *tx_buf, *rx_buf;
	struct zdma_client_config conf;
};


extern int buffer_fill(void *p, int len);
extern int buffer_compare(void *p, void *q, int len);
extern int zdma_core_register(const char name[]);
extern int zdma_debug();
extern int zdma_task_init(struct zdma_task *task);
extern int zdma_task_configure(struct zdma_task *task, const char core_name[],
				int tx_size, int rx_size, int argc, ...);
extern int zdma_task_enqueue(struct zdma_task *task);
extern int zdma_task_waitfor(struct zdma_task *task);
extern int zdma_task_verify(struct zdma_task *task);
extern void zdma_task_destroy(struct zdma_task *task);

#ifdef __cplusplus
}
#endif
