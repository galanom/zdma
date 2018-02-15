set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_0]
create_pblock pblock_0
add_cells_to_pblock [get_pblocks pblock_0] [get_cells -quiet [list sym_i/zcore32_0]]
resize_pblock [get_pblocks pblock_0] -add {SLICE_X1Y390:SLICE_X9Y419}
resize_pblock [get_pblocks pblock_0] -add {DSP48E2_X0Y156:DSP48E2_X0Y167}
resize_pblock [get_pblocks pblock_0] -add {RAMB18_X0Y156:RAMB18_X1Y167}
resize_pblock [get_pblocks pblock_0] -add {RAMB36_X0Y78:RAMB36_X1Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_0]

create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list sym_i/zcore32_1]]
resize_pblock [get_pblocks pblock_1] -add {SLICE_X11Y390:SLICE_X18Y419}
resize_pblock [get_pblocks pblock_1] -add {DSP48E2_X2Y156:DSP48E2_X2Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X2Y156:RAMB18_X2Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X2Y78:RAMB36_X2Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_1]

create_pblock pblock_2
add_cells_to_pblock [get_pblocks pblock_2] [get_cells -quiet [list sym_i/zcore32_2]]
resize_pblock [get_pblocks pblock_2] -add {SLICE_X20Y390:SLICE_X27Y419}
resize_pblock [get_pblocks pblock_2] -add {DSP48E2_X4Y156:DSP48E2_X4Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB18_X3Y156:RAMB18_X3Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB36_X3Y78:RAMB36_X3Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_2]

create_pblock pblock_3
add_cells_to_pblock [get_pblocks pblock_3] [get_cells -quiet [list sym_i/zcore32_3]]
resize_pblock [get_pblocks pblock_3] -add {SLICE_X34Y390:SLICE_X42Y419}
resize_pblock [get_pblocks pblock_3] -add {DSP48E2_X6Y156:DSP48E2_X7Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB18_X5Y156:RAMB18_X5Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB36_X5Y78:RAMB36_X5Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_3]

create_pblock pblock_4
add_cells_to_pblock [get_pblocks pblock_4] [get_cells -quiet [list sym_i/zcore32_4]]
resize_pblock [get_pblocks pblock_4] -add {SLICE_X46Y390:SLICE_X54Y419}
resize_pblock [get_pblocks pblock_4] -add {DSP48E2_X9Y156:DSP48E2_X10Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB18_X6Y156:RAMB18_X6Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB36_X6Y78:RAMB36_X6Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_4]

create_pblock pblock_5
add_cells_to_pblock [get_pblocks pblock_5] [get_cells -quiet [list sym_i/zcore32_5]]
resize_pblock [get_pblocks pblock_5] -add {SLICE_X62Y390:SLICE_X69Y419}
resize_pblock [get_pblocks pblock_5] -add {DSP48E2_X13Y156:DSP48E2_X13Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB18_X8Y156:RAMB18_X8Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB36_X8Y78:RAMB36_X8Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_5]

create_pblock pblock_6
add_cells_to_pblock [get_pblocks pblock_6] [get_cells -quiet [list sym_i/zcore32_6]]
resize_pblock [get_pblocks pblock_6] -add {SLICE_X76Y390:SLICE_X83Y419}
resize_pblock [get_pblocks pblock_6] -add {DSP48E2_X15Y156:DSP48E2_X15Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB18_X10Y156:RAMB18_X10Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB36_X10Y78:RAMB36_X10Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_6]

create_pblock pblock_7
add_cells_to_pblock [get_pblocks pblock_7] [get_cells -quiet [list sym_i/zcore32_7]]
resize_pblock [get_pblocks pblock_7] -add {SLICE_X88Y390:SLICE_X95Y419}
resize_pblock [get_pblocks pblock_7] -add {DSP48E2_X17Y156:DSP48E2_X17Y167}
resize_pblock [get_pblocks pblock_7] -add {RAMB18_X12Y156:RAMB18_X12Y167}
resize_pblock [get_pblocks pblock_7] -add {RAMB36_X12Y78:RAMB36_X12Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_7]


create_pblock pblock_9
add_cells_to_pblock [get_pblocks pblock_9] [get_cells -quiet [list sym_i/zcore32_9]]
resize_pblock [get_pblocks pblock_9] -add {SLICE_X76Y330:SLICE_X83Y359}
resize_pblock [get_pblocks pblock_9] -add {DSP48E2_X15Y132:DSP48E2_X15Y143}
resize_pblock [get_pblocks pblock_9] -add {RAMB18_X10Y132:RAMB18_X10Y143}
resize_pblock [get_pblocks pblock_9] -add {RAMB36_X10Y66:RAMB36_X10Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_9]

create_pblock pblock_10
add_cells_to_pblock [get_pblocks pblock_10] [get_cells -quiet [list sym_i/zcore32_10]]
resize_pblock [get_pblocks pblock_10] -add {SLICE_X62Y330:SLICE_X69Y359}
resize_pblock [get_pblocks pblock_10] -add {DSP48E2_X13Y132:DSP48E2_X13Y143}
resize_pblock [get_pblocks pblock_10] -add {RAMB18_X8Y132:RAMB18_X8Y143}
resize_pblock [get_pblocks pblock_10] -add {RAMB36_X8Y66:RAMB36_X8Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_10]

create_pblock pblock_11
add_cells_to_pblock [get_pblocks pblock_11] [get_cells -quiet [list sym_i/zcore32_11]]
resize_pblock [get_pblocks pblock_11] -add {SLICE_X46Y330:SLICE_X54Y359}
resize_pblock [get_pblocks pblock_11] -add {DSP48E2_X9Y132:DSP48E2_X10Y143}
resize_pblock [get_pblocks pblock_11] -add {RAMB18_X6Y132:RAMB18_X6Y143}
resize_pblock [get_pblocks pblock_11] -add {RAMB36_X6Y66:RAMB36_X6Y71}
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
resize_pblock [get_pblocks pblock_12] -add {SLICE_X34Y330:SLICE_X42Y359}
resize_pblock [get_pblocks pblock_12] -add {DSP48E2_X6Y132:DSP48E2_X7Y143}
resize_pblock [get_pblocks pblock_12] -add {RAMB18_X5Y132:RAMB18_X5Y143}
resize_pblock [get_pblocks pblock_12] -add {RAMB36_X5Y66:RAMB36_X5Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_12]

create_pblock pblock_13
add_cells_to_pblock [get_pblocks pblock_13] [get_cells -quiet [list sym_i/zcore32_13]]
resize_pblock [get_pblocks pblock_13] -add {SLICE_X20Y330:SLICE_X27Y359}
resize_pblock [get_pblocks pblock_13] -add {DSP48E2_X4Y132:DSP48E2_X4Y143}
resize_pblock [get_pblocks pblock_13] -add {RAMB18_X3Y132:RAMB18_X3Y143}
resize_pblock [get_pblocks pblock_13] -add {RAMB36_X3Y66:RAMB36_X3Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_13]

create_pblock pblock_14
add_cells_to_pblock [get_pblocks pblock_14] [get_cells -quiet [list sym_i/zcore32_14]]
resize_pblock [get_pblocks pblock_14] -add {SLICE_X11Y330:SLICE_X18Y359}
resize_pblock [get_pblocks pblock_14] -add {DSP48E2_X2Y132:DSP48E2_X2Y143}
resize_pblock [get_pblocks pblock_14] -add {RAMB18_X2Y132:RAMB18_X2Y143}
resize_pblock [get_pblocks pblock_14] -add {RAMB36_X2Y66:RAMB36_X2Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_14]

create_pblock pblock_15
add_cells_to_pblock [get_pblocks pblock_15] [get_cells -quiet [list sym_i/zcore32_15]]
resize_pblock [get_pblocks pblock_15] -add {SLICE_X1Y330:SLICE_X9Y359}
resize_pblock [get_pblocks pblock_15] -add {DSP48E2_X0Y132:DSP48E2_X0Y143}
resize_pblock [get_pblocks pblock_15] -add {RAMB18_X0Y132:RAMB18_X1Y143}
resize_pblock [get_pblocks pblock_15] -add {RAMB36_X0Y66:RAMB36_X1Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_15]

create_pblock pblock_16
add_cells_to_pblock [get_pblocks pblock_16] [get_cells -quiet [list sym_i/zcore32_16]]
resize_pblock [get_pblocks pblock_16] -add {SLICE_X1Y270:SLICE_X9Y299}
resize_pblock [get_pblocks pblock_16] -add {DSP48E2_X0Y108:DSP48E2_X0Y119}
resize_pblock [get_pblocks pblock_16] -add {RAMB18_X0Y108:RAMB18_X1Y119}
resize_pblock [get_pblocks pblock_16] -add {RAMB36_X0Y54:RAMB36_X1Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_16]

create_pblock pblock_17
add_cells_to_pblock [get_pblocks pblock_17] [get_cells -quiet [list sym_i/zcore32_17]]
resize_pblock [get_pblocks pblock_17] -add {SLICE_X11Y270:SLICE_X18Y299}
resize_pblock [get_pblocks pblock_17] -add {DSP48E2_X2Y108:DSP48E2_X2Y119}
resize_pblock [get_pblocks pblock_17] -add {RAMB18_X2Y108:RAMB18_X2Y119}
resize_pblock [get_pblocks pblock_17] -add {RAMB36_X2Y54:RAMB36_X2Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_17]

create_pblock pblock_18
add_cells_to_pblock [get_pblocks pblock_18] [get_cells -quiet [list sym_i/zcore32_18]]
resize_pblock [get_pblocks pblock_18] -add {SLICE_X20Y270:SLICE_X27Y299}
resize_pblock [get_pblocks pblock_18] -add {DSP48E2_X4Y108:DSP48E2_X4Y119}
resize_pblock [get_pblocks pblock_18] -add {RAMB18_X3Y108:RAMB18_X3Y119}
resize_pblock [get_pblocks pblock_18] -add {RAMB36_X3Y54:RAMB36_X3Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_18]

create_pblock pblock_19
add_cells_to_pblock [get_pblocks pblock_19] [get_cells -quiet [list sym_i/zcore32_19]]
resize_pblock [get_pblocks pblock_19] -add {SLICE_X34Y270:SLICE_X42Y299}
resize_pblock [get_pblocks pblock_19] -add {DSP48E2_X6Y108:DSP48E2_X7Y119}
resize_pblock [get_pblocks pblock_19] -add {RAMB18_X5Y108:RAMB18_X5Y119}
resize_pblock [get_pblocks pblock_19] -add {RAMB36_X5Y54:RAMB36_X5Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_19]

create_pblock pblock_20
add_cells_to_pblock [get_pblocks pblock_20] [get_cells -quiet [list sym_i/zcore32_20]]
resize_pblock [get_pblocks pblock_20] -add {SLICE_X46Y270:SLICE_X54Y299}
resize_pblock [get_pblocks pblock_20] -add {DSP48E2_X9Y108:DSP48E2_X10Y119}
resize_pblock [get_pblocks pblock_20] -add {RAMB18_X6Y108:RAMB18_X6Y119}
resize_pblock [get_pblocks pblock_20] -add {RAMB36_X6Y54:RAMB36_X6Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_20]

create_pblock pblock_21
add_cells_to_pblock [get_pblocks pblock_21] [get_cells -quiet [list sym_i/zcore32_21]]
resize_pblock [get_pblocks pblock_21] -add {SLICE_X62Y270:SLICE_X69Y299}
resize_pblock [get_pblocks pblock_21] -add {DSP48E2_X13Y108:DSP48E2_X13Y119}
resize_pblock [get_pblocks pblock_21] -add {RAMB18_X8Y108:RAMB18_X8Y119}
resize_pblock [get_pblocks pblock_21] -add {RAMB36_X8Y54:RAMB36_X8Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_21]

create_pblock pblock_22
add_cells_to_pblock [get_pblocks pblock_22] [get_cells -quiet [list sym_i/zcore32_22]]
resize_pblock [get_pblocks pblock_22] -add {SLICE_X76Y270:SLICE_X83Y299}
resize_pblock [get_pblocks pblock_22] -add {DSP48E2_X15Y108:DSP48E2_X15Y119}
resize_pblock [get_pblocks pblock_22] -add {RAMB18_X10Y108:RAMB18_X10Y119}
resize_pblock [get_pblocks pblock_22] -add {RAMB36_X10Y54:RAMB36_X10Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_22]

create_pblock pblock_23
add_cells_to_pblock [get_pblocks pblock_23] [get_cells -quiet [list sym_i/zcore32_23]]
resize_pblock [get_pblocks pblock_23] -add {SLICE_X88Y270:SLICE_X95Y299}
resize_pblock [get_pblocks pblock_23] -add {DSP48E2_X17Y108:DSP48E2_X17Y119}
resize_pblock [get_pblocks pblock_23] -add {RAMB18_X12Y108:RAMB18_X12Y119}
resize_pblock [get_pblocks pblock_23] -add {RAMB36_X12Y54:RAMB36_X12Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_23]

create_pblock pblock_24
add_cells_to_pblock [get_pblocks pblock_24] [get_cells -quiet [list sym_i/zcore32_24]]
resize_pblock [get_pblocks pblock_24] -add {SLICE_X88Y210:SLICE_X95Y239}
resize_pblock [get_pblocks pblock_24] -add {DSP48E2_X17Y84:DSP48E2_X17Y95}
resize_pblock [get_pblocks pblock_24] -add {RAMB18_X12Y84:RAMB18_X12Y95}
resize_pblock [get_pblocks pblock_24] -add {RAMB36_X12Y42:RAMB36_X12Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_24]

create_pblock pblock_25
add_cells_to_pblock [get_pblocks pblock_25] [get_cells -quiet [list sym_i/zcore32_25]]
resize_pblock [get_pblocks pblock_25] -add {SLICE_X76Y210:SLICE_X83Y239}
resize_pblock [get_pblocks pblock_25] -add {DSP48E2_X15Y84:DSP48E2_X15Y95}
resize_pblock [get_pblocks pblock_25] -add {RAMB18_X10Y84:RAMB18_X10Y95}
resize_pblock [get_pblocks pblock_25] -add {RAMB36_X10Y42:RAMB36_X10Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_25]

create_pblock pblock_26
add_cells_to_pblock [get_pblocks pblock_26] [get_cells -quiet [list sym_i/zcore32_26]]
resize_pblock [get_pblocks pblock_26] -add {SLICE_X62Y210:SLICE_X69Y239}
resize_pblock [get_pblocks pblock_26] -add {DSP48E2_X13Y84:DSP48E2_X13Y95}
resize_pblock [get_pblocks pblock_26] -add {RAMB18_X8Y84:RAMB18_X8Y95}
resize_pblock [get_pblocks pblock_26] -add {RAMB36_X8Y42:RAMB36_X8Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_26]

create_pblock pblock_27
add_cells_to_pblock [get_pblocks pblock_27] [get_cells -quiet [list sym_i/zcore32_27]]
resize_pblock [get_pblocks pblock_27] -add {SLICE_X46Y210:SLICE_X54Y239}
resize_pblock [get_pblocks pblock_27] -add {DSP48E2_X9Y84:DSP48E2_X10Y95}
resize_pblock [get_pblocks pblock_27] -add {RAMB18_X6Y84:RAMB18_X6Y95}
resize_pblock [get_pblocks pblock_27] -add {RAMB36_X6Y42:RAMB36_X6Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_27]

create_pblock pblock_28
add_cells_to_pblock [get_pblocks pblock_28] [get_cells -quiet [list sym_i/zcore32_28]]
resize_pblock [get_pblocks pblock_28] -add {SLICE_X34Y210:SLICE_X42Y239}
resize_pblock [get_pblocks pblock_28] -add {DSP48E2_X6Y84:DSP48E2_X7Y95}
resize_pblock [get_pblocks pblock_28] -add {RAMB18_X5Y84:RAMB18_X5Y95}
resize_pblock [get_pblocks pblock_28] -add {RAMB36_X5Y42:RAMB36_X5Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_28]

create_pblock pblock_29
add_cells_to_pblock [get_pblocks pblock_29] [get_cells -quiet [list sym_i/zcore32_29]]
resize_pblock [get_pblocks pblock_29] -add {SLICE_X20Y210:SLICE_X27Y239}
resize_pblock [get_pblocks pblock_29] -add {DSP48E2_X4Y84:DSP48E2_X4Y95}
resize_pblock [get_pblocks pblock_29] -add {RAMB18_X3Y84:RAMB18_X3Y95}
resize_pblock [get_pblocks pblock_29] -add {RAMB36_X3Y42:RAMB36_X3Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_29]

create_pblock pblock_30
add_cells_to_pblock [get_pblocks pblock_30] [get_cells -quiet [list sym_i/zcore32_30]]
resize_pblock [get_pblocks pblock_30] -add {SLICE_X11Y210:SLICE_X18Y239}
resize_pblock [get_pblocks pblock_30] -add {DSP48E2_X2Y84:DSP48E2_X2Y95}
resize_pblock [get_pblocks pblock_30] -add {RAMB18_X2Y84:RAMB18_X2Y95}
resize_pblock [get_pblocks pblock_30] -add {RAMB36_X2Y42:RAMB36_X2Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_30]

create_pblock pblock_31
add_cells_to_pblock [get_pblocks pblock_31] [get_cells -quiet [list sym_i/zcore32_31]]
resize_pblock [get_pblocks pblock_31] -add {SLICE_X1Y210:SLICE_X9Y239}
resize_pblock [get_pblocks pblock_31] -add {DSP48E2_X0Y84:DSP48E2_X0Y95}
resize_pblock [get_pblocks pblock_31] -add {RAMB18_X0Y84:RAMB18_X1Y95}
resize_pblock [get_pblocks pblock_31] -add {RAMB36_X0Y42:RAMB36_X1Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_31]

create_pblock pblock_32
add_cells_to_pblock [get_pblocks pblock_32] [get_cells -quiet [list sym_i/zcore32_32]]
resize_pblock [get_pblocks pblock_32] -add {SLICE_X37Y150:SLICE_X45Y179}
resize_pblock [get_pblocks pblock_32] -add {DSP48E2_X7Y60:DSP48E2_X8Y71}
resize_pblock [get_pblocks pblock_32] -add {RAMB18_X5Y60:RAMB18_X5Y71}
resize_pblock [get_pblocks pblock_32] -add {RAMB36_X5Y30:RAMB36_X5Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_32]

create_pblock pblock_33
add_cells_to_pblock [get_pblocks pblock_33] [get_cells -quiet [list sym_i/zcore32_33]]
resize_pblock [get_pblocks pblock_33] -add {SLICE_X53Y150:SLICE_X61Y179}
resize_pblock [get_pblocks pblock_33] -add {DSP48E2_X11Y60:DSP48E2_X12Y71}
resize_pblock [get_pblocks pblock_33] -add {RAMB18_X7Y60:RAMB18_X7Y71}
resize_pblock [get_pblocks pblock_33] -add {RAMB36_X7Y30:RAMB36_X7Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_33]

create_pblock pblock_34
add_cells_to_pblock [get_pblocks pblock_34] [get_cells -quiet [list sym_i/zcore32_34]]
resize_pblock [get_pblocks pblock_34] -add {SLICE_X64Y150:SLICE_X71Y179}
resize_pblock [get_pblocks pblock_34] -add {DSP48E2_X13Y60:DSP48E2_X13Y71}
resize_pblock [get_pblocks pblock_34] -add {RAMB18_X8Y60:RAMB18_X8Y71}
resize_pblock [get_pblocks pblock_34] -add {RAMB36_X8Y30:RAMB36_X8Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_34]

create_pblock pblock_35
add_cells_to_pblock [get_pblocks pblock_35] [get_cells -quiet [list sym_i/zcore32_35]]
resize_pblock [get_pblocks pblock_35] -add {SLICE_X76Y150:SLICE_X83Y179}
resize_pblock [get_pblocks pblock_35] -add {DSP48E2_X15Y60:DSP48E2_X15Y71}
resize_pblock [get_pblocks pblock_35] -add {RAMB18_X10Y60:RAMB18_X10Y71}
resize_pblock [get_pblocks pblock_35] -add {RAMB36_X10Y30:RAMB36_X10Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_35]

create_pblock pblock_36
add_cells_to_pblock [get_pblocks pblock_36] [get_cells -quiet [list sym_i/zcore32_36]]
resize_pblock [get_pblocks pblock_36] -add {SLICE_X88Y150:SLICE_X95Y179}
resize_pblock [get_pblocks pblock_36] -add {DSP48E2_X17Y60:DSP48E2_X17Y71}
resize_pblock [get_pblocks pblock_36] -add {RAMB18_X12Y60:RAMB18_X12Y71}
resize_pblock [get_pblocks pblock_36] -add {RAMB36_X12Y30:RAMB36_X12Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_36]

create_pblock pblock_37
add_cells_to_pblock [get_pblocks pblock_37] [get_cells -quiet [list sym_i/zcore32_37]]
resize_pblock [get_pblocks pblock_37] -add {SLICE_X88Y90:SLICE_X95Y119}
resize_pblock [get_pblocks pblock_37] -add {DSP48E2_X17Y36:DSP48E2_X17Y47}
resize_pblock [get_pblocks pblock_37] -add {RAMB18_X12Y36:RAMB18_X12Y47}
resize_pblock [get_pblocks pblock_37] -add {RAMB36_X12Y18:RAMB36_X12Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_37]

create_pblock pblock_38
add_cells_to_pblock [get_pblocks pblock_38] [get_cells -quiet [list sym_i/zcore32_38]]
resize_pblock [get_pblocks pblock_38] -add {SLICE_X76Y90:SLICE_X84Y119}
resize_pblock [get_pblocks pblock_38] -add {DSP48E2_X15Y36:DSP48E2_X15Y47}
resize_pblock [get_pblocks pblock_38] -add {RAMB18_X10Y36:RAMB18_X11Y47}
resize_pblock [get_pblocks pblock_38] -add {RAMB36_X10Y18:RAMB36_X11Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_38]

create_pblock pblock_39
add_cells_to_pblock [get_pblocks pblock_39] [get_cells -quiet [list sym_i/zcore32_39]]
resize_pblock [get_pblocks pblock_39] -add {SLICE_X66Y90:SLICE_X73Y119}
resize_pblock [get_pblocks pblock_39] -add {DSP48E2_X13Y36:DSP48E2_X14Y47}
resize_pblock [get_pblocks pblock_39] -add {RAMB18_X8Y36:RAMB18_X9Y47}
resize_pblock [get_pblocks pblock_39] -add {RAMB36_X8Y18:RAMB36_X9Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_39]

create_pblock pblock_40
add_cells_to_pblock [get_pblocks pblock_40] [get_cells -quiet [list sym_i/zcore32_40]]
resize_pblock [get_pblocks pblock_40] -add {SLICE_X58Y90:SLICE_X65Y119}
resize_pblock [get_pblocks pblock_40] -add {DSP48E2_X12Y36:DSP48E2_X12Y47}
resize_pblock [get_pblocks pblock_40] -add {RAMB18_X7Y36:RAMB18_X7Y47}
resize_pblock [get_pblocks pblock_40] -add {RAMB36_X7Y18:RAMB36_X7Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_40]

create_pblock pblock_41
add_cells_to_pblock [get_pblocks pblock_41] [get_cells -quiet [list sym_i/zcore32_41]]
resize_pblock [get_pblocks pblock_41] -add {SLICE_X48Y90:SLICE_X55Y119}
resize_pblock [get_pblocks pblock_41] -add {DSP48E2_X9Y36:DSP48E2_X11Y47}
resize_pblock [get_pblocks pblock_41] -add {RAMB18_X6Y36:RAMB18_X6Y47}
resize_pblock [get_pblocks pblock_41] -add {RAMB36_X6Y18:RAMB36_X6Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_41]

create_pblock pblock_42
add_cells_to_pblock [get_pblocks pblock_42] [get_cells -quiet [list sym_i/zcore32_42]]
resize_pblock [get_pblocks pblock_42] -add {SLICE_X37Y90:SLICE_X45Y119}
resize_pblock [get_pblocks pblock_42] -add {DSP48E2_X7Y36:DSP48E2_X8Y47}
resize_pblock [get_pblocks pblock_42] -add {RAMB18_X5Y36:RAMB18_X5Y47}
resize_pblock [get_pblocks pblock_42] -add {RAMB36_X5Y18:RAMB36_X5Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_42]

create_pblock pblock_43
add_cells_to_pblock [get_pblocks pblock_43] [get_cells -quiet [list sym_i/zcore32_43]]
resize_pblock [get_pblocks pblock_43] -add {SLICE_X37Y30:SLICE_X45Y59}
resize_pblock [get_pblocks pblock_43] -add {DSP48E2_X7Y12:DSP48E2_X8Y23}
resize_pblock [get_pblocks pblock_43] -add {RAMB18_X5Y12:RAMB18_X5Y23}
resize_pblock [get_pblocks pblock_43] -add {RAMB36_X5Y6:RAMB36_X5Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_43]

create_pblock pblock_44
add_cells_to_pblock [get_pblocks pblock_44] [get_cells -quiet [list sym_i/zcore32_44]]
resize_pblock [get_pblocks pblock_44] -add {SLICE_X53Y30:SLICE_X61Y59}
resize_pblock [get_pblocks pblock_44] -add {DSP48E2_X11Y12:DSP48E2_X12Y23}
resize_pblock [get_pblocks pblock_44] -add {RAMB18_X7Y12:RAMB18_X7Y23}
resize_pblock [get_pblocks pblock_44] -add {RAMB36_X7Y6:RAMB36_X7Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_44]

create_pblock pblock_45
add_cells_to_pblock [get_pblocks pblock_45] [get_cells -quiet [list sym_i/zcore32_45]]
resize_pblock [get_pblocks pblock_45] -add {SLICE_X64Y30:SLICE_X72Y59}
resize_pblock [get_pblocks pblock_45] -add {DSP48E2_X13Y12:DSP48E2_X13Y23}
resize_pblock [get_pblocks pblock_45] -add {RAMB18_X8Y12:RAMB18_X9Y23}
resize_pblock [get_pblocks pblock_45] -add {RAMB36_X8Y6:RAMB36_X9Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_45]

create_pblock pblock_46
add_cells_to_pblock [get_pblocks pblock_46] [get_cells -quiet [list sym_i/zcore32_46]]
resize_pblock [get_pblocks pblock_46] -add {SLICE_X76Y30:SLICE_X83Y59}
resize_pblock [get_pblocks pblock_46] -add {DSP48E2_X15Y12:DSP48E2_X15Y23}
resize_pblock [get_pblocks pblock_46] -add {RAMB18_X10Y12:RAMB18_X10Y23}
resize_pblock [get_pblocks pblock_46] -add {RAMB36_X10Y6:RAMB36_X10Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_46]

create_pblock pblock_47
add_cells_to_pblock [get_pblocks pblock_47] [get_cells -quiet [list sym_i/zcore32_47]]
resize_pblock [get_pblocks pblock_47] -add {SLICE_X88Y30:SLICE_X95Y59}
resize_pblock [get_pblocks pblock_47] -add {DSP48E2_X17Y12:DSP48E2_X17Y23}
resize_pblock [get_pblocks pblock_47] -add {RAMB18_X12Y12:RAMB18_X12Y23}
resize_pblock [get_pblocks pblock_47] -add {RAMB36_X12Y6:RAMB36_X12Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_47]

create_pblock pblock_8
add_cells_to_pblock [get_pblocks pblock_8] [get_cells -quiet [list sym_i/zcore32_8]]
resize_pblock [get_pblocks pblock_8] -add {SLICE_X88Y330:SLICE_X95Y359}
resize_pblock [get_pblocks pblock_8] -add {DSP48E2_X17Y132:DSP48E2_X17Y143}
resize_pblock [get_pblocks pblock_8] -add {RAMB18_X12Y132:RAMB18_X12Y143}
resize_pblock [get_pblocks pblock_8] -add {RAMB36_X12Y66:RAMB36_X12Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_8]











