#include "common.h"
#include "ap_int.h"
#define KERN_DIM GAUSS_KERN_DIM
#define AXI_TDATA_SIZE 8
#define AXI_TDATA_SHIFT 3

int32_t gauss(axi_stream_t& src, axi_stream_t& dst, int32_t line_width, ap_uint<4> *debug)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=line_width bundle=CONTROL_BUS offset=0x14
#pragma HLS INTERFACE s_axilite port=return bundle=CONTROL_BUS offset=0x24
#pragma HLS INTERFACE ap_stable port=line_width
#pragma HLS INTERFACE ap_none port=debug
	axi_elem_t data_in, data_out;
	int32_t ret = 0;
	uint8_t lnbuf[KERN_DIM][MAX_LINE_WIDTH];
	int32_t win[8][KERN_DIM][KERN_DIM];
	int32_t acc[AXI_TDATA_SIZE];

	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_SIZE];
	} pixel;

	int8_t kern[KERN_DIM][KERN_DIM] =
				{{ 1,  4,  6,  4,  1},
				 { 4, 16, 24, 16,  4},
				 { 6, 26, 36, 26,  6},
				 { 4, 16, 24, 16,  4},
				 { 1,  4,  6,  4,  1}};
	int32_t kern_sum = 256;


	if (line_width < 0 || line_width > MAX_LINE_WIDTH) line_width = MAX_LINE_WIDTH;

	*debug = 0;
	int col = 0;
	do {
		src >> data_in;
		data_out = data_in;
		pixel.all = data_out.data;
		data_out.data = 0;
		for (int px = 0; px < AXI_TDATA_SIZE; px++) {
			for (int i = 0; i < KERN_DIM - 1; i++) {
				lnbuf[i][col+px] = lnbuf[i+1][col+px];
			}

			lnbuf[KERN_DIM-1][col+px] = pixel.at[px];

			for (int i = 0; i < KERN_DIM; i++) {
				for (int j = 0; j < KERN_DIM; j++) {
					win[px][i][j] = kern[i][j] * lnbuf[i][j+col+px];
				}
			}

			acc[px] = 0;
			for (int i = 0; i < KERN_DIM; i++) for (int j = 0; j < KERN_DIM; j++) {
				acc[px] += win[px][i][j];
			}

			int64_t val = acc[px] / kern_sum;
			if (val > 255) val = 255;
			if (val < 0) val = 0;
			data_out.data |= val << (px << AXI_TDATA_SHIFT);

		}
		col += AXI_TDATA_SIZE;

		if (col >= line_width)
			col = 0;

		dst << data_out;
	} while (!data_out.last);
	return ret;
}
