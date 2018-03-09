#include "common.h"
#include "ap_int.h"

int CORE_NAME(axi_stream_t& src, axi_stream_t& dst)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#ifdef CLK_AXILITE
#  pragma HLS INTERFACE s_axilite clock=axi_lite_clk port=return bundle=control offset=0x38
#else
#  pragma HLS INTERFACE s_axilite port=return bundle=control offset=0x38
#endif
	int ret;
	axi_elem_t x, y;
	ret = 0;
	do {
#pragma HLS loop_tripcount min=153600 max=518400
#pragma HLS pipeline
		src >> x;
		y = x;
		dst << y;
	} while (!x.last);
	return ret;
}
