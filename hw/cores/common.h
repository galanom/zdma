#pragma once
#include <hls_video.h>
#include "ap_axi_sdata.h"
#include "ap_int.h"
#include "generated.h"

#define MAX_LINE_WIDTH	1920

//typedef uint64_t axi_data_t;

#define AXI_TDATA_NBYTES sizeof(axi_data_t)
typedef ap_axiu<sizeof(axi_data_t)*8, 1, 1, 1>	axi_elem_t;
typedef hls::stream<axi_elem_t>	axi_stream_t;

int zdma_core(axi_stream_t& src, axi_stream_t& dst);
int zdma_core(axi_stream_t& src, axi_stream_t& dst, int arg1);
int zdma_core(axi_stream_t& src, axi_stream_t& dst, int arg1, int arg2);

int zdma_core_32(axi_stream_t& src, axi_stream_t& dst);
int zdma_core_32(axi_stream_t& src, axi_stream_t& dst, int arg1);
int zdma_core_32(axi_stream_t& src, axi_stream_t& dst, int arg1, int arg2);

int zdma_core_64(axi_stream_t& src, axi_stream_t& dst);
int zdma_core_64(axi_stream_t& src, axi_stream_t& dst, int arg1);
int zdma_core_64(axi_stream_t& src, axi_stream_t& dst, int arg1, int arg2);

int zdma_core_tiny(axi_stream_t& src, axi_stream_t& dst);
int zdma_core_tiny(axi_stream_t& src, axi_stream_t& dst, int arg1);
int zdma_core_tiny(axi_stream_t& src, axi_stream_t& dst, int arg1, int arg2);
