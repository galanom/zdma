#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "zdma_ioctl.h"

int main(int argc, char **argv)
{
	int fd, txlen = 1048576, rxlen = 1048576;
	if ((fd = open("/dev/zdma", O_RDWR|O_SYNC)) < 0) {
		perror("open");
		exit(-1);
	}
	ioctl(fd, ZDMA_IOCTL_SET_SIZE, 1024<<16 | 1024);
	void *txbuf = mmap(0, txlen, PROT_WRITE, MAP_SHARED|MAP_LOCKED, fd, 0);
	if (txbuf == MAP_FAILED) {
		perror("mmap");
	} else	printf("tx done\n");
	void *rxbuf = mmap(0, rxlen, PROT_READ, MAP_SHARED|MAP_LOCKED, fd, 0);
	if (rxbuf == MAP_FAILED) {
		perror("mmap");
	} else printf("rx done\n");

	((unsigned *)txbuf)[0] = 0xfeeddead;
	ioctl(fd, ZDMA_IOCTL_PREP, 0);
	ioctl(fd, ZDMA_IOCTL_ISSUE, 0);
	printf("ret=%x\n", ((unsigned *)rxbuf)[0]);

	return 0;
}
