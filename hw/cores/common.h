#pragma once

#include "hls_video.h"
#include "ap_axi_sdata.h"
#include "ap_int.h"

#define GAUSS_KERN_DIM	5
#define MAX_KERNEL_DIM	11
#define MAX_LINE_WIDTH	1920

#define AXI_TDATA_NBYTES 8
#define AXI_TDATA_SHIFT 3
typedef uint64_t axi_data_t;
typedef ap_axiu<64, 1, 1, 1>	axi_elem_t;
typedef hls::stream<axi_elem_t>	axi_stream_t;

int32_t loopback(axi_stream_t& src, axi_stream_t& dst, ap_uint<4> *debug);
int32_t blur(axi_stream_t& src, axi_stream_t& dst, int32_t line_width, int32_t kernel_dim, ap_uint<4> *debug);
int32_t gauss(axi_stream_t& src, axi_stream_t& dst, int32_t line_width, ap_uint<4> *debug);
int32_t edge_detect(axi_stream_t& src, axi_stream_t& dst, int32_t line_width, ap_uint<4> *debug);
