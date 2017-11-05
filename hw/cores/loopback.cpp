#include "common.h"
#include "ap_int.h"

int32_t loopback(axi_stream_t& src, axi_stream_t& dst, ap_uint<4> *debug)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=return bundle=CONTROL_BUS offset=0x24
#pragma HLS INTERFACE ap_none port=debug
	*debug = 1;
	uint64_t ret = 0;
	axi_elem_t x, y;
	do {
		src >> x;
		y = x;
		ret += AXI_TDATA_NBYTES;
		dst << y;
	} while (!x.last);
	*debug = 0;
	return ret;
}
