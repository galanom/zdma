#pragma once
#include <hls_video.h>
#include "ap_axi_sdata.h"
#include "ap_int.h"
#include "generated.h"

#define MAX_LINE_WIDTH	1920
#define LINE_WIDTH_BITS 11

#define AXI_TDATA_NBYTES sizeof(axi_data_t)
typedef ap_axiu<sizeof(axi_data_t)*8, 1, 1, 1>	axi_elem_t;
typedef hls::stream<axi_elem_t>	axi_stream_t;

int CORE_NAME(axi_stream_t& src, axi_stream_t& dst);
int CORE_NAME(axi_stream_t& src, axi_stream_t& dst, int8_t arg1);
int CORE_NAME(axi_stream_t& src, axi_stream_t& dst, ap_uint<LINE_WIDTH_BITS> line_width);
int CORE_NAME(axi_stream_t& src, axi_stream_t& dst, int8_t arg1, int8_t arg2);
int CORE_NAME(axi_stream_t& src, axi_stream_t& dst, ap_uint<LINE_WIDTH_BITS> line_width, ap_uint<1> func);
