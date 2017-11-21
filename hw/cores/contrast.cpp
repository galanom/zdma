#include "common.h"
#include "ap_int.h"

#define KERN_DIM 3

int32_t zdma_core(axi_stream_t& src, axi_stream_t& dst, int32_t brightness, int32_t contrast)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=brightness bundle=control offset=0x20
#pragma HLS INTERFACE s_axilite port=contrast bundle=control offset=0x30
#pragma HLS INTERFACE s_axilite port=return bundle=control offset=0xC0
#pragma HLS INTERFACE ap_stable port=brightness
#pragma HLS INTERFACE ap_stable port=contrast
	axi_elem_t data_in, data_out;
	int32_t ret = 0;
#pragma HLS reset variable=ret
	int64_t val[AXI_TDATA_NBYTES];
	ap_int<20> alpha_1, alpha_2, beta;
	ap_fixed<32,16> alpha;

	//ap_fixed<32,16> alpha = 259.0*(contrast + 255)/(255.0*(259 - contrast)),
	//beta = brightness + 128;
	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;
	{
#pragma HLS inline off
#pragma HLS expression_balance off
		contrast += 255;
		alpha_1 = 259*contrast;
		contrast = 4 - contrast;
		alpha_2 = 255*contrast;
	}

	beta = brightness + 128;
	{
#pragma HLS inline off
#pragma HLS latency max=2
#pragma HLS expression_balance off
		alpha = alpha_1 / alpha_2;
	}

	do {
#pragma HLS loop_tripcount min=76800 max=288000
#pragma HLS pipeline
		src >> data_in;
		data_out = data_in;
		pixel.all = data_out.data;
		//data_out.data = 0;

		for (int px = 0; px < AXI_TDATA_NBYTES; px++) {
			val[px] = alpha*(pixel.at[px] - 128) + beta;
			if (val[px] > 255) val[px] = 255;
			if (val[px] <   0) val[px] = 0;
		}

		data_out.data =
//				val[7] << 56 | val[6] << 48 |
	//			val[5] << 40 | val[4] << 32 |
				val[3] << 24 | val[2] << 16 |
				val[1] <<  8 | val[0];

		dst << data_out;
	} while (!data_out.last);
	return ret;
}

