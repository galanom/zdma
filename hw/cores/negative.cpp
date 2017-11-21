#include "common.h"
#include "ap_int.h"

#define KERN_DIM 3

int32_t zdma_core(axi_stream_t& src, axi_stream_t& dst)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=return bundle=control offset=0xC0
	axi_elem_t data_in, data_out;
	int32_t ret;
	int16_t col;
	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;

	ret = 0;
	col = 0;
	do {
#pragma HLS loop_tripcount min=76800 max=288000
#pragma HLS pipeline
		src >> data_in;
		ret += AXI_TDATA_NBYTES;
		data_out = data_in;
		data_out.data = ~data_in.data;;
		dst << data_out;
	} while (!data_out.last);
	
	return ret;
}

