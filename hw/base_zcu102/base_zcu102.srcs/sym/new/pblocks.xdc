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
resize_pblock [get_pblocks pblock_1] -add {SLICE_X13Y380:SLICE_X18Y419}
resize_pblock [get_pblocks pblock_1] -add {DSP48E2_X2Y152:DSP48E2_X2Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X2Y152:RAMB18_X2Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X2Y76:RAMB36_X2Y83}
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
resize_pblock [get_pblocks pblock_3] -add {SLICE_X34Y380:SLICE_X39Y419}
resize_pblock [get_pblocks pblock_3] -add {DSP48E2_X6Y152:DSP48E2_X6Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB18_X5Y152:RAMB18_X5Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB36_X5Y76:RAMB36_X5Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_3]

create_pblock pblock_4
add_cells_to_pblock [get_pblocks pblock_4] [get_cells -quiet [list sym_i/zcore32_4]]
resize_pblock [get_pblocks pblock_4] -add {SLICE_X48Y385:SLICE_X54Y419}
resize_pblock [get_pblocks pblock_4] -add {DSP48E2_X9Y154:DSP48E2_X10Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB18_X6Y154:RAMB18_X6Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB36_X6Y77:RAMB36_X6Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_4]

create_pblock pblock_5
add_cells_to_pblock [get_pblocks pblock_5] [get_cells -quiet [list sym_i/zcore32_5]]
resize_pblock [get_pblocks pblock_5] -add {SLICE_X64Y380:SLICE_X69Y419}
resize_pblock [get_pblocks pblock_5] -add {DSP48E2_X13Y152:DSP48E2_X13Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB18_X8Y152:RAMB18_X8Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB36_X8Y76:RAMB36_X8Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_5]

create_pblock pblock_6
add_cells_to_pblock [get_pblocks pblock_6] [get_cells -quiet [list sym_i/zcore32_6]]
resize_pblock [get_pblocks pblock_6] -add {SLICE_X76Y380:SLICE_X81Y419}
resize_pblock [get_pblocks pblock_6] -add {DSP48E2_X15Y152:DSP48E2_X15Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB18_X10Y152:RAMB18_X10Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB36_X10Y76:RAMB36_X10Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_6]

create_pblock pblock_7
add_cells_to_pblock [get_pblocks pblock_7] [get_cells -quiet [list sym_i/zcore32_7]]
resize_pblock [get_pblocks pblock_7] -add {SLICE_X90Y380:SLICE_X95Y419}
resize_pblock [get_pblocks pblock_7] -add {DSP48E2_X17Y152:DSP48E2_X17Y167}
resize_pblock [get_pblocks pblock_7] -add {RAMB18_X12Y152:RAMB18_X12Y167}
resize_pblock [get_pblocks pblock_7] -add {RAMB36_X12Y76:RAMB36_X12Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_7]


create_pblock pblock_9
add_cells_to_pblock [get_pblocks pblock_9] [get_cells -quiet [list sym_i/zcore32_9]]
resize_pblock [get_pblocks pblock_9] -add {SLICE_X76Y320:SLICE_X81Y359}
resize_pblock [get_pblocks pblock_9] -add {DSP48E2_X15Y128:DSP48E2_X15Y143}
resize_pblock [get_pblocks pblock_9] -add {RAMB18_X10Y128:RAMB18_X10Y143}
resize_pblock [get_pblocks pblock_9] -add {RAMB36_X10Y64:RAMB36_X10Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_9]

create_pblock pblock_10
add_cells_to_pblock [get_pblocks pblock_10] [get_cells -quiet [list sym_i/zcore32_10]]
resize_pblock [get_pblocks pblock_10] -add {SLICE_X64Y320:SLICE_X69Y359}
resize_pblock [get_pblocks pblock_10] -add {DSP48E2_X13Y128:DSP48E2_X13Y143}
resize_pblock [get_pblocks pblock_10] -add {RAMB18_X8Y128:RAMB18_X8Y143}
resize_pblock [get_pblocks pblock_10] -add {RAMB36_X8Y64:RAMB36_X8Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_10]

create_pblock pblock_11
add_cells_to_pblock [get_pblocks pblock_11] [get_cells -quiet [list sym_i/zcore32_11]]
resize_pblock [get_pblocks pblock_11] -add {SLICE_X48Y325:SLICE_X54Y359}
resize_pblock [get_pblocks pblock_11] -add {DSP48E2_X9Y130:DSP48E2_X10Y143}
resize_pblock [get_pblocks pblock_11] -add {RAMB18_X6Y130:RAMB18_X6Y143}
resize_pblock [get_pblocks pblock_11] -add {RAMB36_X6Y65:RAMB36_X6Y71}
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
resize_pblock [get_pblocks pblock_12] -add {SLICE_X34Y320:SLICE_X39Y359}
resize_pblock [get_pblocks pblock_12] -add {DSP48E2_X6Y128:DSP48E2_X6Y143}
resize_pblock [get_pblocks pblock_12] -add {RAMB18_X5Y128:RAMB18_X5Y143}
resize_pblock [get_pblocks pblock_12] -add {RAMB36_X5Y64:RAMB36_X5Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_12]

create_pblock pblock_13
add_cells_to_pblock [get_pblocks pblock_13] [get_cells -quiet [list sym_i/zcore32_13]]
resize_pblock [get_pblocks pblock_13] -add {SLICE_X22Y320:SLICE_X27Y359}
resize_pblock [get_pblocks pblock_13] -add {DSP48E2_X4Y128:DSP48E2_X4Y143}
resize_pblock [get_pblocks pblock_13] -add {RAMB18_X3Y128:RAMB18_X3Y143}
resize_pblock [get_pblocks pblock_13] -add {RAMB36_X3Y64:RAMB36_X3Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_13]

create_pblock pblock_14
add_cells_to_pblock [get_pblocks pblock_14] [get_cells -quiet [list sym_i/zcore32_14]]
resize_pblock [get_pblocks pblock_14] -add {SLICE_X13Y320:SLICE_X18Y359}
resize_pblock [get_pblocks pblock_14] -add {DSP48E2_X2Y128:DSP48E2_X2Y143}
resize_pblock [get_pblocks pblock_14] -add {RAMB18_X2Y128:RAMB18_X2Y143}
resize_pblock [get_pblocks pblock_14] -add {RAMB36_X2Y64:RAMB36_X2Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_14]

create_pblock pblock_15
add_cells_to_pblock [get_pblocks pblock_15] [get_cells -quiet [list sym_i/zcore32_15]]
resize_pblock [get_pblocks pblock_15] -add {SLICE_X1Y320:SLICE_X6Y359}
resize_pblock [get_pblocks pblock_15] -add {DSP48E2_X0Y128:DSP48E2_X0Y143}
resize_pblock [get_pblocks pblock_15] -add {RAMB18_X0Y128:RAMB18_X0Y143}
resize_pblock [get_pblocks pblock_15] -add {RAMB36_X0Y64:RAMB36_X0Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_15]

create_pblock pblock_16
add_cells_to_pblock [get_pblocks pblock_16] [get_cells -quiet [list sym_i/zcore32_16]]
resize_pblock [get_pblocks pblock_16] -add {SLICE_X1Y260:SLICE_X6Y299}
resize_pblock [get_pblocks pblock_16] -add {DSP48E2_X0Y104:DSP48E2_X0Y119}
resize_pblock [get_pblocks pblock_16] -add {RAMB18_X0Y104:RAMB18_X0Y119}
resize_pblock [get_pblocks pblock_16] -add {RAMB36_X0Y52:RAMB36_X0Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_16]

create_pblock pblock_17
add_cells_to_pblock [get_pblocks pblock_17] [get_cells -quiet [list sym_i/zcore32_17]]
resize_pblock [get_pblocks pblock_17] -add {SLICE_X13Y260:SLICE_X18Y299}
resize_pblock [get_pblocks pblock_17] -add {DSP48E2_X2Y104:DSP48E2_X2Y119}
resize_pblock [get_pblocks pblock_17] -add {RAMB18_X2Y104:RAMB18_X2Y119}
resize_pblock [get_pblocks pblock_17] -add {RAMB36_X2Y52:RAMB36_X2Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_17]

create_pblock pblock_18
add_cells_to_pblock [get_pblocks pblock_18] [get_cells -quiet [list sym_i/zcore32_18]]
resize_pblock [get_pblocks pblock_18] -add {SLICE_X22Y260:SLICE_X27Y299}
resize_pblock [get_pblocks pblock_18] -add {DSP48E2_X4Y104:DSP48E2_X4Y119}
resize_pblock [get_pblocks pblock_18] -add {RAMB18_X3Y104:RAMB18_X3Y119}
resize_pblock [get_pblocks pblock_18] -add {RAMB36_X3Y52:RAMB36_X3Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_18]

create_pblock pblock_19
add_cells_to_pblock [get_pblocks pblock_19] [get_cells -quiet [list sym_i/zcore32_19]]
resize_pblock [get_pblocks pblock_19] -add {SLICE_X34Y260:SLICE_X39Y299}
resize_pblock [get_pblocks pblock_19] -add {DSP48E2_X6Y104:DSP48E2_X6Y119}
resize_pblock [get_pblocks pblock_19] -add {RAMB18_X5Y104:RAMB18_X5Y119}
resize_pblock [get_pblocks pblock_19] -add {RAMB36_X5Y52:RAMB36_X5Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_19]

create_pblock pblock_20
add_cells_to_pblock [get_pblocks pblock_20] [get_cells -quiet [list sym_i/zcore32_20]]
resize_pblock [get_pblocks pblock_20] -add {SLICE_X48Y260:SLICE_X54Y299}
resize_pblock [get_pblocks pblock_20] -add {DSP48E2_X9Y104:DSP48E2_X10Y119}
resize_pblock [get_pblocks pblock_20] -add {RAMB18_X6Y104:RAMB18_X6Y119}
resize_pblock [get_pblocks pblock_20] -add {RAMB36_X6Y52:RAMB36_X6Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_20]

create_pblock pblock_21
add_cells_to_pblock [get_pblocks pblock_21] [get_cells -quiet [list sym_i/zcore32_21]]
resize_pblock [get_pblocks pblock_21] -add {SLICE_X64Y260:SLICE_X69Y299}
resize_pblock [get_pblocks pblock_21] -add {DSP48E2_X13Y104:DSP48E2_X13Y119}
resize_pblock [get_pblocks pblock_21] -add {RAMB18_X8Y104:RAMB18_X8Y119}
resize_pblock [get_pblocks pblock_21] -add {RAMB36_X8Y52:RAMB36_X8Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_21]

create_pblock pblock_22
add_cells_to_pblock [get_pblocks pblock_22] [get_cells -quiet [list sym_i/zcore32_22]]
resize_pblock [get_pblocks pblock_22] -add {SLICE_X76Y260:SLICE_X81Y299}
resize_pblock [get_pblocks pblock_22] -add {DSP48E2_X15Y104:DSP48E2_X15Y119}
resize_pblock [get_pblocks pblock_22] -add {RAMB18_X10Y104:RAMB18_X10Y119}
resize_pblock [get_pblocks pblock_22] -add {RAMB36_X10Y52:RAMB36_X10Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_22]

create_pblock pblock_23
add_cells_to_pblock [get_pblocks pblock_23] [get_cells -quiet [list sym_i/zcore32_23]]
resize_pblock [get_pblocks pblock_23] -add {SLICE_X90Y260:SLICE_X95Y299}
resize_pblock [get_pblocks pblock_23] -add {DSP48E2_X17Y104:DSP48E2_X17Y119}
resize_pblock [get_pblocks pblock_23] -add {RAMB18_X12Y104:RAMB18_X12Y119}
resize_pblock [get_pblocks pblock_23] -add {RAMB36_X12Y52:RAMB36_X12Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_23]

create_pblock pblock_24
add_cells_to_pblock [get_pblocks pblock_24] [get_cells -quiet [list sym_i/zcore32_24]]
resize_pblock [get_pblocks pblock_24] -add {SLICE_X90Y200:SLICE_X95Y239}
resize_pblock [get_pblocks pblock_24] -add {DSP48E2_X17Y80:DSP48E2_X17Y95}
resize_pblock [get_pblocks pblock_24] -add {RAMB18_X12Y80:RAMB18_X12Y95}
resize_pblock [get_pblocks pblock_24] -add {RAMB36_X12Y40:RAMB36_X12Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_24]

create_pblock pblock_25
add_cells_to_pblock [get_pblocks pblock_25] [get_cells -quiet [list sym_i/zcore32_25]]
resize_pblock [get_pblocks pblock_25] -add {SLICE_X76Y200:SLICE_X81Y239}
resize_pblock [get_pblocks pblock_25] -add {DSP48E2_X15Y80:DSP48E2_X15Y95}
resize_pblock [get_pblocks pblock_25] -add {RAMB18_X10Y80:RAMB18_X10Y95}
resize_pblock [get_pblocks pblock_25] -add {RAMB36_X10Y40:RAMB36_X10Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_25]

create_pblock pblock_26
add_cells_to_pblock [get_pblocks pblock_26] [get_cells -quiet [list sym_i/zcore32_26]]
resize_pblock [get_pblocks pblock_26] -add {SLICE_X64Y200:SLICE_X69Y239}
resize_pblock [get_pblocks pblock_26] -add {DSP48E2_X13Y80:DSP48E2_X13Y95}
resize_pblock [get_pblocks pblock_26] -add {RAMB18_X8Y80:RAMB18_X8Y95}
resize_pblock [get_pblocks pblock_26] -add {RAMB36_X8Y40:RAMB36_X8Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_26]

create_pblock pblock_27
add_cells_to_pblock [get_pblocks pblock_27] [get_cells -quiet [list sym_i/zcore32_27]]
resize_pblock [get_pblocks pblock_27] -add {SLICE_X48Y205:SLICE_X54Y239}
resize_pblock [get_pblocks pblock_27] -add {DSP48E2_X9Y82:DSP48E2_X10Y95}
resize_pblock [get_pblocks pblock_27] -add {RAMB18_X6Y82:RAMB18_X6Y95}
resize_pblock [get_pblocks pblock_27] -add {RAMB36_X6Y41:RAMB36_X6Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_27]

create_pblock pblock_28
add_cells_to_pblock [get_pblocks pblock_28] [get_cells -quiet [list sym_i/zcore32_28]]
resize_pblock [get_pblocks pblock_28] -add {SLICE_X34Y200:SLICE_X39Y239}
resize_pblock [get_pblocks pblock_28] -add {DSP48E2_X6Y80:DSP48E2_X6Y95}
resize_pblock [get_pblocks pblock_28] -add {RAMB18_X5Y80:RAMB18_X5Y95}
resize_pblock [get_pblocks pblock_28] -add {RAMB36_X5Y40:RAMB36_X5Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_28]

create_pblock pblock_29
add_cells_to_pblock [get_pblocks pblock_29] [get_cells -quiet [list sym_i/zcore32_29]]
resize_pblock [get_pblocks pblock_29] -add {SLICE_X22Y200:SLICE_X27Y239}
resize_pblock [get_pblocks pblock_29] -add {DSP48E2_X4Y80:DSP48E2_X4Y95}
resize_pblock [get_pblocks pblock_29] -add {RAMB18_X3Y80:RAMB18_X3Y95}
resize_pblock [get_pblocks pblock_29] -add {RAMB36_X3Y40:RAMB36_X3Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_29]

create_pblock pblock_30
add_cells_to_pblock [get_pblocks pblock_30] [get_cells -quiet [list sym_i/zcore32_30]]
resize_pblock [get_pblocks pblock_30] -add {SLICE_X13Y200:SLICE_X18Y239}
resize_pblock [get_pblocks pblock_30] -add {DSP48E2_X2Y80:DSP48E2_X2Y95}
resize_pblock [get_pblocks pblock_30] -add {RAMB18_X2Y80:RAMB18_X2Y95}
resize_pblock [get_pblocks pblock_30] -add {RAMB36_X2Y40:RAMB36_X2Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_30]

create_pblock pblock_31
add_cells_to_pblock [get_pblocks pblock_31] [get_cells -quiet [list sym_i/zcore32_31]]
resize_pblock [get_pblocks pblock_31] -add {SLICE_X1Y200:SLICE_X6Y239}
resize_pblock [get_pblocks pblock_31] -add {DSP48E2_X0Y80:DSP48E2_X0Y95}
resize_pblock [get_pblocks pblock_31] -add {RAMB18_X0Y80:RAMB18_X0Y95}
resize_pblock [get_pblocks pblock_31] -add {RAMB36_X0Y40:RAMB36_X0Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_31]

create_pblock pblock_32
add_cells_to_pblock [get_pblocks pblock_32] [get_cells -quiet [list sym_i/zcore32_32]]
resize_pblock [get_pblocks pblock_32] -add {SLICE_X37Y140:SLICE_X42Y179}
resize_pblock [get_pblocks pblock_32] -add {DSP48E2_X7Y56:DSP48E2_X7Y71}
resize_pblock [get_pblocks pblock_32] -add {RAMB18_X5Y56:RAMB18_X5Y71}
resize_pblock [get_pblocks pblock_32] -add {RAMB36_X5Y28:RAMB36_X5Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_32]

create_pblock pblock_33
add_cells_to_pblock [get_pblocks pblock_33] [get_cells -quiet [list sym_i/zcore32_33]]
resize_pblock [get_pblocks pblock_33] -add {SLICE_X48Y145:SLICE_X54Y179}
resize_pblock [get_pblocks pblock_33] -add {DSP48E2_X9Y58:DSP48E2_X10Y71}
resize_pblock [get_pblocks pblock_33] -add {RAMB18_X6Y58:RAMB18_X6Y71}
resize_pblock [get_pblocks pblock_33] -add {RAMB36_X6Y29:RAMB36_X6Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_33]

create_pblock pblock_34
add_cells_to_pblock [get_pblocks pblock_34] [get_cells -quiet [list sym_i/zcore32_34]]
resize_pblock [get_pblocks pblock_34] -add {SLICE_X64Y140:SLICE_X69Y179}
resize_pblock [get_pblocks pblock_34] -add {DSP48E2_X13Y56:DSP48E2_X13Y71}
resize_pblock [get_pblocks pblock_34] -add {RAMB18_X8Y56:RAMB18_X8Y71}
resize_pblock [get_pblocks pblock_34] -add {RAMB36_X8Y28:RAMB36_X8Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_34]

create_pblock pblock_35
add_cells_to_pblock [get_pblocks pblock_35] [get_cells -quiet [list sym_i/zcore32_35]]
resize_pblock [get_pblocks pblock_35] -add {SLICE_X76Y140:SLICE_X81Y179}
resize_pblock [get_pblocks pblock_35] -add {DSP48E2_X15Y56:DSP48E2_X15Y71}
resize_pblock [get_pblocks pblock_35] -add {RAMB18_X10Y56:RAMB18_X10Y71}
resize_pblock [get_pblocks pblock_35] -add {RAMB36_X10Y28:RAMB36_X10Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_35]

create_pblock pblock_36
add_cells_to_pblock [get_pblocks pblock_36] [get_cells -quiet [list sym_i/zcore32_36]]
resize_pblock [get_pblocks pblock_36] -add {SLICE_X90Y140:SLICE_X95Y179}
resize_pblock [get_pblocks pblock_36] -add {DSP48E2_X17Y56:DSP48E2_X17Y71}
resize_pblock [get_pblocks pblock_36] -add {RAMB18_X12Y56:RAMB18_X12Y71}
resize_pblock [get_pblocks pblock_36] -add {RAMB36_X12Y28:RAMB36_X12Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_36]

create_pblock pblock_37
add_cells_to_pblock [get_pblocks pblock_37] [get_cells -quiet [list sym_i/zcore32_37]]
resize_pblock [get_pblocks pblock_37] -add {SLICE_X90Y80:SLICE_X95Y119}
resize_pblock [get_pblocks pblock_37] -add {DSP48E2_X17Y32:DSP48E2_X17Y47}
resize_pblock [get_pblocks pblock_37] -add {RAMB18_X12Y32:RAMB18_X12Y47}
resize_pblock [get_pblocks pblock_37] -add {RAMB36_X12Y16:RAMB36_X12Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_37]

create_pblock pblock_38
add_cells_to_pblock [get_pblocks pblock_38] [get_cells -quiet [list sym_i/zcore32_38]]
resize_pblock [get_pblocks pblock_38] -add {SLICE_X76Y80:SLICE_X81Y119}
resize_pblock [get_pblocks pblock_38] -add {DSP48E2_X15Y32:DSP48E2_X15Y47}
resize_pblock [get_pblocks pblock_38] -add {RAMB18_X10Y32:RAMB18_X10Y47}
resize_pblock [get_pblocks pblock_38] -add {RAMB36_X10Y16:RAMB36_X10Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_38]

create_pblock pblock_39
add_cells_to_pblock [get_pblocks pblock_39] [get_cells -quiet [list sym_i/zcore32_39]]
resize_pblock [get_pblocks pblock_39] -add {SLICE_X67Y80:SLICE_X72Y119}
resize_pblock [get_pblocks pblock_39] -add {DSP48E2_X13Y32:DSP48E2_X13Y47}
resize_pblock [get_pblocks pblock_39] -add {RAMB18_X9Y32:RAMB18_X9Y47}
resize_pblock [get_pblocks pblock_39] -add {RAMB36_X9Y16:RAMB36_X9Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_39]

create_pblock pblock_40
add_cells_to_pblock [get_pblocks pblock_40] [get_cells -quiet [list sym_i/zcore32_40]]
resize_pblock [get_pblocks pblock_40] -add {SLICE_X58Y80:SLICE_X63Y119}
resize_pblock [get_pblocks pblock_40] -add {DSP48E2_X12Y32:DSP48E2_X12Y47}
resize_pblock [get_pblocks pblock_40] -add {RAMB18_X7Y32:RAMB18_X7Y47}
resize_pblock [get_pblocks pblock_40] -add {RAMB36_X7Y16:RAMB36_X7Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_40]

create_pblock pblock_41
add_cells_to_pblock [get_pblocks pblock_41] [get_cells -quiet [list sym_i/zcore32_41]]
resize_pblock [get_pblocks pblock_41] -add {SLICE_X48Y70:SLICE_X52Y119}
resize_pblock [get_pblocks pblock_41] -add {DSP48E2_X9Y28:DSP48E2_X10Y47}
resize_pblock [get_pblocks pblock_41] -add {RAMB18_X6Y28:RAMB18_X6Y47}
resize_pblock [get_pblocks pblock_41] -add {RAMB36_X6Y14:RAMB36_X6Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_41]

create_pblock pblock_42
add_cells_to_pblock [get_pblocks pblock_42] [get_cells -quiet [list sym_i/zcore32_42]]
resize_pblock [get_pblocks pblock_42] -add {SLICE_X37Y80:SLICE_X42Y119}
resize_pblock [get_pblocks pblock_42] -add {DSP48E2_X7Y32:DSP48E2_X7Y47}
resize_pblock [get_pblocks pblock_42] -add {RAMB18_X5Y32:RAMB18_X5Y47}
resize_pblock [get_pblocks pblock_42] -add {RAMB36_X5Y16:RAMB36_X5Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_42]

create_pblock pblock_43
add_cells_to_pblock [get_pblocks pblock_43] [get_cells -quiet [list sym_i/zcore32_43]]
resize_pblock [get_pblocks pblock_43] -add {SLICE_X37Y20:SLICE_X42Y59}
resize_pblock [get_pblocks pblock_43] -add {DSP48E2_X7Y8:DSP48E2_X7Y23}
resize_pblock [get_pblocks pblock_43] -add {RAMB18_X5Y8:RAMB18_X5Y23}
resize_pblock [get_pblocks pblock_43] -add {RAMB36_X5Y4:RAMB36_X5Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_43]

create_pblock pblock_44
add_cells_to_pblock [get_pblocks pblock_44] [get_cells -quiet [list sym_i/zcore32_44]]
resize_pblock [get_pblocks pblock_44] -add {SLICE_X48Y25:SLICE_X54Y59}
resize_pblock [get_pblocks pblock_44] -add {DSP48E2_X9Y10:DSP48E2_X10Y23}
resize_pblock [get_pblocks pblock_44] -add {RAMB18_X6Y10:RAMB18_X6Y23}
resize_pblock [get_pblocks pblock_44] -add {RAMB36_X6Y5:RAMB36_X6Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_44]

create_pblock pblock_45
add_cells_to_pblock [get_pblocks pblock_45] [get_cells -quiet [list sym_i/zcore32_45]]
resize_pblock [get_pblocks pblock_45] -add {SLICE_X64Y20:SLICE_X69Y59}
resize_pblock [get_pblocks pblock_45] -add {DSP48E2_X13Y8:DSP48E2_X13Y23}
resize_pblock [get_pblocks pblock_45] -add {RAMB18_X8Y8:RAMB18_X8Y23}
resize_pblock [get_pblocks pblock_45] -add {RAMB36_X8Y4:RAMB36_X8Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_45]

create_pblock pblock_46
add_cells_to_pblock [get_pblocks pblock_46] [get_cells -quiet [list sym_i/zcore32_46]]
resize_pblock [get_pblocks pblock_46] -add {SLICE_X76Y20:SLICE_X81Y59}
resize_pblock [get_pblocks pblock_46] -add {DSP48E2_X15Y8:DSP48E2_X15Y23}
resize_pblock [get_pblocks pblock_46] -add {RAMB18_X10Y8:RAMB18_X10Y23}
resize_pblock [get_pblocks pblock_46] -add {RAMB36_X10Y4:RAMB36_X10Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_46]

create_pblock pblock_47
add_cells_to_pblock [get_pblocks pblock_47] [get_cells -quiet [list sym_i/zcore32_47]]
resize_pblock [get_pblocks pblock_47] -add {SLICE_X90Y20:SLICE_X95Y59}
resize_pblock [get_pblocks pblock_47] -add {DSP48E2_X17Y8:DSP48E2_X17Y23}
resize_pblock [get_pblocks pblock_47] -add {RAMB18_X12Y8:RAMB18_X12Y23}
resize_pblock [get_pblocks pblock_47] -add {RAMB36_X12Y4:RAMB36_X12Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_47]

create_pblock pblock_8
add_cells_to_pblock [get_pblocks pblock_8] [get_cells -quiet [list sym_i/zcore32_8]]
resize_pblock [get_pblocks pblock_8] -add {SLICE_X90Y320:SLICE_X95Y359}
resize_pblock [get_pblocks pblock_8] -add {DSP48E2_X17Y128:DSP48E2_X17Y143}
resize_pblock [get_pblocks pblock_8] -add {RAMB18_X12Y128:RAMB18_X12Y143}
resize_pblock [get_pblocks pblock_8] -add {RAMB36_X12Y64:RAMB36_X12Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_8]







