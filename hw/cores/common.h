#pragma once

#include "hls_video.h"
#include "ap_axi_sdata.h"
#include "ap_int.h"
typedef ap_axis<64, 1, 2, 2>	axi_elem_t;

uint64_t loopback(hls::stream<axi_elem_t>& src, hls::stream<axi_elem_t>& dst, ap_uint<4> *debug);
