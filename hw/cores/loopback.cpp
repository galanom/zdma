#include "common.h"

void loopback(AXI_STREAM& src, AXI_STREAM& dst, int rows, int cols)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=rows bundle=CONTROL_BUS offset=0x14
#pragma HLS INTERFACE s_axilite port=cols bundle=CONTROL_BUS offset=0x1C
#pragma HLS INTERFACE s_axilite port=return bundle=CONTROL_BUS
#pragma HLS INTERFACE ap_stable port=rows
#pragma HLS INTERFACE ap_stable port=cols
	YUV_IMAGE img(rows, cols);
#pragma HLS dataflow
	hls::AXIvideo2Mat(src, img);
	hls::Mat2AXIvideo(img, dst);
}
