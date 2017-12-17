#include "common.h"
#include "ap_int.h"

int zdma_core(axi_stream_t& src, axi_stream_t& dst)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite clock=s_axi_lite_clk port=return bundle=control offset=0x1C
	axi_elem_t data_in, data_out;
	int ret;
	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;

	ret = 0;
	do {
#pragma HLS loop_tripcount min=307200 max=1036800
#pragma HLS pipeline
		src >> data_in;
		data_out.last = data_in.last;
		data_out.keep = data_in.keep;
		data_out.strb = data_in.strb;
		data_out.data = ~data_in.data;;
		dst << data_out;
	} while (!data_out.last);
	
	return ret;
}

