#pragma once

#include "hls_video.h"
#include "ap_axi_sdata.h"

#define MAX_WIDTH	1920
#define MAX_HEIGHT	1080

typedef ap_axiu<64, 1, 1, 1>	AXI_PIXEL;
typedef hls::stream<AXI_PIXEL>	AXI_STREAM;

typedef hls::Scalar<2, unsigned char>			YUV_PIXEL;
typedef hls::Mat<MAX_HEIGHT, MAX_WIDTH, HLS_8UC2>	YUV_IMAGE;
typedef hls::Scalar<3, unsigned char>			RGB_PIXEL;
typedef hls::Mat<MAX_HEIGHT, MAX_WIDTH, HLS_8UC3>	RGB_IMAGE;

void loopback(AXI_STREAM& src, AXI_STREAM& dst, int rows, int cols);
