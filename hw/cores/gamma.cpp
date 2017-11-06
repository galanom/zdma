#include "common.h"
#include "ap_int.h"
//#include "hls/hls_pow.h"
//#incl ude "ap_fixed.h"

#define KERN_DIM 3

int32_t gamma(axi_stream_t& src, axi_stream_t& dst, float gamma, ap_uint<4> *debug)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=gamma bundle=CONTROL_BUS offset=0x14
#pragma HLS INTERFACE s_axilite port=return bundle=CONTROL_BUS offset=0x24
#pragma HLS INTERFACE ap_stable port=gamma
#pragma HLS INTERFACE ap_none port=debug
	*debug = 10;
	axi_elem_t data_in, data_out;
	int32_t ret = 0;
	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;

	uint8_t lut[256];
	//ap_fixed<32, 16> gamma_fixed = gamma;

	float stage1[256];
	float stage2[256];
	int64_t stage3[256];

	for (int i = 0; i < 256; ++i) {
#pragma HLS pipeline
		stage1[i] = i / 255.0;
	}

	for (int i = 0; i < 256; ++i) {
#pragma HLS pipeline
		stage2[i] = pow(stage1[i], gamma);
	}
	for (int i = 0; i < 256; ++i) {
#pragma HLS pipeline
		stage3[i] = stage2[i] * 255;
	}
	for (int i = 0; i < 256; ++i) {
#pragma HLS pipeline
		if (stage3[i] > 255) lut[i] = 255;
		else if (stage3[i] < 0) lut[i] = 0;
		else lut[i] = uint8_t(stage3[i]);
	}

	do {
#pragma HLS loop_tripcount min=76800 max=288000
#pragma HLS pipeline
		src >> data_in;
		data_out = data_in;
		pixel.all = data_out.data;
		data_out.data = 0;

		for (int px = 0; px < AXI_TDATA_NBYTES; px++) {
#pragma HLS unroll
			int64_t val = lut[pixel.at[px]];
			data_out.data |= val << (px << AXI_TDATA_SHIFT);
		}

		dst << data_out;
	} while (!data_out.last);
	*debug = 0;
	return ret;
}

