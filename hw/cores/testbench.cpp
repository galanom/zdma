#include <stdlib.h>
#include "common.h"
#include "testbench.h"

int main (int argc, char** argv) {
	hls::stream<axi_elem_t> src, dst;
	int size = 1048576, gain = 2;
	axi_elem_t x;
	uint64_t i;
	for (i = 0; i < size/8; ++i) {
		x.data = i;
		if (i == size/8 - 1) x.last = 1;
		src << x;
	}
	ap_uint<4> debug;
	int ret = loopback(src, dst, &debug);
	std::cout << "debug =" << debug << ", ret = " << ret << std::endl;
	int err = 0;
	i = 0;
	do {
		dst >> x;
		if (x.data != i++) ++err;
	} while (!x.last);
	return err;
}
