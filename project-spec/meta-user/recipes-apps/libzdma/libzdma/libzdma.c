#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/mman.h>

int main(int argc, char **argv)
{
	int fd, len = 1024;
	if ((fd = open("/dev/zdma", O_RDWR|O_SYNC)) < 0) {
		perror("open");
		exit(-1);
	}
	unsigned *kadr = mmap(0, len, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_LOCKED, fd, 0);
	if (kadr == MAP_FAILED) {
		perror("mmap");
		exit(-1);
	}
	printf("ret=%x\n", kadr[0]);
	return 0;
}
