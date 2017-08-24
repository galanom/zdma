#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <assert.h>
#include "zdma_ioctl.h"

int main(int argc, char **argv)
{
	int fd, txlen = 1000, rxlen = 1000;

	if ((fd = open("/dev/zdma", O_RDWR|O_SYNC)) < 0) {
		perror("open");
		exit(-1);
	}
	ioctl(fd, ZDMA_IOCTL_SET_SIZE, txlen<<16 | rxlen);
	void *txbuf = mmap(0, txlen*1024, PROT_WRITE, MAP_SHARED|MAP_LOCKED, fd, 0);
	if (txbuf == MAP_FAILED) {
		perror("mmap");
	} else	printf("tx done\n");
	void *rxbuf = mmap(0, rxlen*1024, PROT_READ, MAP_SHARED|MAP_LOCKED, fd, 0);
	if (rxbuf == MAP_FAILED) {
		perror("mmap");
	} else printf("rx done\n");

	srand(1);
	for (int i = 0; i < txlen*1024/4; ++i)
		((int *)txbuf)[i] = rand();
	((unsigned *)txbuf)[0] = 0xfeeddead;
	ioctl(fd, ZDMA_IOCTL_PREP, 0);
	ioctl(fd, ZDMA_IOCTL_ISSUE, 0);
	fclose(fd);
	printf("ret=%x\n", ((unsigned *)rxbuf)[0]);
	for (int i = 0; i < txlen*1024/8; ++i) if (((long long *)txbuf)[i] != ((long long *)rxbuf)[i]) {
			printf("compare error at position dw %u\n", i);
			return -1;
		}
	printf("compare successful\n");
	return 0;
}
