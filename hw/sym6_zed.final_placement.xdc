
# 0.204, 0.474, 5: def/Perf Explore
create_pblock pblock_0
add_cells_to_pblock [get_pblocks pblock_0] [get_cells -quiet [list sym_pb4_i/zcore64_0]]
resize_pblock [get_pblocks pblock_0] -add {SLICE_X26Y100:SLICE_X47Y149}
resize_pblock [get_pblocks pblock_0] -add {DSP48_X2Y40:DSP48_X2Y59}
resize_pblock [get_pblocks pblock_0] -add {RAMB18_X2Y40:RAMB18_X2Y59}
resize_pblock [get_pblocks pblock_0] -add {RAMB36_X2Y20:RAMB36_X2Y29}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_0]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_0]
create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list sym_pb4_i/zcore64_1]]
resize_pblock [get_pblocks pblock_1] -add {SLICE_X90Y100:SLICE_X111Y149}
resize_pblock [get_pblocks pblock_1] -add {DSP48_X3Y40:DSP48_X4Y59}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X5Y40:RAMB18_X5Y59}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X5Y20:RAMB36_X5Y29}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_1]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_1]
create_pblock pblock_2
add_cells_to_pblock [get_pblocks pblock_2] [get_cells -quiet [list sym_pb4_i/zcore64_2]]
resize_pblock [get_pblocks pblock_2] -add {SLICE_X26Y50:SLICE_X47Y99}
resize_pblock [get_pblocks pblock_2] -add {DSP48_X2Y20:DSP48_X2Y39}
resize_pblock [get_pblocks pblock_2] -add {RAMB18_X2Y20:RAMB18_X2Y39}
resize_pblock [get_pblocks pblock_2] -add {RAMB36_X2Y10:RAMB36_X2Y19}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_2]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_2]
create_pblock pblock_3
add_cells_to_pblock [get_pblocks pblock_3] [get_cells -quiet [list sym_pb4_i/zcore64_3]]
resize_pblock [get_pblocks pblock_3] -add {SLICE_X90Y50:SLICE_X109Y99}
resize_pblock [get_pblocks pblock_3] -add {DSP48_X3Y20:DSP48_X4Y39}
resize_pblock [get_pblocks pblock_3] -add {RAMB18_X5Y20:RAMB18_X5Y39}
resize_pblock [get_pblocks pblock_3] -add {RAMB36_X5Y10:RAMB36_X5Y19}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_3]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_3]
create_pblock pblock_4
add_cells_to_pblock [get_pblocks pblock_4] [get_cells -quiet [list sym_pb4_i/zcore64_4]]
resize_pblock [get_pblocks pblock_4] -add {SLICE_X2Y0:SLICE_X23Y49}
resize_pblock [get_pblocks pblock_4] -add {DSP48_X0Y0:DSP48_X1Y19}
resize_pblock [get_pblocks pblock_4] -add {RAMB18_X0Y0:RAMB18_X1Y19}
resize_pblock [get_pblocks pblock_4] -add {RAMB36_X0Y0:RAMB36_X1Y9}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_4]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_4]
create_pblock pblock_5
add_cells_to_pblock [get_pblocks pblock_5] [get_cells -quiet [list sym_pb4_i/zcore64_5]]
resize_pblock [get_pblocks pblock_5] -add {SLICE_X90Y0:SLICE_X109Y49}
resize_pblock [get_pblocks pblock_5] -add {DSP48_X3Y0:DSP48_X4Y19}
resize_pblock [get_pblocks pblock_5] -add {RAMB18_X5Y0:RAMB18_X5Y19}
resize_pblock [get_pblocks pblock_5] -add {RAMB36_X5Y0:RAMB36_X5Y9}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_5]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_5]

set_property HD.RECONFIGURABLE true [get_cells sym_pb4_i/zcore64_0]
set_property HD.RECONFIGURABLE true [get_cells sym_pb4_i/zcore64_1]
set_property HD.RECONFIGURABLE true [get_cells sym_pb4_i/zcore64_2]
set_property HD.RECONFIGURABLE true [get_cells sym_pb4_i/zcore64_3]
set_property HD.RECONFIGURABLE true [get_cells sym_pb4_i/zcore64_4]
set_property HD.RECONFIGURABLE true [get_cells sym_pb4_i/zcore64_5]



















