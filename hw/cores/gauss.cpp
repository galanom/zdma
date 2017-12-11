#include "common.h"
#include "ap_int.h"

#define KERN_DIM 5

int32_t zdma_core(axi_stream_t& src, axi_stream_t& dst, int32_t line_width)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=line_width bundle=control offset=0x10
#pragma HLS INTERFACE s_axilite port=return bundle=control offset=0x1C
#pragma HLS INTERFACE ap_stable port=line_width
	axi_elem_t data_in, data_out;
	int16_t col;
	int32_t ret;
	hls::LineBuffer<KERN_DIM, MAX_LINE_WIDTH+KERN_DIM, uint8_t> linebuf;
	hls::Window<KERN_DIM, KERN_DIM, int32_t> win;
	int32_t acc[AXI_TDATA_NBYTES];
	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;

	int8_t kern[KERN_DIM][KERN_DIM] =	// kernel sum is 256
				/*{{1, 2, 1},
				 {2, 4, 2},
				 {1, 2, 1}};*/

				{{ 1,  4,  6,  4,  1},
				 { 4, 16, 24, 16,  4},
				 { 6, 26, 36, 26,  6},
				 { 4, 16, 24, 16,  4},
				 { 1,  4,  6,  4,  1}};
	ret = 0;
	if (line_width < 0 || line_width > MAX_LINE_WIDTH) {
		line_width = MAX_LINE_WIDTH;
		ret = -1;
	}

	col = 0;
	do {
#pragma HLS loop_tripcount min=153600 max=518400
#pragma HLS pipeline
		src >> data_in;
		data_out.last = data_in.last;
		data_out.keep = data_in.keep;
		data_out.strb = data_in.strb;

		pixel.all = data_in.data;

		for (int px = 0; px < AXI_TDATA_NBYTES; px++) {
			linebuf.shift_up(col+px);
			linebuf.insert_top(pixel.at[px], col+px);

			for (int i = 0; i < KERN_DIM; i++) {
				for (int j = 0; j < KERN_DIM; j++) {
					win.insert(kern[i][j] * linebuf.getval(i, j+col+px), i, j);
				}
			}
			acc[px] = 0;
			for (int i = 0; i < KERN_DIM; i++) {
				for (int j = 0; j < KERN_DIM; j++) {
					acc[px] += win.getval(i, j);
				}
			}

			int32_t val = acc[px] >> 8;
			pixel.at[px] = val;
			if (val > 255) pixel.at[px] = 255;
		}
		data_out.data = pixel.all;
		col += AXI_TDATA_NBYTES;

		if (col >= line_width)
			col = 0;

		dst << data_out;
	} while (!data_out.last);
	return ret;
}
