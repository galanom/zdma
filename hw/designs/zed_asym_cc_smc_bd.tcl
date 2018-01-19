
################################################################
# This is a generated script based on design: zed_asym_cc_smc
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source zed_asym_cc_smc_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name zed_asym_cc_smc

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
CONFIG.c_single_interface {0} \
 ] $axi_dma_0

  # Create instance: axi_dma_1, and set properties
  set axi_dma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_1 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
CONFIG.c_single_interface {0} \
 ] $axi_dma_1

  # Create instance: axi_dma_2, and set properties
  set axi_dma_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_2 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
CONFIG.c_single_interface {0} \
 ] $axi_dma_2

  # Create instance: axi_dma_3, and set properties
  set axi_dma_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_3 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
CONFIG.c_single_interface {0} \
 ] $axi_dma_3

  # Create instance: axi_dma_4, and set properties
  set axi_dma_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_4 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
CONFIG.c_single_interface {0} \
 ] $axi_dma_4

  # Create instance: axi_dma_5, and set properties
  set axi_dma_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_5 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
CONFIG.c_single_interface {0} \
 ] $axi_dma_5

  # Create instance: axi_dma_6, and set properties
  set axi_dma_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_6 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
CONFIG.c_single_interface {0} \
 ] $axi_dma_6

  # Create instance: axi_dma_7, and set properties
  set axi_dma_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_7 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
CONFIG.c_single_interface {0} \
 ] $axi_dma_7

  # Create instance: axi_dma_8, and set properties
  set axi_dma_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_8 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_8

  # Create instance: axi_dma_9, and set properties
  set axi_dma_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_9 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_9

  # Create instance: axi_dma_10, and set properties
  set axi_dma_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_10 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_10

  # Create instance: axi_dma_11, and set properties
  set axi_dma_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_11 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_11

  # Create instance: axi_fifo_mm_s_0, and set properties
  set axi_fifo_mm_s_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_fifo_mm_s:4.1 axi_fifo_mm_s_0 ]

  # Create instance: axi_fifo_mm_s_1, and set properties
  set axi_fifo_mm_s_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_fifo_mm_s:4.1 axi_fifo_mm_s_1 ]

  # Create instance: axis_dwidth_converter_0, and set properties
  set axis_dwidth_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_0 ]
  set_property -dict [ list \
CONFIG.M_TDATA_NUM_BYTES {2} \
 ] $axis_dwidth_converter_0

  # Create instance: axis_dwidth_converter_1, and set properties
  set axis_dwidth_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_1 ]
  set_property -dict [ list \
CONFIG.M_TDATA_NUM_BYTES {2} \
 ] $axis_dwidth_converter_1

  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [ list \
CONFIG.M_TDATA_NUM_BYTES {4} \
CONFIG.S_TDATA_NUM_BYTES {2} \
CONFIG.TDATA_REMAP {16'b0000000000000000,tdata[15:0]} \
 ] $axis_subset_converter_0

  # Create instance: axis_subset_converter_1, and set properties
  set axis_subset_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_1 ]
  set_property -dict [ list \
CONFIG.M_TDATA_NUM_BYTES {4} \
CONFIG.S_TDATA_NUM_BYTES {2} \
CONFIG.TDATA_REMAP {16'b0000000000000000,tdata[15:0]} \
 ] $axis_subset_converter_1

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {145} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_HIGH_OCM {0} \
CONFIG.PCW_USE_M_AXI_GP1 {1} \
CONFIG.PCW_USE_S_AXI_GP0 {1} \
CONFIG.PCW_USE_S_AXI_GP1 {1} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.PCW_USE_S_AXI_HP1 {1} \
CONFIG.PCW_USE_S_AXI_HP2 {1} \
CONFIG.PCW_USE_S_AXI_HP3 {1} \
CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph_0, and set properties
  set ps7_0_axi_periph_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph_0 ]
  set_property -dict [ list \
CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
CONFIG.M00_HAS_REGSLICE {4} \
CONFIG.M01_HAS_REGSLICE {4} \
CONFIG.M02_HAS_REGSLICE {4} \
CONFIG.M03_HAS_REGSLICE {4} \
CONFIG.M04_HAS_REGSLICE {4} \
CONFIG.M05_HAS_REGSLICE {4} \
CONFIG.M06_HAS_REGSLICE {4} \
CONFIG.M07_HAS_REGSLICE {4} \
CONFIG.M08_HAS_REGSLICE {4} \
CONFIG.M09_HAS_REGSLICE {4} \
CONFIG.M10_HAS_REGSLICE {4} \
CONFIG.M11_HAS_REGSLICE {4} \
CONFIG.M12_HAS_REGSLICE {4} \
CONFIG.M13_HAS_REGSLICE {1} \
CONFIG.M14_HAS_REGSLICE {1} \
CONFIG.M15_HAS_REGSLICE {1} \
CONFIG.M16_HAS_REGSLICE {1} \
CONFIG.M17_HAS_REGSLICE {1} \
CONFIG.M18_HAS_REGSLICE {1} \
CONFIG.M19_HAS_REGSLICE {1} \
CONFIG.M20_HAS_REGSLICE {1} \
CONFIG.M21_HAS_REGSLICE {1} \
CONFIG.M22_HAS_REGSLICE {1} \
CONFIG.M23_HAS_REGSLICE {1} \
CONFIG.M24_HAS_REGSLICE {1} \
CONFIG.M25_HAS_REGSLICE {1} \
CONFIG.M26_HAS_REGSLICE {1} \
CONFIG.M27_HAS_REGSLICE {1} \
CONFIG.M28_HAS_REGSLICE {1} \
CONFIG.M29_HAS_REGSLICE {1} \
CONFIG.M30_HAS_REGSLICE {1} \
CONFIG.M31_HAS_REGSLICE {1} \
CONFIG.NUM_MI {13} \
CONFIG.S00_HAS_DATA_FIFO {1} \
CONFIG.S00_HAS_REGSLICE {4} \
CONFIG.STRATEGY {0} \
 ] $ps7_0_axi_periph_0

  # Create instance: ps7_0_axi_periph_1, and set properties
  set ps7_0_axi_periph_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph_1 ]
  set_property -dict [ list \
CONFIG.M00_HAS_DATA_FIFO {0} \
CONFIG.M00_HAS_REGSLICE {4} \
CONFIG.M01_HAS_REGSLICE {4} \
CONFIG.M02_HAS_REGSLICE {4} \
CONFIG.M03_HAS_REGSLICE {4} \
CONFIG.M04_HAS_REGSLICE {4} \
CONFIG.M05_HAS_REGSLICE {4} \
CONFIG.M06_HAS_REGSLICE {4} \
CONFIG.M07_HAS_REGSLICE {4} \
CONFIG.M08_HAS_REGSLICE {4} \
CONFIG.M09_HAS_REGSLICE {4} \
CONFIG.M10_HAS_REGSLICE {4} \
CONFIG.M11_HAS_REGSLICE {4} \
CONFIG.M12_HAS_REGSLICE {4} \
CONFIG.M13_HAS_REGSLICE {4} \
CONFIG.M14_HAS_REGSLICE {4} \
CONFIG.M15_HAS_DATA_FIFO {1} \
CONFIG.M15_HAS_REGSLICE {1} \
CONFIG.NUM_MI {15} \
CONFIG.S00_HAS_DATA_FIFO {1} \
CONFIG.S00_HAS_REGSLICE {4} \
 ] $ps7_0_axi_periph_1

  # Create instance: rst_ps7_0_100M, and set properties
  set rst_ps7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M ]

  # Create instance: sc_gp_mm2s, and set properties
  set sc_gp_mm2s [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 sc_gp_mm2s ]
  set_property -dict [ list \
CONFIG.HAS_ARESETN {0} \
CONFIG.NUM_SI {4} \
 ] $sc_gp_mm2s

  # Create instance: sc_gp_s2mm, and set properties
  set sc_gp_s2mm [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 sc_gp_s2mm ]
  set_property -dict [ list \
CONFIG.HAS_ARESETN {0} \
CONFIG.NUM_SI {4} \
 ] $sc_gp_s2mm

  # Create instance: sc_p0_mm2s, and set properties
  set sc_p0_mm2s [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 sc_p0_mm2s ]
  set_property -dict [ list \
CONFIG.ADVANCED_PROPERTIES { __view__ { functional { SW0 { DATA_WIDTH 32 } } }} \
CONFIG.HAS_ARESETN {0} \
CONFIG.NUM_SI {4} \
 ] $sc_p0_mm2s

  # Create instance: sc_p0_s2mm, and set properties
  set sc_p0_s2mm [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 sc_p0_s2mm ]
  set_property -dict [ list \
CONFIG.ADVANCED_PROPERTIES { __view__ { functional { SW0 { DATA_WIDTH 32 } } }} \
CONFIG.HAS_ARESETN {0} \
CONFIG.NUM_SI {4} \
 ] $sc_p0_s2mm

  # Create instance: sc_p1_mm2s, and set properties
  set sc_p1_mm2s [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 sc_p1_mm2s ]
  set_property -dict [ list \
CONFIG.ADVANCED_PROPERTIES { __view__ { functional { SW0 { DATA_WIDTH 32 } } }} \
CONFIG.HAS_ARESETN {0} \
CONFIG.NUM_SI {4} \
 ] $sc_p1_mm2s

  # Create instance: sc_p1_s2mm, and set properties
  set sc_p1_s2mm [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 sc_p1_s2mm ]
  set_property -dict [ list \
CONFIG.ADVANCED_PROPERTIES { __view__ { functional { SW0 { DATA_WIDTH 32 } } }} \
CONFIG.HAS_ARESETN {0} \
CONFIG.NUM_SI {4} \
 ] $sc_p1_s2mm

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {12} \
 ] $xlconcat_0

  # Create instance: zdma_core_0, and set properties
  set zdma_core_0 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_0 ]

  # Create instance: zdma_core_1, and set properties
  set zdma_core_1 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_1 ]

  # Create instance: zdma_core_2, and set properties
  set zdma_core_2 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_2 ]

  # Create instance: zdma_core_3, and set properties
  set zdma_core_3 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_3 ]

  # Create instance: zdma_core_4, and set properties
  set zdma_core_4 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_4 ]

  # Create instance: zdma_core_5, and set properties
  set zdma_core_5 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_5 ]

  # Create instance: zdma_core_6, and set properties
  set zdma_core_6 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_6 ]

  # Create instance: zdma_core_7, and set properties
  set zdma_core_7 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_7 ]

  # Create instance: zdma_core_8, and set properties
  set zdma_core_8 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_8 ]

  # Create instance: zdma_core_9, and set properties
  set zdma_core_9 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_9 ]

  # Create instance: zdma_core_10, and set properties
  set zdma_core_10 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_10 ]

  # Create instance: zdma_core_11, and set properties
  set zdma_core_11 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_11 ]

  # Create instance: zdma_core_12, and set properties
  set zdma_core_12 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_12 ]

  # Create instance: zdma_core_13, and set properties
  set zdma_core_13 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:3.2 zdma_core_13 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_0/src]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins sc_p0_mm2s/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins sc_p1_s2mm/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_10_M_AXIS_MM2S [get_bd_intf_pins axi_dma_10/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_10/src]
  connect_bd_intf_net -intf_net axi_dma_10_M_AXI_MM2S [get_bd_intf_pins axi_dma_10/M_AXI_MM2S] [get_bd_intf_pins sc_gp_mm2s/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_10_M_AXI_S2MM [get_bd_intf_pins axi_dma_10/M_AXI_S2MM] [get_bd_intf_pins sc_gp_s2mm/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_11_M_AXIS_MM2S [get_bd_intf_pins axi_dma_11/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_11/src]
  connect_bd_intf_net -intf_net axi_dma_11_M_AXI_MM2S [get_bd_intf_pins axi_dma_11/M_AXI_MM2S] [get_bd_intf_pins sc_gp_mm2s/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_11_M_AXI_S2MM [get_bd_intf_pins axi_dma_11/M_AXI_S2MM] [get_bd_intf_pins sc_gp_s2mm/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXIS_MM2S [get_bd_intf_pins axi_dma_1/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_1/src]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_MM2S [get_bd_intf_pins axi_dma_1/M_AXI_MM2S] [get_bd_intf_pins sc_p0_mm2s/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_S2MM [get_bd_intf_pins axi_dma_1/M_AXI_S2MM] [get_bd_intf_pins sc_p1_s2mm/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXIS_MM2S [get_bd_intf_pins axi_dma_2/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_2/src]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_MM2S [get_bd_intf_pins axi_dma_2/M_AXI_MM2S] [get_bd_intf_pins sc_p0_mm2s/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_S2MM [get_bd_intf_pins axi_dma_2/M_AXI_S2MM] [get_bd_intf_pins sc_p1_s2mm/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXIS_MM2S [get_bd_intf_pins axi_dma_3/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_3/src]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXI_MM2S [get_bd_intf_pins axi_dma_3/M_AXI_MM2S] [get_bd_intf_pins sc_p0_mm2s/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXI_S2MM [get_bd_intf_pins axi_dma_3/M_AXI_S2MM] [get_bd_intf_pins sc_p1_s2mm/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXIS_MM2S [get_bd_intf_pins axi_dma_4/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_4/src]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXI_MM2S [get_bd_intf_pins axi_dma_4/M_AXI_MM2S] [get_bd_intf_pins sc_p1_mm2s/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXI_S2MM [get_bd_intf_pins axi_dma_4/M_AXI_S2MM] [get_bd_intf_pins sc_p0_s2mm/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXIS_MM2S [get_bd_intf_pins axi_dma_5/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_5/src]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXI_MM2S [get_bd_intf_pins axi_dma_5/M_AXI_MM2S] [get_bd_intf_pins sc_p1_mm2s/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXI_S2MM [get_bd_intf_pins axi_dma_5/M_AXI_S2MM] [get_bd_intf_pins sc_p0_s2mm/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXIS_MM2S [get_bd_intf_pins axi_dma_6/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_6/src]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_MM2S [get_bd_intf_pins axi_dma_6/M_AXI_MM2S] [get_bd_intf_pins sc_p1_mm2s/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_S2MM [get_bd_intf_pins axi_dma_6/M_AXI_S2MM] [get_bd_intf_pins sc_p0_s2mm/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXIS_MM2S [get_bd_intf_pins axi_dma_7/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_7/src]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXI_MM2S [get_bd_intf_pins axi_dma_7/M_AXI_MM2S] [get_bd_intf_pins sc_p1_mm2s/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXI_S2MM [get_bd_intf_pins axi_dma_7/M_AXI_S2MM] [get_bd_intf_pins sc_p0_s2mm/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_8_M_AXIS_MM2S [get_bd_intf_pins axi_dma_8/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_8/src]
  connect_bd_intf_net -intf_net axi_dma_8_M_AXI_MM2S [get_bd_intf_pins axi_dma_8/M_AXI_MM2S] [get_bd_intf_pins sc_gp_mm2s/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_8_M_AXI_S2MM [get_bd_intf_pins axi_dma_8/M_AXI_S2MM] [get_bd_intf_pins sc_gp_s2mm/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_9_M_AXIS_MM2S [get_bd_intf_pins axi_dma_9/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_9/src]
  connect_bd_intf_net -intf_net axi_dma_9_M_AXI_MM2S [get_bd_intf_pins axi_dma_9/M_AXI_MM2S] [get_bd_intf_pins sc_gp_mm2s/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_9_M_AXI_S2MM [get_bd_intf_pins axi_dma_9/M_AXI_S2MM] [get_bd_intf_pins sc_gp_s2mm/S01_AXI]
  connect_bd_intf_net -intf_net axi_fifo_mm_s_1_AXI_STR_TXD [get_bd_intf_pins axi_fifo_mm_s_1/AXI_STR_TXD] [get_bd_intf_pins axis_dwidth_converter_1/S_AXIS]
  connect_bd_intf_net -intf_net axi_fifo_mm_s_AXI_STR_TXD [get_bd_intf_pins axi_fifo_mm_s_0/AXI_STR_TXD] [get_bd_intf_pins axis_dwidth_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins axis_dwidth_converter_0/M_AXIS] [get_bd_intf_pins zdma_core_12/src]
  connect_bd_intf_net -intf_net axis_dwidth_converter_1_M_AXIS [get_bd_intf_pins axis_dwidth_converter_1/M_AXIS] [get_bd_intf_pins zdma_core_13/src]
  connect_bd_intf_net -intf_net axis_subset_converter_1_M_AXIS [get_bd_intf_pins axi_fifo_mm_s_1/AXI_STR_RXD] [get_bd_intf_pins axis_subset_converter_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_M_AXIS [get_bd_intf_pins axi_fifo_mm_s_0/AXI_STR_RXD] [get_bd_intf_pins axis_subset_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph_0/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP1 [get_bd_intf_pins processing_system7_0/M_AXI_GP1] [get_bd_intf_pins ps7_0_axi_periph_1/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M00_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M01_AXI [get_bd_intf_pins axi_dma_1/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M01_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M02_AXI [get_bd_intf_pins axi_dma_2/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M02_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M03_AXI [get_bd_intf_pins axi_dma_3/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M03_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M04_AXI [get_bd_intf_pins axi_dma_4/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M04_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M05_AXI [get_bd_intf_pins axi_dma_5/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M05_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M06_AXI [get_bd_intf_pins axi_dma_6/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M06_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M07_AXI [get_bd_intf_pins axi_dma_7/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M07_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M08_AXI [get_bd_intf_pins axi_dma_8/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M08_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M09_AXI [get_bd_intf_pins axi_dma_9/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M09_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M10_AXI [get_bd_intf_pins axi_dma_10/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M10_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M11_AXI [get_bd_intf_pins axi_dma_11/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M11_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M12_AXI [get_bd_intf_pins axi_fifo_mm_s_1/S_AXI] [get_bd_intf_pins ps7_0_axi_periph_0/M12_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M00_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M00_AXI] [get_bd_intf_pins zdma_core_0/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M01_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M01_AXI] [get_bd_intf_pins zdma_core_1/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M02_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M02_AXI] [get_bd_intf_pins zdma_core_2/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M03_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M03_AXI] [get_bd_intf_pins zdma_core_3/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M04_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M04_AXI] [get_bd_intf_pins zdma_core_4/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M05_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M05_AXI] [get_bd_intf_pins zdma_core_5/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M06_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M06_AXI] [get_bd_intf_pins zdma_core_6/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M07_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M07_AXI] [get_bd_intf_pins zdma_core_7/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M08_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M08_AXI] [get_bd_intf_pins zdma_core_8/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M09_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M09_AXI] [get_bd_intf_pins zdma_core_9/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M10_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M10_AXI] [get_bd_intf_pins zdma_core_10/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M11_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M11_AXI] [get_bd_intf_pins zdma_core_11/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M12_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M12_AXI] [get_bd_intf_pins zdma_core_12/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M13_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M13_AXI] [get_bd_intf_pins zdma_core_13/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M14_AXI [get_bd_intf_pins axi_fifo_mm_s_0/S_AXI] [get_bd_intf_pins ps7_0_axi_periph_1/M14_AXI]
  connect_bd_intf_net -intf_net sc_gp_mm2s_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_GP0] [get_bd_intf_pins sc_gp_mm2s/M00_AXI]
  connect_bd_intf_net -intf_net sc_gp_s2mm_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_GP1] [get_bd_intf_pins sc_gp_s2mm/M00_AXI]
  connect_bd_intf_net -intf_net sc_p0_mm2s_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP0] [get_bd_intf_pins sc_p0_mm2s/M00_AXI]
  connect_bd_intf_net -intf_net sc_p0_s2mm_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP1] [get_bd_intf_pins sc_p0_s2mm/M00_AXI]
  connect_bd_intf_net -intf_net sc_p1_mm2s_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP3] [get_bd_intf_pins sc_p1_mm2s/M00_AXI]
  connect_bd_intf_net -intf_net sc_p1_s2mm_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP2] [get_bd_intf_pins sc_p1_s2mm/M00_AXI]
  connect_bd_intf_net -intf_net zdma_core_0_dst [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_0/dst]
  connect_bd_intf_net -intf_net zdma_core_10_dst [get_bd_intf_pins axi_dma_10/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_10/dst]
  connect_bd_intf_net -intf_net zdma_core_11_dst [get_bd_intf_pins axi_dma_11/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_11/dst]
  connect_bd_intf_net -intf_net zdma_core_12_dst [get_bd_intf_pins axis_subset_converter_0/S_AXIS] [get_bd_intf_pins zdma_core_12/dst]
  connect_bd_intf_net -intf_net zdma_core_13_dst [get_bd_intf_pins axis_subset_converter_1/S_AXIS] [get_bd_intf_pins zdma_core_13/dst]
  connect_bd_intf_net -intf_net zdma_core_1_dst [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_1/dst]
  connect_bd_intf_net -intf_net zdma_core_2_dst [get_bd_intf_pins axi_dma_2/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_2/dst]
  connect_bd_intf_net -intf_net zdma_core_3_dst [get_bd_intf_pins axi_dma_3/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_3/dst]
  connect_bd_intf_net -intf_net zdma_core_4_dst [get_bd_intf_pins axi_dma_4/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_4/dst]
  connect_bd_intf_net -intf_net zdma_core_5_dst [get_bd_intf_pins axi_dma_5/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_5/dst]
  connect_bd_intf_net -intf_net zdma_core_6_dst [get_bd_intf_pins axi_dma_6/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_6/dst]
  connect_bd_intf_net -intf_net zdma_core_7_dst [get_bd_intf_pins axi_dma_7/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_7/dst]
  connect_bd_intf_net -intf_net zdma_core_8_dst [get_bd_intf_pins axi_dma_8/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_8/dst]
  connect_bd_intf_net -intf_net zdma_core_9_dst [get_bd_intf_pins axi_dma_9/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_9/dst]

  # Create port connections
  connect_bd_net -net axi_dma_0_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_0/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_0/ap_rst_n]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_dma_10_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_10/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_10/ap_rst_n]
  connect_bd_net -net axi_dma_10_s2mm_introut [get_bd_pins axi_dma_10/s2mm_introut] [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net axi_dma_11_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_11/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_11/ap_rst_n]
  connect_bd_net -net axi_dma_11_s2mm_introut [get_bd_pins axi_dma_11/s2mm_introut] [get_bd_pins xlconcat_0/In11]
  connect_bd_net -net axi_dma_1_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_1/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_1/ap_rst_n]
  connect_bd_net -net axi_dma_1_s2mm_introut [get_bd_pins axi_dma_1/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_dma_2_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_2/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_2/ap_rst_n]
  connect_bd_net -net axi_dma_2_s2mm_introut [get_bd_pins axi_dma_2/s2mm_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_dma_3_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_3/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_3/ap_rst_n]
  connect_bd_net -net axi_dma_3_s2mm_introut [get_bd_pins axi_dma_3/s2mm_introut] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_dma_4_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_4/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_4/ap_rst_n]
  connect_bd_net -net axi_dma_4_s2mm_introut [get_bd_pins axi_dma_4/s2mm_introut] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_dma_5_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_5/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_5/ap_rst_n]
  connect_bd_net -net axi_dma_5_s2mm_introut [get_bd_pins axi_dma_5/s2mm_introut] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net axi_dma_6_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_6/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_6/ap_rst_n]
  connect_bd_net -net axi_dma_6_s2mm_introut [get_bd_pins axi_dma_6/s2mm_introut] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net axi_dma_7_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_7/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_7/ap_rst_n]
  connect_bd_net -net axi_dma_7_s2mm_introut [get_bd_pins axi_dma_7/s2mm_introut] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net axi_dma_8_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_8/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_8/ap_rst_n]
  connect_bd_net -net axi_dma_8_s2mm_introut [get_bd_pins axi_dma_8/s2mm_introut] [get_bd_pins xlconcat_0/In8]
  connect_bd_net -net axi_dma_9_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_9/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_9/ap_rst_n]
  connect_bd_net -net axi_dma_9_s2mm_introut [get_bd_pins axi_dma_9/s2mm_introut] [get_bd_pins xlconcat_0/In9]
  connect_bd_net -net axi_fifo_mm_s_0_mm2s_prmry_reset_out_n [get_bd_pins axi_fifo_mm_s_0/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_12/ap_rst_n]
  connect_bd_net -net axi_fifo_mm_s_1_mm2s_prmry_reset_out_n [get_bd_pins axi_fifo_mm_s_1/mm2s_prmry_reset_out_n] [get_bd_pins zdma_core_13/ap_rst_n]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_dma_1/m_axi_mm2s_aclk] [get_bd_pins axi_dma_1/m_axi_s2mm_aclk] [get_bd_pins axi_dma_1/s_axi_lite_aclk] [get_bd_pins axi_dma_10/m_axi_mm2s_aclk] [get_bd_pins axi_dma_10/m_axi_s2mm_aclk] [get_bd_pins axi_dma_10/s_axi_lite_aclk] [get_bd_pins axi_dma_11/m_axi_mm2s_aclk] [get_bd_pins axi_dma_11/m_axi_s2mm_aclk] [get_bd_pins axi_dma_11/s_axi_lite_aclk] [get_bd_pins axi_dma_2/m_axi_mm2s_aclk] [get_bd_pins axi_dma_2/m_axi_s2mm_aclk] [get_bd_pins axi_dma_2/s_axi_lite_aclk] [get_bd_pins axi_dma_3/m_axi_mm2s_aclk] [get_bd_pins axi_dma_3/m_axi_s2mm_aclk] [get_bd_pins axi_dma_3/s_axi_lite_aclk] [get_bd_pins axi_dma_4/m_axi_mm2s_aclk] [get_bd_pins axi_dma_4/m_axi_s2mm_aclk] [get_bd_pins axi_dma_4/s_axi_lite_aclk] [get_bd_pins axi_dma_5/m_axi_mm2s_aclk] [get_bd_pins axi_dma_5/m_axi_s2mm_aclk] [get_bd_pins axi_dma_5/s_axi_lite_aclk] [get_bd_pins axi_dma_6/m_axi_mm2s_aclk] [get_bd_pins axi_dma_6/m_axi_s2mm_aclk] [get_bd_pins axi_dma_6/s_axi_lite_aclk] [get_bd_pins axi_dma_7/m_axi_mm2s_aclk] [get_bd_pins axi_dma_7/m_axi_s2mm_aclk] [get_bd_pins axi_dma_7/s_axi_lite_aclk] [get_bd_pins axi_dma_8/m_axi_mm2s_aclk] [get_bd_pins axi_dma_8/m_axi_s2mm_aclk] [get_bd_pins axi_dma_8/s_axi_lite_aclk] [get_bd_pins axi_dma_9/m_axi_mm2s_aclk] [get_bd_pins axi_dma_9/m_axi_s2mm_aclk] [get_bd_pins axi_dma_9/s_axi_lite_aclk] [get_bd_pins axi_fifo_mm_s_0/s_axi_aclk] [get_bd_pins axi_fifo_mm_s_1/s_axi_aclk] [get_bd_pins axis_dwidth_converter_0/aclk] [get_bd_pins axis_dwidth_converter_1/aclk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins axis_subset_converter_1/aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/M_AXI_GP1_ACLK] [get_bd_pins processing_system7_0/S_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_GP1_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP1_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP2_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP3_ACLK] [get_bd_pins ps7_0_axi_periph_0/ACLK] [get_bd_pins ps7_0_axi_periph_0/M00_ACLK] [get_bd_pins ps7_0_axi_periph_0/M01_ACLK] [get_bd_pins ps7_0_axi_periph_0/M02_ACLK] [get_bd_pins ps7_0_axi_periph_0/M03_ACLK] [get_bd_pins ps7_0_axi_periph_0/M04_ACLK] [get_bd_pins ps7_0_axi_periph_0/M05_ACLK] [get_bd_pins ps7_0_axi_periph_0/M06_ACLK] [get_bd_pins ps7_0_axi_periph_0/M07_ACLK] [get_bd_pins ps7_0_axi_periph_0/M08_ACLK] [get_bd_pins ps7_0_axi_periph_0/M09_ACLK] [get_bd_pins ps7_0_axi_periph_0/M10_ACLK] [get_bd_pins ps7_0_axi_periph_0/M11_ACLK] [get_bd_pins ps7_0_axi_periph_0/M12_ACLK] [get_bd_pins ps7_0_axi_periph_0/S00_ACLK] [get_bd_pins ps7_0_axi_periph_1/ACLK] [get_bd_pins ps7_0_axi_periph_1/M00_ACLK] [get_bd_pins ps7_0_axi_periph_1/M01_ACLK] [get_bd_pins ps7_0_axi_periph_1/M02_ACLK] [get_bd_pins ps7_0_axi_periph_1/M03_ACLK] [get_bd_pins ps7_0_axi_periph_1/M04_ACLK] [get_bd_pins ps7_0_axi_periph_1/M05_ACLK] [get_bd_pins ps7_0_axi_periph_1/M06_ACLK] [get_bd_pins ps7_0_axi_periph_1/M07_ACLK] [get_bd_pins ps7_0_axi_periph_1/M08_ACLK] [get_bd_pins ps7_0_axi_periph_1/M09_ACLK] [get_bd_pins ps7_0_axi_periph_1/M10_ACLK] [get_bd_pins ps7_0_axi_periph_1/M11_ACLK] [get_bd_pins ps7_0_axi_periph_1/M12_ACLK] [get_bd_pins ps7_0_axi_periph_1/M13_ACLK] [get_bd_pins ps7_0_axi_periph_1/M14_ACLK] [get_bd_pins ps7_0_axi_periph_1/S00_ACLK] [get_bd_pins rst_ps7_0_100M/slowest_sync_clk] [get_bd_pins sc_gp_mm2s/aclk] [get_bd_pins sc_gp_s2mm/aclk] [get_bd_pins sc_p0_mm2s/aclk] [get_bd_pins sc_p0_s2mm/aclk] [get_bd_pins sc_p1_mm2s/aclk] [get_bd_pins sc_p1_s2mm/aclk] [get_bd_pins zdma_core_0/ap_clk] [get_bd_pins zdma_core_1/ap_clk] [get_bd_pins zdma_core_10/ap_clk] [get_bd_pins zdma_core_11/ap_clk] [get_bd_pins zdma_core_12/ap_clk] [get_bd_pins zdma_core_13/ap_clk] [get_bd_pins zdma_core_2/ap_clk] [get_bd_pins zdma_core_3/ap_clk] [get_bd_pins zdma_core_4/ap_clk] [get_bd_pins zdma_core_5/ap_clk] [get_bd_pins zdma_core_6/ap_clk] [get_bd_pins zdma_core_7/ap_clk] [get_bd_pins zdma_core_8/ap_clk] [get_bd_pins zdma_core_9/ap_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_100M/ext_reset_in]
  connect_bd_net -net rst_ps7_0_100M_interconnect_aresetn [get_bd_pins axis_dwidth_converter_0/aresetn] [get_bd_pins axis_dwidth_converter_1/aresetn] [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins axis_subset_converter_1/aresetn] [get_bd_pins ps7_0_axi_periph_0/ARESETN] [get_bd_pins ps7_0_axi_periph_1/ARESETN] [get_bd_pins rst_ps7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_dma_1/axi_resetn] [get_bd_pins axi_dma_10/axi_resetn] [get_bd_pins axi_dma_11/axi_resetn] [get_bd_pins axi_dma_2/axi_resetn] [get_bd_pins axi_dma_3/axi_resetn] [get_bd_pins axi_dma_4/axi_resetn] [get_bd_pins axi_dma_5/axi_resetn] [get_bd_pins axi_dma_6/axi_resetn] [get_bd_pins axi_dma_7/axi_resetn] [get_bd_pins axi_dma_8/axi_resetn] [get_bd_pins axi_dma_9/axi_resetn] [get_bd_pins axi_fifo_mm_s_0/s_axi_aresetn] [get_bd_pins axi_fifo_mm_s_1/s_axi_aresetn] [get_bd_pins ps7_0_axi_periph_0/M00_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M01_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M02_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M03_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M04_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M05_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M06_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M07_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M08_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M09_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M10_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M11_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M12_ARESETN] [get_bd_pins ps7_0_axi_periph_0/S00_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M00_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M01_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M02_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M03_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M04_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M05_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M06_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M07_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M08_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M09_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M10_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M11_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M12_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M13_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M14_ARESETN] [get_bd_pins ps7_0_axi_periph_1/S00_ARESETN] [get_bd_pins rst_ps7_0_100M/peripheral_aresetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x01000000 -offset 0x18000000 [get_bd_addr_spaces axi_dma_8/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] SEG_processing_system7_0_GP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_8/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] SEG_processing_system7_0_GP0_IOP
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_8/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0] SEG_processing_system7_0_GP0_M_AXI_GP0
  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_8/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP1] SEG_processing_system7_0_GP0_M_AXI_GP1
  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_8/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] SEG_processing_system7_0_GP0_QSPI_LINEAR
  create_bd_addr_seg -range 0x01000000 -offset 0x19000000 [get_bd_addr_spaces axi_dma_8/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_DDR_LOWOCM] SEG_processing_system7_0_GP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_8/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_IOP] SEG_processing_system7_0_GP1_IOP
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_8/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP0] SEG_processing_system7_0_GP1_M_AXI_GP0
  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_8/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP1] SEG_processing_system7_0_GP1_M_AXI_GP1
  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_8/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_QSPI_LINEAR] SEG_processing_system7_0_GP1_QSPI_LINEAR
  create_bd_addr_seg -range 0x01000000 -offset 0x18000000 [get_bd_addr_spaces axi_dma_9/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] SEG_processing_system7_0_GP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_9/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] SEG_processing_system7_0_GP0_IOP
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_9/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0] SEG_processing_system7_0_GP0_M_AXI_GP0
  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_9/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP1] SEG_processing_system7_0_GP0_M_AXI_GP1
  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_9/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] SEG_processing_system7_0_GP0_QSPI_LINEAR
  create_bd_addr_seg -range 0x01000000 -offset 0x19000000 [get_bd_addr_spaces axi_dma_9/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_DDR_LOWOCM] SEG_processing_system7_0_GP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_9/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_IOP] SEG_processing_system7_0_GP1_IOP
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_9/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP0] SEG_processing_system7_0_GP1_M_AXI_GP0
  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_9/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP1] SEG_processing_system7_0_GP1_M_AXI_GP1
  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_9/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_QSPI_LINEAR] SEG_processing_system7_0_GP1_QSPI_LINEAR
  create_bd_addr_seg -range 0x01000000 -offset 0x18000000 [get_bd_addr_spaces axi_dma_10/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] SEG_processing_system7_0_GP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_10/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] SEG_processing_system7_0_GP0_IOP
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_10/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0] SEG_processing_system7_0_GP0_M_AXI_GP0
  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_10/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP1] SEG_processing_system7_0_GP0_M_AXI_GP1
  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_10/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] SEG_processing_system7_0_GP0_QSPI_LINEAR
  create_bd_addr_seg -range 0x01000000 -offset 0x19000000 [get_bd_addr_spaces axi_dma_10/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_DDR_LOWOCM] SEG_processing_system7_0_GP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_10/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_IOP] SEG_processing_system7_0_GP1_IOP
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_10/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP0] SEG_processing_system7_0_GP1_M_AXI_GP0
  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_10/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP1] SEG_processing_system7_0_GP1_M_AXI_GP1
  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_10/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_QSPI_LINEAR] SEG_processing_system7_0_GP1_QSPI_LINEAR
  create_bd_addr_seg -range 0x01000000 -offset 0x18000000 [get_bd_addr_spaces axi_dma_11/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] SEG_processing_system7_0_GP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_11/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] SEG_processing_system7_0_GP0_IOP
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_11/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0] SEG_processing_system7_0_GP0_M_AXI_GP0
  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_11/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP1] SEG_processing_system7_0_GP0_M_AXI_GP1
  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_11/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] SEG_processing_system7_0_GP0_QSPI_LINEAR
  create_bd_addr_seg -range 0x01000000 -offset 0x19000000 [get_bd_addr_spaces axi_dma_11/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_DDR_LOWOCM] SEG_processing_system7_0_GP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_11/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_IOP] SEG_processing_system7_0_GP1_IOP
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_11/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP0] SEG_processing_system7_0_GP1_M_AXI_GP0
  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_11/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP1] SEG_processing_system7_0_GP1_M_AXI_GP1
  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_11/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_QSPI_LINEAR] SEG_processing_system7_0_GP1_QSPI_LINEAR
  create_bd_addr_seg -range 0x00010000 -offset 0x40400000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x404A0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_10/S_AXI_LITE/Reg] SEG_axi_dma_10_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x404B0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_11/S_AXI_LITE/Reg] SEG_axi_dma_11_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40410000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_1/S_AXI_LITE/Reg] SEG_axi_dma_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40420000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_2/S_AXI_LITE/Reg] SEG_axi_dma_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40430000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_3/S_AXI_LITE/Reg] SEG_axi_dma_3_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40440000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_4/S_AXI_LITE/Reg] SEG_axi_dma_4_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40450000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_5/S_AXI_LITE/Reg] SEG_axi_dma_5_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40460000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_6/S_AXI_LITE/Reg] SEG_axi_dma_6_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40470000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_7/S_AXI_LITE/Reg] SEG_axi_dma_7_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40480000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_8/S_AXI_LITE/Reg] SEG_axi_dma_8_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40490000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_9/S_AXI_LITE/Reg] SEG_axi_dma_9_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83CF0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_fifo_mm_s_0/S_AXI/Mem0] SEG_axi_fifo_mm_s_0_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_fifo_mm_s_1/S_AXI/Mem0] SEG_axi_fifo_mm_s_1_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x83C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_0/s_axi_control/Reg] SEG_zdma_core_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83CA0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_10/s_axi_control/Reg] SEG_zdma_core_10_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83CB0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_11/s_axi_control/Reg] SEG_zdma_core_11_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83CC0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_12/s_axi_control/Reg] SEG_zdma_core_12_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83CD0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_13/s_axi_control/Reg] SEG_zdma_core_13_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_1/s_axi_control/Reg] SEG_zdma_core_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_2/s_axi_control/Reg] SEG_zdma_core_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_3/s_axi_control/Reg] SEG_zdma_core_3_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_4/s_axi_control/Reg] SEG_zdma_core_4_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C50000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_5/s_axi_control/Reg] SEG_zdma_core_5_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C60000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_6/s_axi_control/Reg] SEG_zdma_core_6_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C70000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_7/s_axi_control/Reg] SEG_zdma_core_7_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C80000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_8/s_axi_control/Reg] SEG_zdma_core_8_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C90000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_9/s_axi_control/Reg] SEG_zdma_core_9_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


