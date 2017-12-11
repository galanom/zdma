#include "common.h"
#include "ap_int.h"

#define MAX_KERN_DIM 11
int32_t zdma_core(axi_stream_t& src, axi_stream_t& dst, int32_t line_width, int32_t kernel_dim)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=line_width bundle=control offset=0x10
#pragma HLS INTERFACE s_axilite port=kernel_dim bundle=control offset=0x14
#pragma HLS INTERFACE s_axilite port=return bundle=control offset=0x1C
#pragma HLS INTERFACE ap_stable port=line_width
#pragma HLS INTERFACE ap_stable port=kernel_dim
	axi_elem_t data_in, data_out;
	int32_t ret;
	int32_t col;
	hls::LineBuffer<MAX_KERN_DIM, MAX_LINE_WIDTH, uint8_t> linebuf;
	hls::Window<MAX_KERN_DIM, MAX_KERN_DIM, int32_t> win;
	int32_t kern_sum;
	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;
	int32_t acc[AXI_TDATA_NBYTES];

	ret = 0;

	if (kernel_dim < 3 || kernel_dim > MAX_KERN_DIM || (kernel_dim & 1) != 1) {
		kernel_dim = 5;
		ret = -1;
	}

	if (line_width < 0 || line_width > MAX_LINE_WIDTH) {
		line_width = MAX_LINE_WIDTH;
		ret = -1;
	}

	switch (kernel_dim) {
	case 1:
		kern_sum = 1;
		break;
	case 3:
		kern_sum = 9;
		break;
	case 5:
		kern_sum = 25;
		break;
	case 7:
		kern_sum = 49;
		break;
	case 9:
		kern_sum = 81;
		break;
	case 11:
		kern_sum = 121;
		break;
	}
//	kern_sum = kernel_dim*kernel_dim;

	col = 0;
	do {
#pragma HLS pipeline
#pragma HLS loop_tripcount min=153600 max=518400
		src >> data_in;
		ret += AXI_TDATA_NBYTES;
		data_out = data_in;
		pixel.all = data_out.data;
		data_out.data = 0;

		for (int px = 0; px < AXI_TDATA_NBYTES; px++) {
			linebuf.shift_up(col+px);
			linebuf.insert_top(pixel.at[px], col+px);

			acc[px] = 0;
			for (int i = 0; i < kernel_dim; i++) {
#pragma HLS pipeline
#pragma HLS loop_tripcount min=3 max=9
				for (int j = 0; j < kernel_dim; j++) {
#pragma HLS pipeline
#pragma HLS loop_tripcount min=3 max=9
					acc[px] += linebuf.getval(i, j+col+px);
				}
			}

			int64_t val = acc[px] / kern_sum;
			if (val > 255) val = 255;
			data_out.data |= val << (px << 3);

		}
		col += AXI_TDATA_NBYTES;

		if (col >= line_width)
			col = 0;

		dst << data_out;
	} while (!data_out.last);
	return ret;
}
