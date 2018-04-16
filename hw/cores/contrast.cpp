#include "common.h"
#include "ap_int.h"

int CORE_NAME(axi_stream_t& src, axi_stream_t& dst, int8_t brightness, int8_t contrast)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#ifdef CLK_AXILITE
#  pragma HLS INTERFACE s_axilite clock=axi_lite_clk port=brightness bundle=control offset=0x10
#  pragma HLS INTERFACE s_axilite clock=axi_lite_clk port=contrast bundle=control offset=0x18
#  pragma HLS INTERFACE s_axilite clock=axi_lite_clk port=return bundle=control offset=0x38
#else
#  pragma HLS INTERFACE s_axilite port=brightness bundle=control offset=0x10
#  pragma HLS INTERFACE s_axilite port=contrast bundle=control offset=0x18
#  pragma HLS INTERFACE s_axilite port=return bundle=control offset=0x38
#endif
#pragma HLS INTERFACE ap_stable port=brightness
#pragma HLS INTERFACE ap_stable port=contrast

	axi_elem_t data_in, data_out;
	int ret;
	uint8_t alpha, beta;
	alpha = ((contrast + 256)<<7)/(256 - contrast);
	beta = brightness + 128;

	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;

	ret = 0;
	do {
#pragma HLS loop_tripcount min=153600 max=518400
#pragma HLS pipeline
		src >> data_in;
		data_out.last = data_in.last;
		data_out.keep = data_in.keep;
		data_out.strb = data_in.strb;
		pixel.all = data_in.data;

		for (int px = 0; px < AXI_TDATA_NBYTES; px++) {
			int16_t tmp;
//#pragma HLS resource variable=tmp core=Mul_LUT
			tmp = alpha * (pixel.at[px] - 128);
			ap_int<10> val = (tmp >> 7 ) + beta;
			if (val > 255)
				pixel.at[px] = 255;
			else if (val < 0)
				pixel.at[px] = 0;
			else
				pixel.at[px] = val;
			/*pixel.at[px] = (uint8_t)val;
			if (val > 255)
				pixel.at[px] = 255;
			if (val < 0)
				pixel.at[px] = 0;*/
		}
		data_out.data = pixel.all;
		dst << data_out;
	} while (!data_out.last);
	return ret;
}
