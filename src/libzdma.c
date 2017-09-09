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

#include "macro.h"
#include "zdma_ioctl.h"


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
	else printf("Buffer verification successful\n");
	return errors;
}


int main(int argc, char **argv)
{
	int fd0, fd1;
	fd0 = open("/dev/zdma", O_RDWR|O_SYNC);
	fd1 = open("/dev/zdma", O_RDWR|O_SYNC);
	assert(fd0 >= 0 && fd1 >= 0);

	struct dma_config xf0, xf1;
	if (argc == 2) xf0.tx_size = atoi(argv[1]);
	else xf0.tx_size = 1*Mi;
	xf0.rx_size = xf0.tx_size;
	xf1.tx_size = xf0.tx_size;
	xf1.rx_size = xf0.rx_size;

	ioctl(fd0, ZDMA_IOCTL_CONFIG, &xf0);
	ioctl(fd1, ZDMA_IOCTL_CONFIG, &xf1);
	
	void *tx0 = mmap(0, xf0.tx_size, PROT_WRITE, MAP_SHARED|MAP_LOCKED, fd0, 0);
	assert(tx0 != MAP_FAILED);
	
	void *rx0 = mmap(0, xf0.rx_size, PROT_READ, MAP_SHARED|MAP_LOCKED, fd0, 0);
	assert(rx0 != MAP_FAILED);

	void *tx1 = mmap(0, xf1.tx_size, PROT_WRITE, MAP_SHARED|MAP_LOCKED, fd1, 0);
	assert(tx1 != MAP_FAILED);
	
	void *rx1 = mmap(0, xf1.rx_size, PROT_READ, MAP_SHARED|MAP_LOCKED, fd1, 0);
	assert(rx1 != MAP_FAILED);

	buffer_fill(tx0, xf0.tx_size);
	buffer_fill(tx1, xf1.tx_size);

	ioctl(fd0, ZDMA_IOCTL_ISSUE, 0);
	buffer_compare(tx0, rx0, xf0.tx_size);
	
	ioctl(fd1, ZDMA_IOCTL_ISSUE, 0);
	buffer_compare(tx1, rx1, xf1.tx_size);
	
	close(fd0);
	close(fd1);

	return 0;
}

