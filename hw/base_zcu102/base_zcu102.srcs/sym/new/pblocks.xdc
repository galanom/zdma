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
resize_pblock [get_pblocks pblock_9] -add {SLICE_X76Y310:SLICE_X81Y349}
resize_pblock [get_pblocks pblock_9] -add {DSP48E2_X15Y124:DSP48E2_X15Y139}
resize_pblock [get_pblocks pblock_9] -add {RAMB18_X10Y124:RAMB18_X10Y139}
resize_pblock [get_pblocks pblock_9] -add {RAMB36_X10Y62:RAMB36_X10Y69}
set_property SNAPPING_MODE ON [get_pblocks pblock_9]

create_pblock pblock_10
add_cells_to_pblock [get_pblocks pblock_10] [get_cells -quiet [list sym_i/zcore32_10]]
resize_pblock [get_pblocks pblock_10] -add {SLICE_X64Y310:SLICE_X69Y349}
resize_pblock [get_pblocks pblock_10] -add {DSP48E2_X13Y124:DSP48E2_X13Y139}
resize_pblock [get_pblocks pblock_10] -add {RAMB18_X8Y124:RAMB18_X8Y139}
resize_pblock [get_pblocks pblock_10] -add {RAMB36_X8Y62:RAMB36_X8Y69}
set_property SNAPPING_MODE ON [get_pblocks pblock_10]

create_pblock pblock_11
add_cells_to_pblock [get_pblocks pblock_11] [get_cells -quiet [list sym_i/zcore32_11]]
resize_pblock [get_pblocks pblock_11] -add {SLICE_X48Y315:SLICE_X54Y349}
resize_pblock [get_pblocks pblock_11] -add {DSP48E2_X9Y126:DSP48E2_X10Y139}
resize_pblock [get_pblocks pblock_11] -add {RAMB18_X6Y126:RAMB18_X6Y139}
resize_pblock [get_pblocks pblock_11] -add {RAMB36_X6Y63:RAMB36_X6Y69}
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
resize_pblock [get_pblocks pblock_12] -add {SLICE_X34Y310:SLICE_X39Y349}
resize_pblock [get_pblocks pblock_12] -add {DSP48E2_X6Y124:DSP48E2_X6Y139}
resize_pblock [get_pblocks pblock_12] -add {RAMB18_X5Y124:RAMB18_X5Y139}
resize_pblock [get_pblocks pblock_12] -add {RAMB36_X5Y62:RAMB36_X5Y69}
set_property SNAPPING_MODE ON [get_pblocks pblock_12]

create_pblock pblock_13
add_cells_to_pblock [get_pblocks pblock_13] [get_cells -quiet [list sym_i/zcore32_13]]
resize_pblock [get_pblocks pblock_13] -add {SLICE_X22Y310:SLICE_X27Y349}
resize_pblock [get_pblocks pblock_13] -add {DSP48E2_X4Y124:DSP48E2_X4Y139}
resize_pblock [get_pblocks pblock_13] -add {RAMB18_X3Y124:RAMB18_X3Y139}
resize_pblock [get_pblocks pblock_13] -add {RAMB36_X3Y62:RAMB36_X3Y69}
set_property SNAPPING_MODE ON [get_pblocks pblock_13]

create_pblock pblock_14
add_cells_to_pblock [get_pblocks pblock_14] [get_cells -quiet [list sym_i/zcore32_14]]
resize_pblock [get_pblocks pblock_14] -add {SLICE_X13Y310:SLICE_X18Y349}
resize_pblock [get_pblocks pblock_14] -add {DSP48E2_X2Y124:DSP48E2_X2Y139}
resize_pblock [get_pblocks pblock_14] -add {RAMB18_X2Y124:RAMB18_X2Y139}
resize_pblock [get_pblocks pblock_14] -add {RAMB36_X2Y62:RAMB36_X2Y69}
set_property SNAPPING_MODE ON [get_pblocks pblock_14]

create_pblock pblock_15
add_cells_to_pblock [get_pblocks pblock_15] [get_cells -quiet [list sym_i/zcore32_15]]
resize_pblock [get_pblocks pblock_15] -add {SLICE_X1Y310:SLICE_X6Y349}
resize_pblock [get_pblocks pblock_15] -add {DSP48E2_X0Y124:DSP48E2_X0Y139}
resize_pblock [get_pblocks pblock_15] -add {RAMB18_X0Y124:RAMB18_X0Y139}
resize_pblock [get_pblocks pblock_15] -add {RAMB36_X0Y62:RAMB36_X0Y69}
set_property SNAPPING_MODE ON [get_pblocks pblock_15]

create_pblock pblock_16
add_cells_to_pblock [get_pblocks pblock_16] [get_cells -quiet [list sym_i/zcore32_16]]
resize_pblock [get_pblocks pblock_16] -add {SLICE_X1Y250:SLICE_X6Y289}
resize_pblock [get_pblocks pblock_16] -add {DSP48E2_X0Y100:DSP48E2_X0Y115}
resize_pblock [get_pblocks pblock_16] -add {RAMB18_X0Y100:RAMB18_X0Y115}
resize_pblock [get_pblocks pblock_16] -add {RAMB36_X0Y50:RAMB36_X0Y57}
set_property SNAPPING_MODE ON [get_pblocks pblock_16]

create_pblock pblock_17
add_cells_to_pblock [get_pblocks pblock_17] [get_cells -quiet [list sym_i/zcore32_17]]
resize_pblock [get_pblocks pblock_17] -add {SLICE_X13Y250:SLICE_X18Y289}
resize_pblock [get_pblocks pblock_17] -add {DSP48E2_X2Y100:DSP48E2_X2Y115}
resize_pblock [get_pblocks pblock_17] -add {RAMB18_X2Y100:RAMB18_X2Y115}
resize_pblock [get_pblocks pblock_17] -add {RAMB36_X2Y50:RAMB36_X2Y57}
set_property SNAPPING_MODE ON [get_pblocks pblock_17]

create_pblock pblock_18
add_cells_to_pblock [get_pblocks pblock_18] [get_cells -quiet [list sym_i/zcore32_18]]
resize_pblock [get_pblocks pblock_18] -add {SLICE_X22Y250:SLICE_X27Y289}
resize_pblock [get_pblocks pblock_18] -add {DSP48E2_X4Y100:DSP48E2_X4Y115}
resize_pblock [get_pblocks pblock_18] -add {RAMB18_X3Y100:RAMB18_X3Y115}
resize_pblock [get_pblocks pblock_18] -add {RAMB36_X3Y50:RAMB36_X3Y57}
set_property SNAPPING_MODE ON [get_pblocks pblock_18]

create_pblock pblock_19
add_cells_to_pblock [get_pblocks pblock_19] [get_cells -quiet [list sym_i/zcore32_19]]
resize_pblock [get_pblocks pblock_19] -add {SLICE_X34Y250:SLICE_X39Y289}
resize_pblock [get_pblocks pblock_19] -add {DSP48E2_X6Y100:DSP48E2_X6Y115}
resize_pblock [get_pblocks pblock_19] -add {RAMB18_X5Y100:RAMB18_X5Y115}
resize_pblock [get_pblocks pblock_19] -add {RAMB36_X5Y50:RAMB36_X5Y57}
set_property SNAPPING_MODE ON [get_pblocks pblock_19]

create_pblock pblock_20
add_cells_to_pblock [get_pblocks pblock_20] [get_cells -quiet [list sym_i/zcore32_20]]
resize_pblock [get_pblocks pblock_20] -add {SLICE_X48Y250:SLICE_X54Y289}
resize_pblock [get_pblocks pblock_20] -add {DSP48E2_X9Y100:DSP48E2_X10Y115}
resize_pblock [get_pblocks pblock_20] -add {RAMB18_X6Y100:RAMB18_X6Y115}
resize_pblock [get_pblocks pblock_20] -add {RAMB36_X6Y50:RAMB36_X6Y57}
set_property SNAPPING_MODE ON [get_pblocks pblock_20]

create_pblock pblock_21
add_cells_to_pblock [get_pblocks pblock_21] [get_cells -quiet [list sym_i/zcore32_21]]
resize_pblock [get_pblocks pblock_21] -add {SLICE_X64Y250:SLICE_X69Y289}
resize_pblock [get_pblocks pblock_21] -add {DSP48E2_X13Y100:DSP48E2_X13Y115}
resize_pblock [get_pblocks pblock_21] -add {RAMB18_X8Y100:RAMB18_X8Y115}
resize_pblock [get_pblocks pblock_21] -add {RAMB36_X8Y50:RAMB36_X8Y57}
set_property SNAPPING_MODE ON [get_pblocks pblock_21]

create_pblock pblock_22
add_cells_to_pblock [get_pblocks pblock_22] [get_cells -quiet [list sym_i/zcore32_22]]
resize_pblock [get_pblocks pblock_22] -add {SLICE_X76Y250:SLICE_X81Y289}
resize_pblock [get_pblocks pblock_22] -add {DSP48E2_X15Y100:DSP48E2_X15Y115}
resize_pblock [get_pblocks pblock_22] -add {RAMB18_X10Y100:RAMB18_X10Y115}
resize_pblock [get_pblocks pblock_22] -add {RAMB36_X10Y50:RAMB36_X10Y57}
set_property SNAPPING_MODE ON [get_pblocks pblock_22]

create_pblock pblock_23
add_cells_to_pblock [get_pblocks pblock_23] [get_cells -quiet [list sym_i/zcore32_23]]
resize_pblock [get_pblocks pblock_23] -add {SLICE_X90Y250:SLICE_X95Y289}
resize_pblock [get_pblocks pblock_23] -add {DSP48E2_X17Y100:DSP48E2_X17Y115}
resize_pblock [get_pblocks pblock_23] -add {RAMB18_X12Y100:RAMB18_X12Y115}
resize_pblock [get_pblocks pblock_23] -add {RAMB36_X12Y50:RAMB36_X12Y57}
set_property SNAPPING_MODE ON [get_pblocks pblock_23]

create_pblock pblock_24
add_cells_to_pblock [get_pblocks pblock_24] [get_cells -quiet [list sym_i/zcore32_24]]
resize_pblock [get_pblocks pblock_24] -add {SLICE_X90Y190:SLICE_X95Y229}
resize_pblock [get_pblocks pblock_24] -add {DSP48E2_X17Y76:DSP48E2_X17Y91}
resize_pblock [get_pblocks pblock_24] -add {RAMB18_X12Y76:RAMB18_X12Y91}
resize_pblock [get_pblocks pblock_24] -add {RAMB36_X12Y38:RAMB36_X12Y45}
set_property SNAPPING_MODE ON [get_pblocks pblock_24]

create_pblock pblock_25
add_cells_to_pblock [get_pblocks pblock_25] [get_cells -quiet [list sym_i/zcore32_25]]
resize_pblock [get_pblocks pblock_25] -add {SLICE_X76Y190:SLICE_X81Y229}
resize_pblock [get_pblocks pblock_25] -add {DSP48E2_X15Y76:DSP48E2_X15Y91}
resize_pblock [get_pblocks pblock_25] -add {RAMB18_X10Y76:RAMB18_X10Y91}
resize_pblock [get_pblocks pblock_25] -add {RAMB36_X10Y38:RAMB36_X10Y45}
set_property SNAPPING_MODE ON [get_pblocks pblock_25]

create_pblock pblock_26
add_cells_to_pblock [get_pblocks pblock_26] [get_cells -quiet [list sym_i/zcore32_26]]
resize_pblock [get_pblocks pblock_26] -add {SLICE_X64Y190:SLICE_X69Y229}
resize_pblock [get_pblocks pblock_26] -add {DSP48E2_X13Y76:DSP48E2_X13Y91}
resize_pblock [get_pblocks pblock_26] -add {RAMB18_X8Y76:RAMB18_X8Y91}
resize_pblock [get_pblocks pblock_26] -add {RAMB36_X8Y38:RAMB36_X8Y45}
set_property SNAPPING_MODE ON [get_pblocks pblock_26]

create_pblock pblock_27
add_cells_to_pblock [get_pblocks pblock_27] [get_cells -quiet [list sym_i/zcore32_27]]
resize_pblock [get_pblocks pblock_27] -add {SLICE_X48Y195:SLICE_X54Y229}
resize_pblock [get_pblocks pblock_27] -add {DSP48E2_X9Y78:DSP48E2_X10Y91}
resize_pblock [get_pblocks pblock_27] -add {RAMB18_X6Y78:RAMB18_X6Y91}
resize_pblock [get_pblocks pblock_27] -add {RAMB36_X6Y39:RAMB36_X6Y45}
set_property SNAPPING_MODE ON [get_pblocks pblock_27]

create_pblock pblock_28
add_cells_to_pblock [get_pblocks pblock_28] [get_cells -quiet [list sym_i/zcore32_28]]
resize_pblock [get_pblocks pblock_28] -add {SLICE_X34Y195:SLICE_X40Y229}
resize_pblock [get_pblocks pblock_28] -add {DSP48E2_X6Y78:DSP48E2_X7Y91}
resize_pblock [get_pblocks pblock_28] -add {RAMB18_X5Y78:RAMB18_X5Y91}
resize_pblock [get_pblocks pblock_28] -add {RAMB36_X5Y39:RAMB36_X5Y45}
set_property SNAPPING_MODE ON [get_pblocks pblock_28]

create_pblock pblock_29
add_cells_to_pblock [get_pblocks pblock_29] [get_cells -quiet [list sym_i/zcore32_29]]
resize_pblock [get_pblocks pblock_29] -add {SLICE_X22Y190:SLICE_X27Y229}
resize_pblock [get_pblocks pblock_29] -add {DSP48E2_X4Y76:DSP48E2_X4Y91}
resize_pblock [get_pblocks pblock_29] -add {RAMB18_X3Y76:RAMB18_X3Y91}
resize_pblock [get_pblocks pblock_29] -add {RAMB36_X3Y38:RAMB36_X3Y45}
set_property SNAPPING_MODE ON [get_pblocks pblock_29]

create_pblock pblock_30
add_cells_to_pblock [get_pblocks pblock_30] [get_cells -quiet [list sym_i/zcore32_30]]
resize_pblock [get_pblocks pblock_30] -add {SLICE_X13Y190:SLICE_X18Y229}
resize_pblock [get_pblocks pblock_30] -add {DSP48E2_X2Y76:DSP48E2_X2Y91}
resize_pblock [get_pblocks pblock_30] -add {RAMB18_X2Y76:RAMB18_X2Y91}
resize_pblock [get_pblocks pblock_30] -add {RAMB36_X2Y38:RAMB36_X2Y45}
set_property SNAPPING_MODE ON [get_pblocks pblock_30]

create_pblock pblock_31
add_cells_to_pblock [get_pblocks pblock_31] [get_cells -quiet [list sym_i/zcore32_31]]
resize_pblock [get_pblocks pblock_31] -add {SLICE_X1Y190:SLICE_X6Y229}
resize_pblock [get_pblocks pblock_31] -add {DSP48E2_X0Y76:DSP48E2_X0Y91}
resize_pblock [get_pblocks pblock_31] -add {RAMB18_X0Y76:RAMB18_X0Y91}
resize_pblock [get_pblocks pblock_31] -add {RAMB36_X0Y38:RAMB36_X0Y45}
set_property SNAPPING_MODE ON [get_pblocks pblock_31]

create_pblock pblock_32
add_cells_to_pblock [get_pblocks pblock_32] [get_cells -quiet [list sym_i/zcore32_32]]
resize_pblock [get_pblocks pblock_32] -add {SLICE_X37Y130:SLICE_X42Y169}
resize_pblock [get_pblocks pblock_32] -add {DSP48E2_X7Y52:DSP48E2_X7Y67}
resize_pblock [get_pblocks pblock_32] -add {RAMB18_X5Y52:RAMB18_X5Y67}
resize_pblock [get_pblocks pblock_32] -add {RAMB36_X5Y26:RAMB36_X5Y33}
set_property SNAPPING_MODE ON [get_pblocks pblock_32]

create_pblock pblock_33
add_cells_to_pblock [get_pblocks pblock_33] [get_cells -quiet [list sym_i/zcore32_33]]
resize_pblock [get_pblocks pblock_33] -add {SLICE_X48Y135:SLICE_X54Y169}
resize_pblock [get_pblocks pblock_33] -add {DSP48E2_X9Y54:DSP48E2_X10Y67}
resize_pblock [get_pblocks pblock_33] -add {RAMB18_X6Y54:RAMB18_X6Y67}
resize_pblock [get_pblocks pblock_33] -add {RAMB36_X6Y27:RAMB36_X6Y33}
set_property SNAPPING_MODE ON [get_pblocks pblock_33]

create_pblock pblock_34
add_cells_to_pblock [get_pblocks pblock_34] [get_cells -quiet [list sym_i/zcore32_34]]
resize_pblock [get_pblocks pblock_34] -add {SLICE_X64Y130:SLICE_X69Y169}
resize_pblock [get_pblocks pblock_34] -add {DSP48E2_X13Y52:DSP48E2_X13Y67}
resize_pblock [get_pblocks pblock_34] -add {RAMB18_X8Y52:RAMB18_X8Y67}
resize_pblock [get_pblocks pblock_34] -add {RAMB36_X8Y26:RAMB36_X8Y33}
set_property SNAPPING_MODE ON [get_pblocks pblock_34]

create_pblock pblock_35
add_cells_to_pblock [get_pblocks pblock_35] [get_cells -quiet [list sym_i/zcore32_35]]
resize_pblock [get_pblocks pblock_35] -add {SLICE_X76Y130:SLICE_X81Y169}
resize_pblock [get_pblocks pblock_35] -add {DSP48E2_X15Y52:DSP48E2_X15Y67}
resize_pblock [get_pblocks pblock_35] -add {RAMB18_X10Y52:RAMB18_X10Y67}
resize_pblock [get_pblocks pblock_35] -add {RAMB36_X10Y26:RAMB36_X10Y33}
set_property SNAPPING_MODE ON [get_pblocks pblock_35]

create_pblock pblock_36
add_cells_to_pblock [get_pblocks pblock_36] [get_cells -quiet [list sym_i/zcore32_36]]
resize_pblock [get_pblocks pblock_36] -add {SLICE_X90Y130:SLICE_X95Y169}
resize_pblock [get_pblocks pblock_36] -add {DSP48E2_X17Y52:DSP48E2_X17Y67}
resize_pblock [get_pblocks pblock_36] -add {RAMB18_X12Y52:RAMB18_X12Y67}
resize_pblock [get_pblocks pblock_36] -add {RAMB36_X12Y26:RAMB36_X12Y33}
set_property SNAPPING_MODE ON [get_pblocks pblock_36]

create_pblock pblock_37
add_cells_to_pblock [get_pblocks pblock_37] [get_cells -quiet [list sym_i/zcore32_37]]
resize_pblock [get_pblocks pblock_37] -add {SLICE_X90Y70:SLICE_X95Y109}
resize_pblock [get_pblocks pblock_37] -add {DSP48E2_X17Y28:DSP48E2_X17Y43}
resize_pblock [get_pblocks pblock_37] -add {RAMB18_X12Y28:RAMB18_X12Y43}
resize_pblock [get_pblocks pblock_37] -add {RAMB36_X12Y14:RAMB36_X12Y21}
set_property SNAPPING_MODE ON [get_pblocks pblock_37]

create_pblock pblock_38
add_cells_to_pblock [get_pblocks pblock_38] [get_cells -quiet [list sym_i/zcore32_38]]
resize_pblock [get_pblocks pblock_38] -add {SLICE_X76Y70:SLICE_X81Y109}
resize_pblock [get_pblocks pblock_38] -add {DSP48E2_X15Y28:DSP48E2_X15Y43}
resize_pblock [get_pblocks pblock_38] -add {RAMB18_X10Y28:RAMB18_X10Y43}
resize_pblock [get_pblocks pblock_38] -add {RAMB36_X10Y14:RAMB36_X10Y21}
set_property SNAPPING_MODE ON [get_pblocks pblock_38]

create_pblock pblock_39
add_cells_to_pblock [get_pblocks pblock_39] [get_cells -quiet [list sym_i/zcore32_39]]
resize_pblock [get_pblocks pblock_39] -add {SLICE_X67Y70:SLICE_X72Y109}
resize_pblock [get_pblocks pblock_39] -add {DSP48E2_X13Y28:DSP48E2_X13Y43}
resize_pblock [get_pblocks pblock_39] -add {RAMB18_X9Y28:RAMB18_X9Y43}
resize_pblock [get_pblocks pblock_39] -add {RAMB36_X9Y14:RAMB36_X9Y21}
set_property SNAPPING_MODE ON [get_pblocks pblock_39]

create_pblock pblock_40
add_cells_to_pblock [get_pblocks pblock_40] [get_cells -quiet [list sym_i/zcore32_40]]
resize_pblock [get_pblocks pblock_40] -add {SLICE_X58Y70:SLICE_X63Y109}
resize_pblock [get_pblocks pblock_40] -add {DSP48E2_X12Y28:DSP48E2_X12Y43}
resize_pblock [get_pblocks pblock_40] -add {RAMB18_X7Y28:RAMB18_X7Y43}
resize_pblock [get_pblocks pblock_40] -add {RAMB36_X7Y14:RAMB36_X7Y21}
set_property SNAPPING_MODE ON [get_pblocks pblock_40]

create_pblock pblock_41
add_cells_to_pblock [get_pblocks pblock_41] [get_cells -quiet [list sym_i/zcore32_41]]
resize_pblock [get_pblocks pblock_41] -add {SLICE_X48Y65:SLICE_X52Y114}
resize_pblock [get_pblocks pblock_41] -add {DSP48E2_X9Y26:DSP48E2_X10Y45}
resize_pblock [get_pblocks pblock_41] -add {RAMB18_X6Y26:RAMB18_X6Y45}
resize_pblock [get_pblocks pblock_41] -add {RAMB36_X6Y13:RAMB36_X6Y22}
set_property SNAPPING_MODE ON [get_pblocks pblock_41]

create_pblock pblock_42
add_cells_to_pblock [get_pblocks pblock_42] [get_cells -quiet [list sym_i/zcore32_42]]
resize_pblock [get_pblocks pblock_42] -add {SLICE_X37Y70:SLICE_X42Y109}
resize_pblock [get_pblocks pblock_42] -add {DSP48E2_X7Y28:DSP48E2_X7Y43}
resize_pblock [get_pblocks pblock_42] -add {RAMB18_X5Y28:RAMB18_X5Y43}
resize_pblock [get_pblocks pblock_42] -add {RAMB36_X5Y14:RAMB36_X5Y21}
set_property SNAPPING_MODE ON [get_pblocks pblock_42]

create_pblock pblock_43
add_cells_to_pblock [get_pblocks pblock_43] [get_cells -quiet [list sym_i/zcore32_43]]
resize_pblock [get_pblocks pblock_43] -add {SLICE_X37Y0:SLICE_X42Y39}
resize_pblock [get_pblocks pblock_43] -add {DSP48E2_X7Y0:DSP48E2_X7Y15}
resize_pblock [get_pblocks pblock_43] -add {RAMB18_X5Y0:RAMB18_X5Y15}
resize_pblock [get_pblocks pblock_43] -add {RAMB36_X5Y0:RAMB36_X5Y7}
set_property SNAPPING_MODE ON [get_pblocks pblock_43]

create_pblock pblock_44
add_cells_to_pblock [get_pblocks pblock_44] [get_cells -quiet [list sym_i/zcore32_44]]
resize_pblock [get_pblocks pblock_44] -add {SLICE_X48Y0:SLICE_X54Y34}
resize_pblock [get_pblocks pblock_44] -add {DSP48E2_X9Y0:DSP48E2_X10Y13}
resize_pblock [get_pblocks pblock_44] -add {RAMB18_X6Y0:RAMB18_X6Y13}
resize_pblock [get_pblocks pblock_44] -add {RAMB36_X6Y0:RAMB36_X6Y6}
set_property SNAPPING_MODE ON [get_pblocks pblock_44]

create_pblock pblock_45
add_cells_to_pblock [get_pblocks pblock_45] [get_cells -quiet [list sym_i/zcore32_45]]
resize_pblock [get_pblocks pblock_45] -add {SLICE_X64Y0:SLICE_X69Y39}
resize_pblock [get_pblocks pblock_45] -add {DSP48E2_X13Y0:DSP48E2_X13Y15}
resize_pblock [get_pblocks pblock_45] -add {RAMB18_X8Y0:RAMB18_X8Y15}
resize_pblock [get_pblocks pblock_45] -add {RAMB36_X8Y0:RAMB36_X8Y7}
set_property SNAPPING_MODE ON [get_pblocks pblock_45]

create_pblock pblock_46
add_cells_to_pblock [get_pblocks pblock_46] [get_cells -quiet [list sym_i/zcore32_46]]
resize_pblock [get_pblocks pblock_46] -add {SLICE_X76Y0:SLICE_X81Y39}
resize_pblock [get_pblocks pblock_46] -add {DSP48E2_X15Y0:DSP48E2_X15Y15}
resize_pblock [get_pblocks pblock_46] -add {RAMB18_X10Y0:RAMB18_X10Y15}
resize_pblock [get_pblocks pblock_46] -add {RAMB36_X10Y0:RAMB36_X10Y7}
set_property SNAPPING_MODE ON [get_pblocks pblock_46]

create_pblock pblock_47
add_cells_to_pblock [get_pblocks pblock_47] [get_cells -quiet [list sym_i/zcore32_47]]
resize_pblock [get_pblocks pblock_47] -add {SLICE_X90Y0:SLICE_X95Y39}
resize_pblock [get_pblocks pblock_47] -add {DSP48E2_X17Y0:DSP48E2_X17Y15}
resize_pblock [get_pblocks pblock_47] -add {RAMB18_X12Y0:RAMB18_X12Y15}
resize_pblock [get_pblocks pblock_47] -add {RAMB36_X12Y0:RAMB36_X12Y7}
set_property SNAPPING_MODE ON [get_pblocks pblock_47]

create_pblock pblock_8
add_cells_to_pblock [get_pblocks pblock_8] [get_cells -quiet [list sym_i/zcore32_8]]
resize_pblock [get_pblocks pblock_8] -add {SLICE_X90Y305:SLICE_X95Y354}
resize_pblock [get_pblocks pblock_8] -add {DSP48E2_X17Y122:DSP48E2_X17Y141}
resize_pblock [get_pblocks pblock_8] -add {RAMB18_X12Y122:RAMB18_X12Y141}
resize_pblock [get_pblocks pblock_8] -add {RAMB36_X12Y61:RAMB36_X12Y70}
set_property SNAPPING_MODE ON [get_pblocks pblock_8]






