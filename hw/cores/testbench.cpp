#include <stdlib.h>
#include "common.h"
#include "testbench.h"

int main (int argc, char** argv) {
	hls::stream<axi_elem_t> src, dst;
	int size = 1048576, gain = 2;
	axi_elem_t x;

	for (int i = 0; i < size/8; ++i) {
		x.data = (int64_t)i;
		if (i == size/8 - 1) x.last = 1;
		src << x;
	}
	ap_uint<4> debug;
	int ret = loopback(src, dst, size, gain, &debug);
	std::cout << "debug =" << debug << ", ret = " << ret << std::endl;
	int err = 0;
	for (int i = 0; i < size/8; ++i) {
		dst >> x;
		if (x.data != (int64_t)i*gain) ++err;
	}
	return err;
}
