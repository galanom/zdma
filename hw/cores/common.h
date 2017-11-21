#pragma once

#include "hls_video.h"
#include "ap_axi_sdata.h"
#include "ap_int.h"

#define MAX_LINE_WIDTH	1920

#define AXI_TDATA_NBYTES 4
typedef uint32_t axi_data_t;
typedef ap_axiu<32, 1, 1, 1>	axi_elem_t;
typedef hls::stream<axi_elem_t>	axi_stream_t;

int32_t zdma_core(axi_stream_t& src, axi_stream_t& dst, int32_t arg1/*, int32_t arg2*/);
