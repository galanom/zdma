# Retiming

create_pblock pblock_0
add_cells_to_pblock [get_pblocks pblock_0] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_0]]
resize_pblock [get_pblocks pblock_0] -add {SLICE_X32Y100:SLICE_X35Y149}
resize_pblock [get_pblocks pblock_0] -add {DSP48_X2Y40:DSP48_X2Y59}
resize_pblock [get_pblocks pblock_0] -add {RAMB18_X2Y40:RAMB18_X2Y59}
resize_pblock [get_pblocks pblock_0] -add {RAMB36_X2Y20:RAMB36_X2Y29}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_0]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_0]
create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_1]]
resize_pblock [get_pblocks pblock_1] -add {SLICE_X32Y50:SLICE_X35Y99}
resize_pblock [get_pblocks pblock_1] -add {DSP48_X2Y20:DSP48_X2Y39}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X2Y20:RAMB18_X2Y39}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X2Y10:RAMB36_X2Y19}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_1]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_1]
create_pblock pblock_2
add_cells_to_pblock [get_pblocks pblock_2] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_2]]
resize_pblock [get_pblocks pblock_2] -add {SLICE_X8Y0:SLICE_X11Y49}
resize_pblock [get_pblocks pblock_2] -add {DSP48_X0Y0:DSP48_X0Y19}
resize_pblock [get_pblocks pblock_2] -add {RAMB18_X0Y0:RAMB18_X0Y19}
resize_pblock [get_pblocks pblock_2] -add {RAMB36_X0Y0:RAMB36_X0Y9}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_2]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_2]
create_pblock pblock_3
add_cells_to_pblock [get_pblocks pblock_3] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_3]]
resize_pblock [get_pblocks pblock_3] -add {SLICE_X20Y0:SLICE_X23Y49}
resize_pblock [get_pblocks pblock_3] -add {DSP48_X1Y0:DSP48_X1Y19}
resize_pblock [get_pblocks pblock_3] -add {RAMB18_X1Y0:RAMB18_X1Y19}
resize_pblock [get_pblocks pblock_3] -add {RAMB36_X1Y0:RAMB36_X1Y9}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_3]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_3]
create_pblock pblock_4
add_cells_to_pblock [get_pblocks pblock_4] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_4]]
resize_pblock [get_pblocks pblock_4] -add {SLICE_X44Y50:SLICE_X47Y99}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_4]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_4]
create_pblock pblock_5
add_cells_to_pblock [get_pblocks pblock_5] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_5]]
resize_pblock [get_pblocks pblock_5] -add {SLICE_X44Y100:SLICE_X47Y149}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_5]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_5]
create_pblock pblock_6
add_cells_to_pblock [get_pblocks pblock_6] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_6]]
resize_pblock [get_pblocks pblock_6] -add {SLICE_X102Y100:SLICE_X105Y149}
resize_pblock [get_pblocks pblock_6] -add {DSP48_X4Y40:DSP48_X4Y59}
resize_pblock [get_pblocks pblock_6] -add {RAMB18_X5Y40:RAMB18_X5Y59}
resize_pblock [get_pblocks pblock_6] -add {RAMB36_X5Y20:RAMB36_X5Y29}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_6]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_6]
create_pblock pblock_7
add_cells_to_pblock [get_pblocks pblock_7] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_7]]
resize_pblock [get_pblocks pblock_7] -add {SLICE_X102Y50:SLICE_X105Y99}
resize_pblock [get_pblocks pblock_7] -add {DSP48_X4Y20:DSP48_X4Y39}
resize_pblock [get_pblocks pblock_7] -add {RAMB18_X5Y20:RAMB18_X5Y39}
resize_pblock [get_pblocks pblock_7] -add {RAMB36_X5Y10:RAMB36_X5Y19}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_7]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_7]

create_pblock pblock_8
add_cells_to_pblock [get_pblocks pblock_8] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_8]]
resize_pblock [get_pblocks pblock_8] -add {SLICE_X90Y100:SLICE_X93Y149}
resize_pblock [get_pblocks pblock_8] -add {DSP48_X3Y40:DSP48_X3Y59}
resize_pblock [get_pblocks pblock_8] -add {RAMB18_X4Y40:RAMB18_X4Y59}
resize_pblock [get_pblocks pblock_8] -add {RAMB36_X4Y20:RAMB36_X4Y29}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_8]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_8]

create_pblock pblock_9
add_cells_to_pblock [get_pblocks pblock_9] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_9]]
resize_pblock [get_pblocks pblock_9] -add {SLICE_X90Y50:SLICE_X93Y99}
resize_pblock [get_pblocks pblock_9] -add {DSP48_X3Y20:DSP48_X3Y39}
resize_pblock [get_pblocks pblock_9] -add {RAMB18_X4Y20:RAMB18_X4Y39}
resize_pblock [get_pblocks pblock_9] -add {RAMB36_X4Y10:RAMB36_X4Y19}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_9]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_9]

create_pblock pblock_10
add_cells_to_pblock [get_pblocks pblock_10] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_10]]
resize_pblock [get_pblocks pblock_10] -add {SLICE_X60Y50:SLICE_X63Y99}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_10]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_10]






create_pblock pblock_11
add_cells_to_pblock [get_pblocks pblock_11] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_11]]
resize_pblock [get_pblocks pblock_11] -add {SLICE_X56Y100:SLICE_X59Y149}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_11]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_11]
create_pblock pblock_12
add_cells_to_pblock [get_pblocks pblock_12] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_12]]
resize_pblock [get_pblocks pblock_12] -add {SLICE_X102Y0:SLICE_X105Y49}
resize_pblock [get_pblocks pblock_12] -add {DSP48_X4Y0:DSP48_X4Y19}
resize_pblock [get_pblocks pblock_12] -add {RAMB18_X5Y0:RAMB18_X5Y19}
resize_pblock [get_pblocks pblock_12] -add {RAMB36_X5Y0:RAMB36_X5Y9}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_12]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_12]
create_pblock pblock_13
add_cells_to_pblock [get_pblocks pblock_13] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_13]]
resize_pblock [get_pblocks pblock_13] -add {SLICE_X90Y0:SLICE_X93Y49}
resize_pblock [get_pblocks pblock_13] -add {DSP48_X3Y0:DSP48_X3Y19}
resize_pblock [get_pblocks pblock_13] -add {RAMB18_X4Y0:RAMB18_X4Y19}
resize_pblock [get_pblocks pblock_13] -add {RAMB36_X4Y0:RAMB36_X4Y9}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_13]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_13]
create_pblock pblock_14
add_cells_to_pblock [get_pblocks pblock_14] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_14]]
resize_pblock [get_pblocks pblock_14] -add {SLICE_X56Y0:SLICE_X59Y49}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_14]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_14]
create_pblock pblock_15
add_cells_to_pblock [get_pblocks pblock_15] [get_cells -quiet [list zed_asym_cc_alt_i/zcore16_15]]
resize_pblock [get_pblocks pblock_15] -add {SLICE_X44Y0:SLICE_X47Y49}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_15]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_15]

set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_0]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_1]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_2]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_3]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_4]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_5]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_6]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_7]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_8]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_9]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_10]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_11]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_12]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_13]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_14]
set_property HD.RECONFIGURABLE true [get_cells zed_asym_cc_alt_i/zcore16_15]















