#include "common.h"
#include "ap_int.h"

#define KERN_DIM 3

int CORE_NAME(axi_stream_t& src, axi_stream_t& dst, ap_uint<LINE_WIDTH_BITS> line_width, ap_uint<1> func)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#ifdef CLK_AXILITE
#  pragma HLS INTERFACE s_axilite clock=axi_lite_clk port=line_width bundle=control offset=0x10
#  pragma HLS INTERFACE s_axilite clock=axi_lite_clk port=func bundle=control offset=0x18
#  pragma HLS INTERFACE s_axilite clock=axi_lite_clk port=return bundle=control offset=0x38
#else
#  pragma HLS INTERFACE s_axilite port=line_width bundle=control offset=0x10
#  pragma HLS INTERFACE s_axilite port=func bundle=control offset=0x18
#  pragma HLS INTERFACE s_axilite port=return bundle=control offset=0x38
#endif

#pragma HLS INTERFACE ap_stable port=line_width
#pragma HLS INTERFACE ap_stable port=func
	axi_elem_t data_in, data_out;
	ap_uint<LINE_WIDTH_BITS> col;
	int ret;
	hls::LineBuffer<KERN_DIM, MAX_LINE_WIDTH+KERN_DIM, uint8_t> linebuf;
	hls::Window<KERN_DIM, KERN_DIM, ap_int<10> > win_x, win_y;
	ap_int<10> acc_x[AXI_TDATA_NBYTES], acc_y[AXI_TDATA_NBYTES];
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
					pixel_tmp = linebuf.getval(i, j+col+px);
					uint16_t tmp_x, tmp_y;
#ifdef FORCE_DSP48
// apparently, dsp48 makes things worse!
//#pragma HLS resource variable=tmp_x core=DSP48
//#pragma HLS resource variable=tmp_y core=DSP48
#endif
					tmp_x = kern_x[func][i][j] * pixel_tmp;
					tmp_y = kern_y[func][i][j] * pixel_tmp;
					win_x.insert(tmp_x, i, j);
					win_y.insert(tmp_y, i, j);
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
			ap_int<10> val = abs(acc_x[px]) + abs(acc_y[px]);
			pixel.at[px] = val;
			if (val > 255)
				pixel.at[px] = 255;
		}
		data_out.data = pixel.all;
		col += AXI_TDATA_NBYTES;

		if (col >= line_width)
			col = 0;

		dst << data_out;
	} while (!data_out.last);
	return ret;
}
