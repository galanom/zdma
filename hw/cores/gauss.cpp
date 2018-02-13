#include "common.h"
#include "ap_int.h"

#define KERN_DIM 5

int CORE_NAME(axi_stream_t& src, axi_stream_t& dst, int line_width)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#ifdef CLK_AXILITE
#  pragma HLS INTERFACE s_axilite clock=axi_lite_clk port=line_width bundle=control offset=0x10
#  pragma HLS INTERFACE s_axilite clock=axi_lite_clk port=return bundle=control offset=0x1C
#else
#  pragma HLS INTERFACE s_axilite port=line_width bundle=control offset=0x10
#  pragma HLS INTERFACE s_axilite port=return bundle=control offset=0x1C
#endif
#pragma HLS INTERFACE ap_stable port=line_width
	axi_elem_t data_in, data_out;
	int16_t col;
	int ret;
	hls::LineBuffer<KERN_DIM, MAX_LINE_WIDTH+KERN_DIM, uint8_t> linebuf;
	ap_uint<17> acc;//[AXI_TDATA_NBYTES];
	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;

	uint8_t kern[KERN_DIM][KERN_DIM] =	// kernel sum is 256
				{{ 1,  4,  6,  4,  1},
				 { 4, 16, 25, 16,  4},
				 { 6, 25, 32, 25,  6},
				 { 4, 16, 25, 16,  4},
				 { 1,  4,  6,  4,  1}};
	ret = 0;
	if (line_width < 0 || line_width > MAX_LINE_WIDTH) {
		line_width = MAX_LINE_WIDTH;
		ret = -1;
	}

	col = 0;
	do {
#pragma HLS pipeline
#pragma HLS loop_tripcount min=153600 max=518400
		src >> data_in;
		data_out.last = data_in.last;
		data_out.keep = data_in.keep;
		data_out.strb = data_in.strb;

		pixel.all = data_in.data;

		for (int px = 0; px < AXI_TDATA_NBYTES; px++) {
			linebuf.shift_up(col+px);
			linebuf.insert_top(pixel.at[px], col+px);

			acc = 0;

			for (int i = 0; i < KERN_DIM; i++) {
				for (int j = 0; j < KERN_DIM; j++) {
					uint16_t tmp;
//#pragma HLS resource variable=tmp core=DSP48
					tmp = kern[i][j] * linebuf.getval(i, j+col+px);
					acc += tmp;
				}
			}
			pixel.at[px] = acc >> 8;
		}
		data_out.data = pixel.all;
		col += AXI_TDATA_NBYTES;

		if (col >= line_width)
			col = 0;

		dst << data_out;
	} while (!data_out.last);
	return ret;
}
