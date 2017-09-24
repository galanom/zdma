#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <unistd.h>

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
#include "zdma_ioctl.h"

#define DEV_FILE "/dev/zdma"

struct zdma_task {
	int fd;
	void *tx_buf, *rx_buf;
	struct client_config conf;
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

	for (int i = 0; i < len/8; ++i) {
		uint64_t x = ((int64_t *)p)[i], y = ((int64_t *)q)[i];
		if (x != y) {
			uint64_t flip = x^y;
			do if (flip & 1) ++errors;
			while (flip >>= 1);
		}
	}
	if (errors) fprintf(stderr, "*** Buffer verification failed: %d bits were flippedd (%d%%) ***\n",
			errors, 100*errors/(len*8));
//	else printf("Buffer verification successful\n");
	return errors;
}

int tdiff(struct timespec t1, struct timespec t0)
{
	return (t1.tv_sec - t0.tv_sec)*K + (t1.tv_nsec - t0.tv_nsec)/M;
}

int zdma_core_register(char *name, char *fname)
{
	int fd, fddev, err;
	struct stat st;
	struct core_config core;
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

int zdma_task_configure(struct zdma_task *task, char *core_name, int tx_size, int rx_size)
{
	int err;
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
	} // TODO unmap

	buffer_fill(task->tx_buf, task->conf.tx_size);

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
	buffer_compare(task->tx_buf, task->rx_buf, task->conf.tx_size);
	return 0;
}

void zdma_task_destroy(struct zdma_task *task)
{
	close(task->fd);
	return;
}

#define SIZE (8ULL*M)

int main(int argc, char **argv)
{
	int err, task_num = 0, iter_num = 0;
	if (argc == 3) {
		task_num = atoi(argv[1]);
		iter_num = atoi(argv[2]);
	}
	if (!task_num) task_num = 1;
	if (!iter_num) iter_num = 1;
	err = zdma_core_register("loopback", "./loopback.bit");
	if (err) return err;

	struct timespec t0, t1;
	struct zdma_task task[task_num];
	for (int j = 0; j < task_num; ++j) {
		zdma_task_init(&task[j]);
		zdma_task_configure(&task[j], "loopback", SIZE, SIZE);
	}
	clock_gettime(CLOCK_MONOTONIC, &t0);
	for (int i = 0; i < iter_num; ++i)
		for (int j = 0; j < task_num; ++j)
			zdma_task_enqueue(&task[j]);

	clock_gettime(CLOCK_MONOTONIC, &t1);
	for (int j = 0; j < task_num; ++j)
		zdma_task_destroy(&task[j]);
	int t = tdiff(t1, t0);
	printf("Exec: %d tasks by %d times, time: %d.%d, %.2fMB/s\n", 
		task_num, iter_num, t/1000, t%1000, task_num*iter_num*SIZE/(t*1000.0));
	return 0;
}

