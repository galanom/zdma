set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_0]
create_pblock pblock_0
add_cells_to_pblock [get_pblocks pblock_0] [get_cells -quiet [list sym_i/zcore32_0]]
resize_pblock [get_pblocks pblock_0] -add {SLICE_X1Y360:SLICE_X6Y419}
resize_pblock [get_pblocks pblock_0] -add {DSP48E2_X0Y144:DSP48E2_X0Y167}
resize_pblock [get_pblocks pblock_0] -add {RAMB18_X0Y144:RAMB18_X0Y167}
resize_pblock [get_pblocks pblock_0] -add {RAMB36_X0Y72:RAMB36_X0Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_0]

create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list sym_i/zcore32_1]]
resize_pblock [get_pblocks pblock_1] -add {SLICE_X13Y360:SLICE_X18Y419}
resize_pblock [get_pblocks pblock_1] -add {DSP48E2_X2Y144:DSP48E2_X2Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X2Y144:RAMB18_X2Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X2Y72:RAMB36_X2Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_1]
create_pblock pblock_2
add_cells_to_pblock [get_pblocks pblock_2] [get_cells -quiet [list sym_i/zcore32_2]]
resize_pblock [get_pblocks pblock_2] -add {SLICE_X29Y360:SLICE_X34Y419}
resize_pblock [get_pblocks pblock_2] -add {DSP48E2_X6Y144:DSP48E2_X6Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB18_X4Y144:RAMB18_X4Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB36_X4Y72:RAMB36_X4Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_2]
create_pblock pblock_3
add_cells_to_pblock [get_pblocks pblock_3] [get_cells -quiet [list sym_i/zcore32_3]]
resize_pblock [get_pblocks pblock_3] -add {SLICE_X46Y360:SLICE_X51Y419}
resize_pblock [get_pblocks pblock_3] -add {DSP48E2_X9Y144:DSP48E2_X9Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB18_X6Y144:RAMB18_X6Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB36_X6Y72:RAMB36_X6Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_3]
create_pblock pblock_4
add_cells_to_pblock [get_pblocks pblock_4] [get_cells -quiet [list sym_i/zcore32_4]]
resize_pblock [get_pblocks pblock_4] -add {SLICE_X58Y360:SLICE_X63Y419}
resize_pblock [get_pblocks pblock_4] -add {DSP48E2_X12Y144:DSP48E2_X12Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB18_X7Y144:RAMB18_X7Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB36_X7Y72:RAMB36_X7Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_4]
create_pblock pblock_5
add_cells_to_pblock [get_pblocks pblock_5] [get_cells -quiet [list sym_i/zcore32_5]]
resize_pblock [get_pblocks pblock_5] -add {SLICE_X70Y360:SLICE_X75Y419}
resize_pblock [get_pblocks pblock_5] -add {DSP48E2_X14Y144:DSP48E2_X14Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB18_X9Y144:RAMB18_X9Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB36_X9Y72:RAMB36_X9Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_5]
create_pblock pblock_6
add_cells_to_pblock [get_pblocks pblock_6] [get_cells -quiet [list sym_i/zcore32_6]]
resize_pblock [get_pblocks pblock_6] -add {SLICE_X90Y360:SLICE_X95Y419}
resize_pblock [get_pblocks pblock_6] -add {DSP48E2_X17Y144:DSP48E2_X17Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB18_X12Y144:RAMB18_X12Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB36_X12Y72:RAMB36_X12Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_6]
create_pblock pblock_7
add_cells_to_pblock [get_pblocks pblock_7] [get_cells -quiet [list sym_i/zcore32_7]]
resize_pblock [get_pblocks pblock_7] -add {SLICE_X90Y300:SLICE_X95Y359}
resize_pblock [get_pblocks pblock_7] -add {DSP48E2_X17Y120:DSP48E2_X17Y143}
resize_pblock [get_pblocks pblock_7] -add {RAMB18_X12Y120:RAMB18_X12Y143}
resize_pblock [get_pblocks pblock_7] -add {RAMB36_X12Y60:RAMB36_X12Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_7]
create_pblock pblock_8
add_cells_to_pblock [get_pblocks pblock_8] [get_cells -quiet [list sym_i/zcore32_8]]
resize_pblock [get_pblocks pblock_8] -add {SLICE_X70Y300:SLICE_X75Y359}
resize_pblock [get_pblocks pblock_8] -add {DSP48E2_X14Y120:DSP48E2_X14Y143}
resize_pblock [get_pblocks pblock_8] -add {RAMB18_X9Y120:RAMB18_X9Y143}
resize_pblock [get_pblocks pblock_8] -add {RAMB36_X9Y60:RAMB36_X9Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_8]
create_pblock pblock_9
add_cells_to_pblock [get_pblocks pblock_9] [get_cells -quiet [list sym_i/zcore32_9]]
resize_pblock [get_pblocks pblock_9] -add {SLICE_X58Y300:SLICE_X63Y359}
resize_pblock [get_pblocks pblock_9] -add {DSP48E2_X12Y120:DSP48E2_X12Y143}
resize_pblock [get_pblocks pblock_9] -add {RAMB18_X7Y120:RAMB18_X7Y143}
resize_pblock [get_pblocks pblock_9] -add {RAMB36_X7Y60:RAMB36_X7Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_9]
create_pblock pblock_10
add_cells_to_pblock [get_pblocks pblock_10] [get_cells -quiet [list sym_i/zcore32_10]]
resize_pblock [get_pblocks pblock_10] -add {SLICE_X46Y300:SLICE_X51Y359}
resize_pblock [get_pblocks pblock_10] -add {DSP48E2_X9Y120:DSP48E2_X9Y143}
resize_pblock [get_pblocks pblock_10] -add {RAMB18_X6Y120:RAMB18_X6Y143}
resize_pblock [get_pblocks pblock_10] -add {RAMB36_X6Y60:RAMB36_X6Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_10]
create_pblock pblock_11
add_cells_to_pblock [get_pblocks pblock_11] [get_cells -quiet [list sym_i/zcore32_11]]
resize_pblock [get_pblocks pblock_11] -add {SLICE_X29Y300:SLICE_X34Y359}
resize_pblock [get_pblocks pblock_11] -add {DSP48E2_X6Y120:DSP48E2_X6Y143}
resize_pblock [get_pblocks pblock_11] -add {RAMB18_X4Y120:RAMB18_X4Y143}
resize_pblock [get_pblocks pblock_11] -add {RAMB36_X4Y60:RAMB36_X4Y71}
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
resize_pblock [get_pblocks pblock_12] -add {SLICE_X13Y300:SLICE_X18Y359}
resize_pblock [get_pblocks pblock_12] -add {DSP48E2_X2Y120:DSP48E2_X2Y143}
resize_pblock [get_pblocks pblock_12] -add {RAMB18_X2Y120:RAMB18_X2Y143}
resize_pblock [get_pblocks pblock_12] -add {RAMB36_X2Y60:RAMB36_X2Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_12]
create_pblock pblock_13
add_cells_to_pblock [get_pblocks pblock_13] [get_cells -quiet [list sym_i/zcore32_13]]
resize_pblock [get_pblocks pblock_13] -add {SLICE_X1Y300:SLICE_X6Y359}
resize_pblock [get_pblocks pblock_13] -add {DSP48E2_X0Y120:DSP48E2_X0Y143}
resize_pblock [get_pblocks pblock_13] -add {RAMB18_X0Y120:RAMB18_X0Y143}
resize_pblock [get_pblocks pblock_13] -add {RAMB36_X0Y60:RAMB36_X0Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_13]
create_pblock pblock_14
add_cells_to_pblock [get_pblocks pblock_14] [get_cells -quiet [list sym_i/zcore32_14]]
resize_pblock [get_pblocks pblock_14] -add {SLICE_X1Y240:SLICE_X6Y299}
resize_pblock [get_pblocks pblock_14] -add {DSP48E2_X0Y96:DSP48E2_X0Y119}
resize_pblock [get_pblocks pblock_14] -add {RAMB18_X0Y96:RAMB18_X0Y119}
resize_pblock [get_pblocks pblock_14] -add {RAMB36_X0Y48:RAMB36_X0Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_14]
create_pblock pblock_15
add_cells_to_pblock [get_pblocks pblock_15] [get_cells -quiet [list sym_i/zcore32_15]]
resize_pblock [get_pblocks pblock_15] -add {SLICE_X13Y240:SLICE_X18Y299}
resize_pblock [get_pblocks pblock_15] -add {DSP48E2_X2Y96:DSP48E2_X2Y119}
resize_pblock [get_pblocks pblock_15] -add {RAMB18_X2Y96:RAMB18_X2Y119}
resize_pblock [get_pblocks pblock_15] -add {RAMB36_X2Y48:RAMB36_X2Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_15]
create_pblock pblock_16
add_cells_to_pblock [get_pblocks pblock_16] [get_cells -quiet [list sym_i/zcore32_16]]
resize_pblock [get_pblocks pblock_16] -add {SLICE_X29Y240:SLICE_X34Y299}
resize_pblock [get_pblocks pblock_16] -add {DSP48E2_X6Y96:DSP48E2_X6Y119}
resize_pblock [get_pblocks pblock_16] -add {RAMB18_X4Y96:RAMB18_X4Y119}
resize_pblock [get_pblocks pblock_16] -add {RAMB36_X4Y48:RAMB36_X4Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_16]
create_pblock pblock_17
add_cells_to_pblock [get_pblocks pblock_17] [get_cells -quiet [list sym_i/zcore32_17]]
resize_pblock [get_pblocks pblock_17] -add {SLICE_X46Y240:SLICE_X51Y299}
resize_pblock [get_pblocks pblock_17] -add {DSP48E2_X9Y96:DSP48E2_X9Y119}
resize_pblock [get_pblocks pblock_17] -add {RAMB18_X6Y96:RAMB18_X6Y119}
resize_pblock [get_pblocks pblock_17] -add {RAMB36_X6Y48:RAMB36_X6Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_17]
create_pblock pblock_18
add_cells_to_pblock [get_pblocks pblock_18] [get_cells -quiet [list sym_i/zcore32_18]]
resize_pblock [get_pblocks pblock_18] -add {SLICE_X58Y240:SLICE_X63Y299}
resize_pblock [get_pblocks pblock_18] -add {DSP48E2_X12Y96:DSP48E2_X12Y119}
resize_pblock [get_pblocks pblock_18] -add {RAMB18_X7Y96:RAMB18_X7Y119}
resize_pblock [get_pblocks pblock_18] -add {RAMB36_X7Y48:RAMB36_X7Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_18]
create_pblock pblock_19
add_cells_to_pblock [get_pblocks pblock_19] [get_cells -quiet [list sym_i/zcore32_19]]
resize_pblock [get_pblocks pblock_19] -add {SLICE_X70Y240:SLICE_X75Y299}
resize_pblock [get_pblocks pblock_19] -add {DSP48E2_X14Y96:DSP48E2_X14Y119}
resize_pblock [get_pblocks pblock_19] -add {RAMB18_X9Y96:RAMB18_X9Y119}
resize_pblock [get_pblocks pblock_19] -add {RAMB36_X9Y48:RAMB36_X9Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_19]
create_pblock pblock_20
add_cells_to_pblock [get_pblocks pblock_20] [get_cells -quiet [list sym_i/zcore32_20]]
resize_pblock [get_pblocks pblock_20] -add {SLICE_X90Y240:SLICE_X95Y299}
resize_pblock [get_pblocks pblock_20] -add {DSP48E2_X17Y96:DSP48E2_X17Y119}
resize_pblock [get_pblocks pblock_20] -add {RAMB18_X12Y96:RAMB18_X12Y119}
resize_pblock [get_pblocks pblock_20] -add {RAMB36_X12Y48:RAMB36_X12Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_20]
create_pblock pblock_21
add_cells_to_pblock [get_pblocks pblock_21] [get_cells -quiet [list sym_i/zcore32_21]]
resize_pblock [get_pblocks pblock_21] -add {SLICE_X90Y180:SLICE_X95Y239}
resize_pblock [get_pblocks pblock_21] -add {DSP48E2_X17Y72:DSP48E2_X17Y95}
resize_pblock [get_pblocks pblock_21] -add {RAMB18_X12Y72:RAMB18_X12Y95}
resize_pblock [get_pblocks pblock_21] -add {RAMB36_X12Y36:RAMB36_X12Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_21]
create_pblock pblock_22
add_cells_to_pblock [get_pblocks pblock_22] [get_cells -quiet [list sym_i/zcore32_22]]
resize_pblock [get_pblocks pblock_22] -add {SLICE_X70Y180:SLICE_X75Y239}
resize_pblock [get_pblocks pblock_22] -add {DSP48E2_X14Y72:DSP48E2_X14Y95}
resize_pblock [get_pblocks pblock_22] -add {RAMB18_X9Y72:RAMB18_X9Y95}
resize_pblock [get_pblocks pblock_22] -add {RAMB36_X9Y36:RAMB36_X9Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_22]
create_pblock pblock_23
add_cells_to_pblock [get_pblocks pblock_23] [get_cells -quiet [list sym_i/zcore32_23]]
resize_pblock [get_pblocks pblock_23] -add {SLICE_X58Y180:SLICE_X63Y239}
resize_pblock [get_pblocks pblock_23] -add {DSP48E2_X12Y72:DSP48E2_X12Y95}
resize_pblock [get_pblocks pblock_23] -add {RAMB18_X7Y72:RAMB18_X7Y95}
resize_pblock [get_pblocks pblock_23] -add {RAMB36_X7Y36:RAMB36_X7Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_23]
create_pblock pblock_24
add_cells_to_pblock [get_pblocks pblock_24] [get_cells -quiet [list sym_i/zcore32_24]]
resize_pblock [get_pblocks pblock_24] -add {SLICE_X46Y180:SLICE_X51Y239}
resize_pblock [get_pblocks pblock_24] -add {DSP48E2_X9Y72:DSP48E2_X9Y95}
resize_pblock [get_pblocks pblock_24] -add {RAMB18_X6Y72:RAMB18_X6Y95}
resize_pblock [get_pblocks pblock_24] -add {RAMB36_X6Y36:RAMB36_X6Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_24]
create_pblock pblock_25
add_cells_to_pblock [get_pblocks pblock_25] [get_cells -quiet [list sym_i/zcore32_25]]
resize_pblock [get_pblocks pblock_25] -add {SLICE_X29Y180:SLICE_X34Y239}
resize_pblock [get_pblocks pblock_25] -add {DSP48E2_X6Y72:DSP48E2_X6Y95}
resize_pblock [get_pblocks pblock_25] -add {RAMB18_X4Y72:RAMB18_X4Y95}
resize_pblock [get_pblocks pblock_25] -add {RAMB36_X4Y36:RAMB36_X4Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_25]
create_pblock pblock_26
add_cells_to_pblock [get_pblocks pblock_26] [get_cells -quiet [list sym_i/zcore32_26]]
resize_pblock [get_pblocks pblock_26] -add {SLICE_X13Y180:SLICE_X18Y239}
resize_pblock [get_pblocks pblock_26] -add {DSP48E2_X2Y72:DSP48E2_X2Y95}
resize_pblock [get_pblocks pblock_26] -add {RAMB18_X2Y72:RAMB18_X2Y95}
resize_pblock [get_pblocks pblock_26] -add {RAMB36_X2Y36:RAMB36_X2Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_26]
create_pblock pblock_27
add_cells_to_pblock [get_pblocks pblock_27] [get_cells -quiet [list sym_i/zcore32_27]]
resize_pblock [get_pblocks pblock_27] -add {SLICE_X1Y180:SLICE_X6Y239}
resize_pblock [get_pblocks pblock_27] -add {DSP48E2_X0Y72:DSP48E2_X0Y95}
resize_pblock [get_pblocks pblock_27] -add {RAMB18_X0Y72:RAMB18_X0Y95}
resize_pblock [get_pblocks pblock_27] -add {RAMB36_X0Y36:RAMB36_X0Y47}
set_property SNAPPING_MODE ON [get_pblocks pblock_27]
create_pblock pblock_28
add_cells_to_pblock [get_pblocks pblock_28] [get_cells -quiet [list sym_i/zcore32_28]]
resize_pblock [get_pblocks pblock_28] -add {SLICE_X46Y120:SLICE_X51Y179}
resize_pblock [get_pblocks pblock_28] -add {DSP48E2_X9Y48:DSP48E2_X9Y71}
resize_pblock [get_pblocks pblock_28] -add {RAMB18_X6Y48:RAMB18_X6Y71}
resize_pblock [get_pblocks pblock_28] -add {RAMB36_X6Y24:RAMB36_X6Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_28]
create_pblock pblock_29
add_cells_to_pblock [get_pblocks pblock_29] [get_cells -quiet [list sym_i/zcore32_29]]
resize_pblock [get_pblocks pblock_29] -add {SLICE_X58Y120:SLICE_X63Y179}
resize_pblock [get_pblocks pblock_29] -add {DSP48E2_X12Y48:DSP48E2_X12Y71}
resize_pblock [get_pblocks pblock_29] -add {RAMB18_X7Y48:RAMB18_X7Y71}
resize_pblock [get_pblocks pblock_29] -add {RAMB36_X7Y24:RAMB36_X7Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_29]
create_pblock pblock_30
add_cells_to_pblock [get_pblocks pblock_30] [get_cells -quiet [list sym_i/zcore32_30]]
resize_pblock [get_pblocks pblock_30] -add {SLICE_X70Y120:SLICE_X75Y179}
resize_pblock [get_pblocks pblock_30] -add {DSP48E2_X14Y48:DSP48E2_X14Y71}
resize_pblock [get_pblocks pblock_30] -add {RAMB18_X9Y48:RAMB18_X9Y71}
resize_pblock [get_pblocks pblock_30] -add {RAMB36_X9Y24:RAMB36_X9Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_30]
create_pblock pblock_31
add_cells_to_pblock [get_pblocks pblock_31] [get_cells -quiet [list sym_i/zcore32_31]]
resize_pblock [get_pblocks pblock_31] -add {SLICE_X90Y120:SLICE_X95Y179}
resize_pblock [get_pblocks pblock_31] -add {DSP48E2_X17Y48:DSP48E2_X17Y71}
resize_pblock [get_pblocks pblock_31] -add {RAMB18_X12Y48:RAMB18_X12Y71}
resize_pblock [get_pblocks pblock_31] -add {RAMB36_X12Y24:RAMB36_X12Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_31]
create_pblock pblock_32
add_cells_to_pblock [get_pblocks pblock_32] [get_cells -quiet [list sym_i/zcore32_32]]
resize_pblock [get_pblocks pblock_32] -add {SLICE_X90Y60:SLICE_X95Y119}
resize_pblock [get_pblocks pblock_32] -add {DSP48E2_X17Y24:DSP48E2_X17Y47}
resize_pblock [get_pblocks pblock_32] -add {RAMB18_X12Y24:RAMB18_X12Y47}
resize_pblock [get_pblocks pblock_32] -add {RAMB36_X12Y12:RAMB36_X12Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_32]
create_pblock pblock_33
add_cells_to_pblock [get_pblocks pblock_33] [get_cells -quiet [list sym_i/zcore32_33]]
resize_pblock [get_pblocks pblock_33] -add {SLICE_X70Y60:SLICE_X75Y119}
resize_pblock [get_pblocks pblock_33] -add {DSP48E2_X14Y24:DSP48E2_X14Y47}
resize_pblock [get_pblocks pblock_33] -add {RAMB18_X9Y24:RAMB18_X9Y47}
resize_pblock [get_pblocks pblock_33] -add {RAMB36_X9Y12:RAMB36_X9Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_33]
create_pblock pblock_34
add_cells_to_pblock [get_pblocks pblock_34] [get_cells -quiet [list sym_i/zcore32_34]]
resize_pblock [get_pblocks pblock_34] -add {SLICE_X58Y60:SLICE_X63Y119}
resize_pblock [get_pblocks pblock_34] -add {DSP48E2_X12Y24:DSP48E2_X12Y47}
resize_pblock [get_pblocks pblock_34] -add {RAMB18_X7Y24:RAMB18_X7Y47}
resize_pblock [get_pblocks pblock_34] -add {RAMB36_X7Y12:RAMB36_X7Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_34]
create_pblock pblock_35
add_cells_to_pblock [get_pblocks pblock_35] [get_cells -quiet [list sym_i/zcore32_35]]
resize_pblock [get_pblocks pblock_35] -add {SLICE_X46Y60:SLICE_X51Y119}
resize_pblock [get_pblocks pblock_35] -add {DSP48E2_X9Y24:DSP48E2_X9Y47}
resize_pblock [get_pblocks pblock_35] -add {RAMB18_X6Y24:RAMB18_X6Y47}
resize_pblock [get_pblocks pblock_35] -add {RAMB36_X6Y12:RAMB36_X6Y23}
set_property SNAPPING_MODE ON [get_pblocks pblock_35]
create_pblock pblock_36
add_cells_to_pblock [get_pblocks pblock_36] [get_cells -quiet [list sym_i/zcore32_36]]
resize_pblock [get_pblocks pblock_36] -add {SLICE_X46Y0:SLICE_X51Y59}
resize_pblock [get_pblocks pblock_36] -add {DSP48E2_X9Y0:DSP48E2_X9Y23}
resize_pblock [get_pblocks pblock_36] -add {RAMB18_X6Y0:RAMB18_X6Y23}
resize_pblock [get_pblocks pblock_36] -add {RAMB36_X6Y0:RAMB36_X6Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_36]
create_pblock pblock_37
add_cells_to_pblock [get_pblocks pblock_37] [get_cells -quiet [list sym_i/zcore32_37]]
resize_pblock [get_pblocks pblock_37] -add {SLICE_X58Y0:SLICE_X63Y59}
resize_pblock [get_pblocks pblock_37] -add {DSP48E2_X12Y0:DSP48E2_X12Y23}
resize_pblock [get_pblocks pblock_37] -add {RAMB18_X7Y0:RAMB18_X7Y23}
resize_pblock [get_pblocks pblock_37] -add {RAMB36_X7Y0:RAMB36_X7Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_37]
create_pblock pblock_38
add_cells_to_pblock [get_pblocks pblock_38] [get_cells -quiet [list sym_i/zcore32_38]]
resize_pblock [get_pblocks pblock_38] -add {SLICE_X70Y0:SLICE_X75Y59}
resize_pblock [get_pblocks pblock_38] -add {DSP48E2_X14Y0:DSP48E2_X14Y23}
resize_pblock [get_pblocks pblock_38] -add {RAMB18_X9Y0:RAMB18_X9Y23}
resize_pblock [get_pblocks pblock_38] -add {RAMB36_X9Y0:RAMB36_X9Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_38]
create_pblock pblock_39
add_cells_to_pblock [get_pblocks pblock_39] [get_cells -quiet [list sym_i/zcore32_39]]
resize_pblock [get_pblocks pblock_39] -add {SLICE_X90Y0:SLICE_X95Y59}
resize_pblock [get_pblocks pblock_39] -add {DSP48E2_X17Y0:DSP48E2_X17Y23}
resize_pblock [get_pblocks pblock_39] -add {RAMB18_X12Y0:RAMB18_X12Y23}
resize_pblock [get_pblocks pblock_39] -add {RAMB36_X12Y0:RAMB36_X12Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_39]













