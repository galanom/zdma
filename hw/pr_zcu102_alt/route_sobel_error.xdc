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
resize_pblock [get_pblocks pblock_1] -add {SLICE_X9Y385:SLICE_X15Y419}
resize_pblock [get_pblocks pblock_1] -add {DSP48E2_X1Y154:DSP48E2_X2Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X1Y154:RAMB18_X1Y167}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X1Y77:RAMB36_X1Y83}
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
resize_pblock [get_pblocks pblock_3] -add {SLICE_X31Y390:SLICE_X38Y419}
resize_pblock [get_pblocks pblock_3] -add {DSP48E2_X6Y156:DSP48E2_X6Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB18_X4Y156:RAMB18_X4Y167}
resize_pblock [get_pblocks pblock_3] -add {RAMB36_X4Y78:RAMB36_X4Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_3]

create_pblock pblock_4
add_cells_to_pblock [get_pblocks pblock_4] [get_cells -quiet [list sym_i/zcore32_4]]
resize_pblock [get_pblocks pblock_4] -add {SLICE_X41Y390:SLICE_X48Y419}
resize_pblock [get_pblocks pblock_4] -add {DSP48E2_X8Y156:DSP48E2_X8Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB18_X6Y156:RAMB18_X6Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB36_X6Y78:RAMB36_X6Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_4]

create_pblock pblock_5
add_cells_to_pblock [get_pblocks pblock_5] [get_cells -quiet [list sym_i/zcore32_5]]
resize_pblock [get_pblocks pblock_5] -add {SLICE_X53Y390:SLICE_X60Y419}
resize_pblock [get_pblocks pblock_5] -add {DSP48E2_X11Y156:DSP48E2_X11Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB18_X7Y156:RAMB18_X7Y167}
resize_pblock [get_pblocks pblock_5] -add {RAMB36_X7Y78:RAMB36_X7Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_5]

create_pblock pblock_6
add_cells_to_pblock [get_pblocks pblock_6] [get_cells -quiet [list sym_i/zcore32_6]]
resize_pblock [get_pblocks pblock_6] -add {SLICE_X64Y380:SLICE_X69Y419}
resize_pblock [get_pblocks pblock_6] -add {DSP48E2_X13Y152:DSP48E2_X13Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB18_X8Y152:RAMB18_X8Y167}
resize_pblock [get_pblocks pblock_6] -add {RAMB36_X8Y76:RAMB36_X8Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_6]

create_pblock pblock_7
add_cells_to_pblock [get_pblocks pblock_7] [get_cells -quiet [list sym_i/zcore32_7]]
resize_pblock [get_pblocks pblock_7] -add {SLICE_X72Y370:SLICE_X76Y419}
resize_pblock [get_pblocks pblock_7] -add {DSP48E2_X14Y148:DSP48E2_X15Y167}
resize_pblock [get_pblocks pblock_7] -add {RAMB18_X9Y148:RAMB18_X9Y167}
resize_pblock [get_pblocks pblock_7] -add {RAMB36_X9Y74:RAMB36_X9Y83}
set_property SNAPPING_MODE ON [get_pblocks pblock_7]


create_pblock pblock_9
add_cells_to_pblock [get_pblocks pblock_9] [get_cells -quiet [list sym_i/zcore32_9]]
resize_pblock [get_pblocks pblock_9] -add {SLICE_X64Y300:SLICE_X69Y339}
resize_pblock [get_pblocks pblock_9] -add {DSP48E2_X13Y120:DSP48E2_X13Y135}
resize_pblock [get_pblocks pblock_9] -add {RAMB18_X8Y120:RAMB18_X8Y135}
resize_pblock [get_pblocks pblock_9] -add {RAMB36_X8Y60:RAMB36_X8Y67}
set_property SNAPPING_MODE ON [get_pblocks pblock_9]

create_pblock pblock_10
add_cells_to_pblock [get_pblocks pblock_10] [get_cells -quiet [list sym_i/zcore32_10]]
resize_pblock [get_pblocks pblock_10] -add {SLICE_X53Y300:SLICE_X60Y329}
resize_pblock [get_pblocks pblock_10] -add {DSP48E2_X11Y120:DSP48E2_X11Y131}
resize_pblock [get_pblocks pblock_10] -add {RAMB18_X7Y120:RAMB18_X7Y131}
resize_pblock [get_pblocks pblock_10] -add {RAMB36_X7Y60:RAMB36_X7Y65}
set_property SNAPPING_MODE ON [get_pblocks pblock_10]

create_pblock pblock_11
add_cells_to_pblock [get_pblocks pblock_11] [get_cells -quiet [list sym_i/zcore32_11]]
resize_pblock [get_pblocks pblock_11] -add {SLICE_X41Y300:SLICE_X48Y329}
resize_pblock [get_pblocks pblock_11] -add {DSP48E2_X8Y120:DSP48E2_X8Y131}
resize_pblock [get_pblocks pblock_11] -add {RAMB18_X6Y120:RAMB18_X6Y131}
resize_pblock [get_pblocks pblock_11] -add {RAMB36_X6Y60:RAMB36_X6Y65}
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
resize_pblock [get_pblocks pblock_12] -add {SLICE_X31Y300:SLICE_X38Y329}
resize_pblock [get_pblocks pblock_12] -add {DSP48E2_X6Y120:DSP48E2_X6Y131}
resize_pblock [get_pblocks pblock_12] -add {RAMB18_X4Y120:RAMB18_X4Y131}
resize_pblock [get_pblocks pblock_12] -add {RAMB36_X4Y60:RAMB36_X4Y65}
set_property SNAPPING_MODE ON [get_pblocks pblock_12]

create_pblock pblock_13
add_cells_to_pblock [get_pblocks pblock_13] [get_cells -quiet [list sym_i/zcore32_13]]
resize_pblock [get_pblocks pblock_13] -add {SLICE_X20Y300:SLICE_X27Y329}
resize_pblock [get_pblocks pblock_13] -add {DSP48E2_X4Y120:DSP48E2_X4Y131}
resize_pblock [get_pblocks pblock_13] -add {RAMB18_X3Y120:RAMB18_X3Y131}
resize_pblock [get_pblocks pblock_13] -add {RAMB36_X3Y60:RAMB36_X3Y65}
set_property SNAPPING_MODE ON [get_pblocks pblock_13]

create_pblock pblock_14
add_cells_to_pblock [get_pblocks pblock_14] [get_cells -quiet [list sym_i/zcore32_14]]
resize_pblock [get_pblocks pblock_14] -add {SLICE_X9Y300:SLICE_X15Y334}
resize_pblock [get_pblocks pblock_14] -add {DSP48E2_X1Y120:DSP48E2_X2Y133}
resize_pblock [get_pblocks pblock_14] -add {RAMB18_X1Y120:RAMB18_X1Y133}
resize_pblock [get_pblocks pblock_14] -add {RAMB36_X1Y60:RAMB36_X1Y66}
set_property SNAPPING_MODE ON [get_pblocks pblock_14]

create_pblock pblock_15
add_cells_to_pblock [get_pblocks pblock_15] [get_cells -quiet [list sym_i/zcore32_15]]
resize_pblock [get_pblocks pblock_15] -add {SLICE_X1Y300:SLICE_X6Y339}
resize_pblock [get_pblocks pblock_15] -add {DSP48E2_X0Y120:DSP48E2_X0Y135}
resize_pblock [get_pblocks pblock_15] -add {RAMB18_X0Y120:RAMB18_X0Y135}
resize_pblock [get_pblocks pblock_15] -add {RAMB36_X0Y60:RAMB36_X0Y67}
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
resize_pblock [get_pblocks pblock_17] -add {SLICE_X9Y265:SLICE_X15Y299}
resize_pblock [get_pblocks pblock_17] -add {DSP48E2_X1Y106:DSP48E2_X2Y119}
resize_pblock [get_pblocks pblock_17] -add {RAMB18_X1Y106:RAMB18_X1Y119}
resize_pblock [get_pblocks pblock_17] -add {RAMB36_X1Y53:RAMB36_X1Y59}
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
resize_pblock [get_pblocks pblock_19] -add {SLICE_X31Y270:SLICE_X38Y299}
resize_pblock [get_pblocks pblock_19] -add {DSP48E2_X6Y108:DSP48E2_X6Y119}
resize_pblock [get_pblocks pblock_19] -add {RAMB18_X4Y108:RAMB18_X4Y119}
resize_pblock [get_pblocks pblock_19] -add {RAMB36_X4Y54:RAMB36_X4Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_19]

create_pblock pblock_20
add_cells_to_pblock [get_pblocks pblock_20] [get_cells -quiet [list sym_i/zcore32_20]]
resize_pblock [get_pblocks pblock_20] -add {SLICE_X41Y270:SLICE_X48Y299}
resize_pblock [get_pblocks pblock_20] -add {DSP48E2_X8Y108:DSP48E2_X8Y119}
resize_pblock [get_pblocks pblock_20] -add {RAMB18_X6Y108:RAMB18_X6Y119}
resize_pblock [get_pblocks pblock_20] -add {RAMB36_X6Y54:RAMB36_X6Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_20]

create_pblock pblock_21
add_cells_to_pblock [get_pblocks pblock_21] [get_cells -quiet [list sym_i/zcore32_21]]
resize_pblock [get_pblocks pblock_21] -add {SLICE_X53Y270:SLICE_X60Y299}
resize_pblock [get_pblocks pblock_21] -add {DSP48E2_X11Y108:DSP48E2_X11Y119}
resize_pblock [get_pblocks pblock_21] -add {RAMB18_X7Y108:RAMB18_X7Y119}
resize_pblock [get_pblocks pblock_21] -add {RAMB36_X7Y54:RAMB36_X7Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_21]

create_pblock pblock_22
add_cells_to_pblock [get_pblocks pblock_22] [get_cells -quiet [list sym_i/zcore32_22]]
resize_pblock [get_pblocks pblock_22] -add {SLICE_X64Y260:SLICE_X69Y299}
resize_pblock [get_pblocks pblock_22] -add {DSP48E2_X13Y104:DSP48E2_X13Y119}
resize_pblock [get_pblocks pblock_22] -add {RAMB18_X8Y104:RAMB18_X8Y119}
resize_pblock [get_pblocks pblock_22] -add {RAMB36_X8Y52:RAMB36_X8Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_22]

create_pblock pblock_23
add_cells_to_pblock [get_pblocks pblock_23] [get_cells -quiet [list sym_i/zcore32_23]]
resize_pblock [get_pblocks pblock_23] -add {SLICE_X72Y250:SLICE_X76Y299}
resize_pblock [get_pblocks pblock_23] -add {DSP48E2_X14Y100:DSP48E2_X15Y119}
resize_pblock [get_pblocks pblock_23] -add {RAMB18_X9Y100:RAMB18_X9Y119}
resize_pblock [get_pblocks pblock_23] -add {RAMB36_X9Y50:RAMB36_X9Y59}
set_property SNAPPING_MODE ON [get_pblocks pblock_23]

create_pblock pblock_24
add_cells_to_pblock [get_pblocks pblock_24] [get_cells -quiet [list sym_i/zcore32_24]]
resize_pblock [get_pblocks pblock_24] -add {SLICE_X72Y180:SLICE_X76Y229}
resize_pblock [get_pblocks pblock_24] -add {DSP48E2_X14Y72:DSP48E2_X15Y91}
resize_pblock [get_pblocks pblock_24] -add {RAMB18_X9Y72:RAMB18_X9Y91}
resize_pblock [get_pblocks pblock_24] -add {RAMB36_X9Y36:RAMB36_X9Y45}
set_property SNAPPING_MODE ON [get_pblocks pblock_24]

create_pblock pblock_25
add_cells_to_pblock [get_pblocks pblock_25] [get_cells -quiet [list sym_i/zcore32_25]]
resize_pblock [get_pblocks pblock_25] -add {SLICE_X64Y180:SLICE_X69Y219}
resize_pblock [get_pblocks pblock_25] -add {DSP48E2_X13Y72:DSP48E2_X13Y87}
resize_pblock [get_pblocks pblock_25] -add {RAMB18_X8Y72:RAMB18_X8Y87}
resize_pblock [get_pblocks pblock_25] -add {RAMB36_X8Y36:RAMB36_X8Y43}
set_property SNAPPING_MODE ON [get_pblocks pblock_25]

create_pblock pblock_26
add_cells_to_pblock [get_pblocks pblock_26] [get_cells -quiet [list sym_i/zcore32_26]]
resize_pblock [get_pblocks pblock_26] -add {SLICE_X53Y180:SLICE_X60Y209}
resize_pblock [get_pblocks pblock_26] -add {DSP48E2_X11Y72:DSP48E2_X11Y83}
resize_pblock [get_pblocks pblock_26] -add {RAMB18_X7Y72:RAMB18_X7Y83}
resize_pblock [get_pblocks pblock_26] -add {RAMB36_X7Y36:RAMB36_X7Y41}
set_property SNAPPING_MODE ON [get_pblocks pblock_26]

create_pblock pblock_27
add_cells_to_pblock [get_pblocks pblock_27] [get_cells -quiet [list sym_i/zcore32_27]]
resize_pblock [get_pblocks pblock_27] -add {SLICE_X41Y180:SLICE_X48Y209}
resize_pblock [get_pblocks pblock_27] -add {DSP48E2_X8Y72:DSP48E2_X8Y83}
resize_pblock [get_pblocks pblock_27] -add {RAMB18_X6Y72:RAMB18_X6Y83}
resize_pblock [get_pblocks pblock_27] -add {RAMB36_X6Y36:RAMB36_X6Y41}
set_property SNAPPING_MODE ON [get_pblocks pblock_27]

create_pblock pblock_28
add_cells_to_pblock [get_pblocks pblock_28] [get_cells -quiet [list sym_i/zcore32_28]]
resize_pblock [get_pblocks pblock_28] -add {SLICE_X31Y180:SLICE_X38Y209}
resize_pblock [get_pblocks pblock_28] -add {DSP48E2_X6Y72:DSP48E2_X6Y83}
resize_pblock [get_pblocks pblock_28] -add {RAMB18_X4Y72:RAMB18_X4Y83}
resize_pblock [get_pblocks pblock_28] -add {RAMB36_X4Y36:RAMB36_X4Y41}
set_property SNAPPING_MODE ON [get_pblocks pblock_28]

create_pblock pblock_29
add_cells_to_pblock [get_pblocks pblock_29] [get_cells -quiet [list sym_i/zcore32_29]]
resize_pblock [get_pblocks pblock_29] -add {SLICE_X20Y180:SLICE_X27Y209}
resize_pblock [get_pblocks pblock_29] -add {DSP48E2_X4Y72:DSP48E2_X4Y83}
resize_pblock [get_pblocks pblock_29] -add {RAMB18_X3Y72:RAMB18_X3Y83}
resize_pblock [get_pblocks pblock_29] -add {RAMB36_X3Y36:RAMB36_X3Y41}
set_property SNAPPING_MODE ON [get_pblocks pblock_29]

create_pblock pblock_30
add_cells_to_pblock [get_pblocks pblock_30] [get_cells -quiet [list sym_i/zcore32_30]]
resize_pblock [get_pblocks pblock_30] -add {SLICE_X9Y180:SLICE_X15Y214}
resize_pblock [get_pblocks pblock_30] -add {DSP48E2_X1Y72:DSP48E2_X2Y85}
resize_pblock [get_pblocks pblock_30] -add {RAMB18_X1Y72:RAMB18_X1Y85}
resize_pblock [get_pblocks pblock_30] -add {RAMB36_X1Y36:RAMB36_X1Y42}
set_property SNAPPING_MODE ON [get_pblocks pblock_30]

create_pblock pblock_31
add_cells_to_pblock [get_pblocks pblock_31] [get_cells -quiet [list sym_i/zcore32_31]]
resize_pblock [get_pblocks pblock_31] -add {SLICE_X1Y180:SLICE_X6Y219}
resize_pblock [get_pblocks pblock_31] -add {DSP48E2_X0Y72:DSP48E2_X0Y87}
resize_pblock [get_pblocks pblock_31] -add {RAMB18_X0Y72:RAMB18_X0Y87}
resize_pblock [get_pblocks pblock_31] -add {RAMB36_X0Y36:RAMB36_X0Y43}
set_property SNAPPING_MODE ON [get_pblocks pblock_31]

create_pblock pblock_32
add_cells_to_pblock [get_pblocks pblock_32] [get_cells -quiet [list sym_i/zcore32_32]]
resize_pblock [get_pblocks pblock_32] -add {SLICE_X41Y150:SLICE_X48Y179}
resize_pblock [get_pblocks pblock_32] -add {DSP48E2_X8Y60:DSP48E2_X8Y71}
resize_pblock [get_pblocks pblock_32] -add {RAMB18_X6Y60:RAMB18_X6Y71}
resize_pblock [get_pblocks pblock_32] -add {RAMB36_X6Y30:RAMB36_X6Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_32]

create_pblock pblock_33
add_cells_to_pblock [get_pblocks pblock_33] [get_cells -quiet [list sym_i/zcore32_33]]
resize_pblock [get_pblocks pblock_33] -add {SLICE_X53Y150:SLICE_X60Y179}
resize_pblock [get_pblocks pblock_33] -add {DSP48E2_X11Y60:DSP48E2_X11Y71}
resize_pblock [get_pblocks pblock_33] -add {RAMB18_X7Y60:RAMB18_X7Y71}
resize_pblock [get_pblocks pblock_33] -add {RAMB36_X7Y30:RAMB36_X7Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_33]

create_pblock pblock_34
add_cells_to_pblock [get_pblocks pblock_34] [get_cells -quiet [list sym_i/zcore32_34]]
resize_pblock [get_pblocks pblock_34] -add {SLICE_X64Y130:SLICE_X69Y179}
resize_pblock [get_pblocks pblock_34] -add {DSP48E2_X13Y52:DSP48E2_X13Y71}
resize_pblock [get_pblocks pblock_34] -add {RAMB18_X8Y52:RAMB18_X8Y71}
resize_pblock [get_pblocks pblock_34] -add {RAMB36_X8Y26:RAMB36_X8Y35}
set_property SNAPPING_MODE ON [get_pblocks pblock_34]

create_pblock pblock_35
add_cells_to_pblock [get_pblocks pblock_35] [get_cells -quiet [list sym_i/zcore32_35]]
resize_pblock [get_pblocks pblock_35] -add {SLICE_X72Y130:SLICE_X76Y179}
resize_pblock [get_pblocks pblock_35] -add {DSP48E2_X14Y52:DSP48E2_X15Y71}
resize_pblock [get_pblocks pblock_35] -add {RAMB18_X9Y52:RAMB18_X9Y71}
resize_pblock [get_pblocks pblock_35] -add {RAMB36_X9Y26:RAMB36_X9Y35}
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
resize_pblock [get_pblocks pblock_37] -add {SLICE_X90Y70:SLICE_X95Y109}
resize_pblock [get_pblocks pblock_37] -add {DSP48E2_X17Y28:DSP48E2_X17Y43}
resize_pblock [get_pblocks pblock_37] -add {RAMB18_X12Y28:RAMB18_X12Y43}
resize_pblock [get_pblocks pblock_37] -add {RAMB36_X12Y14:RAMB36_X12Y21}
set_property SNAPPING_MODE ON [get_pblocks pblock_37]

create_pblock pblock_38
add_cells_to_pblock [get_pblocks pblock_38] [get_cells -quiet [list sym_i/zcore32_38]]
resize_pblock [get_pblocks pblock_38] -add {SLICE_X72Y65:SLICE_X76Y114}
resize_pblock [get_pblocks pblock_38] -add {DSP48E2_X14Y26:DSP48E2_X15Y45}
resize_pblock [get_pblocks pblock_38] -add {RAMB18_X9Y26:RAMB18_X9Y45}
resize_pblock [get_pblocks pblock_38] -add {RAMB36_X9Y13:RAMB36_X9Y22}
set_property SNAPPING_MODE ON [get_pblocks pblock_38]

create_pblock pblock_39
add_cells_to_pblock [get_pblocks pblock_39] [get_cells -quiet [list sym_i/zcore32_39]]
resize_pblock [get_pblocks pblock_39] -add {SLICE_X64Y70:SLICE_X69Y109}
resize_pblock [get_pblocks pblock_39] -add {DSP48E2_X13Y28:DSP48E2_X13Y43}
resize_pblock [get_pblocks pblock_39] -add {RAMB18_X8Y28:RAMB18_X8Y43}
resize_pblock [get_pblocks pblock_39] -add {RAMB36_X8Y14:RAMB36_X8Y21}
set_property SNAPPING_MODE ON [get_pblocks pblock_39]

create_pblock pblock_40
add_cells_to_pblock [get_pblocks pblock_40] [get_cells -quiet [list sym_i/zcore32_40]]
resize_pblock [get_pblocks pblock_40] -add {SLICE_X55Y70:SLICE_X60Y109}
resize_pblock [get_pblocks pblock_40] -add {DSP48E2_X11Y28:DSP48E2_X11Y43}
resize_pblock [get_pblocks pblock_40] -add {RAMB18_X7Y28:RAMB18_X7Y43}
resize_pblock [get_pblocks pblock_40] -add {RAMB36_X7Y14:RAMB36_X7Y21}
set_property SNAPPING_MODE ON [get_pblocks pblock_40]

create_pblock pblock_41
add_cells_to_pblock [get_pblocks pblock_41] [get_cells -quiet [list sym_i/zcore32_41]]
resize_pblock [get_pblocks pblock_41] -add {SLICE_X46Y70:SLICE_X51Y109}
resize_pblock [get_pblocks pblock_41] -add {DSP48E2_X9Y28:DSP48E2_X9Y43}
resize_pblock [get_pblocks pblock_41] -add {RAMB18_X6Y28:RAMB18_X6Y43}
resize_pblock [get_pblocks pblock_41] -add {RAMB36_X6Y14:RAMB36_X6Y21}
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
resize_pblock [get_pblocks pblock_45] -add {SLICE_X58Y0:SLICE_X63Y39}
resize_pblock [get_pblocks pblock_45] -add {DSP48E2_X12Y0:DSP48E2_X12Y15}
resize_pblock [get_pblocks pblock_45] -add {RAMB18_X7Y0:RAMB18_X7Y15}
resize_pblock [get_pblocks pblock_45] -add {RAMB36_X7Y0:RAMB36_X7Y7}
set_property SNAPPING_MODE ON [get_pblocks pblock_45]

create_pblock pblock_46
add_cells_to_pblock [get_pblocks pblock_46] [get_cells -quiet [list sym_i/zcore32_46]]
resize_pblock [get_pblocks pblock_46] -add {SLICE_X72Y0:SLICE_X76Y49}
resize_pblock [get_pblocks pblock_46] -add {DSP48E2_X14Y0:DSP48E2_X15Y19}
resize_pblock [get_pblocks pblock_46] -add {RAMB18_X9Y0:RAMB18_X9Y19}
resize_pblock [get_pblocks pblock_46] -add {RAMB36_X9Y0:RAMB36_X9Y9}
set_property SNAPPING_MODE ON [get_pblocks pblock_46]

create_pblock pblock_47
add_cells_to_pblock [get_pblocks pblock_47] [get_cells -quiet [list sym_i/zcore32_47]]
resize_pblock [get_pblocks pblock_47] -add {SLICE_X88Y0:SLICE_X95Y29}
resize_pblock [get_pblocks pblock_47] -add {DSP48E2_X17Y0:DSP48E2_X17Y11}
resize_pblock [get_pblocks pblock_47] -add {RAMB18_X12Y0:RAMB18_X12Y11}
resize_pblock [get_pblocks pblock_47] -add {RAMB36_X12Y0:RAMB36_X12Y5}
set_property SNAPPING_MODE ON [get_pblocks pblock_47]

create_pblock pblock_8
add_cells_to_pblock [get_pblocks pblock_8] [get_cells -quiet [list sym_i/zcore32_8]]
resize_pblock [get_pblocks pblock_8] -add {SLICE_X72Y300:SLICE_X76Y349}
resize_pblock [get_pblocks pblock_8] -add {DSP48E2_X14Y120:DSP48E2_X15Y139}
resize_pblock [get_pblocks pblock_8] -add {RAMB18_X9Y120:RAMB18_X9Y139}
resize_pblock [get_pblocks pblock_8] -add {RAMB36_X9Y60:RAMB36_X9Y69}
set_property SNAPPING_MODE ON [get_pblocks pblock_8]



