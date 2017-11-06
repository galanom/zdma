#include "common.h"
#include "ap_int.h"

#define KERN_DIM 3

int32_t contrast(axi_stream_t& src, axi_stream_t& dst, int32_t brightness, int32_t contrast)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=brightness bundle=control offset=0x18
#pragma HLS INTERFACE s_axilite port=contrast bundle=control offset=0x20
#pragma HLS INTERFACE s_axilite port=return bundle=control offset=0x10
#pragma HLS INTERFACE ap_stable port=brightness
#pragma HLS INTERFACE ap_stable port=contrast
	axi_elem_t data_in, data_out;
	int32_t ret = 0;
	ap_fixed<32,16> alpha = 259.0*(contrast + 255)/(255.0*(259 - contrast)),
				beta = brightness + 128;
	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;

	do {
#pragma HLS loop_tripcount min=76800 max=288000
#pragma HLS pipeline
		src >> data_in;
		data_out = data_in;
		pixel.all = data_out.data;
		data_out.data = 0;

		for (int px = 0; px < AXI_TDATA_NBYTES; px++) {
#pragma HLS unroll
			int64_t val = alpha*(pixel.at[px] - 128) + beta;
			if (val > 255) val = 255;
			if (val < 0) val = 0;
			data_out.data |= val << (px << AXI_TDATA_SHIFT);
		}

		dst << data_out;
	} while (!data_out.last);
	return ret;
}

