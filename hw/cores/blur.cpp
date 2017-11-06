#include "common.h"
#include "ap_int.h"

#define MAX_KERN_DIM 11

int32_t blur(axi_stream_t& src, axi_stream_t& dst, int32_t line_width, int32_t kernel_dim)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=line_width bundle=control offset=0x18
#pragma HLS INTERFACE s_axilite port=kernel_dim bundle=control offset=0x20
#pragma HLS INTERFACE s_axilite port=return bundle=control offset=0x10
#pragma HLS INTERFACE ap_stable port=line_width
#pragma HLS INTERFACE ap_stable port=kernel_dim
	axi_elem_t data_in, data_out;
	int32_t ret = 0;
	hls::LineBuffer<MAX_KERN_DIM, MAX_LINE_WIDTH, uint8_t> linebuf;
	hls::Window<MAX_KERN_DIM, MAX_KERN_DIM, int32_t> win;
	int32_t kern_sum;
	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;
	int32_t acc[AXI_TDATA_NBYTES];

	if (kernel_dim < 3 || kernel_dim > MAX_KERN_DIM || (kernel_dim & 1) != 1) {
		kernel_dim = 5;
		ret = -1;
	}
	if (line_width < 0 || line_width > MAX_LINE_WIDTH) {
		line_width = MAX_LINE_WIDTH;
		ret = -1;
	}

	kern_sum = kernel_dim*kernel_dim;

	int col = 0;
	do {
#pragma HLS pipeline
#pragma HLS loop_tripcount min=76800 max=288000
		src >> data_in;
		data_out = data_in;
		pixel.all = data_out.data;
		data_out.data = 0;
		for (int px = 0; px < AXI_TDATA_NBYTES; px++) {
#pragma HLS pipeline
#pragma HLS unroll
			linebuf.shift_up(col+px);
			linebuf.insert_top(pixel.at[px], col+px);

			acc[px] = 0;
			for (int i = 0; i < kernel_dim; i++) {
#pragma HLS pipeline
#pragma HLS loop_tripcount min=3 max=11
				for (int j = 0; j < kernel_dim; j++) {
#pragma HLS pipeline
#pragma HLS loop_tripcount min=3 max=11
					acc[px] += linebuf.getval(i, j+col+px);
				}
			}

			int64_t val = acc[px] / kern_sum;
			if (val > 255) val = 255;
			data_out.data |= val << (px << AXI_TDATA_SHIFT);

		}
		col += AXI_TDATA_NBYTES;

		if (col >= line_width)
			col = 0;

		dst << data_out;
	} while (!data_out.last);
	return ret;
}
