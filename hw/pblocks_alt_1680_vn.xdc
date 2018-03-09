set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_0]
create_pblock pblock_0
add_cells_to_pblock [get_pblocks pblock_0] [get_cells -quiet [list sym_i/zcore32_0]]
resize_pblock [get_pblocks pblock_0] -add {SLICE_X1Y385:SLICE_X6Y419}
resize_pblock [get_pblocks pblock_0] -add {DSP48E2_X0Y154:DSP48E2_X0Y167}
resize_pblock [get_pblocks pblock_0] -add {RAMB18_X0Y154:RAMB18_X0Y167}
resize_pblock [get_pblocks pblock_0] -add {RAMB36_X0Y77:RAMB36_X0Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_0]

create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list sym_i/zcore32_1]]
resize_pblock [get_pblocks pblock_1] -add {SLICE_X13Y385:SLICE_X18Y419}
resize_pblock [get_pblocks pblock_1] -add {DSP48E2_X2Y154:DSP48E2_X2Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X2Y154:RAMB18_X2Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X2Y77:RAMB36_X2Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_1]

create_pblock pblock_2
add_cells_to_pblock [get_pblocks pblock_2] [get_cells -quiet [list sym_i/zcore32_2]]
resize_pblock [get_pblocks pblock_2] -add {SLICE_X22Y385:SLICE_X27Y419}
resize_pblock [get_pblocks pblock_2] -add {DSP48E2_X4Y154:DSP48E2_X4Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB18_X3Y154:RAMB18_X3Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB36_X3Y77:RAMB36_X3Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_2]

create_pblock pblock_3
add_cells_to_pblock [get_pblocks pblock_3] [get_cells -quiet [list sym_i/zcore32_3]]
resize_pblock [get_pblocks pblock_3] -add {SLICE_X29Y385:SLICE_X34Y419}
resize_pblock [get_pblocks pblock_3] -add {DSP48E2_X6Y154:DSP48E2_X6Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB18_X4Y154:RAMB18_X4Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB36_X4Y77:RAMB36_X4Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_3]

create_pblock pblock_4
add_cells_to_pblock [get_pblocks pblock_4] [get_cells -quiet [list sym_i/zcore32_4]]
resize_pblock [get_pblocks pblock_4] -add {SLICE_X37Y385:SLICE_X42Y419}
resize_pblock [get_pblocks pblock_4] -add {DSP48E2_X7Y154:DSP48E2_X7Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB18_X5Y154:RAMB18_X5Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB36_X5Y77:RAMB36_X5Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_4]

create_pblock pblock_5
add_cells_to_pblock [get_pblocks pblock_5] [get_cells -quiet [list sym_i/zcore32_5]]
resize_pblock [get_pblocks pblock_5] -add {SLICE_X46Y385:SLICE_X51Y419}
resize_pblock [get_pblocks pblock_5] -add {DSP48E2_X9Y154:DSP48E2_X9Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB18_X6Y154:RAMB18_X6Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB36_X6Y77:RAMB36_X6Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_5]

create_pblock pblock_6
add_cells_to_pblock [get_pblocks pblock_6] [get_cells -quiet [list sym_i/zcore32_6]]
resize_pblock [get_pblocks pblock_6] -add {SLICE_X55Y385:SLICE_X60Y419}
resize_pblock [get_pblocks pblock_6] -add {DSP48E2_X11Y154:DSP48E2_X11Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB18_X7Y154:RAMB18_X7Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB36_X7Y77:RAMB36_X7Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_6]

create_pblock pblock_7
add_cells_to_pblock [get_pblocks pblock_7] [get_cells -quiet [list sym_i/zcore32_7]]
resize_pblock [get_pblocks pblock_7] -add {SLICE_X62Y385:SLICE_X67Y419}
resize_pblock [get_pblocks pblock_7] -add {DSP48E2_X13Y154:DSP48E2_X13Y167}
resize_pblock [get_pblocks pblock_7] -add {RAMB18_X8Y154:RAMB18_X8Y167}
resize_pblock [get_pblocks pblock_7] -add {RAMB36_X8Y77:RAMB36_X8Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_7]

create_pblock pblock_8
add_cells_to_pblock [get_pblocks pblock_8] [get_cells -quiet [list sym_i/zcore32_8]]
resize_pblock [get_pblocks pblock_8] -add {SLICE_X70Y385:SLICE_X75Y419}
resize_pblock [get_pblocks pblock_8] -add {DSP48E2_X14Y154:DSP48E2_X14Y167}
resize_pblock [get_pblocks pblock_8] -add {RAMB18_X9Y154:RAMB18_X9Y167}
resize_pblock [get_pblocks pblock_8] -add {RAMB36_X9Y77:RAMB36_X9Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_8]


create_pblock pblock_9
add_cells_to_pblock [get_pblocks pblock_9] [get_cells -quiet [list sym_i/zcore32_9]]
resize_pblock [get_pblocks pblock_9] -add {SLICE_X82Y375:SLICE_X87Y419}
resize_pblock [get_pblocks pblock_9] -add {DSP48E2_X16Y150:DSP48E2_X16Y167}
resize_pblock [get_pblocks pblock_9] -add {RAMB18_X11Y150:RAMB18_X11Y167}
resize_pblock [get_pblocks pblock_9] -add {RAMB36_X11Y75:RAMB36_X11Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_9]

create_pblock pblock_10
add_cells_to_pblock [get_pblocks pblock_10] [get_cells -quiet [list sym_i/zcore32_10]]
resize_pblock [get_pblocks pblock_10] -add {SLICE_X90Y385:SLICE_X95Y419}
resize_pblock [get_pblocks pblock_10] -add {DSP48E2_X17Y154:DSP48E2_X17Y167}
resize_pblock [get_pblocks pblock_10] -add {RAMB18_X12Y154:RAMB18_X12Y167}
resize_pblock [get_pblocks pblock_10] -add {RAMB36_X12Y77:RAMB36_X12Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_10]

create_pblock pblock_11
add_cells_to_pblock [get_pblocks pblock_11] [get_cells -quiet [list sym_i/zcore32_11]]
resize_pblock [get_pblocks pblock_11] -add {SLICE_X90Y325:SLICE_X95Y359}
resize_pblock [get_pblocks pblock_11] -add {DSP48E2_X17Y130:DSP48E2_X17Y143}
resize_pblock [get_pblocks pblock_11] -add {RAMB18_X12Y130:RAMB18_X12Y143}
resize_pblock [get_pblocks pblock_11] -add {RAMB36_X12Y65:RAMB36_X12Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_11]


set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_1]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_2]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_3]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_4]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_5]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_6]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_7]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_8]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_9]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_10]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_11]

create_pblock pblock_12
add_cells_to_pblock [get_pblocks pblock_12] [get_cells -quiet [list sym_i/zcore32_12]]
resize_pblock [get_pblocks pblock_12] -add {SLICE_X82Y315:SLICE_X87Y359}
resize_pblock [get_pblocks pblock_12] -add {DSP48E2_X16Y126:DSP48E2_X16Y143}
resize_pblock [get_pblocks pblock_12] -add {RAMB18_X11Y126:RAMB18_X11Y143}
resize_pblock [get_pblocks pblock_12] -add {RAMB36_X11Y63:RAMB36_X11Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_12]

create_pblock pblock_13
add_cells_to_pblock [get_pblocks pblock_13] [get_cells -quiet [list sym_i/zcore32_13]]
resize_pblock [get_pblocks pblock_13] -add {SLICE_X70Y325:SLICE_X75Y359}
resize_pblock [get_pblocks pblock_13] -add {DSP48E2_X14Y130:DSP48E2_X14Y143}
resize_pblock [get_pblocks pblock_13] -add {RAMB18_X9Y130:RAMB18_X9Y143}
resize_pblock [get_pblocks pblock_13] -add {RAMB36_X9Y65:RAMB36_X9Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_13]

create_pblock pblock_14
add_cells_to_pblock [get_pblocks pblock_14] [get_cells -quiet [list sym_i/zcore32_14]]
resize_pblock [get_pblocks pblock_14] -add {SLICE_X62Y325:SLICE_X67Y359}
resize_pblock [get_pblocks pblock_14] -add {DSP48E2_X13Y130:DSP48E2_X13Y143}
resize_pblock [get_pblocks pblock_14] -add {RAMB18_X8Y130:RAMB18_X8Y143}
resize_pblock [get_pblocks pblock_14] -add {RAMB36_X8Y65:RAMB36_X8Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_14]

create_pblock pblock_15
add_cells_to_pblock [get_pblocks pblock_15] [get_cells -quiet [list sym_i/zcore32_15]]
resize_pblock [get_pblocks pblock_15] -add {SLICE_X55Y325:SLICE_X60Y359}
resize_pblock [get_pblocks pblock_15] -add {DSP48E2_X11Y130:DSP48E2_X11Y143}
resize_pblock [get_pblocks pblock_15] -add {RAMB18_X7Y130:RAMB18_X7Y143}
resize_pblock [get_pblocks pblock_15] -add {RAMB36_X7Y65:RAMB36_X7Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_15]

create_pblock pblock_16
add_cells_to_pblock [get_pblocks pblock_16] [get_cells -quiet [list sym_i/zcore32_16]]
resize_pblock [get_pblocks pblock_16] -add {SLICE_X46Y325:SLICE_X51Y359}
resize_pblock [get_pblocks pblock_16] -add {DSP48E2_X9Y130:DSP48E2_X9Y143}
resize_pblock [get_pblocks pblock_16] -add {RAMB18_X6Y130:RAMB18_X6Y143}
resize_pblock [get_pblocks pblock_16] -add {RAMB36_X6Y65:RAMB36_X6Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_16]

create_pblock pblock_17
add_cells_to_pblock [get_pblocks pblock_17] [get_cells -quiet [list sym_i/zcore32_17]]
resize_pblock [get_pblocks pblock_17] -add {SLICE_X37Y325:SLICE_X42Y359}
resize_pblock [get_pblocks pblock_17] -add {DSP48E2_X7Y130:DSP48E2_X7Y143}
resize_pblock [get_pblocks pblock_17] -add {RAMB18_X5Y130:RAMB18_X5Y143}
resize_pblock [get_pblocks pblock_17] -add {RAMB36_X5Y65:RAMB36_X5Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_17]

create_pblock pblock_18
add_cells_to_pblock [get_pblocks pblock_18] [get_cells -quiet [list sym_i/zcore32_18]]
resize_pblock [get_pblocks pblock_18] -add {SLICE_X29Y325:SLICE_X34Y359}
resize_pblock [get_pblocks pblock_18] -add {DSP48E2_X6Y130:DSP48E2_X6Y143}
resize_pblock [get_pblocks pblock_18] -add {RAMB18_X4Y130:RAMB18_X4Y143}
resize_pblock [get_pblocks pblock_18] -add {RAMB36_X4Y65:RAMB36_X4Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_18]

create_pblock pblock_19
add_cells_to_pblock [get_pblocks pblock_19] [get_cells -quiet [list sym_i/zcore32_19]]
resize_pblock [get_pblocks pblock_19] -add {SLICE_X22Y325:SLICE_X27Y359}
resize_pblock [get_pblocks pblock_19] -add {DSP48E2_X4Y130:DSP48E2_X4Y143}
resize_pblock [get_pblocks pblock_19] -add {RAMB18_X3Y130:RAMB18_X3Y143}
resize_pblock [get_pblocks pblock_19] -add {RAMB36_X3Y65:RAMB36_X3Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_19]

create_pblock pblock_20
add_cells_to_pblock [get_pblocks pblock_20] [get_cells -quiet [list sym_i/zcore32_20]]
resize_pblock [get_pblocks pblock_20] -add {SLICE_X13Y325:SLICE_X18Y359}
resize_pblock [get_pblocks pblock_20] -add {DSP48E2_X2Y130:DSP48E2_X2Y143}
resize_pblock [get_pblocks pblock_20] -add {RAMB18_X2Y130:RAMB18_X2Y143}
resize_pblock [get_pblocks pblock_20] -add {RAMB36_X2Y65:RAMB36_X2Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_20]

create_pblock pblock_21
add_cells_to_pblock [get_pblocks pblock_21] [get_cells -quiet [list sym_i/zcore32_21]]
resize_pblock [get_pblocks pblock_21] -add {SLICE_X1Y325:SLICE_X6Y359}
resize_pblock [get_pblocks pblock_21] -add {DSP48E2_X0Y130:DSP48E2_X0Y143}
resize_pblock [get_pblocks pblock_21] -add {RAMB18_X0Y130:RAMB18_X0Y143}
resize_pblock [get_pblocks pblock_21] -add {RAMB36_X0Y65:RAMB36_X0Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_21]

create_pblock pblock_22
add_cells_to_pblock [get_pblocks pblock_22] [get_cells -quiet [list sym_i/zcore32_22]]
resize_pblock [get_pblocks pblock_22] -add {SLICE_X1Y265:SLICE_X6Y299}
resize_pblock [get_pblocks pblock_22] -add {DSP48E2_X0Y106:DSP48E2_X0Y119}
resize_pblock [get_pblocks pblock_22] -add {RAMB18_X0Y106:RAMB18_X0Y119}
resize_pblock [get_pblocks pblock_22] -add {RAMB36_X0Y53:RAMB36_X0Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_22]

create_pblock pblock_23
add_cells_to_pblock [get_pblocks pblock_23] [get_cells -quiet [list sym_i/zcore32_23]]
resize_pblock [get_pblocks pblock_23] -add {SLICE_X13Y265:SLICE_X18Y299}
resize_pblock [get_pblocks pblock_23] -add {DSP48E2_X2Y106:DSP48E2_X2Y119}
resize_pblock [get_pblocks pblock_23] -add {RAMB18_X2Y106:RAMB18_X2Y119}
resize_pblock [get_pblocks pblock_23] -add {RAMB36_X2Y53:RAMB36_X2Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_23]

create_pblock pblock_24
add_cells_to_pblock [get_pblocks pblock_24] [get_cells -quiet [list sym_i/zcore32_24]]
resize_pblock [get_pblocks pblock_24] -add {SLICE_X22Y265:SLICE_X27Y299}
resize_pblock [get_pblocks pblock_24] -add {DSP48E2_X4Y106:DSP48E2_X4Y119}
resize_pblock [get_pblocks pblock_24] -add {RAMB18_X3Y106:RAMB18_X3Y119}
resize_pblock [get_pblocks pblock_24] -add {RAMB36_X3Y53:RAMB36_X3Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_24]

create_pblock pblock_25
add_cells_to_pblock [get_pblocks pblock_25] [get_cells -quiet [list sym_i/zcore32_25]]
resize_pblock [get_pblocks pblock_25] -add {SLICE_X29Y265:SLICE_X34Y299}
resize_pblock [get_pblocks pblock_25] -add {DSP48E2_X6Y106:DSP48E2_X6Y119}
resize_pblock [get_pblocks pblock_25] -add {RAMB18_X4Y106:RAMB18_X4Y119}
resize_pblock [get_pblocks pblock_25] -add {RAMB36_X4Y53:RAMB36_X4Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_25]

create_pblock pblock_26
add_cells_to_pblock [get_pblocks pblock_26] [get_cells -quiet [list sym_i/zcore32_26]]
resize_pblock [get_pblocks pblock_26] -add {SLICE_X37Y265:SLICE_X42Y299}
resize_pblock [get_pblocks pblock_26] -add {DSP48E2_X7Y106:DSP48E2_X7Y119}
resize_pblock [get_pblocks pblock_26] -add {RAMB18_X5Y106:RAMB18_X5Y119}
resize_pblock [get_pblocks pblock_26] -add {RAMB36_X5Y53:RAMB36_X5Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_26]

create_pblock pblock_27
add_cells_to_pblock [get_pblocks pblock_27] [get_cells -quiet [list sym_i/zcore32_27]]
resize_pblock [get_pblocks pblock_27] -add {SLICE_X46Y265:SLICE_X51Y299}
resize_pblock [get_pblocks pblock_27] -add {DSP48E2_X9Y106:DSP48E2_X9Y119}
resize_pblock [get_pblocks pblock_27] -add {RAMB18_X6Y106:RAMB18_X6Y119}
resize_pblock [get_pblocks pblock_27] -add {RAMB36_X6Y53:RAMB36_X6Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_27]

create_pblock pblock_28
add_cells_to_pblock [get_pblocks pblock_28] [get_cells -quiet [list sym_i/zcore32_28]]
resize_pblock [get_pblocks pblock_28] -add {SLICE_X55Y265:SLICE_X60Y299}
resize_pblock [get_pblocks pblock_28] -add {DSP48E2_X11Y106:DSP48E2_X11Y119}
resize_pblock [get_pblocks pblock_28] -add {RAMB18_X7Y106:RAMB18_X7Y119}
resize_pblock [get_pblocks pblock_28] -add {RAMB36_X7Y53:RAMB36_X7Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_28]

create_pblock pblock_29
add_cells_to_pblock [get_pblocks pblock_29] [get_cells -quiet [list sym_i/zcore32_29]]
resize_pblock [get_pblocks pblock_29] -add {SLICE_X62Y265:SLICE_X67Y299}
resize_pblock [get_pblocks pblock_29] -add {DSP48E2_X13Y106:DSP48E2_X13Y119}
resize_pblock [get_pblocks pblock_29] -add {RAMB18_X8Y106:RAMB18_X8Y119}
resize_pblock [get_pblocks pblock_29] -add {RAMB36_X8Y53:RAMB36_X8Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_29]

create_pblock pblock_30
add_cells_to_pblock [get_pblocks pblock_30] [get_cells -quiet [list sym_i/zcore32_30]]
resize_pblock [get_pblocks pblock_30] -add {SLICE_X70Y265:SLICE_X75Y299}
resize_pblock [get_pblocks pblock_30] -add {DSP48E2_X14Y106:DSP48E2_X14Y119}
resize_pblock [get_pblocks pblock_30] -add {RAMB18_X9Y106:RAMB18_X9Y119}
resize_pblock [get_pblocks pblock_30] -add {RAMB36_X9Y53:RAMB36_X9Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_30]

create_pblock pblock_31
add_cells_to_pblock [get_pblocks pblock_31] [get_cells -quiet [list sym_i/zcore32_31]]
resize_pblock [get_pblocks pblock_31] -add {SLICE_X82Y255:SLICE_X87Y299}
resize_pblock [get_pblocks pblock_31] -add {DSP48E2_X16Y102:DSP48E2_X16Y119}
resize_pblock [get_pblocks pblock_31] -add {RAMB18_X11Y102:RAMB18_X11Y119}
resize_pblock [get_pblocks pblock_31] -add {RAMB36_X11Y51:RAMB36_X11Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_31]

create_pblock pblock_32
add_cells_to_pblock [get_pblocks pblock_32] [get_cells -quiet [list sym_i/zcore32_32]]
resize_pblock [get_pblocks pblock_32] -add {SLICE_X90Y265:SLICE_X95Y299}
resize_pblock [get_pblocks pblock_32] -add {DSP48E2_X17Y106:DSP48E2_X17Y119}
resize_pblock [get_pblocks pblock_32] -add {RAMB18_X12Y106:RAMB18_X12Y119}
resize_pblock [get_pblocks pblock_32] -add {RAMB36_X12Y53:RAMB36_X12Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_32]

create_pblock pblock_33
add_cells_to_pblock [get_pblocks pblock_33] [get_cells -quiet [list sym_i/zcore32_33]]
resize_pblock [get_pblocks pblock_33] -add {SLICE_X90Y205:SLICE_X95Y239}
resize_pblock [get_pblocks pblock_33] -add {DSP48E2_X17Y82:DSP48E2_X17Y95}
resize_pblock [get_pblocks pblock_33] -add {RAMB18_X12Y82:RAMB18_X12Y95}
resize_pblock [get_pblocks pblock_33] -add {RAMB36_X12Y41:RAMB36_X12Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_33]

create_pblock pblock_34
add_cells_to_pblock [get_pblocks pblock_34] [get_cells -quiet [list sym_i/zcore32_34]]
resize_pblock [get_pblocks pblock_34] -add {SLICE_X82Y195:SLICE_X87Y239}
resize_pblock [get_pblocks pblock_34] -add {DSP48E2_X16Y78:DSP48E2_X16Y95}
resize_pblock [get_pblocks pblock_34] -add {RAMB18_X11Y78:RAMB18_X11Y95}
resize_pblock [get_pblocks pblock_34] -add {RAMB36_X11Y39:RAMB36_X11Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_34]

create_pblock pblock_35
add_cells_to_pblock [get_pblocks pblock_35] [get_cells -quiet [list sym_i/zcore32_35]]
resize_pblock [get_pblocks pblock_35] -add {SLICE_X70Y205:SLICE_X75Y239}
resize_pblock [get_pblocks pblock_35] -add {DSP48E2_X14Y82:DSP48E2_X14Y95}
resize_pblock [get_pblocks pblock_35] -add {RAMB18_X9Y82:RAMB18_X9Y95}
resize_pblock [get_pblocks pblock_35] -add {RAMB36_X9Y41:RAMB36_X9Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_35]

create_pblock pblock_36
add_cells_to_pblock [get_pblocks pblock_36] [get_cells -quiet [list sym_i/zcore32_36]]
resize_pblock [get_pblocks pblock_36] -add {SLICE_X62Y205:SLICE_X67Y239}
resize_pblock [get_pblocks pblock_36] -add {DSP48E2_X13Y82:DSP48E2_X13Y95}
resize_pblock [get_pblocks pblock_36] -add {RAMB18_X8Y82:RAMB18_X8Y95}
resize_pblock [get_pblocks pblock_36] -add {RAMB36_X8Y41:RAMB36_X8Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_36]

create_pblock pblock_37
add_cells_to_pblock [get_pblocks pblock_37] [get_cells -quiet [list sym_i/zcore32_37]]
resize_pblock [get_pblocks pblock_37] -add {SLICE_X55Y205:SLICE_X60Y239}
resize_pblock [get_pblocks pblock_37] -add {DSP48E2_X11Y82:DSP48E2_X11Y95}
resize_pblock [get_pblocks pblock_37] -add {RAMB18_X7Y82:RAMB18_X7Y95}
resize_pblock [get_pblocks pblock_37] -add {RAMB36_X7Y41:RAMB36_X7Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_37]

create_pblock pblock_38
add_cells_to_pblock [get_pblocks pblock_38] [get_cells -quiet [list sym_i/zcore32_38]]
resize_pblock [get_pblocks pblock_38] -add {SLICE_X46Y205:SLICE_X51Y239}
resize_pblock [get_pblocks pblock_38] -add {DSP48E2_X9Y82:DSP48E2_X9Y95}
resize_pblock [get_pblocks pblock_38] -add {RAMB18_X6Y82:RAMB18_X6Y95}
resize_pblock [get_pblocks pblock_38] -add {RAMB36_X6Y41:RAMB36_X6Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_38]

create_pblock pblock_39
add_cells_to_pblock [get_pblocks pblock_39] [get_cells -quiet [list sym_i/zcore32_39]]
resize_pblock [get_pblocks pblock_39] -add {SLICE_X37Y205:SLICE_X42Y239}
resize_pblock [get_pblocks pblock_39] -add {DSP48E2_X7Y82:DSP48E2_X7Y95}
resize_pblock [get_pblocks pblock_39] -add {RAMB18_X5Y82:RAMB18_X5Y95}
resize_pblock [get_pblocks pblock_39] -add {RAMB36_X5Y41:RAMB36_X5Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_39]

create_pblock pblock_40
add_cells_to_pblock [get_pblocks pblock_40] [get_cells -quiet [list sym_i/zcore32_40]]
resize_pblock [get_pblocks pblock_40] -add {SLICE_X29Y205:SLICE_X34Y239}
resize_pblock [get_pblocks pblock_40] -add {DSP48E2_X6Y82:DSP48E2_X6Y95}
resize_pblock [get_pblocks pblock_40] -add {RAMB18_X4Y82:RAMB18_X4Y95}
resize_pblock [get_pblocks pblock_40] -add {RAMB36_X4Y41:RAMB36_X4Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_40]

create_pblock pblock_41
add_cells_to_pblock [get_pblocks pblock_41] [get_cells -quiet [list sym_i/zcore32_41]]
resize_pblock [get_pblocks pblock_41] -add {SLICE_X22Y205:SLICE_X27Y239}
resize_pblock [get_pblocks pblock_41] -add {DSP48E2_X4Y82:DSP48E2_X4Y95}
resize_pblock [get_pblocks pblock_41] -add {RAMB18_X3Y82:RAMB18_X3Y95}
resize_pblock [get_pblocks pblock_41] -add {RAMB36_X3Y41:RAMB36_X3Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_41]

create_pblock pblock_42
add_cells_to_pblock [get_pblocks pblock_42] [get_cells -quiet [list sym_i/zcore32_42]]
resize_pblock [get_pblocks pblock_42] -add {SLICE_X13Y205:SLICE_X18Y239}
resize_pblock [get_pblocks pblock_42] -add {DSP48E2_X2Y82:DSP48E2_X2Y95}
resize_pblock [get_pblocks pblock_42] -add {RAMB18_X2Y82:RAMB18_X2Y95}
resize_pblock [get_pblocks pblock_42] -add {RAMB36_X2Y41:RAMB36_X2Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_42]

create_pblock pblock_43
add_cells_to_pblock [get_pblocks pblock_43] [get_cells -quiet [list sym_i/zcore32_43]]
resize_pblock [get_pblocks pblock_43] -add {SLICE_X1Y205:SLICE_X6Y239}
resize_pblock [get_pblocks pblock_43] -add {DSP48E2_X0Y82:DSP48E2_X0Y95}
resize_pblock [get_pblocks pblock_43] -add {RAMB18_X0Y82:RAMB18_X0Y95}
resize_pblock [get_pblocks pblock_43] -add {RAMB36_X0Y41:RAMB36_X0Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_43]

create_pblock pblock_44
add_cells_to_pblock [get_pblocks pblock_44] [get_cells -quiet [list sym_i/zcore32_44]]
resize_pblock [get_pblocks pblock_44] -add {SLICE_X37Y120:SLICE_X42Y154}
resize_pblock [get_pblocks pblock_44] -add {DSP48E2_X7Y48:DSP48E2_X7Y61}
resize_pblock [get_pblocks pblock_44] -add {RAMB18_X5Y48:RAMB18_X5Y61}
resize_pblock [get_pblocks pblock_44] -add {RAMB36_X5Y24:RAMB36_X5Y30}
set_property SNAPPING_MODE ON [get_pblocks pblock_44]

create_pblock pblock_45
add_cells_to_pblock [get_pblocks pblock_45] [get_cells -quiet [list sym_i/zcore32_45]]
resize_pblock [get_pblocks pblock_45] -add {SLICE_X46Y120:SLICE_X51Y154}
resize_pblock [get_pblocks pblock_45] -add {DSP48E2_X9Y48:DSP48E2_X9Y61}
resize_pblock [get_pblocks pblock_45] -add {RAMB18_X6Y48:RAMB18_X6Y61}
resize_pblock [get_pblocks pblock_45] -add {RAMB36_X6Y24:RAMB36_X6Y30}
set_property SNAPPING_MODE ON [get_pblocks pblock_45]

create_pblock pblock_46
add_cells_to_pblock [get_pblocks pblock_46] [get_cells -quiet [list sym_i/zcore32_46]]
resize_pblock [get_pblocks pblock_46] -add {SLICE_X62Y120:SLICE_X67Y154}
resize_pblock [get_pblocks pblock_46] -add {DSP48E2_X13Y48:DSP48E2_X13Y61}
resize_pblock [get_pblocks pblock_46] -add {RAMB18_X8Y48:RAMB18_X8Y61}
resize_pblock [get_pblocks pblock_46] -add {RAMB36_X8Y24:RAMB36_X8Y30}
set_property SNAPPING_MODE ON [get_pblocks pblock_46]

create_pblock pblock_47
add_cells_to_pblock [get_pblocks pblock_47] [get_cells -quiet [list sym_i/zcore32_47]]
resize_pblock [get_pblocks pblock_47] -add {SLICE_X70Y120:SLICE_X75Y154}
resize_pblock [get_pblocks pblock_47] -add {DSP48E2_X14Y48:DSP48E2_X14Y61}
resize_pblock [get_pblocks pblock_47] -add {RAMB18_X9Y48:RAMB18_X9Y61}
resize_pblock [get_pblocks pblock_47] -add {RAMB36_X9Y24:RAMB36_X9Y30}
set_property SNAPPING_MODE ON [get_pblocks pblock_47]











create_pblock pblock_48
add_cells_to_pblock [get_pblocks pblock_48] [get_cells -quiet [list sym_i/zcore32_48]]
resize_pblock [get_pblocks pblock_48] -add {SLICE_X82Y120:SLICE_X87Y164}
resize_pblock [get_pblocks pblock_48] -add {DSP48E2_X16Y48:DSP48E2_X16Y65}
resize_pblock [get_pblocks pblock_48] -add {RAMB18_X11Y48:RAMB18_X11Y65}
resize_pblock [get_pblocks pblock_48] -add {RAMB36_X11Y24:RAMB36_X11Y32}
set_property SNAPPING_MODE ON [get_pblocks pblock_48]
create_pblock pblock_50
add_cells_to_pblock [get_pblocks pblock_50] [get_cells -quiet [list sym_i/zcore32_50]]
resize_pblock [get_pblocks pblock_50] -add {SLICE_X90Y60:SLICE_X95Y94}
resize_pblock [get_pblocks pblock_50] -add {DSP48E2_X17Y24:DSP48E2_X17Y37}
resize_pblock [get_pblocks pblock_50] -add {RAMB18_X12Y24:RAMB18_X12Y37}
resize_pblock [get_pblocks pblock_50] -add {RAMB36_X12Y12:RAMB36_X12Y18}
set_property SNAPPING_MODE ON [get_pblocks pblock_50]
create_pblock pblock_51
add_cells_to_pblock [get_pblocks pblock_51] [get_cells -quiet [list sym_i/zcore32_51]]
resize_pblock [get_pblocks pblock_51] -add {SLICE_X82Y60:SLICE_X87Y104}
resize_pblock [get_pblocks pblock_51] -add {DSP48E2_X16Y24:DSP48E2_X16Y41}
resize_pblock [get_pblocks pblock_51] -add {RAMB18_X11Y24:RAMB18_X11Y41}
resize_pblock [get_pblocks pblock_51] -add {RAMB36_X11Y12:RAMB36_X11Y20}
set_property SNAPPING_MODE ON [get_pblocks pblock_51]
create_pblock pblock_49
add_cells_to_pblock [get_pblocks pblock_49] [get_cells -quiet [list sym_i/zcore32_49]]
resize_pblock [get_pblocks pblock_49] -add {SLICE_X90Y120:SLICE_X95Y154}
resize_pblock [get_pblocks pblock_49] -add {DSP48E2_X17Y48:DSP48E2_X17Y61}
resize_pblock [get_pblocks pblock_49] -add {RAMB18_X12Y48:RAMB18_X12Y61}
resize_pblock [get_pblocks pblock_49] -add {RAMB36_X12Y24:RAMB36_X12Y30}
set_property SNAPPING_MODE ON [get_pblocks pblock_49]
create_pblock pblock_52
add_cells_to_pblock [get_pblocks pblock_52] [get_cells -quiet [list sym_i/zcore32_52]]
resize_pblock [get_pblocks pblock_52] -add {SLICE_X70Y60:SLICE_X75Y94}
resize_pblock [get_pblocks pblock_52] -add {DSP48E2_X14Y24:DSP48E2_X14Y37}
resize_pblock [get_pblocks pblock_52] -add {RAMB18_X9Y24:RAMB18_X9Y37}
resize_pblock [get_pblocks pblock_52] -add {RAMB36_X9Y12:RAMB36_X9Y18}
set_property SNAPPING_MODE ON [get_pblocks pblock_52]
create_pblock pblock_53
add_cells_to_pblock [get_pblocks pblock_53] [get_cells -quiet [list sym_i/zcore32_53]]
resize_pblock [get_pblocks pblock_53] -add {SLICE_X62Y60:SLICE_X67Y94}
resize_pblock [get_pblocks pblock_53] -add {DSP48E2_X13Y24:DSP48E2_X13Y37}
resize_pblock [get_pblocks pblock_53] -add {RAMB18_X8Y24:RAMB18_X8Y37}
resize_pblock [get_pblocks pblock_53] -add {RAMB36_X8Y12:RAMB36_X8Y18}
set_property SNAPPING_MODE ON [get_pblocks pblock_53]
create_pblock pblock_54
add_cells_to_pblock [get_pblocks pblock_54] [get_cells -quiet [list sym_i/zcore32_54]]
resize_pblock [get_pblocks pblock_54] -add {SLICE_X46Y60:SLICE_X51Y94}
resize_pblock [get_pblocks pblock_54] -add {DSP48E2_X9Y24:DSP48E2_X9Y37}
resize_pblock [get_pblocks pblock_54] -add {RAMB18_X6Y24:RAMB18_X6Y37}
resize_pblock [get_pblocks pblock_54] -add {RAMB36_X6Y12:RAMB36_X6Y18}
set_property SNAPPING_MODE ON [get_pblocks pblock_54]
create_pblock pblock_55
add_cells_to_pblock [get_pblocks pblock_55] [get_cells -quiet [list sym_i/zcore32_55]]
resize_pblock [get_pblocks pblock_55] -add {SLICE_X37Y60:SLICE_X42Y94}
resize_pblock [get_pblocks pblock_55] -add {DSP48E2_X7Y24:DSP48E2_X7Y37}
resize_pblock [get_pblocks pblock_55] -add {RAMB18_X5Y24:RAMB18_X5Y37}
resize_pblock [get_pblocks pblock_55] -add {RAMB36_X5Y12:RAMB36_X5Y18}
set_property SNAPPING_MODE ON [get_pblocks pblock_55]
create_pblock pblock_56
add_cells_to_pblock [get_pblocks pblock_56] [get_cells -quiet [list sym_i/zcore32_56]]
resize_pblock [get_pblocks pblock_56] -add {SLICE_X37Y0:SLICE_X42Y34}
resize_pblock [get_pblocks pblock_56] -add {DSP48E2_X7Y0:DSP48E2_X7Y13}
resize_pblock [get_pblocks pblock_56] -add {RAMB18_X5Y0:RAMB18_X5Y13}
resize_pblock [get_pblocks pblock_56] -add {RAMB36_X5Y0:RAMB36_X5Y6}
set_property SNAPPING_MODE ON [get_pblocks pblock_56]
create_pblock pblock_57
add_cells_to_pblock [get_pblocks pblock_57] [get_cells -quiet [list sym_i/zcore32_57]]
resize_pblock [get_pblocks pblock_57] -add {SLICE_X46Y0:SLICE_X51Y34}
resize_pblock [get_pblocks pblock_57] -add {DSP48E2_X9Y0:DSP48E2_X9Y13}
resize_pblock [get_pblocks pblock_57] -add {RAMB18_X6Y0:RAMB18_X6Y13}
resize_pblock [get_pblocks pblock_57] -add {RAMB36_X6Y0:RAMB36_X6Y6}
set_property SNAPPING_MODE ON [get_pblocks pblock_57]
create_pblock pblock_58
add_cells_to_pblock [get_pblocks pblock_58] [get_cells -quiet [list sym_i/zcore32_58]]
resize_pblock [get_pblocks pblock_58] -add {SLICE_X55Y0:SLICE_X60Y34}
resize_pblock [get_pblocks pblock_58] -add {DSP48E2_X11Y0:DSP48E2_X11Y13}
resize_pblock [get_pblocks pblock_58] -add {RAMB18_X7Y0:RAMB18_X7Y13}
resize_pblock [get_pblocks pblock_58] -add {RAMB36_X7Y0:RAMB36_X7Y6}
set_property SNAPPING_MODE ON [get_pblocks pblock_58]
create_pblock pblock_59
add_cells_to_pblock [get_pblocks pblock_59] [get_cells -quiet [list sym_i/zcore32_59]]
resize_pblock [get_pblocks pblock_59] -add {SLICE_X62Y0:SLICE_X67Y34}
resize_pblock [get_pblocks pblock_59] -add {DSP48E2_X13Y0:DSP48E2_X13Y13}
resize_pblock [get_pblocks pblock_59] -add {RAMB18_X8Y0:RAMB18_X8Y13}
resize_pblock [get_pblocks pblock_59] -add {RAMB36_X8Y0:RAMB36_X8Y6}
set_property SNAPPING_MODE ON [get_pblocks pblock_59]
create_pblock pblock_60
add_cells_to_pblock [get_pblocks pblock_60] [get_cells -quiet [list sym_i/zcore32_60]]
resize_pblock [get_pblocks pblock_60] -add {SLICE_X70Y0:SLICE_X75Y34}
resize_pblock [get_pblocks pblock_60] -add {DSP48E2_X14Y0:DSP48E2_X14Y13}
resize_pblock [get_pblocks pblock_60] -add {RAMB18_X9Y0:RAMB18_X9Y13}
resize_pblock [get_pblocks pblock_60] -add {RAMB36_X9Y0:RAMB36_X9Y6}
set_property SNAPPING_MODE ON [get_pblocks pblock_60]
create_pblock pblock_61
add_cells_to_pblock [get_pblocks pblock_61] [get_cells -quiet [list sym_i/zcore32_61]]
resize_pblock [get_pblocks pblock_61] -add {SLICE_X82Y0:SLICE_X87Y44}
resize_pblock [get_pblocks pblock_61] -add {DSP48E2_X16Y0:DSP48E2_X16Y17}
resize_pblock [get_pblocks pblock_61] -add {RAMB18_X11Y0:RAMB18_X11Y17}
resize_pblock [get_pblocks pblock_61] -add {RAMB36_X11Y0:RAMB36_X11Y8}
set_property SNAPPING_MODE ON [get_pblocks pblock_61]
create_pblock pblock_62
add_cells_to_pblock [get_pblocks pblock_62] [get_cells -quiet [list sym_i/zcore32_62]]
resize_pblock [get_pblocks pblock_62] -add {SLICE_X90Y0:SLICE_X95Y34}
resize_pblock [get_pblocks pblock_62] -add {DSP48E2_X17Y0:DSP48E2_X17Y13}
resize_pblock [get_pblocks pblock_62] -add {RAMB18_X12Y0:RAMB18_X12Y13}
resize_pblock [get_pblocks pblock_62] -add {RAMB36_X12Y0:RAMB36_X12Y6}
set_property SNAPPING_MODE ON [get_pblocks pblock_62]

set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_12]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_13]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_14]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_15]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_16]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_17]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_18]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_19]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_20]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_21]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_22]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_23]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_24]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_25]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_26]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_27]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_28]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_29]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_30]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_31]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_32]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_33]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_34]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_35]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_36]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_37]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_38]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_39]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_40]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_41]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_42]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_43]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_44]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_45]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_46]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_47]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_48]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_49]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_50]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_51]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_52]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_53]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_54]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_55]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_56]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_57]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_58]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_59]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_60]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_61]
set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_62]






