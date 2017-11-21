#include "common.h"
#include "ap_int.h"

int32_t zdma_core(axi_stream_t& src, axi_stream_t& dst)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=return bundle=control offset=0xC0
	int32_t ret;
	axi_elem_t x, y;
	ret = 0;
	do {
#pragma HLS loop_tripcount min=76800 max=288000
#pragma HLS pipeline
		src >> x;
		y = x;
		ret += AXI_TDATA_NBYTES;
		dst << y;
	} while (!x.last);
	return ret;
}
