#pragma once

#include "hls_video.h"
#include "ap_axi_sdata.h"
#include "ap_int.h"

#define KERNEL_DIM	11
#define LINE_WIDTH	4096

typedef ap_axiu<64, 1, 1, 1>	axi_elem_t;
typedef hls::stream<axi_elem_t>	axi_stream_t;

int32_t loopback(axi_stream_t& src, axi_stream_t& dst);
int32_t blur(axi_stream_t& src, axi_stream_t& dst, int32_t line_width, int32_t kernel_dim, ap_uint<4> *debug);
