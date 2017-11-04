#include "common.h"
#include "ap_int.h"

int32_t blur(axi_stream_t& src, axi_stream_t& dst, int32_t line_width, int32_t kernel_dim, ap_uint<4> *debug)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=line_width bundle=CONTROL_BUS offset=0x14
#pragma HLS INTERFACE s_axilite port=kernel_dim bundle=CONTROL_BUS offset=0x1C
#pragma HLS INTERFACE s_axilite port=return bundle=CONTROL_BUS offset=0x24
#pragma HLS INTERFACE ap_stable port=line_width
#pragma HLS INTERFACE ap_stable port=kernel_dim
#pragma HLS INTERFACE ap_none port=debug
	axi_elem_t data_in, data_out;
	int32_t ret = line_width;
	uint8_t lnbuf[KERNEL_DIM][LINE_WIDTH];
	ap_int<24> kern[KERNEL_DIM][KERNEL_DIM];
	int32_t win[8][KERNEL_DIM][KERNEL_DIM];
	union {
		uint64_t all;
		uint8_t at[8];
	} pixel;
	int32_t acc[8];

	if (kernel_dim < 1 || kernel_dim > KERNEL_DIM || (kernel_dim & 1) != 1
			|| line_width < 0 || line_width > LINE_WIDTH) return -1;

	for(int i = 0; i < kernel_dim; ++i) for (int j = 0; j < kernel_dim; ++j) {
		kern[i][j] = ((1 << 23) - 1) / (kernel_dim*kernel_dim);
	}
	*debug = kernel_dim;
	int col = 0;
	do {
		src >> data_in;
		data_out = data_in;
		pixel.all = data_out.data;
		data_out.data = 0;
		for (int px = 0; px < 8; px++) {
			for (int i = 0; i < kernel_dim - 1; i++) {
#pragma HLS loop_tripcount min=1 max=11
				lnbuf[i][col+px] = lnbuf[i+1][col+px];
			}

			lnbuf[kernel_dim-1][col+px] = pixel.at[px];

			for (int i = 0; i < kernel_dim; i++) {
#pragma HLS loop_tripcount min=1 max=11
				for (int j = 0; j < kernel_dim; j++) {
#pragma HLS loop_tripcount min=1 max=11
					win[px][i][j] = kern[i][j] * lnbuf[i][j+col+px];
				}
			}

			acc[px] = 0;
			for (int i = 0; i < kernel_dim; i++) for (int j = 0; j < kernel_dim; j++) {
				acc[px] += win[px][i][j];
			}

			if (acc[px] < 0) acc[px] = 0;

			uint64_t val = (acc[px] / ((1<<23) -1)) & 0xff;
			data_out.data |= val << (px << 3);

		}
		col += 8;

		if (col >= line_width)
			col = 0;

		dst << data_out;
	} while (!data_out.last);
	return ret;
}
