#include <stdio.h>
#include <stdlib.h>
int main(void)
{
	void *x = malloc(100);
	for (int i = 0; i < 100/4; ++i) {
		((int64_t *)x)[i] = i;
		printf("x[%lld]=%d\n", ((int64_t *)x)[i], i);
	}
}

