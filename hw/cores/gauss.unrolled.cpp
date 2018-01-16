#include "common.h"
#include "ap_int.h"

#define KERN_DIM 5

int CORE_NAME(axi_stream_t& src, axi_stream_t& dst, int line_width)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=line_width bundle=control offset=0x10
#pragma HLS INTERFACE s_axilite port=return bundle=control offset=0x1C
#pragma HLS INTERFACE ap_stable port=line_width
	axi_elem_t data_in, data_out;
	int16_t col;
	//int ret;
	hls::LineBuffer<KERN_DIM, MAX_LINE_WIDTH+KERN_DIM, uint8_t> linebuf;
	ap_uint<17> acc[AXI_TDATA_NBYTES];
	union {
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;

/*	uint8_t kern[KERN_DIM][KERN_DIM] =	// kernel sum is 256
				{{ 1,  4,  6,  4,  1},
				 { 4, 16, 24, 16,  4},
				 { 6, 26, 36, 26,  6},
				 { 4, 16, 24, 16,  4},
				 { 1,  4,  6,  4,  1}};*/
	/*ret = 0;
	if (line_width < 0 || line_width > MAX_LINE_WIDTH) {
		line_width = MAX_LINE_WIDTH;
		ret = -1;
	}*/

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

			uint16_t tmp00, tmp01, tmp02, tmp03, tmp04,
					tmp10, tmp11, tmp12, tmp13, tmp14,
					tmp20, tmp21, tmp22, tmp23, tmp24,
					tmp30, tmp31, tmp32, tmp33, tmp34,
					tmp40, tmp41, tmp42, tmp43, tmp44;

#pragma HLS resource variable=tmp02 core=Mul6S
#pragma HLS resource variable=tmp12 core=Mul6S
#pragma HLS resource variable=tmp20 core=Mul6S
#pragma HLS resource variable=tmp21 core=Mul6S
#pragma HLS resource variable=tmp22 core=Mul6S
#pragma HLS resource variable=tmp23 core=Mul6S
#pragma HLS resource variable=tmp24 core=Mul6S
#pragma HLS resource variable=tmp32 core=Mul6S
#pragma HLS resource variable=tmp42 core=Mul6S
//shifts
#pragma HLS resource variable=tmp01 core=DSP48
#pragma HLS resource variable=tmp03 core=DSP48

#pragma HLS resource variable=tmp10 core=DSP48
#pragma HLS resource variable=tmp11 core=DSP48
#pragma HLS resource variable=tmp13 core=DSP48
#pragma HLS resource variable=tmp14 core=DSP48

#pragma HLS resource variable=tmp30 core=DSP48
#pragma HLS resource variable=tmp31 core=DSP48
#pragma HLS resource variable=tmp33 core=DSP48
#pragma HLS resource variable=tmp34 core=DSP48

#pragma HLS resource variable=tmp41 core=DSP48
#pragma HLS resource variable=tmp43 core=DSP48

			tmp00 = linebuf.getval(0, 0+col+px);
			tmp01 = linebuf.getval(0, 1+col+px) * 4;
			tmp02 = linebuf.getval(0, 2+col+px) * 6;
			tmp03 = linebuf.getval(0, 3+col+px) * 4;
			tmp04 = linebuf.getval(0, 4+col+px);

			tmp10 = linebuf.getval(1, 0+col+px) * 4;
			tmp11 = linebuf.getval(1, 1+col+px) * 16;
			tmp12 = linebuf.getval(1, 2+col+px) * 24;
			tmp13 = linebuf.getval(1, 3+col+px) * 16;
			tmp14 = linebuf.getval(1, 4+col+px) * 4;

			tmp20 = linebuf.getval(2, 0+col+px) * 6;
			tmp21 = linebuf.getval(2, 1+col+px) * 26;
			tmp22 = linebuf.getval(2, 2+col+px) * 36;
			tmp23 = linebuf.getval(2, 3+col+px) * 26;
			tmp24 = linebuf.getval(2, 4+col+px) * 6;

			tmp30 = linebuf.getval(3, 0+col+px) * 4;
			tmp31 = linebuf.getval(3, 1+col+px) * 16;
			tmp32 = linebuf.getval(3, 2+col+px) * 24;
			tmp33 = linebuf.getval(3, 3+col+px) * 16;
			tmp34 = linebuf.getval(3, 4+col+px) * 4;

			tmp40 = linebuf.getval(4, 0+col+px);
			tmp41 = linebuf.getval(4, 1+col+px) * 4;
			tmp42 = linebuf.getval(4, 2+col+px) * 6;
			tmp43 = linebuf.getval(4, 3+col+px) * 4;
			tmp44 = linebuf.getval(4, 4+col+px);
#pragma HLS resource variable=acc core=AddSub_DSP
			acc[px] = tmp00 + tmp01 + tmp02 + tmp03 + tmp04
					+ tmp10 + tmp11 + tmp12 + tmp13 + tmp14
					+ tmp20 + tmp21 + tmp22 + tmp13 + tmp24
					+ tmp30 + tmp31 + tmp32 + tmp13 + tmp34
					+ tmp40 + tmp41 + tmp42 + tmp13 + tmp44;

			/*for (int i = 0; i < KERN_DIM; i++) {
				for (int j = 0; j < KERN_DIM; j++) {
					uint16_t tmp;
#pragma HLS resource variable=tmp core=DSP48
					tmp = kern[i][j] * linebuf.getval(i, j+col+px);
					acc[px] += tmp;
				}
			}*/

			pixel.at[px] = acc[px] >> 8;
		}
		data_out.data = pixel.all;
		col += AXI_TDATA_NBYTES;

		if (col >= line_width)
			col = 0;

		dst << data_out;
	} while (!data_out.last);
	return 0;
}
