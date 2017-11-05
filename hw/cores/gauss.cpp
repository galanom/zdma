#include "common.h"
#include "ap_int.h"

#define KERN_DIM 5

int32_t gauss(axi_stream_t& src, axi_stream_t& dst, int32_t line_width, ap_uint<4> *debug)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=line_width bundle=CONTROL_BUS offset=0x14
#pragma HLS INTERFACE s_axilite port=return bundle=CONTROL_BUS offset=0x24
#pragma HLS INTERFACE ap_stable port=line_width
#pragma HLS INTERFACE ap_none port=debug
	*debug = 3;
	axi_elem_t data_in, data_out;
	int16_t col = 0;
	int32_t ret = 0;
	hls::LineBuffer<KERN_DIM, MAX_LINE_WIDTH, uint8_t> linebuf;
	hls::Window<KERN_DIM, KERN_DIM, int32_t> win;
	int32_t acc[AXI_TDATA_NBYTES];
	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;

	int8_t kern[KERN_DIM][KERN_DIM] =	// kernel sum is 256
				{{ 1,  4,  6,  4,  1},
				 { 4, 16, 24, 16,  4},
				 { 6, 26, 36, 26,  6},
				 { 4, 16, 24, 16,  4},
				 { 1,  4,  6,  4,  1}};

	if (line_width < 0 || line_width > MAX_LINE_WIDTH) {
		line_width = MAX_LINE_WIDTH;
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
					win.insert(kern[i][j] * linebuf.getval(i, j+col+px), i, j);
				}
			}

			acc[px] = 0;
			for (int i = 0; i < KERN_DIM; i++) {
				for (int j = 0; j < KERN_DIM; j++) {
					acc[px] += win.getval(i, j);
				}
			}
			int64_t val = acc[px] >> 8; // divide by kern_sum == 256
			if (val > 255) val = 255;
			//if (val < 0) val = 0; /// kernel has no negative values
			data_out.data |= val << (px << AXI_TDATA_SHIFT);
		}
		col += AXI_TDATA_NBYTES;

		if (col >= line_width)
			col = 0;

		dst << data_out;
	} while (!data_out.last);
	*debug = 0;
	return ret;
}
