#include "common.h"
#include "ap_int.h"

int32_t cvloopback(axi_stream_t& src, axi_stream_t& dst, int32_t rows, int32_t cols)
{
#pragma HLS INTERFACE axis port=src bundle=INPUT_STREAM
#pragma HLS INTERFACE axis port=dst bundle=OUTPUT_STREAM
#pragma HLS INTERFACE s_axilite port=rows bundle=CONTROL_BUS offset=0x14
#pragma HLS INTERFACE s_axilite port=cols bundle=CONTROL_BUS offset=0x1C
#pragma HLS INTERFACE s_axilite port=return bundle=CONTROL_BUS offset=0x24
#pragma HLS INTERFACE ap_stable port=rows
#pragma HLS INTERFACE ap_stable port=cols
//#pragma HLS INTERFACE ap_none port=debug
	YUV_IMAGE img(rows, cols);
#pragma HLS dataflow
	hls::AXIvideo2Mat(src, img);
	hls::Mat2AXIvideo(img, dst);
	return 0;
}
