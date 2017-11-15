#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdbool.h>

#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <time.h>

#include <assert.h>
#include <errno.h>
#include <string.h>

#include "macro.h"
#include "glue.h"

#define DEV_FILE "/dev/zdma"

struct zdma_task {
	int fd;
	void *tx_buf, *rx_buf;
	struct zdma_client_config conf;
};


int buffer_fill(void *p, int len)
{
	for (int i = 0; i < len/4; ++i) {
		((int32_t *)p)[i] = mrand48();
	}
	return 0;
}


int buffer_compare(void *p, void *q, int len)
{
	int errors = 0;
	if (p == NULL || q == NULL) return -EFAULT;

	for (int i = 0; i < len/4; ++i) {
		uint32_t x = ((int32_t *)p)[i], y = ((int32_t *)q)[i];
		if (x != y) ++errors;
	}
	if (errors) {
		fprintf(stderr, "%llx->%llx\n", *(uint64_t *)p, *(uint64_t *)q);
		fprintf(stderr, "*** Verification failed: %d%% word mismatch ***\n",
			100*errors/(len/4));
	} else printf("Verification OK\n");
	return errors;
}


int zdma_core_register(const char name[], const char fname[])
{
	int fd, fddev, err;
	struct stat st;
	struct zdma_core_config core;
	fddev = open(DEV_FILE, O_RDONLY);
	err = errno;
	if (fddev < 0) {
		fprintf(stderr, "error %d (%s) opening device file\n",
			err, strerror(err));
		return err;
	}
	
	fd = open(fname, O_RDONLY);
	err = errno;
	if (fd < 0) {
		fprintf(stderr, "error %d (%s) opening bitstream file %s\n",
			err, strerror(err), fname);
		return err;
	}
	fstat(fd, &st);
	core.size = st.st_size;
	strncpy(core.name, name, CORE_NAME_LEN);
	core.bitstream = malloc(core.size);
	if (core.bitstream == NULL) {
		fprintf(stderr, "error allocating %zu bytes of memory "
			"for bitstream\n", core.size);
		return -ENOMEM;
	}
	ssize_t nbytes = read(fd, core.bitstream, core.size);
	if (nbytes == -1) {
		err = errno;
		fprintf(stderr, "error %d (%s) reading bitstream from file %s\n",
			err, strerror(err), fname);
		return err;
	} else if (nbytes != core.size) {
		fprintf(stderr, "bitstream reading was interrupted at %zd\n", nbytes);
		return -EINTR;
	}

	// configuration register offsets; zero for unused
	core.reg_off[0] = 0x00C0; // return value
	core.reg_off[1] = 0x0010; // 1st argument
	core.reg_off[2] = 0x0020; // ...
	core.reg_off[3] = 0x0000;
	core.reg_off[4] = 0x0000;

	err = ioctl(fddev, ZDMA_CORE_REGISTER, &core);
	if (err) {
		fprintf(stderr, "ioctl error %d (%s) registering user core\n",
			err, strerror(err));
		return err;
	}
	free(core.bitstream);
	close(fddev);
	close(fd);
	printf("user core %s was registered successfully\n", core.name);
	return 0;
}


int zdma_debug()
{
	int fddev, err;
	fddev = open(DEV_FILE, O_RDONLY);
	err = errno;
	if (ioctl(fddev, ZDMA_DEBUG, 0)) {
		err = errno;
		fprintf(stderr, "ioctl error %d (%s) requesting debug info\n",
			err, strerror(err));
		return err;
	}
	close(fddev);
	return 0;
}


int zdma_task_init(struct zdma_task *task)
{
	memset(task, 0, sizeof(*task));

	task->fd = open(DEV_FILE, O_RDWR | O_SYNC);
	int err = errno;
	if (task->fd < 0) {
		fprintf(stderr, "error %d (%s) opening device file %s\n", 
			err, strerror(err), DEV_FILE);
		return err;
	}
	return 0;
}


int zdma_task_configure(struct zdma_task *task, const char core_name[],
	int tx_size, int rx_size, int argc, ...)
{
	int err;
	va_list argv;

	if (argc > CORE_PARAM_CNT) return -EINVAL;
	va_start(argv, argc);
	for (int i = 0; i < argc; i++) {
		task->conf.core_param[i] = va_arg(argv, int);
	}
	va_end(argv);

	strncpy(task->conf.core_name, core_name, CORE_NAME_LEN);
	task->conf.tx_size = tx_size;
	task->conf.rx_size = rx_size;
	if (ioctl(task->fd, ZDMA_CLIENT_CONFIG, &task->conf) < 0) {
		err = errno;
		fprintf(stderr, "ioctl error %d (%s) while configuring DMA task\n",
			err, strerror(err));
		return err;
	}

	task->tx_buf = mmap(0, task->conf.tx_size, PROT_WRITE, 
			MAP_SHARED|MAP_LOCKED, task->fd, 0);
	if (task->tx_buf == MAP_FAILED) {
		err = errno;
		fprintf(stderr, "mmap error %d (%s) while mapping the TX "
				"buffer to userspace\n",
				err, strerror(err));
		return err;
	}
	
	task->rx_buf = mmap(0, task->conf.rx_size, PROT_READ, 
			MAP_SHARED|MAP_LOCKED, task->fd, 0);
	if (task->rx_buf == MAP_FAILED) {
		err = errno;
		fprintf(stderr, "mmap error %d (%s) while mapping the RX "
				"buffer to userspace\n",
				err, strerror(err));
		return err;
	} 
	return 0;
}


int zdma_task_enqueue(struct zdma_task *task)
{
	int err;
	if (ioctl(task->fd, ZDMA_CLIENT_ENQUEUE, 0)) {
		err = errno;
		fprintf(stderr, "ioctl error %d (%s) while enqueueing DMA task\n",
			err, strerror(err));
		return err;
	}
	return 0;
}


int zdma_task_waitfor(struct zdma_task *task)
{
	int err;
	if (ioctl(task->fd, ZDMA_CLIENT_BARRIER, 0)) {
		err = errno;
		fprintf(stderr, "ioctl error %d (%s) while flushing work queue\n",
			err, strerror(err));
		return err;
	}
	return 0;
}


int zdma_task_verify(struct zdma_task *task)
{
	return buffer_compare(task->tx_buf, task->rx_buf, task->conf.tx_size);
}


void zdma_task_destroy(struct zdma_task *task)
{
	munmap(task->tx_buf, task->conf.tx_size);
	munmap(task->rx_buf, task->conf.rx_size);
	close(task->fd);
	return;
}

