#pragma once

#include "hls_video.h"
#include "ap_axi_sdata.h"
#include "ap_int.h"

#define MAX_WIDTH	1920
#define MAX_HEIGHT	1080

typedef ap_axiu<64, 1, 1, 1>	axi_elem_t;
typedef hls::stream<axi_elem_t>	axi_stream_t;

typedef hls::Scalar<2, unsigned char>				YUV_PIXEL;
typedef hls::Mat<MAX_HEIGHT, MAX_WIDTH, HLS_8UC2>	YUV_IMAGE;
typedef hls::Scalar<3, unsigned char>				RGB_PIXEL;
typedef hls::Mat<MAX_HEIGHT, MAX_WIDTH, HLS_8UC3>	RGB_IMAGE;

int32_t loopback(axi_stream_t& src, axi_stream_t& dst);
int32_t cvloopback(axi_stream_t& src, axi_stream_t& dst, int32_t rows, int32_t cols);
