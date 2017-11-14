#include "common.h"
#include "ap_int.h"

#define KERN_DIM 3

int32_t zdma_core(axi_stream_t& src, axi_stream_t& dst, int32_t line_width, int32_t func)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=line_width bundle=control offset=0x20
#pragma HLS INTERFACE s_axilite port=func bundle=control offset=0x30
#pragma HLS INTERFACE s_axilite port=return bundle=control offset=0xC0
#pragma HLS INTERFACE ap_stable port=line_width
#pragma HLS INTERFACE ap_stable port=func
	axi_elem_t data_in, data_out;
	int16_t col = 0;
	int32_t ret = 0;
	hls::LineBuffer<KERN_DIM, MAX_LINE_WIDTH, uint8_t> linebuf;
	hls::Window<KERN_DIM, KERN_DIM, int32_t> win_x, win_y;
	int32_t acc_x[AXI_TDATA_NBYTES], acc_y[AXI_TDATA_NBYTES];
	uint8_t pixel_tmp;
	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;

	int8_t kern_x[2][KERN_DIM][KERN_DIM] =	// kernel sum is 0
		{{{  1,  0, -1},	// Gx of sobel
		  {  2,  0, -2},
		  {  1,  0, -1}},

		 {{  3,  0, -3}, 	// Gx of scharr
		  { 10,  0,-10},
		  {  3,  0, -3}}};

	int8_t kern_y[2][KERN_DIM][KERN_DIM] =	// kernel sum is 0
		{{{  1,  2,  1},	// Gy of sobel
		  {  0,  0,  0},
		  { -1, -2, -1}},

		 {{  3, 10,  3},	// Gy of scharr
		  {  0,  0,  0},
		  { -3,-10, -3}}};

	if (line_width < 0 || line_width > MAX_LINE_WIDTH) {
		line_width = MAX_LINE_WIDTH;
		ret = -1;
	}

	if (func != 0 && func != 1) {
		func = 0;
		ret = -1;
	}

	do {
#pragma HLS loop_tripcount min=76800 max=288000
#pragma HLS pipeline
		src >> data_in;
		data_out = data_in;
		pixel.all = data_out.data;
		data_out.data = 0;

		for (int px = 0; px < AXI_TDATA_NBYTES; px++) {

			linebuf.shift_up(col+px);
			linebuf.insert_top(pixel.at[px], col+px);

			for (int i = 0; i < KERN_DIM; i++) {
				for (int j = 0; j < KERN_DIM; j++) {
					pixel_tmp = linebuf.getval(i, j+col+px);
					win_x.insert(kern_x[func][i][j] * pixel_tmp, i, j);
					win_y.insert(kern_y[func][i][j] * pixel_tmp, i, j);
				}
			}

			acc_x[px] = 0;
			acc_y[px] = 0;
			for (int i = 0; i < KERN_DIM; i++) {
				for (int j = 0; j < KERN_DIM; j++) {
					// |Gx| + |Gy| is a crude approximation of sqrt(Gx^2 + Gy^2)
					acc_x[px] += win_x.getval(i, j);
					acc_y[px] += win_y.getval(i, j);
				}
			}
			int64_t val = abs(acc_x[px]) + abs(acc_y[px]);
			if (val > 255) val = 255;
			if (val < 0) val = 0;
			data_out.data |= val << (px << AXI_TDATA_SHIFT);
		}
		col += AXI_TDATA_NBYTES;

		if (col >= line_width)
			col = 0;

		dst << data_out;
	} while (!data_out.last);
	return ret;
}
