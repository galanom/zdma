#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdbool.h>
#include <ctype.h>

#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <time.h>
#include <dirent.h>

#include <assert.h>
#include <errno.h>
#include <string.h>

#include "libzdma.h"
#include "macro.h"

#define DEV_FILE "/dev/zdma"


int zdma_core_register(const char *name, signed char priority, unsigned long affinity)
{
	int fd, fddev, err;
	struct stat st;
	struct zdma_core_config core;

	int nlen = strlen(name);
	if (nlen > CORE_NAME_LEN-1) {
		fprintf(stderr, "zdma_core_register(): core name may be up to %d bytes.\n", CORE_NAME_LEN-1);
		return -EINVAL;
	}

	fddev = open(DEV_FILE, O_RDWR);
	err = errno;
	if (fddev < 0) {
		fprintf(stderr, "error %d (%s) opening device file\n",
			err, strerror(err));
		return err;
	}

	DIR *dir = opendir(CORE_DIRECTORY);
	struct dirent *entry;
	int count = 0;
	char *token;
	char buf[256];
	int i;
	while ((entry = readdir(dir))) {
		strcpy(buf, entry->d_name);
		if ((token = strtok(buf, ".")) == NULL)
			continue;
		if (strncmp(token, name, CORE_NAME_LEN))
			continue;
		if ((token = strtok(NULL, ".")) == NULL)
			continue;
		
		for (i = 0; i < strlen(token); ++i)
			if (!isdigit(token[i])) // no whitespace pls
				break;
		if (i != strlen(token)) // loop was interrupted
			continue;
		int id = atoi(token);
		if (i < 0 || i > sizeof(long)*8-1)
			continue;

		if ((token = strtok(NULL, "\0")) == NULL)
			continue;
		if (strcmp(token, "bin.xz"))
			continue;

		if ((1 << id) & ~affinity)
			continue;

		fd = openat(dirfd(dir), entry->d_name, O_RDONLY);
		err = errno;
		if (fd < 0) {
			fprintf(stderr, "error %d (%s) opening bitstream file %s\n",
				err, strerror(err), entry->d_name);
			goto error_early;
		}
		
		fstat(fd, &st);
		core.size = st.st_size;
		strcpy(core.name, name);
		core.pblock = 1ul << id;
		core.priority = priority > 10 ? 10 : 
				priority < 1 ? 1 :
				priority;
		core.bitstream = malloc(core.size);
		if (core.bitstream == NULL) {
			fprintf(stderr, "error allocating %zu bytes of memory "
				"for bitstream\n", core.size);
			err = -ENOMEM;
			goto error;
		}
		ssize_t nbytes = read(fd, core.bitstream, core.size);
		if (nbytes == -1) {
			err = errno;
			fprintf(stderr, "error %d (%s) reading bitstream from file %s\n",
				err, strerror(err), entry->d_name);
			goto error;
		} else if (nbytes != core.size) {
			fprintf(stderr, "bitstream reading was interrupted at %zd\n", nbytes);
			err = -EINTR;
			goto error;
		}
		close(fd);

		err = ioctl(fddev, ZDMA_CORE_REGISTER, &core);
		
		free(core.bitstream);
		if (!err) ++count;
	}
	closedir(dir);

	close(fddev);
	printf("Core %s registered %d bitstream(s)\n", name, count);
	return !count;
error:
	free(core.bitstream);
error_early:
	fprintf(stderr, "zdma_register_core(): aborting due to error!\n");
	closedir(dir);
	close(fd);
	close(fddev);
	return err;
}


int zdma_core_unregister(const char *name, unsigned long affinity)
{
	if (strlen(name) > DT_NAME_LEN - 1)
		return -EINVAL;
	struct zdma_core_config core;
	strcpy(core.name, name);
	core.pblock = affinity;
	int fddev = open(DEV_FILE, O_RDONLY);
	int ret = ioctl(fddev, ZDMA_CORE_UNREGISTER, &core);
	close(fddev);
	return ret;
}


int zdma_config(enum config arg)
{
	int fddev = open(DEV_FILE, O_RDONLY);
	int ret = ioctl(fddev, ZDMA_CONFIG, (long)arg);
	close(fddev);
	return ret;
}


int zdma_debug()
{
	int fddev = open(DEV_FILE, O_RDONLY);
	int ret = ioctl(fddev, ZDMA_DEBUG, 0);
	close(fddev);
	return ret;
}


int zdma_barrier()
{
	int fddev = open(DEV_FILE, O_RDONLY);
	int ret = ioctl(fddev, ZDMA_BARRIER, 0);
	close(fddev);
	return ret;
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


int zdma_task_configure(struct zdma_task *task, const char *core_name,
	unsigned long affinity, int tx_size, int rx_size, int argc, ...)
{
	int err;
	va_list argv;

	if (argc > CORE_PARAM_CNT)
		return -EINVAL;
	
	task->conf.core_param_count = argc;
	va_start(argv, argc);
	for (int i = 0; i < argc; i++) {
		task->conf.core_param[i] = va_arg(argv, int);
	}
	va_end(argv);

	strncpy(task->conf.core_name, core_name, CORE_NAME_LEN);
	task->conf.affinity = affinity;
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
	if (ioctl(task->fd, ZDMA_CLIENT_ENQUEUE_BLOCK, 0)) {
		int err = errno;
		fprintf(stderr, "ioctl error %d (%s) while enqueueing DMA task\n",
			err, strerror(err));
		return err;
	}
	return 0;
}

int zdma_task_enqueue_nb(struct zdma_task *task)
{
	if (ioctl(task->fd, ZDMA_CLIENT_ENQUEUE_NOBLOCK, 0)) {
		int err = errno;
		fprintf(stderr, "ioctl error %d (%s) while enqueueing DMA task\n",
			err, strerror(err));
		return err;
	}
	return 0;
}



int zdma_task_waitfor(struct zdma_task *task)
{
	if (ioctl(task->fd, ZDMA_CLIENT_WAIT, 0)) {
		int err = errno;
		fprintf(stderr, "ioctl error %d (%s) while flushing work queue\n",
			err, strerror(err));
		return err;
	}
	return 0;
}


void zdma_task_destroy(struct zdma_task *task)
{
	(void)zdma_task_waitfor(task);
	munmap(task->tx_buf, task->conf.tx_size);
	munmap(task->rx_buf, task->conf.rx_size);
	close(task->fd);
	return;
}

