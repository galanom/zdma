#include "common.h"
#include "ap_int.h"

#define KERN_DIM 3

int32_t zdma_core(axi_stream_t& src, axi_stream_t& dst, int32_t brightness)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=brightness bundle=control offset=0x20
#pragma HLS INTERFACE s_axilite port=return bundle=control offset=0xC0
#pragma HLS INTERFACE ap_stable port=brightness
	axi_elem_t data_in, data_out;
	int32_t ret;
	int16_t val[AXI_TDATA_NBYTES];
	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;
	
	ret = 0;
	do {
#pragma HLS pipeline
#pragma HLS loop_tripcount min=76800 max=288000
		src >> data_in;
		ret += AXI_TDATA_NBYTES;
		data_out = data_in;
		pixel.all = data_out.data;

		for (int px = 0; px < AXI_TDATA_NBYTES; px++) {
			val[px] = pixel.at[px] + brightness;
			if (val[px] > 255) pixel.at[px] = 255;
			else pixel.at[px] = (uint8_t)val[px];
		}

		data_out.data = pixel.all;
		dst << data_out;
	} while (!data_out.last);
	return ret;
}

