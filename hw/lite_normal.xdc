set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_0]
create_pblock pblock_0
add_cells_to_pblock [get_pblocks pblock_0] [get_cells -quiet [list sym_i/zcore32_0]]
resize_pblock [get_pblocks pblock_0] -add {SLICE_X1Y375:SLICE_X6Y419}
resize_pblock [get_pblocks pblock_0] -add {DSP48E2_X0Y150:DSP48E2_X0Y167}
resize_pblock [get_pblocks pblock_0] -add {RAMB18_X0Y150:RAMB18_X0Y167}
resize_pblock [get_pblocks pblock_0] -add {RAMB36_X0Y75:RAMB36_X0Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_0]

create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list sym_i/zcore32_1]]
resize_pblock [get_pblocks pblock_1] -add {SLICE_X13Y375:SLICE_X18Y419}
resize_pblock [get_pblocks pblock_1] -add {DSP48E2_X2Y150:DSP48E2_X2Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X2Y150:RAMB18_X2Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X2Y75:RAMB36_X2Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_1]
create_pblock pblock_2
add_cells_to_pblock [get_pblocks pblock_2] [get_cells -quiet [list sym_i/zcore32_2]]
resize_pblock [get_pblocks pblock_2] -add {SLICE_X29Y375:SLICE_X34Y419}
resize_pblock [get_pblocks pblock_2] -add {DSP48E2_X6Y150:DSP48E2_X6Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB18_X4Y150:RAMB18_X4Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB36_X4Y75:RAMB36_X4Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_2]
create_pblock pblock_3
add_cells_to_pblock [get_pblocks pblock_3] [get_cells -quiet [list sym_i/zcore32_3]]
resize_pblock [get_pblocks pblock_3] -add {SLICE_X46Y375:SLICE_X51Y419}
resize_pblock [get_pblocks pblock_3] -add {DSP48E2_X9Y150:DSP48E2_X9Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB18_X6Y150:RAMB18_X6Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB36_X6Y75:RAMB36_X6Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_3]
create_pblock pblock_4
add_cells_to_pblock [get_pblocks pblock_4] [get_cells -quiet [list sym_i/zcore32_4]]
resize_pblock [get_pblocks pblock_4] -add {SLICE_X58Y375:SLICE_X63Y419}
resize_pblock [get_pblocks pblock_4] -add {DSP48E2_X12Y150:DSP48E2_X12Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB18_X7Y150:RAMB18_X7Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB36_X7Y75:RAMB36_X7Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_4]
create_pblock pblock_5
add_cells_to_pblock [get_pblocks pblock_5] [get_cells -quiet [list sym_i/zcore32_5]]
resize_pblock [get_pblocks pblock_5] -add {SLICE_X70Y375:SLICE_X75Y419}
resize_pblock [get_pblocks pblock_5] -add {DSP48E2_X14Y150:DSP48E2_X14Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB18_X9Y150:RAMB18_X9Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB36_X9Y75:RAMB36_X9Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_5]
create_pblock pblock_6
add_cells_to_pblock [get_pblocks pblock_6] [get_cells -quiet [list sym_i/zcore32_6]]
resize_pblock [get_pblocks pblock_6] -add {SLICE_X90Y375:SLICE_X95Y419}
resize_pblock [get_pblocks pblock_6] -add {DSP48E2_X17Y150:DSP48E2_X17Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB18_X12Y150:RAMB18_X12Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB36_X12Y75:RAMB36_X12Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_6]
create_pblock pblock_7
add_cells_to_pblock [get_pblocks pblock_7] [get_cells -quiet [list sym_i/zcore32_7]]
resize_pblock [get_pblocks pblock_7] -add {SLICE_X90Y310:SLICE_X95Y354}
resize_pblock [get_pblocks pblock_7] -add {DSP48E2_X17Y124:DSP48E2_X17Y141}
resize_pblock [get_pblocks pblock_7] -add {RAMB18_X12Y124:RAMB18_X12Y141}
resize_pblock [get_pblocks pblock_7] -add {RAMB36_X12Y62:RAMB36_X12Y70}
set_property SNAPPING_MODE ON [get_pblocks pblock_7]
create_pblock pblock_8
add_cells_to_pblock [get_pblocks pblock_8] [get_cells -quiet [list sym_i/zcore32_8]]
resize_pblock [get_pblocks pblock_8] -add {SLICE_X70Y310:SLICE_X75Y354}
resize_pblock [get_pblocks pblock_8] -add {DSP48E2_X14Y124:DSP48E2_X14Y141}
resize_pblock [get_pblocks pblock_8] -add {RAMB18_X9Y124:RAMB18_X9Y141}
resize_pblock [get_pblocks pblock_8] -add {RAMB36_X9Y62:RAMB36_X9Y70}
set_property SNAPPING_MODE ON [get_pblocks pblock_8]
create_pblock pblock_9
add_cells_to_pblock [get_pblocks pblock_9] [get_cells -quiet [list sym_i/zcore32_9]]
resize_pblock [get_pblocks pblock_9] -add {SLICE_X58Y310:SLICE_X63Y354}
resize_pblock [get_pblocks pblock_9] -add {DSP48E2_X12Y124:DSP48E2_X12Y141}
resize_pblock [get_pblocks pblock_9] -add {RAMB18_X7Y124:RAMB18_X7Y141}
resize_pblock [get_pblocks pblock_9] -add {RAMB36_X7Y62:RAMB36_X7Y70}
set_property SNAPPING_MODE ON [get_pblocks pblock_9]
create_pblock pblock_10
add_cells_to_pblock [get_pblocks pblock_10] [get_cells -quiet [list sym_i/zcore32_10]]
resize_pblock [get_pblocks pblock_10] -add {SLICE_X46Y310:SLICE_X51Y354}
resize_pblock [get_pblocks pblock_10] -add {DSP48E2_X9Y124:DSP48E2_X9Y141}
resize_pblock [get_pblocks pblock_10] -add {RAMB18_X6Y124:RAMB18_X6Y141}
resize_pblock [get_pblocks pblock_10] -add {RAMB36_X6Y62:RAMB36_X6Y70}
set_property SNAPPING_MODE ON [get_pblocks pblock_10]
create_pblock pblock_11
add_cells_to_pblock [get_pblocks pblock_11] [get_cells -quiet [list sym_i/zcore32_11]]
resize_pblock [get_pblocks pblock_11] -add {SLICE_X29Y310:SLICE_X34Y354}
resize_pblock [get_pblocks pblock_11] -add {DSP48E2_X6Y124:DSP48E2_X6Y141}
resize_pblock [get_pblocks pblock_11] -add {RAMB18_X4Y124:RAMB18_X4Y141}
resize_pblock [get_pblocks pblock_11] -add {RAMB36_X4Y62:RAMB36_X4Y70}
set_property SNAPPING_MODE ON [get_pblocks pblock_11]
#create_pblock pblock_a
#add_cells_to_pblock [get_pblocks pblock_a] [get_cells -quiet [list sym_i/axi_dma_0 sym_i/axi_dma_1 sym_i/axi_dma_10 sym_i/axi_dma_11 sym_i/axi_dma_2 sym_i/axi_dma_3 sym_i/axi_dma_4 sym_i/axi_dma_5 sym_i/axi_dma_6 sym_i/axi_dma_7 sym_i/axi_dma_8 sym_i/axi_dma_9]]
#resize_pblock [get_pblocks pblock_a] -add {SLICE_X0Y360:SLICE_X96Y419}
#resize_pblock [get_pblocks pblock_a] -add {DSP48E2_X0Y144:DSP48E2_X17Y167}
#resize_pblock [get_pblocks pblock_a] -add {IOB_X0Y256:IOB_X0Y279}
#resize_pblock [get_pblocks pblock_a] -add {RAMB18_X0Y144:RAMB18_X12Y167}
#resize_pblock [get_pblocks pblock_a] -add {RAMB36_X0Y72:RAMB36_X12Y83}
#set_property CONTAIN_ROUTING 1 [get_pblocks pblock_a]
#set_property EXCLUDE_PLACEMENT 1 [get_pblocks pblock_a]
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
resize_pblock [get_pblocks pblock_12] -add {SLICE_X13Y310:SLICE_X18Y354}
resize_pblock [get_pblocks pblock_12] -add {DSP48E2_X2Y124:DSP48E2_X2Y141}
resize_pblock [get_pblocks pblock_12] -add {RAMB18_X2Y124:RAMB18_X2Y141}
resize_pblock [get_pblocks pblock_12] -add {RAMB36_X2Y62:RAMB36_X2Y70}
set_property SNAPPING_MODE ON [get_pblocks pblock_12]
create_pblock pblock_13
add_cells_to_pblock [get_pblocks pblock_13] [get_cells -quiet [list sym_i/zcore32_13]]
resize_pblock [get_pblocks pblock_13] -add {SLICE_X1Y310:SLICE_X6Y354}
resize_pblock [get_pblocks pblock_13] -add {DSP48E2_X0Y124:DSP48E2_X0Y141}
resize_pblock [get_pblocks pblock_13] -add {RAMB18_X0Y124:RAMB18_X0Y141}
resize_pblock [get_pblocks pblock_13] -add {RAMB36_X0Y62:RAMB36_X0Y70}
set_property SNAPPING_MODE ON [get_pblocks pblock_13]
create_pblock pblock_14
add_cells_to_pblock [get_pblocks pblock_14] [get_cells -quiet [list sym_i/zcore32_14]]
resize_pblock [get_pblocks pblock_14] -add {SLICE_X1Y250:SLICE_X6Y294}
resize_pblock [get_pblocks pblock_14] -add {DSP48E2_X0Y100:DSP48E2_X0Y117}
resize_pblock [get_pblocks pblock_14] -add {RAMB18_X0Y100:RAMB18_X0Y117}
resize_pblock [get_pblocks pblock_14] -add {RAMB36_X0Y50:RAMB36_X0Y58}
set_property SNAPPING_MODE ON [get_pblocks pblock_14]
create_pblock pblock_15
add_cells_to_pblock [get_pblocks pblock_15] [get_cells -quiet [list sym_i/zcore32_15]]
resize_pblock [get_pblocks pblock_15] -add {SLICE_X13Y250:SLICE_X18Y294}
resize_pblock [get_pblocks pblock_15] -add {DSP48E2_X2Y100:DSP48E2_X2Y117}
resize_pblock [get_pblocks pblock_15] -add {RAMB18_X2Y100:RAMB18_X2Y117}
resize_pblock [get_pblocks pblock_15] -add {RAMB36_X2Y50:RAMB36_X2Y58}
set_property SNAPPING_MODE ON [get_pblocks pblock_15]
create_pblock pblock_16
add_cells_to_pblock [get_pblocks pblock_16] [get_cells -quiet [list sym_i/zcore32_16]]
resize_pblock [get_pblocks pblock_16] -add {SLICE_X29Y250:SLICE_X34Y294}
resize_pblock [get_pblocks pblock_16] -add {DSP48E2_X6Y100:DSP48E2_X6Y117}
resize_pblock [get_pblocks pblock_16] -add {RAMB18_X4Y100:RAMB18_X4Y117}
resize_pblock [get_pblocks pblock_16] -add {RAMB36_X4Y50:RAMB36_X4Y58}
set_property SNAPPING_MODE ON [get_pblocks pblock_16]
create_pblock pblock_17
add_cells_to_pblock [get_pblocks pblock_17] [get_cells -quiet [list sym_i/zcore32_17]]
resize_pblock [get_pblocks pblock_17] -add {SLICE_X46Y250:SLICE_X51Y294}
resize_pblock [get_pblocks pblock_17] -add {DSP48E2_X9Y100:DSP48E2_X9Y117}
resize_pblock [get_pblocks pblock_17] -add {RAMB18_X6Y100:RAMB18_X6Y117}
resize_pblock [get_pblocks pblock_17] -add {RAMB36_X6Y50:RAMB36_X6Y58}
set_property SNAPPING_MODE ON [get_pblocks pblock_17]
create_pblock pblock_18
add_cells_to_pblock [get_pblocks pblock_18] [get_cells -quiet [list sym_i/zcore32_18]]
resize_pblock [get_pblocks pblock_18] -add {SLICE_X58Y250:SLICE_X63Y294}
resize_pblock [get_pblocks pblock_18] -add {DSP48E2_X12Y100:DSP48E2_X12Y117}
resize_pblock [get_pblocks pblock_18] -add {RAMB18_X7Y100:RAMB18_X7Y117}
resize_pblock [get_pblocks pblock_18] -add {RAMB36_X7Y50:RAMB36_X7Y58}
set_property SNAPPING_MODE ON [get_pblocks pblock_18]
create_pblock pblock_19
add_cells_to_pblock [get_pblocks pblock_19] [get_cells -quiet [list sym_i/zcore32_19]]
resize_pblock [get_pblocks pblock_19] -add {SLICE_X70Y250:SLICE_X75Y294}
resize_pblock [get_pblocks pblock_19] -add {DSP48E2_X14Y100:DSP48E2_X14Y117}
resize_pblock [get_pblocks pblock_19] -add {RAMB18_X9Y100:RAMB18_X9Y117}
resize_pblock [get_pblocks pblock_19] -add {RAMB36_X9Y50:RAMB36_X9Y58}
set_property SNAPPING_MODE ON [get_pblocks pblock_19]
create_pblock pblock_20
add_cells_to_pblock [get_pblocks pblock_20] [get_cells -quiet [list sym_i/zcore32_20]]
resize_pblock [get_pblocks pblock_20] -add {SLICE_X90Y250:SLICE_X95Y294}
resize_pblock [get_pblocks pblock_20] -add {DSP48E2_X17Y100:DSP48E2_X17Y117}
resize_pblock [get_pblocks pblock_20] -add {RAMB18_X12Y100:RAMB18_X12Y117}
resize_pblock [get_pblocks pblock_20] -add {RAMB36_X12Y50:RAMB36_X12Y58}
set_property SNAPPING_MODE ON [get_pblocks pblock_20]
create_pblock pblock_21
add_cells_to_pblock [get_pblocks pblock_21] [get_cells -quiet [list sym_i/zcore32_21]]
resize_pblock [get_pblocks pblock_21] -add {SLICE_X90Y190:SLICE_X95Y234}
resize_pblock [get_pblocks pblock_21] -add {DSP48E2_X17Y76:DSP48E2_X17Y93}
resize_pblock [get_pblocks pblock_21] -add {RAMB18_X12Y76:RAMB18_X12Y93}
resize_pblock [get_pblocks pblock_21] -add {RAMB36_X12Y38:RAMB36_X12Y46}
set_property SNAPPING_MODE ON [get_pblocks pblock_21]
create_pblock pblock_22
add_cells_to_pblock [get_pblocks pblock_22] [get_cells -quiet [list sym_i/zcore32_22]]
resize_pblock [get_pblocks pblock_22] -add {SLICE_X70Y190:SLICE_X75Y234}
resize_pblock [get_pblocks pblock_22] -add {DSP48E2_X14Y76:DSP48E2_X14Y93}
resize_pblock [get_pblocks pblock_22] -add {RAMB18_X9Y76:RAMB18_X9Y93}
resize_pblock [get_pblocks pblock_22] -add {RAMB36_X9Y38:RAMB36_X9Y46}
set_property SNAPPING_MODE ON [get_pblocks pblock_22]
create_pblock pblock_23
add_cells_to_pblock [get_pblocks pblock_23] [get_cells -quiet [list sym_i/zcore32_23]]
resize_pblock [get_pblocks pblock_23] -add {SLICE_X58Y190:SLICE_X63Y234}
resize_pblock [get_pblocks pblock_23] -add {DSP48E2_X12Y76:DSP48E2_X12Y93}
resize_pblock [get_pblocks pblock_23] -add {RAMB18_X7Y76:RAMB18_X7Y93}
resize_pblock [get_pblocks pblock_23] -add {RAMB36_X7Y38:RAMB36_X7Y46}
set_property SNAPPING_MODE ON [get_pblocks pblock_23]
create_pblock pblock_24
add_cells_to_pblock [get_pblocks pblock_24] [get_cells -quiet [list sym_i/zcore32_24]]
resize_pblock [get_pblocks pblock_24] -add {SLICE_X46Y190:SLICE_X51Y234}
resize_pblock [get_pblocks pblock_24] -add {DSP48E2_X9Y76:DSP48E2_X9Y93}
resize_pblock [get_pblocks pblock_24] -add {RAMB18_X6Y76:RAMB18_X6Y93}
resize_pblock [get_pblocks pblock_24] -add {RAMB36_X6Y38:RAMB36_X6Y46}
set_property SNAPPING_MODE ON [get_pblocks pblock_24]
create_pblock pblock_25
add_cells_to_pblock [get_pblocks pblock_25] [get_cells -quiet [list sym_i/zcore32_25]]
resize_pblock [get_pblocks pblock_25] -add {SLICE_X29Y190:SLICE_X34Y234}
resize_pblock [get_pblocks pblock_25] -add {DSP48E2_X6Y76:DSP48E2_X6Y93}
resize_pblock [get_pblocks pblock_25] -add {RAMB18_X4Y76:RAMB18_X4Y93}
resize_pblock [get_pblocks pblock_25] -add {RAMB36_X4Y38:RAMB36_X4Y46}
set_property SNAPPING_MODE ON [get_pblocks pblock_25]
create_pblock pblock_26
add_cells_to_pblock [get_pblocks pblock_26] [get_cells -quiet [list sym_i/zcore32_26]]
resize_pblock [get_pblocks pblock_26] -add {SLICE_X13Y190:SLICE_X18Y234}
resize_pblock [get_pblocks pblock_26] -add {DSP48E2_X2Y76:DSP48E2_X2Y93}
resize_pblock [get_pblocks pblock_26] -add {RAMB18_X2Y76:RAMB18_X2Y93}
resize_pblock [get_pblocks pblock_26] -add {RAMB36_X2Y38:RAMB36_X2Y46}
set_property SNAPPING_MODE ON [get_pblocks pblock_26]
create_pblock pblock_27
add_cells_to_pblock [get_pblocks pblock_27] [get_cells -quiet [list sym_i/zcore32_27]]
resize_pblock [get_pblocks pblock_27] -add {SLICE_X1Y190:SLICE_X6Y234}
resize_pblock [get_pblocks pblock_27] -add {DSP48E2_X0Y76:DSP48E2_X0Y93}
resize_pblock [get_pblocks pblock_27] -add {RAMB18_X0Y76:RAMB18_X0Y93}
resize_pblock [get_pblocks pblock_27] -add {RAMB36_X0Y38:RAMB36_X0Y46}
set_property SNAPPING_MODE ON [get_pblocks pblock_27]
create_pblock pblock_28
add_cells_to_pblock [get_pblocks pblock_28] [get_cells -quiet [list sym_i/zcore32_28]]
resize_pblock [get_pblocks pblock_28] -add {SLICE_X46Y125:SLICE_X51Y169}
resize_pblock [get_pblocks pblock_28] -add {DSP48E2_X9Y50:DSP48E2_X9Y67}
resize_pblock [get_pblocks pblock_28] -add {RAMB18_X6Y50:RAMB18_X6Y67}
resize_pblock [get_pblocks pblock_28] -add {RAMB36_X6Y25:RAMB36_X6Y33}
set_property SNAPPING_MODE ON [get_pblocks pblock_28]
create_pblock pblock_29
add_cells_to_pblock [get_pblocks pblock_29] [get_cells -quiet [list sym_i/zcore32_29]]
resize_pblock [get_pblocks pblock_29] -add {SLICE_X58Y125:SLICE_X63Y169}
resize_pblock [get_pblocks pblock_29] -add {DSP48E2_X12Y50:DSP48E2_X12Y67}
resize_pblock [get_pblocks pblock_29] -add {RAMB18_X7Y50:RAMB18_X7Y67}
resize_pblock [get_pblocks pblock_29] -add {RAMB36_X7Y25:RAMB36_X7Y33}
set_property SNAPPING_MODE ON [get_pblocks pblock_29]
create_pblock pblock_30
add_cells_to_pblock [get_pblocks pblock_30] [get_cells -quiet [list sym_i/zcore32_30]]
resize_pblock [get_pblocks pblock_30] -add {SLICE_X70Y125:SLICE_X75Y169}
resize_pblock [get_pblocks pblock_30] -add {DSP48E2_X14Y50:DSP48E2_X14Y67}
resize_pblock [get_pblocks pblock_30] -add {RAMB18_X9Y50:RAMB18_X9Y67}
resize_pblock [get_pblocks pblock_30] -add {RAMB36_X9Y25:RAMB36_X9Y33}
set_property SNAPPING_MODE ON [get_pblocks pblock_30]
create_pblock pblock_31
add_cells_to_pblock [get_pblocks pblock_31] [get_cells -quiet [list sym_i/zcore32_31]]
resize_pblock [get_pblocks pblock_31] -add {SLICE_X88Y130:SLICE_X95Y169}
resize_pblock [get_pblocks pblock_31] -add {DSP48E2_X17Y52:DSP48E2_X17Y67}
resize_pblock [get_pblocks pblock_31] -add {RAMB18_X12Y52:RAMB18_X12Y67}
resize_pblock [get_pblocks pblock_31] -add {RAMB36_X12Y26:RAMB36_X12Y33}
set_property SNAPPING_MODE ON [get_pblocks pblock_31]
create_pblock pblock_32
add_cells_to_pblock [get_pblocks pblock_32] [get_cells -quiet [list sym_i/zcore32_32]]
resize_pblock [get_pblocks pblock_32] -add {SLICE_X88Y70:SLICE_X95Y104}
resize_pblock [get_pblocks pblock_32] -add {DSP48E2_X17Y28:DSP48E2_X17Y41}
resize_pblock [get_pblocks pblock_32] -add {RAMB18_X12Y28:RAMB18_X12Y41}
resize_pblock [get_pblocks pblock_32] -add {RAMB36_X12Y14:RAMB36_X12Y20}
set_property SNAPPING_MODE ON [get_pblocks pblock_32]
create_pblock pblock_33
add_cells_to_pblock [get_pblocks pblock_33] [get_cells -quiet [list sym_i/zcore32_33]]
resize_pblock [get_pblocks pblock_33] -add {SLICE_X70Y65:SLICE_X75Y109}
resize_pblock [get_pblocks pblock_33] -add {DSP48E2_X14Y26:DSP48E2_X14Y43}
resize_pblock [get_pblocks pblock_33] -add {RAMB18_X9Y26:RAMB18_X9Y43}
resize_pblock [get_pblocks pblock_33] -add {RAMB36_X9Y13:RAMB36_X9Y21}
set_property SNAPPING_MODE ON [get_pblocks pblock_33]
create_pblock pblock_34
add_cells_to_pblock [get_pblocks pblock_34] [get_cells -quiet [list sym_i/zcore32_34]]
resize_pblock [get_pblocks pblock_34] -add {SLICE_X58Y65:SLICE_X63Y109}
resize_pblock [get_pblocks pblock_34] -add {DSP48E2_X12Y26:DSP48E2_X12Y43}
resize_pblock [get_pblocks pblock_34] -add {RAMB18_X7Y26:RAMB18_X7Y43}
resize_pblock [get_pblocks pblock_34] -add {RAMB36_X7Y13:RAMB36_X7Y21}
set_property SNAPPING_MODE ON [get_pblocks pblock_34]
create_pblock pblock_35
add_cells_to_pblock [get_pblocks pblock_35] [get_cells -quiet [list sym_i/zcore32_35]]
resize_pblock [get_pblocks pblock_35] -add {SLICE_X46Y65:SLICE_X51Y109}
resize_pblock [get_pblocks pblock_35] -add {DSP48E2_X9Y26:DSP48E2_X9Y43}
resize_pblock [get_pblocks pblock_35] -add {RAMB18_X6Y26:RAMB18_X6Y43}
resize_pblock [get_pblocks pblock_35] -add {RAMB36_X6Y13:RAMB36_X6Y21}
set_property SNAPPING_MODE ON [get_pblocks pblock_35]
create_pblock pblock_36
add_cells_to_pblock [get_pblocks pblock_36] [get_cells -quiet [list sym_i/zcore32_36]]
resize_pblock [get_pblocks pblock_36] -add {SLICE_X46Y0:SLICE_X51Y44}
resize_pblock [get_pblocks pblock_36] -add {DSP48E2_X9Y0:DSP48E2_X9Y17}
resize_pblock [get_pblocks pblock_36] -add {RAMB18_X6Y0:RAMB18_X6Y17}
resize_pblock [get_pblocks pblock_36] -add {RAMB36_X6Y0:RAMB36_X6Y8}
set_property SNAPPING_MODE ON [get_pblocks pblock_36]
create_pblock pblock_37
add_cells_to_pblock [get_pblocks pblock_37] [get_cells -quiet [list sym_i/zcore32_37]]
resize_pblock [get_pblocks pblock_37] -add {SLICE_X58Y0:SLICE_X63Y44}
resize_pblock [get_pblocks pblock_37] -add {DSP48E2_X12Y0:DSP48E2_X12Y17}
resize_pblock [get_pblocks pblock_37] -add {RAMB18_X7Y0:RAMB18_X7Y17}
resize_pblock [get_pblocks pblock_37] -add {RAMB36_X7Y0:RAMB36_X7Y8}
set_property SNAPPING_MODE ON [get_pblocks pblock_37]
create_pblock pblock_38
add_cells_to_pblock [get_pblocks pblock_38] [get_cells -quiet [list sym_i/zcore32_38]]
resize_pblock [get_pblocks pblock_38] -add {SLICE_X70Y0:SLICE_X75Y44}
resize_pblock [get_pblocks pblock_38] -add {DSP48E2_X14Y0:DSP48E2_X14Y17}
resize_pblock [get_pblocks pblock_38] -add {RAMB18_X9Y0:RAMB18_X9Y17}
resize_pblock [get_pblocks pblock_38] -add {RAMB36_X9Y0:RAMB36_X9Y8}
set_property SNAPPING_MODE ON [get_pblocks pblock_38]
create_pblock pblock_39
add_cells_to_pblock [get_pblocks pblock_39] [get_cells -quiet [list sym_i/zcore32_39]]
resize_pblock [get_pblocks pblock_39] -add {SLICE_X90Y0:SLICE_X95Y44}
resize_pblock [get_pblocks pblock_39] -add {DSP48E2_X17Y0:DSP48E2_X17Y17}
resize_pblock [get_pblocks pblock_39] -add {RAMB18_X12Y0:RAMB18_X12Y17}
resize_pblock [get_pblocks pblock_39] -add {RAMB36_X12Y0:RAMB36_X12Y8}
set_property SNAPPING_MODE ON [get_pblocks pblock_39]












