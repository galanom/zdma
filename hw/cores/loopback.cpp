#include "common.h"
#include "ap_int.h"

int32_t loopback(axi_stream_t& src, axi_stream_t& dst)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
//#pragma HLS INTERFACE s_axilite port=size bundle=CONTROL_BUS offset=0x14
//#pragma HLS INTERFACE s_axilite port=gain bundle=CONTROL_BUS offset=0x1C
#pragma HLS INTERFACE s_axilite port=return bundle=CONTROL_BUS offset=0x24
//#pragma HLS INTERFACE ap_stable port=size
//#pragma HLS INTERFACE ap_stable port=gain
//#pragma HLS INTERFACE ap_none port=debug
	uint64_t ret = 0;
	axi_elem_t x, y;
	do {
		src >> x;
		y = x;
		ret += x.data;
	//	*debug = ret & 0xf;
		dst << y;
	} while (!x.last);
	return ret;
}
