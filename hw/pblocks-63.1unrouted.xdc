set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_0]
create_pblock pblock_0
add_cells_to_pblock [get_pblocks pblock_0] [get_cells -quiet [list sym_i/zcore32_0]]
resize_pblock [get_pblocks pblock_0] -add {SLICE_X1Y380:SLICE_X6Y419}
resize_pblock [get_pblocks pblock_0] -add {DSP48E2_X0Y152:DSP48E2_X0Y167}
resize_pblock [get_pblocks pblock_0] -add {RAMB18_X0Y152:RAMB18_X0Y167}
resize_pblock [get_pblocks pblock_0] -add {RAMB36_X0Y76:RAMB36_X0Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_0]

create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list sym_i/zcore32_1]]
resize_pblock [get_pblocks pblock_1] -add {SLICE_X11Y390:SLICE_X19Y419}
resize_pblock [get_pblocks pblock_1] -add {DSP48E2_X2Y156:DSP48E2_X3Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X2Y156:RAMB18_X2Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X2Y78:RAMB36_X2Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_1]

create_pblock pblock_2
add_cells_to_pblock [get_pblocks pblock_2] [get_cells -quiet [list sym_i/zcore32_2]]
resize_pblock [get_pblocks pblock_2] -add {SLICE_X22Y380:SLICE_X27Y419}
resize_pblock [get_pblocks pblock_2] -add {DSP48E2_X4Y152:DSP48E2_X4Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB18_X3Y152:RAMB18_X3Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB36_X3Y76:RAMB36_X3Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_2]

create_pblock pblock_3
add_cells_to_pblock [get_pblocks pblock_3] [get_cells -quiet [list sym_i/zcore32_3]]
resize_pblock [get_pblocks pblock_3] -add {SLICE_X29Y380:SLICE_X34Y419}
resize_pblock [get_pblocks pblock_3] -add {DSP48E2_X6Y152:DSP48E2_X6Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB18_X4Y152:RAMB18_X4Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB36_X4Y76:RAMB36_X4Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_3]

create_pblock pblock_4
add_cells_to_pblock [get_pblocks pblock_4] [get_cells -quiet [list sym_i/zcore32_4]]
resize_pblock [get_pblocks pblock_4] -add {SLICE_X37Y380:SLICE_X42Y419}
resize_pblock [get_pblocks pblock_4] -add {DSP48E2_X7Y152:DSP48E2_X7Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB18_X5Y152:RAMB18_X5Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB36_X5Y76:RAMB36_X5Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_4]

create_pblock pblock_5
add_cells_to_pblock [get_pblocks pblock_5] [get_cells -quiet [list sym_i/zcore32_5]]
resize_pblock [get_pblocks pblock_5] -add {SLICE_X46Y380:SLICE_X51Y419}
resize_pblock [get_pblocks pblock_5] -add {DSP48E2_X9Y152:DSP48E2_X9Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB18_X6Y152:RAMB18_X6Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB36_X6Y76:RAMB36_X6Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_5]

create_pblock pblock_6
add_cells_to_pblock [get_pblocks pblock_6] [get_cells -quiet [list sym_i/zcore32_6]]
resize_pblock [get_pblocks pblock_6] -add {SLICE_X55Y380:SLICE_X60Y419}
resize_pblock [get_pblocks pblock_6] -add {DSP48E2_X11Y152:DSP48E2_X11Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB18_X7Y152:RAMB18_X7Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB36_X7Y76:RAMB36_X7Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_6]

create_pblock pblock_7
add_cells_to_pblock [get_pblocks pblock_7] [get_cells -quiet [list sym_i/zcore32_7]]
resize_pblock [get_pblocks pblock_7] -add {SLICE_X62Y380:SLICE_X67Y419}
resize_pblock [get_pblocks pblock_7] -add {DSP48E2_X13Y152:DSP48E2_X13Y167}
resize_pblock [get_pblocks pblock_7] -add {RAMB18_X8Y152:RAMB18_X8Y167}
resize_pblock [get_pblocks pblock_7] -add {RAMB36_X8Y76:RAMB36_X8Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_7]

create_pblock pblock_8
add_cells_to_pblock [get_pblocks pblock_8] [get_cells -quiet [list sym_i/zcore32_8]]
resize_pblock [get_pblocks pblock_8] -add {SLICE_X70Y380:SLICE_X75Y419}
resize_pblock [get_pblocks pblock_8] -add {DSP48E2_X14Y152:DSP48E2_X14Y167}
resize_pblock [get_pblocks pblock_8] -add {RAMB18_X9Y152:RAMB18_X9Y167}
resize_pblock [get_pblocks pblock_8] -add {RAMB36_X9Y76:RAMB36_X9Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_8]


create_pblock pblock_9
add_cells_to_pblock [get_pblocks pblock_9] [get_cells -quiet [list sym_i/zcore32_9]]
resize_pblock [get_pblocks pblock_9] -add {SLICE_X82Y370:SLICE_X87Y419}
resize_pblock [get_pblocks pblock_9] -add {DSP48E2_X16Y148:DSP48E2_X16Y167}
resize_pblock [get_pblocks pblock_9] -add {RAMB18_X11Y148:RAMB18_X11Y167}
resize_pblock [get_pblocks pblock_9] -add {RAMB36_X11Y74:RAMB36_X11Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_9]

create_pblock pblock_10
add_cells_to_pblock [get_pblocks pblock_10] [get_cells -quiet [list sym_i/zcore32_10]]
resize_pblock [get_pblocks pblock_10] -add {SLICE_X90Y380:SLICE_X95Y419}
resize_pblock [get_pblocks pblock_10] -add {DSP48E2_X17Y152:DSP48E2_X17Y167}
resize_pblock [get_pblocks pblock_10] -add {RAMB18_X12Y152:RAMB18_X12Y167}
resize_pblock [get_pblocks pblock_10] -add {RAMB36_X12Y76:RAMB36_X12Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_10]

create_pblock pblock_11
add_cells_to_pblock [get_pblocks pblock_11] [get_cells -quiet [list sym_i/zcore32_11]]
resize_pblock [get_pblocks pblock_11] -add {SLICE_X90Y320:SLICE_X95Y359}
resize_pblock [get_pblocks pblock_11] -add {DSP48E2_X17Y128:DSP48E2_X17Y143}
resize_pblock [get_pblocks pblock_11] -add {RAMB18_X12Y128:RAMB18_X12Y143}
resize_pblock [get_pblocks pblock_11] -add {RAMB36_X12Y64:RAMB36_X12Y71}
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
resize_pblock [get_pblocks pblock_12] -add {SLICE_X82Y310:SLICE_X87Y359}
resize_pblock [get_pblocks pblock_12] -add {DSP48E2_X16Y124:DSP48E2_X16Y143}
resize_pblock [get_pblocks pblock_12] -add {RAMB18_X11Y124:RAMB18_X11Y143}
resize_pblock [get_pblocks pblock_12] -add {RAMB36_X11Y62:RAMB36_X11Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_12]

create_pblock pblock_13
add_cells_to_pblock [get_pblocks pblock_13] [get_cells -quiet [list sym_i/zcore32_13]]
resize_pblock [get_pblocks pblock_13] -add {SLICE_X70Y320:SLICE_X75Y359}
resize_pblock [get_pblocks pblock_13] -add {DSP48E2_X14Y128:DSP48E2_X14Y143}
resize_pblock [get_pblocks pblock_13] -add {RAMB18_X9Y128:RAMB18_X9Y143}
resize_pblock [get_pblocks pblock_13] -add {RAMB36_X9Y64:RAMB36_X9Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_13]

create_pblock pblock_14
add_cells_to_pblock [get_pblocks pblock_14] [get_cells -quiet [list sym_i/zcore32_14]]
resize_pblock [get_pblocks pblock_14] -add {SLICE_X62Y320:SLICE_X67Y359}
resize_pblock [get_pblocks pblock_14] -add {DSP48E2_X13Y128:DSP48E2_X13Y143}
resize_pblock [get_pblocks pblock_14] -add {RAMB18_X8Y128:RAMB18_X8Y143}
resize_pblock [get_pblocks pblock_14] -add {RAMB36_X8Y64:RAMB36_X8Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_14]

create_pblock pblock_15
add_cells_to_pblock [get_pblocks pblock_15] [get_cells -quiet [list sym_i/zcore32_15]]
resize_pblock [get_pblocks pblock_15] -add {SLICE_X55Y320:SLICE_X60Y359}
resize_pblock [get_pblocks pblock_15] -add {DSP48E2_X11Y128:DSP48E2_X11Y143}
resize_pblock [get_pblocks pblock_15] -add {RAMB18_X7Y128:RAMB18_X7Y143}
resize_pblock [get_pblocks pblock_15] -add {RAMB36_X7Y64:RAMB36_X7Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_15]

create_pblock pblock_16
add_cells_to_pblock [get_pblocks pblock_16] [get_cells -quiet [list sym_i/zcore32_16]]
resize_pblock [get_pblocks pblock_16] -add {SLICE_X46Y320:SLICE_X51Y359}
resize_pblock [get_pblocks pblock_16] -add {DSP48E2_X9Y128:DSP48E2_X9Y143}
resize_pblock [get_pblocks pblock_16] -add {RAMB18_X6Y128:RAMB18_X6Y143}
resize_pblock [get_pblocks pblock_16] -add {RAMB36_X6Y64:RAMB36_X6Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_16]

create_pblock pblock_17
add_cells_to_pblock [get_pblocks pblock_17] [get_cells -quiet [list sym_i/zcore32_17]]
resize_pblock [get_pblocks pblock_17] -add {SLICE_X37Y320:SLICE_X42Y359}
resize_pblock [get_pblocks pblock_17] -add {DSP48E2_X7Y128:DSP48E2_X7Y143}
resize_pblock [get_pblocks pblock_17] -add {RAMB18_X5Y128:RAMB18_X5Y143}
resize_pblock [get_pblocks pblock_17] -add {RAMB36_X5Y64:RAMB36_X5Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_17]

create_pblock pblock_18
add_cells_to_pblock [get_pblocks pblock_18] [get_cells -quiet [list sym_i/zcore32_18]]
resize_pblock [get_pblocks pblock_18] -add {SLICE_X29Y320:SLICE_X34Y359}
resize_pblock [get_pblocks pblock_18] -add {DSP48E2_X6Y128:DSP48E2_X6Y143}
resize_pblock [get_pblocks pblock_18] -add {RAMB18_X4Y128:RAMB18_X4Y143}
resize_pblock [get_pblocks pblock_18] -add {RAMB36_X4Y64:RAMB36_X4Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_18]

create_pblock pblock_19
add_cells_to_pblock [get_pblocks pblock_19] [get_cells -quiet [list sym_i/zcore32_19]]
resize_pblock [get_pblocks pblock_19] -add {SLICE_X22Y320:SLICE_X27Y359}
resize_pblock [get_pblocks pblock_19] -add {DSP48E2_X4Y128:DSP48E2_X4Y143}
resize_pblock [get_pblocks pblock_19] -add {RAMB18_X3Y128:RAMB18_X3Y143}
resize_pblock [get_pblocks pblock_19] -add {RAMB36_X3Y64:RAMB36_X3Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_19]

create_pblock pblock_20
add_cells_to_pblock [get_pblocks pblock_20] [get_cells -quiet [list sym_i/zcore32_20]]
resize_pblock [get_pblocks pblock_20] -add {SLICE_X11Y330:SLICE_X19Y359}
resize_pblock [get_pblocks pblock_20] -add {DSP48E2_X2Y132:DSP48E2_X3Y143}
resize_pblock [get_pblocks pblock_20] -add {RAMB18_X2Y132:RAMB18_X2Y143}
resize_pblock [get_pblocks pblock_20] -add {RAMB36_X2Y66:RAMB36_X2Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_20]

create_pblock pblock_21
add_cells_to_pblock [get_pblocks pblock_21] [get_cells -quiet [list sym_i/zcore32_21]]
resize_pblock [get_pblocks pblock_21] -add {SLICE_X1Y320:SLICE_X6Y359}
resize_pblock [get_pblocks pblock_21] -add {DSP48E2_X0Y128:DSP48E2_X0Y143}
resize_pblock [get_pblocks pblock_21] -add {RAMB18_X0Y128:RAMB18_X0Y143}
resize_pblock [get_pblocks pblock_21] -add {RAMB36_X0Y64:RAMB36_X0Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_21]

create_pblock pblock_22
add_cells_to_pblock [get_pblocks pblock_22] [get_cells -quiet [list sym_i/zcore32_22]]
resize_pblock [get_pblocks pblock_22] -add {SLICE_X1Y260:SLICE_X6Y299}
resize_pblock [get_pblocks pblock_22] -add {DSP48E2_X0Y104:DSP48E2_X0Y119}
resize_pblock [get_pblocks pblock_22] -add {RAMB18_X0Y104:RAMB18_X0Y119}
resize_pblock [get_pblocks pblock_22] -add {RAMB36_X0Y52:RAMB36_X0Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_22]

create_pblock pblock_23
add_cells_to_pblock [get_pblocks pblock_23] [get_cells -quiet [list sym_i/zcore32_23]]
resize_pblock [get_pblocks pblock_23] -add {SLICE_X11Y270:SLICE_X19Y299}
resize_pblock [get_pblocks pblock_23] -add {DSP48E2_X2Y108:DSP48E2_X3Y119}
resize_pblock [get_pblocks pblock_23] -add {RAMB18_X2Y108:RAMB18_X2Y119}
resize_pblock [get_pblocks pblock_23] -add {RAMB36_X2Y54:RAMB36_X2Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_23]

create_pblock pblock_24
add_cells_to_pblock [get_pblocks pblock_24] [get_cells -quiet [list sym_i/zcore32_24]]
resize_pblock [get_pblocks pblock_24] -add {SLICE_X22Y260:SLICE_X27Y299}
resize_pblock [get_pblocks pblock_24] -add {DSP48E2_X4Y104:DSP48E2_X4Y119}
resize_pblock [get_pblocks pblock_24] -add {RAMB18_X3Y104:RAMB18_X3Y119}
resize_pblock [get_pblocks pblock_24] -add {RAMB36_X3Y52:RAMB36_X3Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_24]

create_pblock pblock_25
add_cells_to_pblock [get_pblocks pblock_25] [get_cells -quiet [list sym_i/zcore32_25]]
resize_pblock [get_pblocks pblock_25] -add {SLICE_X29Y260:SLICE_X34Y299}
resize_pblock [get_pblocks pblock_25] -add {DSP48E2_X6Y104:DSP48E2_X6Y119}
resize_pblock [get_pblocks pblock_25] -add {RAMB18_X4Y104:RAMB18_X4Y119}
resize_pblock [get_pblocks pblock_25] -add {RAMB36_X4Y52:RAMB36_X4Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_25]

create_pblock pblock_26
add_cells_to_pblock [get_pblocks pblock_26] [get_cells -quiet [list sym_i/zcore32_26]]
resize_pblock [get_pblocks pblock_26] -add {SLICE_X37Y260:SLICE_X42Y299}
resize_pblock [get_pblocks pblock_26] -add {DSP48E2_X7Y104:DSP48E2_X7Y119}
resize_pblock [get_pblocks pblock_26] -add {RAMB18_X5Y104:RAMB18_X5Y119}
resize_pblock [get_pblocks pblock_26] -add {RAMB36_X5Y52:RAMB36_X5Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_26]

create_pblock pblock_27
add_cells_to_pblock [get_pblocks pblock_27] [get_cells -quiet [list sym_i/zcore32_27]]
resize_pblock [get_pblocks pblock_27] -add {SLICE_X46Y260:SLICE_X51Y299}
resize_pblock [get_pblocks pblock_27] -add {DSP48E2_X9Y104:DSP48E2_X9Y119}
resize_pblock [get_pblocks pblock_27] -add {RAMB18_X6Y104:RAMB18_X6Y119}
resize_pblock [get_pblocks pblock_27] -add {RAMB36_X6Y52:RAMB36_X6Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_27]

create_pblock pblock_28
add_cells_to_pblock [get_pblocks pblock_28] [get_cells -quiet [list sym_i/zcore32_28]]
resize_pblock [get_pblocks pblock_28] -add {SLICE_X55Y260:SLICE_X60Y299}
resize_pblock [get_pblocks pblock_28] -add {DSP48E2_X11Y104:DSP48E2_X11Y119}
resize_pblock [get_pblocks pblock_28] -add {RAMB18_X7Y104:RAMB18_X7Y119}
resize_pblock [get_pblocks pblock_28] -add {RAMB36_X7Y52:RAMB36_X7Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_28]

create_pblock pblock_29
add_cells_to_pblock [get_pblocks pblock_29] [get_cells -quiet [list sym_i/zcore32_29]]
resize_pblock [get_pblocks pblock_29] -add {SLICE_X62Y260:SLICE_X67Y299}
resize_pblock [get_pblocks pblock_29] -add {DSP48E2_X13Y104:DSP48E2_X13Y119}
resize_pblock [get_pblocks pblock_29] -add {RAMB18_X8Y104:RAMB18_X8Y119}
resize_pblock [get_pblocks pblock_29] -add {RAMB36_X8Y52:RAMB36_X8Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_29]

create_pblock pblock_30
add_cells_to_pblock [get_pblocks pblock_30] [get_cells -quiet [list sym_i/zcore32_30]]
resize_pblock [get_pblocks pblock_30] -add {SLICE_X70Y260:SLICE_X75Y299}
resize_pblock [get_pblocks pblock_30] -add {DSP48E2_X14Y104:DSP48E2_X14Y119}
resize_pblock [get_pblocks pblock_30] -add {RAMB18_X9Y104:RAMB18_X9Y119}
resize_pblock [get_pblocks pblock_30] -add {RAMB36_X9Y52:RAMB36_X9Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_30]

create_pblock pblock_31
add_cells_to_pblock [get_pblocks pblock_31] [get_cells -quiet [list sym_i/zcore32_31]]
resize_pblock [get_pblocks pblock_31] -add {SLICE_X82Y250:SLICE_X87Y299}
resize_pblock [get_pblocks pblock_31] -add {DSP48E2_X16Y100:DSP48E2_X16Y119}
resize_pblock [get_pblocks pblock_31] -add {RAMB18_X11Y100:RAMB18_X11Y119}
resize_pblock [get_pblocks pblock_31] -add {RAMB36_X11Y50:RAMB36_X11Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_31]

create_pblock pblock_32
add_cells_to_pblock [get_pblocks pblock_32] [get_cells -quiet [list sym_i/zcore32_32]]
resize_pblock [get_pblocks pblock_32] -add {SLICE_X90Y260:SLICE_X95Y299}
resize_pblock [get_pblocks pblock_32] -add {DSP48E2_X17Y104:DSP48E2_X17Y119}
resize_pblock [get_pblocks pblock_32] -add {RAMB18_X12Y104:RAMB18_X12Y119}
resize_pblock [get_pblocks pblock_32] -add {RAMB36_X12Y52:RAMB36_X12Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_32]

create_pblock pblock_33
add_cells_to_pblock [get_pblocks pblock_33] [get_cells -quiet [list sym_i/zcore32_33]]
resize_pblock [get_pblocks pblock_33] -add {SLICE_X90Y200:SLICE_X95Y239}
resize_pblock [get_pblocks pblock_33] -add {DSP48E2_X17Y80:DSP48E2_X17Y95}
resize_pblock [get_pblocks pblock_33] -add {RAMB18_X12Y80:RAMB18_X12Y95}
resize_pblock [get_pblocks pblock_33] -add {RAMB36_X12Y40:RAMB36_X12Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_33]

create_pblock pblock_34
add_cells_to_pblock [get_pblocks pblock_34] [get_cells -quiet [list sym_i/zcore32_34]]
resize_pblock [get_pblocks pblock_34] -add {SLICE_X82Y190:SLICE_X87Y239}
resize_pblock [get_pblocks pblock_34] -add {DSP48E2_X16Y76:DSP48E2_X16Y95}
resize_pblock [get_pblocks pblock_34] -add {RAMB18_X11Y76:RAMB18_X11Y95}
resize_pblock [get_pblocks pblock_34] -add {RAMB36_X11Y38:RAMB36_X11Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_34]

create_pblock pblock_35
add_cells_to_pblock [get_pblocks pblock_35] [get_cells -quiet [list sym_i/zcore32_35]]
resize_pblock [get_pblocks pblock_35] -add {SLICE_X70Y200:SLICE_X75Y239}
resize_pblock [get_pblocks pblock_35] -add {DSP48E2_X14Y80:DSP48E2_X14Y95}
resize_pblock [get_pblocks pblock_35] -add {RAMB18_X9Y80:RAMB18_X9Y95}
resize_pblock [get_pblocks pblock_35] -add {RAMB36_X9Y40:RAMB36_X9Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_35]

create_pblock pblock_36
add_cells_to_pblock [get_pblocks pblock_36] [get_cells -quiet [list sym_i/zcore32_36]]
resize_pblock [get_pblocks pblock_36] -add {SLICE_X62Y200:SLICE_X67Y239}
resize_pblock [get_pblocks pblock_36] -add {DSP48E2_X13Y80:DSP48E2_X13Y95}
resize_pblock [get_pblocks pblock_36] -add {RAMB18_X8Y80:RAMB18_X8Y95}
resize_pblock [get_pblocks pblock_36] -add {RAMB36_X8Y40:RAMB36_X8Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_36]

create_pblock pblock_37
add_cells_to_pblock [get_pblocks pblock_37] [get_cells -quiet [list sym_i/zcore32_37]]
resize_pblock [get_pblocks pblock_37] -add {SLICE_X55Y200:SLICE_X60Y239}
resize_pblock [get_pblocks pblock_37] -add {DSP48E2_X11Y80:DSP48E2_X11Y95}
resize_pblock [get_pblocks pblock_37] -add {RAMB18_X7Y80:RAMB18_X7Y95}
resize_pblock [get_pblocks pblock_37] -add {RAMB36_X7Y40:RAMB36_X7Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_37]

create_pblock pblock_38
add_cells_to_pblock [get_pblocks pblock_38] [get_cells -quiet [list sym_i/zcore32_38]]
resize_pblock [get_pblocks pblock_38] -add {SLICE_X46Y200:SLICE_X51Y239}
resize_pblock [get_pblocks pblock_38] -add {DSP48E2_X9Y80:DSP48E2_X9Y95}
resize_pblock [get_pblocks pblock_38] -add {RAMB18_X6Y80:RAMB18_X6Y95}
resize_pblock [get_pblocks pblock_38] -add {RAMB36_X6Y40:RAMB36_X6Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_38]

create_pblock pblock_39
add_cells_to_pblock [get_pblocks pblock_39] [get_cells -quiet [list sym_i/zcore32_39]]
resize_pblock [get_pblocks pblock_39] -add {SLICE_X37Y200:SLICE_X42Y239}
resize_pblock [get_pblocks pblock_39] -add {DSP48E2_X7Y80:DSP48E2_X7Y95}
resize_pblock [get_pblocks pblock_39] -add {RAMB18_X5Y80:RAMB18_X5Y95}
resize_pblock [get_pblocks pblock_39] -add {RAMB36_X5Y40:RAMB36_X5Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_39]

create_pblock pblock_40
add_cells_to_pblock [get_pblocks pblock_40] [get_cells -quiet [list sym_i/zcore32_40]]
resize_pblock [get_pblocks pblock_40] -add {SLICE_X29Y200:SLICE_X34Y239}
resize_pblock [get_pblocks pblock_40] -add {DSP48E2_X6Y80:DSP48E2_X6Y95}
resize_pblock [get_pblocks pblock_40] -add {RAMB18_X4Y80:RAMB18_X4Y95}
resize_pblock [get_pblocks pblock_40] -add {RAMB36_X4Y40:RAMB36_X4Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_40]

create_pblock pblock_41
add_cells_to_pblock [get_pblocks pblock_41] [get_cells -quiet [list sym_i/zcore32_41]]
resize_pblock [get_pblocks pblock_41] -add {SLICE_X22Y200:SLICE_X27Y239}
resize_pblock [get_pblocks pblock_41] -add {DSP48E2_X4Y80:DSP48E2_X4Y95}
resize_pblock [get_pblocks pblock_41] -add {RAMB18_X3Y80:RAMB18_X3Y95}
resize_pblock [get_pblocks pblock_41] -add {RAMB36_X3Y40:RAMB36_X3Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_41]

create_pblock pblock_42
add_cells_to_pblock [get_pblocks pblock_42] [get_cells -quiet [list sym_i/zcore32_42]]
resize_pblock [get_pblocks pblock_42] -add {SLICE_X11Y210:SLICE_X19Y239}
resize_pblock [get_pblocks pblock_42] -add {DSP48E2_X2Y84:DSP48E2_X3Y95}
resize_pblock [get_pblocks pblock_42] -add {RAMB18_X2Y84:RAMB18_X2Y95}
resize_pblock [get_pblocks pblock_42] -add {RAMB36_X2Y42:RAMB36_X2Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_42]

create_pblock pblock_43
add_cells_to_pblock [get_pblocks pblock_43] [get_cells -quiet [list sym_i/zcore32_43]]
resize_pblock [get_pblocks pblock_43] -add {SLICE_X1Y200:SLICE_X6Y239}
resize_pblock [get_pblocks pblock_43] -add {DSP48E2_X0Y80:DSP48E2_X0Y95}
resize_pblock [get_pblocks pblock_43] -add {RAMB18_X0Y80:RAMB18_X0Y95}
resize_pblock [get_pblocks pblock_43] -add {RAMB36_X0Y40:RAMB36_X0Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_43]

create_pblock pblock_44
add_cells_to_pblock [get_pblocks pblock_44] [get_cells -quiet [list sym_i/zcore32_44]]
resize_pblock [get_pblocks pblock_44] -add {SLICE_X36Y150:SLICE_X45Y179}
resize_pblock [get_pblocks pblock_44] -add {DSP48E2_X7Y60:DSP48E2_X8Y71}
resize_pblock [get_pblocks pblock_44] -add {RAMB18_X5Y60:RAMB18_X5Y71}
resize_pblock [get_pblocks pblock_44] -add {RAMB36_X5Y30:RAMB36_X5Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_44]

create_pblock pblock_45
add_cells_to_pblock [get_pblocks pblock_45] [get_cells -quiet [list sym_i/zcore32_45]]
resize_pblock [get_pblocks pblock_45] -add {SLICE_X55Y140:SLICE_X60Y179}
resize_pblock [get_pblocks pblock_45] -add {DSP48E2_X11Y56:DSP48E2_X11Y71}
resize_pblock [get_pblocks pblock_45] -add {RAMB18_X7Y56:RAMB18_X7Y71}
resize_pblock [get_pblocks pblock_45] -add {RAMB36_X7Y28:RAMB36_X7Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_45]

create_pblock pblock_46
add_cells_to_pblock [get_pblocks pblock_46] [get_cells -quiet [list sym_i/zcore32_46]]
resize_pblock [get_pblocks pblock_46] -add {SLICE_X62Y140:SLICE_X67Y179}
resize_pblock [get_pblocks pblock_46] -add {DSP48E2_X13Y56:DSP48E2_X13Y71}
resize_pblock [get_pblocks pblock_46] -add {RAMB18_X8Y56:RAMB18_X8Y71}
resize_pblock [get_pblocks pblock_46] -add {RAMB36_X8Y28:RAMB36_X8Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_46]

create_pblock pblock_47
add_cells_to_pblock [get_pblocks pblock_47] [get_cells -quiet [list sym_i/zcore32_47]]
resize_pblock [get_pblocks pblock_47] -add {SLICE_X70Y140:SLICE_X75Y179}
resize_pblock [get_pblocks pblock_47] -add {DSP48E2_X14Y56:DSP48E2_X14Y71}
resize_pblock [get_pblocks pblock_47] -add {RAMB18_X9Y56:RAMB18_X9Y71}
resize_pblock [get_pblocks pblock_47] -add {RAMB36_X9Y28:RAMB36_X9Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_47]











create_pblock pblock_48
add_cells_to_pblock [get_pblocks pblock_48] [get_cells -quiet [list sym_i/zcore32_48]]
resize_pblock [get_pblocks pblock_48] -add {SLICE_X82Y130:SLICE_X87Y179}
resize_pblock [get_pblocks pblock_48] -add {DSP48E2_X16Y52:DSP48E2_X16Y71}
resize_pblock [get_pblocks pblock_48] -add {RAMB18_X11Y52:RAMB18_X11Y71}
resize_pblock [get_pblocks pblock_48] -add {RAMB36_X11Y26:RAMB36_X11Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_48]
create_pblock pblock_50
add_cells_to_pblock [get_pblocks pblock_50] [get_cells -quiet [list sym_i/zcore32_50]]
resize_pblock [get_pblocks pblock_50] -add {SLICE_X90Y80:SLICE_X95Y119}
resize_pblock [get_pblocks pblock_50] -add {DSP48E2_X17Y32:DSP48E2_X17Y47}
resize_pblock [get_pblocks pblock_50] -add {RAMB18_X12Y32:RAMB18_X12Y47}
resize_pblock [get_pblocks pblock_50] -add {RAMB36_X12Y16:RAMB36_X12Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_50]
create_pblock pblock_51
add_cells_to_pblock [get_pblocks pblock_51] [get_cells -quiet [list sym_i/zcore32_51]]
resize_pblock [get_pblocks pblock_51] -add {SLICE_X82Y70:SLICE_X87Y119}
resize_pblock [get_pblocks pblock_51] -add {DSP48E2_X16Y28:DSP48E2_X16Y47}
resize_pblock [get_pblocks pblock_51] -add {RAMB18_X11Y28:RAMB18_X11Y47}
resize_pblock [get_pblocks pblock_51] -add {RAMB36_X11Y14:RAMB36_X11Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_51]
create_pblock pblock_49
add_cells_to_pblock [get_pblocks pblock_49] [get_cells -quiet [list sym_i/zcore32_49]]
resize_pblock [get_pblocks pblock_49] -add {SLICE_X90Y140:SLICE_X95Y179}
resize_pblock [get_pblocks pblock_49] -add {DSP48E2_X17Y56:DSP48E2_X17Y71}
resize_pblock [get_pblocks pblock_49] -add {RAMB18_X12Y56:RAMB18_X12Y71}
resize_pblock [get_pblocks pblock_49] -add {RAMB36_X12Y28:RAMB36_X12Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_49]
create_pblock pblock_52
add_cells_to_pblock [get_pblocks pblock_52] [get_cells -quiet [list sym_i/zcore32_52]]
resize_pblock [get_pblocks pblock_52] -add {SLICE_X70Y80:SLICE_X75Y119}
resize_pblock [get_pblocks pblock_52] -add {DSP48E2_X14Y32:DSP48E2_X14Y47}
resize_pblock [get_pblocks pblock_52] -add {RAMB18_X9Y32:RAMB18_X9Y47}
resize_pblock [get_pblocks pblock_52] -add {RAMB36_X9Y16:RAMB36_X9Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_52]
create_pblock pblock_53
add_cells_to_pblock [get_pblocks pblock_53] [get_cells -quiet [list sym_i/zcore32_53]]
resize_pblock [get_pblocks pblock_53] -add {SLICE_X62Y80:SLICE_X67Y119}
resize_pblock [get_pblocks pblock_53] -add {DSP48E2_X13Y32:DSP48E2_X13Y47}
resize_pblock [get_pblocks pblock_53] -add {RAMB18_X8Y32:RAMB18_X8Y47}
resize_pblock [get_pblocks pblock_53] -add {RAMB36_X8Y16:RAMB36_X8Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_53]
create_pblock pblock_54
add_cells_to_pblock [get_pblocks pblock_54] [get_cells -quiet [list sym_i/zcore32_54]]
resize_pblock [get_pblocks pblock_54] -add {SLICE_X55Y80:SLICE_X60Y119}
resize_pblock [get_pblocks pblock_54] -add {DSP48E2_X11Y32:DSP48E2_X11Y47}
resize_pblock [get_pblocks pblock_54] -add {RAMB18_X7Y32:RAMB18_X7Y47}
resize_pblock [get_pblocks pblock_54] -add {RAMB36_X7Y16:RAMB36_X7Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_54]
create_pblock pblock_55
add_cells_to_pblock [get_pblocks pblock_55] [get_cells -quiet [list sym_i/zcore32_55]]
resize_pblock [get_pblocks pblock_55] -add {SLICE_X36Y90:SLICE_X45Y119}
resize_pblock [get_pblocks pblock_55] -add {DSP48E2_X7Y36:DSP48E2_X8Y47}
resize_pblock [get_pblocks pblock_55] -add {RAMB18_X5Y36:RAMB18_X5Y47}
resize_pblock [get_pblocks pblock_55] -add {RAMB36_X5Y18:RAMB36_X5Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_55]
create_pblock pblock_56
add_cells_to_pblock [get_pblocks pblock_56] [get_cells -quiet [list sym_i/zcore32_56]]
resize_pblock [get_pblocks pblock_56] -add {SLICE_X37Y20:SLICE_X42Y59}
resize_pblock [get_pblocks pblock_56] -add {DSP48E2_X7Y8:DSP48E2_X7Y23}
resize_pblock [get_pblocks pblock_56] -add {RAMB18_X5Y8:RAMB18_X5Y23}
resize_pblock [get_pblocks pblock_56] -add {RAMB36_X5Y4:RAMB36_X5Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_56]
create_pblock pblock_57
add_cells_to_pblock [get_pblocks pblock_57] [get_cells -quiet [list sym_i/zcore32_57]]
resize_pblock [get_pblocks pblock_57] -add {SLICE_X46Y20:SLICE_X51Y59}
resize_pblock [get_pblocks pblock_57] -add {DSP48E2_X9Y8:DSP48E2_X9Y23}
resize_pblock [get_pblocks pblock_57] -add {RAMB18_X6Y8:RAMB18_X6Y23}
resize_pblock [get_pblocks pblock_57] -add {RAMB36_X6Y4:RAMB36_X6Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_57]
create_pblock pblock_58
add_cells_to_pblock [get_pblocks pblock_58] [get_cells -quiet [list sym_i/zcore32_58]]
resize_pblock [get_pblocks pblock_58] -add {SLICE_X55Y20:SLICE_X60Y59}
resize_pblock [get_pblocks pblock_58] -add {DSP48E2_X11Y8:DSP48E2_X11Y23}
resize_pblock [get_pblocks pblock_58] -add {RAMB18_X7Y8:RAMB18_X7Y23}
resize_pblock [get_pblocks pblock_58] -add {RAMB36_X7Y4:RAMB36_X7Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_58]
create_pblock pblock_59
add_cells_to_pblock [get_pblocks pblock_59] [get_cells -quiet [list sym_i/zcore32_59]]
resize_pblock [get_pblocks pblock_59] -add {SLICE_X62Y20:SLICE_X67Y59}
resize_pblock [get_pblocks pblock_59] -add {DSP48E2_X13Y8:DSP48E2_X13Y23}
resize_pblock [get_pblocks pblock_59] -add {RAMB18_X8Y8:RAMB18_X8Y23}
resize_pblock [get_pblocks pblock_59] -add {RAMB36_X8Y4:RAMB36_X8Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_59]
create_pblock pblock_60
add_cells_to_pblock [get_pblocks pblock_60] [get_cells -quiet [list sym_i/zcore32_60]]
resize_pblock [get_pblocks pblock_60] -add {SLICE_X70Y20:SLICE_X75Y59}
resize_pblock [get_pblocks pblock_60] -add {DSP48E2_X14Y8:DSP48E2_X14Y23}
resize_pblock [get_pblocks pblock_60] -add {RAMB18_X9Y8:RAMB18_X9Y23}
resize_pblock [get_pblocks pblock_60] -add {RAMB36_X9Y4:RAMB36_X9Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_60]
create_pblock pblock_61
add_cells_to_pblock [get_pblocks pblock_61] [get_cells -quiet [list sym_i/zcore32_61]]
resize_pblock [get_pblocks pblock_61] -add {SLICE_X82Y10:SLICE_X87Y59}
resize_pblock [get_pblocks pblock_61] -add {DSP48E2_X16Y4:DSP48E2_X16Y23}
resize_pblock [get_pblocks pblock_61] -add {RAMB18_X11Y4:RAMB18_X11Y23}
resize_pblock [get_pblocks pblock_61] -add {RAMB36_X11Y2:RAMB36_X11Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_61]
create_pblock pblock_62
add_cells_to_pblock [get_pblocks pblock_62] [get_cells -quiet [list sym_i/zcore32_62]]
resize_pblock [get_pblocks pblock_62] -add {SLICE_X90Y20:SLICE_X95Y59}
resize_pblock [get_pblocks pblock_62] -add {DSP48E2_X17Y8:DSP48E2_X17Y23}
resize_pblock [get_pblocks pblock_62] -add {RAMB18_X12Y8:RAMB18_X12Y23}
resize_pblock [get_pblocks pblock_62] -add {RAMB36_X12Y4:RAMB36_X12Y11}
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





