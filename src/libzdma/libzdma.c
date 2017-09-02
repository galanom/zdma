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

#include "zdma_ioctl.h"

#define Ki 1024
#define CEIL(x, y)	((x - 1)/y + 1)
#define MKDIV(x, y)	((x + y - 1) & ~(y - 1))
#define MIN(a,b)	({ __typeof__ (a) _a = (a); __typeof__ (b) _b = (b); _a < _b ? _a : _b; })
#define MAX(a,b)	({ __typeof__ (a) _a = (a); __typeof__ (b) _b = (b); _a > _b ? _a : _b; })


int buffer_fill(void *p, int len)
{
	for (int i = 0; i < len*Ki/4; ++i) {
		((int32_t *)p)[i] = mrand48();
	}
	return 0;
}

int buffer_compare(void *p, void *q, int len)
{
	int errors = 0;
	if (p == NULL || q == NULL) return -EFAULT;

//	struct timespec t0, t1;
	
	for (int i = 0; i < len*Ki/8; ++i) {

	//	clock_gettime(CLOCK_MONOTONIC, &t0);
		uint64_t x = ((int64_t *)p)[i], y = ((int64_t *)q)[i];
/*		clock_gettime(CLOCK_MONOTONIC, &t1);
		unsigned long diff = (t1.tv_nsec-t0.tv_nsec)/1000 + (t1.tv_sec-t0.tv_sec)*1000*1000;
		if (diff > 20) fprintf(stderr, "diff: %lu\n", diff);
*/
		if (x != y) {
			uint64_t flip = x^y;
			do if (flip & 1) ++errors;
			while (flip >>= 1);
		}
	}
	if (errors) fprintf(stderr, "*** Buffer verification failed: %d bits were flippedd (%d%%) ***\n",
			errors, 100*errors/(len*Ki*8));
	else printf("Buffer verification successful\n");
	return errors;
}


int main(int argc, char **argv)
{
	int fd0, fd1;
	assert(argc == 2);
	int tx0len = atoi(argv[1]), rx0len = tx0len;
	int tx1len = 2*tx0len, rx1len = tx1len;
	assert(tx0len >= 1 && tx0len <= 4000);

	fd0 = open("/dev/zdma", O_RDWR|O_SYNC);
	fd1 = open("/dev/zdma", O_RDWR|O_SYNC);
	assert(fd0 >= 0 && fd1 >= 0);

	ioctl(fd0, ZDMA_IOCTL_SET_SIZE, tx0len<<16 | rx0len);
	ioctl(fd1, ZDMA_IOCTL_SET_SIZE, tx1len<<16 | rx1len);
	
	void *tx0 = mmap(0, tx0len*Ki, PROT_WRITE, MAP_SHARED|MAP_LOCKED, fd0, 0);
	assert(tx0 != MAP_FAILED);
	
	void *rx0 = mmap(0, rx0len*Ki, PROT_READ, MAP_SHARED|MAP_LOCKED, fd0, 0);
	assert(rx0 != MAP_FAILED);

	void *tx1 = mmap(0, tx1len*Ki, PROT_WRITE, MAP_SHARED|MAP_LOCKED, fd1, 0);
	assert(tx1 != MAP_FAILED);
	
	void *rx1 = mmap(0, rx1len*Ki, PROT_READ, MAP_SHARED|MAP_LOCKED, fd1, 0);
	assert(rx1 != MAP_FAILED);

	buffer_fill(tx0, tx0len);
	buffer_fill(tx1, tx1len);

	ioctl(fd0, ZDMA_IOCTL_PREP, 0);
	ioctl(fd0, ZDMA_IOCTL_ISSUE, 0);
	buffer_compare(tx0, rx0, tx0len);
	buffer_fill(tx0, tx0len);
	ioctl(fd0, ZDMA_IOCTL_ISSUE, 0);
	buffer_compare(tx0, rx0, tx0len);
	
	
	ioctl(fd1, ZDMA_IOCTL_PREP, 0);
	ioctl(fd1, ZDMA_IOCTL_ISSUE, 0);

	close(fd0);
	close(fd1);

	return 0;
}

