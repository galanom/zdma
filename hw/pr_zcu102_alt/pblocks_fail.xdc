

set_property HD.RECONFIGURABLE true [get_cells sym_i/zcore32_0]
create_pblock pblock_0
add_cells_to_pblock [get_pblocks pblock_0] [get_cells -quiet [list sym_i/zcore32_0]]
resize_pblock [get_pblocks pblock_0] -add {SLICE_X1Y360:SLICE_X4Y419}
resize_pblock [get_pblocks pblock_0] -add {DSP48E2_X0Y144:DSP48E2_X0Y167}
resize_pblock [get_pblocks pblock_0] -add {RAMB18_X0Y144:RAMB18_X0Y167}
resize_pblock [get_pblocks pblock_0] -add {RAMB36_X0Y72:RAMB36_X0Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_0]

create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list sym_i/zcore32_1]]
resize_pblock [get_pblocks pblock_1] -add {SLICE_X9Y360:SLICE_X12Y419}
resize_pblock [get_pblocks pblock_1] -add {DSP48E2_X1Y144:DSP48E2_X1Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X1Y144:RAMB18_X1Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X1Y72:RAMB36_X1Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_1]
create_pblock pblock_2
add_cells_to_pblock [get_pblocks pblock_2] [get_cells -quiet [list sym_i/zcore32_2]]
resize_pblock [get_pblocks pblock_2] -add {SLICE_X16Y360:SLICE_X19Y419}
resize_pblock [get_pblocks pblock_2] -add {DSP48E2_X3Y144:DSP48E2_X3Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB18_X2Y144:RAMB18_X2Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB36_X2Y72:RAMB36_X2Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_2]
create_pblock pblock_3
add_cells_to_pblock [get_pblocks pblock_3] [get_cells -quiet [list sym_i/zcore32_3]]
resize_pblock [get_pblocks pblock_3] -add {SLICE_X22Y360:SLICE_X25Y419}
resize_pblock [get_pblocks pblock_3] -add {DSP48E2_X4Y144:DSP48E2_X4Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB18_X3Y144:RAMB18_X3Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB36_X3Y72:RAMB36_X3Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_3]
create_pblock pblock_4
add_cells_to_pblock [get_pblocks pblock_4] [get_cells -quiet [list sym_i/zcore32_4]]
resize_pblock [get_pblocks pblock_4] -add {SLICE_X22Y300:SLICE_X25Y359}
resize_pblock [get_pblocks pblock_4] -add {DSP48E2_X4Y120:DSP48E2_X4Y143}
resize_pblock [get_pblocks pblock_4] -add {RAMB18_X3Y120:RAMB18_X3Y143}
resize_pblock [get_pblocks pblock_4] -add {RAMB36_X3Y60:RAMB36_X3Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_4]
create_pblock pblock_5
add_cells_to_pblock [get_pblocks pblock_5] [get_cells -quiet [list sym_i/zcore32_5]]
resize_pblock [get_pblocks pblock_5] -add {SLICE_X16Y300:SLICE_X19Y359}
resize_pblock [get_pblocks pblock_5] -add {DSP48E2_X3Y120:DSP48E2_X3Y143}
resize_pblock [get_pblocks pblock_5] -add {RAMB18_X2Y120:RAMB18_X2Y143}
resize_pblock [get_pblocks pblock_5] -add {RAMB36_X2Y60:RAMB36_X2Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_5]
create_pblock pblock_6
add_cells_to_pblock [get_pblocks pblock_6] [get_cells -quiet [list sym_i/zcore32_6]]
resize_pblock [get_pblocks pblock_6] -add {SLICE_X9Y300:SLICE_X12Y359}
resize_pblock [get_pblocks pblock_6] -add {DSP48E2_X1Y120:DSP48E2_X1Y143}
resize_pblock [get_pblocks pblock_6] -add {RAMB18_X1Y120:RAMB18_X1Y143}
resize_pblock [get_pblocks pblock_6] -add {RAMB36_X1Y60:RAMB36_X1Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_6]
create_pblock pblock_7
add_cells_to_pblock [get_pblocks pblock_7] [get_cells -quiet [list sym_i/zcore32_7]]
resize_pblock [get_pblocks pblock_7] -add {SLICE_X1Y300:SLICE_X4Y359}
resize_pblock [get_pblocks pblock_7] -add {DSP48E2_X0Y120:DSP48E2_X0Y143}
resize_pblock [get_pblocks pblock_7] -add {RAMB18_X0Y120:RAMB18_X0Y143}
resize_pblock [get_pblocks pblock_7] -add {RAMB36_X0Y60:RAMB36_X0Y71}
set_property SNAPPING_MODE ON [get_pblocks pblock_7]
create_pblock pblock_8
add_cells_to_pblock [get_pblocks pblock_8] [get_cells -quiet [list sym_i/zcore32_8]]
resize_pblock [get_pblocks pblock_8] -add {SLICE_X1Y240:SLICE_X4Y299}
resize_pblock [get_pblocks pblock_8] -add {DSP48E2_X0Y96:DSP48E2_X0Y119}
resize_pblock [get_pblocks pblock_8] -add {RAMB18_X0Y96:RAMB18_X0Y119}
resize_pblock [get_pblocks pblock_8] -add {RAMB36_X0Y48:RAMB36_X0Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_8]
create_pblock pblock_9
add_cells_to_pblock [get_pblocks pblock_9] [get_cells -quiet [list sym_i/zcore32_9]]
resize_pblock [get_pblocks pblock_9] -add {SLICE_X9Y240:SLICE_X12Y299}
resize_pblock [get_pblocks pblock_9] -add {DSP48E2_X1Y96:DSP48E2_X1Y119}
resize_pblock [get_pblocks pblock_9] -add {RAMB18_X1Y96:RAMB18_X1Y119}
resize_pblock [get_pblocks pblock_9] -add {RAMB36_X1Y48:RAMB36_X1Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_9]
create_pblock pblock_10
add_cells_to_pblock [get_pblocks pblock_10] [get_cells -quiet [list sym_i/zcore32_10]]
resize_pblock [get_pblocks pblock_10] -add {SLICE_X16Y240:SLICE_X19Y299}
resize_pblock [get_pblocks pblock_10] -add {DSP48E2_X3Y96:DSP48E2_X3Y119}
resize_pblock [get_pblocks pblock_10] -add {RAMB18_X2Y96:RAMB18_X2Y119}
resize_pblock [get_pblocks pblock_10] -add {RAMB36_X2Y48:RAMB36_X2Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_10]
create_pblock pblock_11
add_cells_to_pblock [get_pblocks pblock_11] [get_cells -quiet [list sym_i/zcore32_11]]
resize_pblock [get_pblocks pblock_11] -add {SLICE_X22Y240:SLICE_X25Y299}
resize_pblock [get_pblocks pblock_11] -add {DSP48E2_X4Y96:DSP48E2_X4Y119}
resize_pblock [get_pblocks pblock_11] -add {RAMB18_X3Y96:RAMB18_X3Y119}
resize_pblock [get_pblocks pblock_11] -add {RAMB36_X3Y48:RAMB36_X3Y59}
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
#set_property SNAPPING_MODE ON [get_pblocks pblock_a]
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
resize_pblock [get_pblocks pblock_12] -add {SLICE_X22Y180:SLICE_X25Y239}
resize_pblock [get_pblocks pblock_12] -add {DSP48E2_X4Y72:DSP48E2_X4Y95}
resize_pblock [get_pblocks pblock_12] -add {RAMB18_X3Y72:RAMB18_X3Y95}
resize_pblock [get_pblocks pblock_12] -add {RAMB36_X3Y36:RAMB36_X3Y47}
create_pblock pblock_13
add_cells_to_pblock [get_pblocks pblock_13] [get_cells -quiet [list sym_i/zcore32_13]]
resize_pblock [get_pblocks pblock_13] -add {SLICE_X16Y180:SLICE_X19Y239}
resize_pblock [get_pblocks pblock_13] -add {DSP48E2_X3Y72:DSP48E2_X3Y95}
resize_pblock [get_pblocks pblock_13] -add {RAMB18_X2Y72:RAMB18_X2Y95}
resize_pblock [get_pblocks pblock_13] -add {RAMB36_X2Y36:RAMB36_X2Y47}
create_pblock pblock_14
add_cells_to_pblock [get_pblocks pblock_14] [get_cells -quiet [list sym_i/zcore32_14]]
resize_pblock [get_pblocks pblock_14] -add {SLICE_X9Y180:SLICE_X12Y239}
resize_pblock [get_pblocks pblock_14] -add {DSP48E2_X1Y72:DSP48E2_X1Y95}
resize_pblock [get_pblocks pblock_14] -add {RAMB18_X1Y72:RAMB18_X1Y95}
resize_pblock [get_pblocks pblock_14] -add {RAMB36_X1Y36:RAMB36_X1Y47}
create_pblock pblock_15
add_cells_to_pblock [get_pblocks pblock_15] [get_cells -quiet [list sym_i/zcore32_15]]
resize_pblock [get_pblocks pblock_15] -add {SLICE_X1Y180:SLICE_X4Y239}
resize_pblock [get_pblocks pblock_15] -add {DSP48E2_X0Y72:DSP48E2_X0Y95}
resize_pblock [get_pblocks pblock_15] -add {RAMB18_X0Y72:RAMB18_X0Y95}
resize_pblock [get_pblocks pblock_15] -add {RAMB36_X0Y36:RAMB36_X0Y47}
create_pblock pblock_16
add_cells_to_pblock [get_pblocks pblock_16] [get_cells -quiet [list sym_i/zcore32_16]]
resize_pblock [get_pblocks pblock_16] -add {SLICE_X39Y360:SLICE_X40Y419}
resize_pblock [get_pblocks pblock_16] -add {DSP48E2_X7Y144:DSP48E2_X7Y167}
resize_pblock [get_pblocks pblock_16] -add {RAMB18_X5Y144:RAMB18_X5Y167}
resize_pblock [get_pblocks pblock_16] -add {RAMB36_X5Y72:RAMB36_X5Y83}
create_pblock pblock_17
add_cells_to_pblock [get_pblocks pblock_17] [get_cells -quiet [list sym_i/zcore32_17]]
resize_pblock [get_pblocks pblock_17] -add {SLICE_X44Y360:SLICE_X48Y419}
resize_pblock [get_pblocks pblock_17] -add {RAMB18_X6Y144:RAMB18_X6Y167}
resize_pblock [get_pblocks pblock_17] -add {RAMB36_X6Y72:RAMB36_X6Y83}
create_pblock pblock_18
add_cells_to_pblock [get_pblocks pblock_18] [get_cells -quiet [list sym_i/zcore32_18]]
resize_pblock [get_pblocks pblock_18] -add {SLICE_X58Y360:SLICE_X61Y419}
resize_pblock [get_pblocks pblock_18] -add {DSP48E2_X12Y144:DSP48E2_X12Y167}
resize_pblock [get_pblocks pblock_18] -add {RAMB18_X7Y144:RAMB18_X7Y167}
resize_pblock [get_pblocks pblock_18] -add {RAMB36_X7Y72:RAMB36_X7Y83}
create_pblock pblock_19
add_cells_to_pblock [get_pblocks pblock_19] [get_cells -quiet [list sym_i/zcore32_19]]
resize_pblock [get_pblocks pblock_19] -add {SLICE_X66Y360:SLICE_X69Y419}
resize_pblock [get_pblocks pblock_19] -add {DSP48E2_X13Y144:DSP48E2_X13Y167}
resize_pblock [get_pblocks pblock_19] -add {RAMB18_X8Y144:RAMB18_X8Y167}
resize_pblock [get_pblocks pblock_19] -add {RAMB36_X8Y72:RAMB36_X8Y83}
create_pblock pblock_20
add_cells_to_pblock [get_pblocks pblock_20] [get_cells -quiet [list sym_i/zcore32_20]]
resize_pblock [get_pblocks pblock_20] -add {SLICE_X66Y300:SLICE_X69Y359}
resize_pblock [get_pblocks pblock_20] -add {DSP48E2_X13Y120:DSP48E2_X13Y143}
resize_pblock [get_pblocks pblock_20] -add {RAMB18_X8Y120:RAMB18_X8Y143}
resize_pblock [get_pblocks pblock_20] -add {RAMB36_X8Y60:RAMB36_X8Y71}
create_pblock pblock_21
add_cells_to_pblock [get_pblocks pblock_21] [get_cells -quiet [list sym_i/zcore32_21]]
resize_pblock [get_pblocks pblock_21] -add {SLICE_X58Y300:SLICE_X61Y359}
resize_pblock [get_pblocks pblock_21] -add {DSP48E2_X12Y120:DSP48E2_X12Y143}
resize_pblock [get_pblocks pblock_21] -add {RAMB18_X7Y120:RAMB18_X7Y143}
resize_pblock [get_pblocks pblock_21] -add {RAMB36_X7Y60:RAMB36_X7Y71}
create_pblock pblock_22
add_cells_to_pblock [get_pblocks pblock_22] [get_cells -quiet [list sym_i/zcore32_22]]
resize_pblock [get_pblocks pblock_22] -add {SLICE_X44Y300:SLICE_X48Y359}
resize_pblock [get_pblocks pblock_22] -add {RAMB18_X6Y120:RAMB18_X6Y143}
resize_pblock [get_pblocks pblock_22] -add {RAMB36_X6Y60:RAMB36_X6Y71}
create_pblock pblock_23
add_cells_to_pblock [get_pblocks pblock_23] [get_cells -quiet [list sym_i/zcore32_23]]
resize_pblock [get_pblocks pblock_23] -add {SLICE_X39Y300:SLICE_X40Y359}
resize_pblock [get_pblocks pblock_23] -add {DSP48E2_X7Y120:DSP48E2_X7Y143}
resize_pblock [get_pblocks pblock_23] -add {RAMB18_X5Y120:RAMB18_X5Y143}
resize_pblock [get_pblocks pblock_23] -add {RAMB36_X5Y60:RAMB36_X5Y71}
create_pblock pblock_24
add_cells_to_pblock [get_pblocks pblock_24] [get_cells -quiet [list sym_i/zcore32_24]]
resize_pblock [get_pblocks pblock_24] -add {SLICE_X39Y240:SLICE_X40Y299}
resize_pblock [get_pblocks pblock_24] -add {DSP48E2_X7Y96:DSP48E2_X7Y119}
resize_pblock [get_pblocks pblock_24] -add {RAMB18_X5Y96:RAMB18_X5Y119}
resize_pblock [get_pblocks pblock_24] -add {RAMB36_X5Y48:RAMB36_X5Y59}
create_pblock pblock_25
add_cells_to_pblock [get_pblocks pblock_25] [get_cells -quiet [list sym_i/zcore32_25]]
resize_pblock [get_pblocks pblock_25] -add {SLICE_X44Y240:SLICE_X48Y299}
resize_pblock [get_pblocks pblock_25] -add {RAMB18_X6Y96:RAMB18_X6Y119}
resize_pblock [get_pblocks pblock_25] -add {RAMB36_X6Y48:RAMB36_X6Y59}
create_pblock pblock_26
add_cells_to_pblock [get_pblocks pblock_26] [get_cells -quiet [list sym_i/zcore32_26]]
resize_pblock [get_pblocks pblock_26] -add {SLICE_X58Y240:SLICE_X61Y299}
resize_pblock [get_pblocks pblock_26] -add {DSP48E2_X12Y96:DSP48E2_X12Y119}
resize_pblock [get_pblocks pblock_26] -add {RAMB18_X7Y96:RAMB18_X7Y119}
resize_pblock [get_pblocks pblock_26] -add {RAMB36_X7Y48:RAMB36_X7Y59}
create_pblock pblock_27
add_cells_to_pblock [get_pblocks pblock_27] [get_cells -quiet [list sym_i/zcore32_27]]
resize_pblock [get_pblocks pblock_27] -add {SLICE_X66Y240:SLICE_X69Y299}
resize_pblock [get_pblocks pblock_27] -add {DSP48E2_X13Y96:DSP48E2_X13Y119}
resize_pblock [get_pblocks pblock_27] -add {RAMB18_X8Y96:RAMB18_X8Y119}
resize_pblock [get_pblocks pblock_27] -add {RAMB36_X8Y48:RAMB36_X8Y59}
create_pblock pblock_28
add_cells_to_pblock [get_pblocks pblock_28] [get_cells -quiet [list sym_i/zcore32_28]]
resize_pblock [get_pblocks pblock_28] -add {SLICE_X66Y180:SLICE_X69Y239}
resize_pblock [get_pblocks pblock_28] -add {DSP48E2_X13Y72:DSP48E2_X13Y95}
resize_pblock [get_pblocks pblock_28] -add {RAMB18_X8Y72:RAMB18_X8Y95}
resize_pblock [get_pblocks pblock_28] -add {RAMB36_X8Y36:RAMB36_X8Y47}
create_pblock pblock_29
add_cells_to_pblock [get_pblocks pblock_29] [get_cells -quiet [list sym_i/zcore32_29]]
resize_pblock [get_pblocks pblock_29] -add {SLICE_X58Y180:SLICE_X61Y239}
resize_pblock [get_pblocks pblock_29] -add {DSP48E2_X12Y72:DSP48E2_X12Y95}
resize_pblock [get_pblocks pblock_29] -add {RAMB18_X7Y72:RAMB18_X7Y95}
resize_pblock [get_pblocks pblock_29] -add {RAMB36_X7Y36:RAMB36_X7Y47}
create_pblock pblock_30
add_cells_to_pblock [get_pblocks pblock_30] [get_cells -quiet [list sym_i/zcore32_30]]
resize_pblock [get_pblocks pblock_30] -add {SLICE_X44Y180:SLICE_X48Y239}
resize_pblock [get_pblocks pblock_30] -add {RAMB18_X6Y72:RAMB18_X6Y95}
resize_pblock [get_pblocks pblock_30] -add {RAMB36_X6Y36:RAMB36_X6Y47}
create_pblock pblock_31
add_cells_to_pblock [get_pblocks pblock_31] [get_cells -quiet [list sym_i/zcore32_31]]
resize_pblock [get_pblocks pblock_31] -add {SLICE_X39Y180:SLICE_X40Y239}
resize_pblock [get_pblocks pblock_31] -add {DSP48E2_X7Y72:DSP48E2_X7Y95}
resize_pblock [get_pblocks pblock_31] -add {RAMB18_X5Y72:RAMB18_X5Y95}
resize_pblock [get_pblocks pblock_31] -add {RAMB36_X5Y36:RAMB36_X5Y47}
create_pblock pblock_32
add_cells_to_pblock [get_pblocks pblock_32] [get_cells -quiet [list sym_i/zcore32_32]]
resize_pblock [get_pblocks pblock_32] -add {SLICE_X77Y180:SLICE_X80Y239}
resize_pblock [get_pblocks pblock_32] -add {DSP48E2_X15Y72:DSP48E2_X15Y95}
resize_pblock [get_pblocks pblock_32] -add {RAMB18_X10Y72:RAMB18_X10Y95}
resize_pblock [get_pblocks pblock_32] -add {RAMB36_X10Y36:RAMB36_X10Y47}
create_pblock pblock_33
add_cells_to_pblock [get_pblocks pblock_33] [get_cells -quiet [list sym_i/zcore32_33]]
resize_pblock [get_pblocks pblock_33] -add {SLICE_X77Y240:SLICE_X80Y299}
resize_pblock [get_pblocks pblock_33] -add {DSP48E2_X15Y96:DSP48E2_X15Y119}
resize_pblock [get_pblocks pblock_33] -add {RAMB18_X10Y96:RAMB18_X10Y119}
resize_pblock [get_pblocks pblock_33] -add {RAMB36_X10Y48:RAMB36_X10Y59}
create_pblock pblock_34
add_cells_to_pblock [get_pblocks pblock_34] [get_cells -quiet [list sym_i/zcore32_34]]
resize_pblock [get_pblocks pblock_34] -add {SLICE_X77Y300:SLICE_X80Y359}
resize_pblock [get_pblocks pblock_34] -add {DSP48E2_X15Y120:DSP48E2_X15Y143}
resize_pblock [get_pblocks pblock_34] -add {RAMB18_X10Y120:RAMB18_X10Y143}
resize_pblock [get_pblocks pblock_34] -add {RAMB36_X10Y60:RAMB36_X10Y71}
create_pblock pblock_35
add_cells_to_pblock [get_pblocks pblock_35] [get_cells -quiet [list sym_i/zcore32_35]]
resize_pblock [get_pblocks pblock_35] -add {SLICE_X77Y360:SLICE_X80Y419}
resize_pblock [get_pblocks pblock_35] -add {DSP48E2_X15Y144:DSP48E2_X15Y167}
resize_pblock [get_pblocks pblock_35] -add {RAMB18_X10Y144:RAMB18_X10Y167}
resize_pblock [get_pblocks pblock_35] -add {RAMB36_X10Y72:RAMB36_X10Y83}
create_pblock pblock_36
add_cells_to_pblock [get_pblocks pblock_36] [get_cells -quiet [list sym_i/zcore32_36]]
resize_pblock [get_pblocks pblock_36] -add {SLICE_X84Y360:SLICE_X87Y419}
resize_pblock [get_pblocks pblock_36] -add {DSP48E2_X16Y144:DSP48E2_X16Y167}
resize_pblock [get_pblocks pblock_36] -add {RAMB18_X11Y144:RAMB18_X11Y167}
resize_pblock [get_pblocks pblock_36] -add {RAMB36_X11Y72:RAMB36_X11Y83}
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_36]
create_pblock pblock_37
add_cells_to_pblock [get_pblocks pblock_37] [get_cells -quiet [list sym_i/zcore32_37]]
resize_pblock [get_pblocks pblock_37] -add {SLICE_X84Y300:SLICE_X87Y359}
resize_pblock [get_pblocks pblock_37] -add {DSP48E2_X16Y120:DSP48E2_X16Y143}
resize_pblock [get_pblocks pblock_37] -add {RAMB18_X11Y120:RAMB18_X11Y143}
resize_pblock [get_pblocks pblock_37] -add {RAMB36_X11Y60:RAMB36_X11Y71}
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_37]
create_pblock pblock_38
add_cells_to_pblock [get_pblocks pblock_38] [get_cells -quiet [list sym_i/zcore32_38]]
resize_pblock [get_pblocks pblock_38] -add {SLICE_X84Y240:SLICE_X87Y299}
resize_pblock [get_pblocks pblock_38] -add {DSP48E2_X16Y96:DSP48E2_X16Y119}
resize_pblock [get_pblocks pblock_38] -add {RAMB18_X11Y96:RAMB18_X11Y119}
resize_pblock [get_pblocks pblock_38] -add {RAMB36_X11Y48:RAMB36_X11Y59}
create_pblock pblock_39
add_cells_to_pblock [get_pblocks pblock_39] [get_cells -quiet [list sym_i/zcore32_39]]
resize_pblock [get_pblocks pblock_39] -add {SLICE_X84Y180:SLICE_X87Y239}
resize_pblock [get_pblocks pblock_39] -add {DSP48E2_X16Y72:DSP48E2_X16Y95}
resize_pblock [get_pblocks pblock_39] -add {RAMB18_X11Y72:RAMB18_X11Y95}
resize_pblock [get_pblocks pblock_39] -add {RAMB36_X11Y36:RAMB36_X11Y47}
create_pblock pblock_40
add_cells_to_pblock [get_pblocks pblock_40] [get_cells -quiet [list sym_i/zcore32_40]]
resize_pblock [get_pblocks pblock_40] -add {SLICE_X84Y120:SLICE_X87Y179}
resize_pblock [get_pblocks pblock_40] -add {DSP48E2_X16Y48:DSP48E2_X16Y71}
resize_pblock [get_pblocks pblock_40] -add {RAMB18_X11Y48:RAMB18_X11Y71}
resize_pblock [get_pblocks pblock_40] -add {RAMB36_X11Y24:RAMB36_X11Y35}
create_pblock pblock_41
add_cells_to_pblock [get_pblocks pblock_41] [get_cells -quiet [list sym_i/zcore32_41]]
resize_pblock [get_pblocks pblock_41] -add {SLICE_X77Y120:SLICE_X80Y179}
resize_pblock [get_pblocks pblock_41] -add {DSP48E2_X15Y48:DSP48E2_X15Y71}
resize_pblock [get_pblocks pblock_41] -add {RAMB18_X10Y48:RAMB18_X10Y71}
resize_pblock [get_pblocks pblock_41] -add {RAMB36_X10Y24:RAMB36_X10Y35}
create_pblock pblock_42
add_cells_to_pblock [get_pblocks pblock_42] [get_cells -quiet [list sym_i/zcore32_42]]
resize_pblock [get_pblocks pblock_42] -add {SLICE_X66Y120:SLICE_X69Y179}
resize_pblock [get_pblocks pblock_42] -add {DSP48E2_X13Y48:DSP48E2_X13Y71}
resize_pblock [get_pblocks pblock_42] -add {RAMB18_X8Y48:RAMB18_X8Y71}
resize_pblock [get_pblocks pblock_42] -add {RAMB36_X8Y24:RAMB36_X8Y35}
create_pblock pblock_43
add_cells_to_pblock [get_pblocks pblock_43] [get_cells -quiet [list sym_i/zcore32_43]]
resize_pblock [get_pblocks pblock_43] -add {SLICE_X66Y60:SLICE_X69Y119}
resize_pblock [get_pblocks pblock_43] -add {DSP48E2_X13Y24:DSP48E2_X13Y47}
resize_pblock [get_pblocks pblock_43] -add {RAMB18_X8Y24:RAMB18_X8Y47}
resize_pblock [get_pblocks pblock_43] -add {RAMB36_X8Y12:RAMB36_X8Y23}
create_pblock pblock_44
add_cells_to_pblock [get_pblocks pblock_44] [get_cells -quiet [list sym_i/zcore32_44]]
resize_pblock [get_pblocks pblock_44] -add {SLICE_X84Y60:SLICE_X87Y119}
resize_pblock [get_pblocks pblock_44] -add {DSP48E2_X16Y24:DSP48E2_X16Y47}
resize_pblock [get_pblocks pblock_44] -add {RAMB18_X11Y24:RAMB18_X11Y47}
resize_pblock [get_pblocks pblock_44] -add {RAMB36_X11Y12:RAMB36_X11Y23}
create_pblock pblock_45
add_cells_to_pblock [get_pblocks pblock_45] [get_cells -quiet [list sym_i/zcore32_45]]
resize_pblock [get_pblocks pblock_45] -add {SLICE_X84Y0:SLICE_X87Y59}
resize_pblock [get_pblocks pblock_45] -add {DSP48E2_X16Y0:DSP48E2_X16Y23}
resize_pblock [get_pblocks pblock_45] -add {RAMB18_X11Y0:RAMB18_X11Y23}
resize_pblock [get_pblocks pblock_45] -add {RAMB36_X11Y0:RAMB36_X11Y11}
create_pblock pblock_46
add_cells_to_pblock [get_pblocks pblock_46] [get_cells -quiet [list sym_i/zcore32_46]]
resize_pblock [get_pblocks pblock_46] -add {SLICE_X77Y0:SLICE_X80Y59}
resize_pblock [get_pblocks pblock_46] -add {DSP48E2_X15Y0:DSP48E2_X15Y23}
resize_pblock [get_pblocks pblock_46] -add {RAMB18_X10Y0:RAMB18_X10Y23}
resize_pblock [get_pblocks pblock_46] -add {RAMB36_X10Y0:RAMB36_X10Y11}
create_pblock pblock_47
add_cells_to_pblock [get_pblocks pblock_47] [get_cells -quiet [list sym_i/zcore32_47]]
resize_pblock [get_pblocks pblock_47] -add {SLICE_X66Y0:SLICE_X69Y59}
resize_pblock [get_pblocks pblock_47] -add {DSP48E2_X13Y0:DSP48E2_X13Y23}
resize_pblock [get_pblocks pblock_47] -add {RAMB18_X8Y0:RAMB18_X8Y23}
resize_pblock [get_pblocks pblock_47] -add {RAMB36_X8Y0:RAMB36_X8Y11}
set_property SNAPPING_MODE ON [get_pblocks pblock_47]









