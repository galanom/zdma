
################################################################
# This is a generated script based on design: zed_asym_cc_alt
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
# source zed_asym_cc_alt_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name zed_asym_cc_alt

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
  set LED [ create_bd_port -dir O -from 7 -to 0 LED ]
  set sel [ create_bd_port -dir I sel ]

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
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_11

  # Create instance: axi_dma_12, and set properties
  set axi_dma_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_12 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_12

  # Create instance: axi_dma_13, and set properties
  set axi_dma_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_13 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_13

  # Create instance: axi_dma_14, and set properties
  set axi_dma_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_14 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_14

  # Create instance: axi_dma_15, and set properties
  set axi_dma_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_15 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_15

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {6} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
 ] $axi_interconnect_0

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {6} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
 ] $axi_interconnect_1

  # Create instance: axi_interconnect_2, and set properties
  set axi_interconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_2 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {6} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
 ] $axi_interconnect_2

  # Create instance: axi_interconnect_3, and set properties
  set axi_interconnect_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_3 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {6} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
 ] $axi_interconnect_3

  # Create instance: axi_interconnect_4, and set properties
  set axi_interconnect_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_4 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {4} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
 ] $axi_interconnect_4

  # Create instance: axi_interconnect_5, and set properties
  set axi_interconnect_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_5 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {4} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
 ] $axi_interconnect_5

  # Create instance: debugger_0, and set properties
  set debugger_0 [ create_bd_cell -type ip -vlnv tuc.gr:zdma:debugger:2.7.1 debugger_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {ARM PLL} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {133} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {32} \
CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {32} \
CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {32} \
CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {32} \
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
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.M01_HAS_REGSLICE {1} \
CONFIG.M02_HAS_REGSLICE {1} \
CONFIG.M03_HAS_REGSLICE {1} \
CONFIG.M04_HAS_REGSLICE {1} \
CONFIG.M05_HAS_REGSLICE {1} \
CONFIG.M06_HAS_REGSLICE {1} \
CONFIG.M07_HAS_REGSLICE {1} \
CONFIG.M08_HAS_REGSLICE {1} \
CONFIG.M09_HAS_REGSLICE {1} \
CONFIG.M10_HAS_REGSLICE {1} \
CONFIG.M11_HAS_REGSLICE {1} \
CONFIG.M12_HAS_REGSLICE {1} \
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
CONFIG.NUM_MI {16} \
CONFIG.S00_HAS_DATA_FIFO {0} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.STRATEGY {1} \
 ] $ps7_0_axi_periph_0

  # Create instance: ps7_0_axi_periph_1, and set properties
  set ps7_0_axi_periph_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph_1 ]
  set_property -dict [ list \
CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.M01_HAS_REGSLICE {1} \
CONFIG.M02_HAS_REGSLICE {1} \
CONFIG.M03_HAS_REGSLICE {1} \
CONFIG.M04_HAS_REGSLICE {1} \
CONFIG.M05_HAS_REGSLICE {1} \
CONFIG.M06_HAS_REGSLICE {1} \
CONFIG.M07_HAS_REGSLICE {1} \
CONFIG.M08_HAS_REGSLICE {1} \
CONFIG.M09_HAS_REGSLICE {1} \
CONFIG.M10_HAS_REGSLICE {1} \
CONFIG.M11_HAS_REGSLICE {1} \
CONFIG.M12_HAS_REGSLICE {1} \
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
CONFIG.NUM_MI {16} \
CONFIG.S00_HAS_DATA_FIFO {0} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.STRATEGY {1} \
 ] $ps7_0_axi_periph_1

  # Create instance: rst_ps7_0_100M, and set properties
  set rst_ps7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {16} \
 ] $xlconcat_0

  # Create instance: zcore16_0, and set properties
  set zcore16_0 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_0 ]

  # Create instance: zcore16_1, and set properties
  set zcore16_1 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_1 ]

  # Create instance: zcore16_2, and set properties
  set zcore16_2 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_2 ]

  # Create instance: zcore16_3, and set properties
  set zcore16_3 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_3 ]

  # Create instance: zcore16_4, and set properties
  set zcore16_4 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_4 ]

  # Create instance: zcore16_5, and set properties
  set zcore16_5 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_5 ]

  # Create instance: zcore16_6, and set properties
  set zcore16_6 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_6 ]

  # Create instance: zcore16_7, and set properties
  set zcore16_7 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_7 ]

  # Create instance: zcore16_8, and set properties
  set zcore16_8 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_8 ]

  # Create instance: zcore16_9, and set properties
  set zcore16_9 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_9 ]

  # Create instance: zcore16_10, and set properties
  set zcore16_10 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_10 ]

  # Create instance: zcore16_11, and set properties
  set zcore16_11 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_11 ]

  # Create instance: zcore16_12, and set properties
  set zcore16_12 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_12 ]

  # Create instance: zcore16_13, and set properties
  set zcore16_13 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_13 ]

  # Create instance: zcore16_14, and set properties
  set zcore16_14 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_14 ]

  # Create instance: zcore16_15, and set properties
  set zcore16_15 [ create_bd_cell -type ip -vlnv tuc:hls:zcore16:3.7 zcore16_15 ]

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins processing_system7_0/M_AXI_GP1] [get_bd_intf_pins ps7_0_axi_periph_1/S00_AXI]
  connect_bd_intf_net -intf_net S05_AXI_1 [get_bd_intf_pins axi_dma_5/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins zcore16_0/src]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_10_M_AXIS_MM2S [get_bd_intf_pins axi_dma_10/M_AXIS_MM2S] [get_bd_intf_pins zcore16_10/src]
  connect_bd_intf_net -intf_net axi_dma_10_M_AXI_MM2S [get_bd_intf_pins axi_dma_10/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_10_M_AXI_S2MM [get_bd_intf_pins axi_dma_10/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_11_M_AXIS_MM2S [get_bd_intf_pins axi_dma_11/M_AXIS_MM2S] [get_bd_intf_pins zcore16_11/src]
  connect_bd_intf_net -intf_net axi_dma_11_M_AXI_MM2S [get_bd_intf_pins axi_dma_11/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_11_M_AXI_S2MM [get_bd_intf_pins axi_dma_11/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_12_M_AXIS_MM2S [get_bd_intf_pins axi_dma_12/M_AXIS_MM2S] [get_bd_intf_pins zcore16_12/src]
  connect_bd_intf_net -intf_net axi_dma_12_M_AXI_MM2S [get_bd_intf_pins axi_dma_12/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_5/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_12_M_AXI_S2MM [get_bd_intf_pins axi_dma_12/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_4/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_13_M_AXIS_MM2S [get_bd_intf_pins axi_dma_13/M_AXIS_MM2S] [get_bd_intf_pins zcore16_13/src]
  connect_bd_intf_net -intf_net axi_dma_13_M_AXI_MM2S [get_bd_intf_pins axi_dma_13/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_5/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_13_M_AXI_S2MM [get_bd_intf_pins axi_dma_13/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_4/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_14_M_AXIS_MM2S [get_bd_intf_pins axi_dma_14/M_AXIS_MM2S] [get_bd_intf_pins zcore16_14/src]
  connect_bd_intf_net -intf_net axi_dma_14_M_AXI_MM2S [get_bd_intf_pins axi_dma_14/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_5/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_14_M_AXI_S2MM [get_bd_intf_pins axi_dma_14/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_4/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_15_M_AXIS_MM2S [get_bd_intf_pins axi_dma_15/M_AXIS_MM2S] [get_bd_intf_pins zcore16_15/src]
  connect_bd_intf_net -intf_net axi_dma_15_M_AXI_MM2S [get_bd_intf_pins axi_dma_15/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_5/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_15_M_AXI_S2MM [get_bd_intf_pins axi_dma_15/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_4/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXIS_MM2S [get_bd_intf_pins axi_dma_1/M_AXIS_MM2S] [get_bd_intf_pins zcore16_1/src]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_MM2S [get_bd_intf_pins axi_dma_1/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_S2MM [get_bd_intf_pins axi_dma_1/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXIS_MM2S [get_bd_intf_pins axi_dma_2/M_AXIS_MM2S] [get_bd_intf_pins zcore16_2/src]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_MM2S [get_bd_intf_pins axi_dma_2/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_S2MM [get_bd_intf_pins axi_dma_2/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXIS_MM2S [get_bd_intf_pins axi_dma_3/M_AXIS_MM2S] [get_bd_intf_pins zcore16_3/src]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXI_MM2S [get_bd_intf_pins axi_dma_3/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXI_S2MM [get_bd_intf_pins axi_dma_3/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXIS_MM2S [get_bd_intf_pins axi_dma_4/M_AXIS_MM2S] [get_bd_intf_pins zcore16_4/src]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXI_MM2S [get_bd_intf_pins axi_dma_4/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXI_S2MM [get_bd_intf_pins axi_dma_4/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXIS_MM2S [get_bd_intf_pins axi_dma_5/M_AXIS_MM2S] [get_bd_intf_pins zcore16_5/src]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXI_S2MM [get_bd_intf_pins axi_dma_5/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXIS_MM2S [get_bd_intf_pins axi_dma_6/M_AXIS_MM2S] [get_bd_intf_pins zcore16_6/src]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_MM2S [get_bd_intf_pins axi_dma_6/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_S2MM [get_bd_intf_pins axi_dma_6/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXIS_MM2S [get_bd_intf_pins axi_dma_7/M_AXIS_MM2S] [get_bd_intf_pins zcore16_7/src]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXI_MM2S [get_bd_intf_pins axi_dma_7/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXI_S2MM [get_bd_intf_pins axi_dma_7/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_8_M_AXIS_MM2S [get_bd_intf_pins axi_dma_8/M_AXIS_MM2S] [get_bd_intf_pins zcore16_8/src]
  connect_bd_intf_net -intf_net axi_dma_8_M_AXI_MM2S [get_bd_intf_pins axi_dma_8/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_8_M_AXI_S2MM [get_bd_intf_pins axi_dma_8/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_9_M_AXIS_MM2S [get_bd_intf_pins axi_dma_9/M_AXIS_MM2S] [get_bd_intf_pins zcore16_9/src]
  connect_bd_intf_net -intf_net axi_dma_9_M_AXI_MM2S [get_bd_intf_pins axi_dma_9/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_9_M_AXI_S2MM [get_bd_intf_pins axi_dma_9/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP2]
  connect_bd_intf_net -intf_net axi_interconnect_2_M00_AXI [get_bd_intf_pins axi_interconnect_2/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP3]
  connect_bd_intf_net -intf_net axi_interconnect_3_M00_AXI [get_bd_intf_pins axi_interconnect_3/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP1]
  connect_bd_intf_net -intf_net axi_interconnect_4_M00_AXI [get_bd_intf_pins axi_interconnect_4/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_GP1]
  connect_bd_intf_net -intf_net axi_interconnect_5_M00_AXI [get_bd_intf_pins axi_interconnect_5/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_GP0]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph_0/S00_AXI]
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
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M12_AXI [get_bd_intf_pins axi_dma_12/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M12_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M13_AXI [get_bd_intf_pins axi_dma_13/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M13_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M14_AXI [get_bd_intf_pins axi_dma_14/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M14_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M15_AXI [get_bd_intf_pins axi_dma_15/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph_0/M15_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M00_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M00_AXI] [get_bd_intf_pins zcore16_0/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M01_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M01_AXI] [get_bd_intf_pins zcore16_1/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M02_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M02_AXI] [get_bd_intf_pins zcore16_2/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M03_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M03_AXI] [get_bd_intf_pins zcore16_3/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M04_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M04_AXI] [get_bd_intf_pins zcore16_4/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M05_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M05_AXI] [get_bd_intf_pins zcore16_5/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M06_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M06_AXI] [get_bd_intf_pins zcore16_6/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M07_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M07_AXI] [get_bd_intf_pins zcore16_7/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M08_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M08_AXI] [get_bd_intf_pins zcore16_8/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M09_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M09_AXI] [get_bd_intf_pins zcore16_9/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M10_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M10_AXI] [get_bd_intf_pins zcore16_10/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M11_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M11_AXI] [get_bd_intf_pins zcore16_11/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M12_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M12_AXI] [get_bd_intf_pins zcore16_12/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M13_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M13_AXI] [get_bd_intf_pins zcore16_13/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M14_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M14_AXI] [get_bd_intf_pins zcore16_14/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_1_M15_AXI [get_bd_intf_pins ps7_0_axi_periph_1/M15_AXI] [get_bd_intf_pins zcore16_15/s_axi_control]
  connect_bd_intf_net -intf_net zcore16_0_dst [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins zcore16_0/dst]
  connect_bd_intf_net -intf_net zcore16_10_dst [get_bd_intf_pins axi_dma_10/S_AXIS_S2MM] [get_bd_intf_pins zcore16_10/dst]
  connect_bd_intf_net -intf_net zcore16_11_dst [get_bd_intf_pins axi_dma_11/S_AXIS_S2MM] [get_bd_intf_pins zcore16_11/dst]
  connect_bd_intf_net -intf_net zcore16_12_dst [get_bd_intf_pins axi_dma_12/S_AXIS_S2MM] [get_bd_intf_pins zcore16_12/dst]
  connect_bd_intf_net -intf_net zcore16_13_dst [get_bd_intf_pins axi_dma_13/S_AXIS_S2MM] [get_bd_intf_pins zcore16_13/dst]
  connect_bd_intf_net -intf_net zcore16_14_dst [get_bd_intf_pins axi_dma_14/S_AXIS_S2MM] [get_bd_intf_pins zcore16_14/dst]
  connect_bd_intf_net -intf_net zcore16_15_dst [get_bd_intf_pins axi_dma_15/S_AXIS_S2MM] [get_bd_intf_pins zcore16_15/dst]
  connect_bd_intf_net -intf_net zcore16_1_dst [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM] [get_bd_intf_pins zcore16_1/dst]
  connect_bd_intf_net -intf_net zcore16_2_dst [get_bd_intf_pins axi_dma_2/S_AXIS_S2MM] [get_bd_intf_pins zcore16_2/dst]
  connect_bd_intf_net -intf_net zcore16_3_dst [get_bd_intf_pins axi_dma_3/S_AXIS_S2MM] [get_bd_intf_pins zcore16_3/dst]
  connect_bd_intf_net -intf_net zcore16_4_dst [get_bd_intf_pins axi_dma_4/S_AXIS_S2MM] [get_bd_intf_pins zcore16_4/dst]
  connect_bd_intf_net -intf_net zcore16_5_dst [get_bd_intf_pins axi_dma_5/S_AXIS_S2MM] [get_bd_intf_pins zcore16_5/dst]
  connect_bd_intf_net -intf_net zcore16_6_dst [get_bd_intf_pins axi_dma_6/S_AXIS_S2MM] [get_bd_intf_pins zcore16_6/dst]
  connect_bd_intf_net -intf_net zcore16_7_dst [get_bd_intf_pins axi_dma_7/S_AXIS_S2MM] [get_bd_intf_pins zcore16_7/dst]
  connect_bd_intf_net -intf_net zcore16_8_dst [get_bd_intf_pins axi_dma_8/S_AXIS_S2MM] [get_bd_intf_pins zcore16_8/dst]
  connect_bd_intf_net -intf_net zcore16_9_dst [get_bd_intf_pins axi_dma_9/S_AXIS_S2MM] [get_bd_intf_pins zcore16_9/dst]

  # Create port connections
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_dma_10_s2mm_introut [get_bd_pins axi_dma_10/s2mm_introut] [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net axi_dma_11_s2mm_introut [get_bd_pins axi_dma_11/s2mm_introut] [get_bd_pins xlconcat_0/In11]
  connect_bd_net -net axi_dma_12_s2mm_introut [get_bd_pins axi_dma_12/s2mm_introut] [get_bd_pins xlconcat_0/In12]
  connect_bd_net -net axi_dma_13_s2mm_introut [get_bd_pins axi_dma_13/s2mm_introut] [get_bd_pins xlconcat_0/In13]
  connect_bd_net -net axi_dma_14_s2mm_introut [get_bd_pins axi_dma_14/s2mm_introut] [get_bd_pins xlconcat_0/In14]
  connect_bd_net -net axi_dma_15_s2mm_introut [get_bd_pins axi_dma_15/s2mm_introut] [get_bd_pins xlconcat_0/In15]
  connect_bd_net -net axi_dma_1_s2mm_introut [get_bd_pins axi_dma_1/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_dma_2_s2mm_introut [get_bd_pins axi_dma_2/s2mm_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_dma_3_s2mm_introut [get_bd_pins axi_dma_3/s2mm_introut] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_dma_4_s2mm_introut [get_bd_pins axi_dma_4/s2mm_introut] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_dma_5_s2mm_introut [get_bd_pins axi_dma_5/s2mm_introut] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net axi_dma_6_s2mm_introut [get_bd_pins axi_dma_6/s2mm_introut] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net axi_dma_7_s2mm_introut [get_bd_pins axi_dma_7/s2mm_introut] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net axi_dma_8_s2mm_introut [get_bd_pins axi_dma_8/s2mm_introut] [get_bd_pins xlconcat_0/In8]
  connect_bd_net -net axi_dma_9_s2mm_introut [get_bd_pins axi_dma_9/s2mm_introut] [get_bd_pins xlconcat_0/In9]
  connect_bd_net -net debugger_0_LED [get_bd_ports LED] [get_bd_pins debugger_0/LED]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_dma_1/m_axi_mm2s_aclk] [get_bd_pins axi_dma_1/m_axi_s2mm_aclk] [get_bd_pins axi_dma_1/s_axi_lite_aclk] [get_bd_pins axi_dma_10/m_axi_mm2s_aclk] [get_bd_pins axi_dma_10/m_axi_s2mm_aclk] [get_bd_pins axi_dma_10/s_axi_lite_aclk] [get_bd_pins axi_dma_11/m_axi_mm2s_aclk] [get_bd_pins axi_dma_11/m_axi_s2mm_aclk] [get_bd_pins axi_dma_11/s_axi_lite_aclk] [get_bd_pins axi_dma_12/m_axi_mm2s_aclk] [get_bd_pins axi_dma_12/m_axi_s2mm_aclk] [get_bd_pins axi_dma_12/s_axi_lite_aclk] [get_bd_pins axi_dma_13/m_axi_mm2s_aclk] [get_bd_pins axi_dma_13/m_axi_s2mm_aclk] [get_bd_pins axi_dma_13/s_axi_lite_aclk] [get_bd_pins axi_dma_14/m_axi_mm2s_aclk] [get_bd_pins axi_dma_14/m_axi_s2mm_aclk] [get_bd_pins axi_dma_14/s_axi_lite_aclk] [get_bd_pins axi_dma_15/m_axi_mm2s_aclk] [get_bd_pins axi_dma_15/m_axi_s2mm_aclk] [get_bd_pins axi_dma_15/s_axi_lite_aclk] [get_bd_pins axi_dma_2/m_axi_mm2s_aclk] [get_bd_pins axi_dma_2/m_axi_s2mm_aclk] [get_bd_pins axi_dma_2/s_axi_lite_aclk] [get_bd_pins axi_dma_3/m_axi_mm2s_aclk] [get_bd_pins axi_dma_3/m_axi_s2mm_aclk] [get_bd_pins axi_dma_3/s_axi_lite_aclk] [get_bd_pins axi_dma_4/m_axi_mm2s_aclk] [get_bd_pins axi_dma_4/m_axi_s2mm_aclk] [get_bd_pins axi_dma_4/s_axi_lite_aclk] [get_bd_pins axi_dma_5/m_axi_mm2s_aclk] [get_bd_pins axi_dma_5/m_axi_s2mm_aclk] [get_bd_pins axi_dma_5/s_axi_lite_aclk] [get_bd_pins axi_dma_6/m_axi_mm2s_aclk] [get_bd_pins axi_dma_6/m_axi_s2mm_aclk] [get_bd_pins axi_dma_6/s_axi_lite_aclk] [get_bd_pins axi_dma_7/m_axi_mm2s_aclk] [get_bd_pins axi_dma_7/m_axi_s2mm_aclk] [get_bd_pins axi_dma_7/s_axi_lite_aclk] [get_bd_pins axi_dma_8/m_axi_mm2s_aclk] [get_bd_pins axi_dma_8/m_axi_s2mm_aclk] [get_bd_pins axi_dma_8/s_axi_lite_aclk] [get_bd_pins axi_dma_9/m_axi_mm2s_aclk] [get_bd_pins axi_dma_9/m_axi_s2mm_aclk] [get_bd_pins axi_dma_9/s_axi_lite_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_interconnect_0/S02_ACLK] [get_bd_pins axi_interconnect_0/S03_ACLK] [get_bd_pins axi_interconnect_0/S04_ACLK] [get_bd_pins axi_interconnect_0/S05_ACLK] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_interconnect_1/S01_ACLK] [get_bd_pins axi_interconnect_1/S02_ACLK] [get_bd_pins axi_interconnect_1/S03_ACLK] [get_bd_pins axi_interconnect_1/S04_ACLK] [get_bd_pins axi_interconnect_1/S05_ACLK] [get_bd_pins axi_interconnect_2/ACLK] [get_bd_pins axi_interconnect_2/M00_ACLK] [get_bd_pins axi_interconnect_2/S00_ACLK] [get_bd_pins axi_interconnect_2/S01_ACLK] [get_bd_pins axi_interconnect_2/S02_ACLK] [get_bd_pins axi_interconnect_2/S03_ACLK] [get_bd_pins axi_interconnect_2/S04_ACLK] [get_bd_pins axi_interconnect_2/S05_ACLK] [get_bd_pins axi_interconnect_3/ACLK] [get_bd_pins axi_interconnect_3/M00_ACLK] [get_bd_pins axi_interconnect_3/S00_ACLK] [get_bd_pins axi_interconnect_3/S01_ACLK] [get_bd_pins axi_interconnect_3/S02_ACLK] [get_bd_pins axi_interconnect_3/S03_ACLK] [get_bd_pins axi_interconnect_3/S04_ACLK] [get_bd_pins axi_interconnect_3/S05_ACLK] [get_bd_pins axi_interconnect_4/ACLK] [get_bd_pins axi_interconnect_4/M00_ACLK] [get_bd_pins axi_interconnect_4/S00_ACLK] [get_bd_pins axi_interconnect_4/S01_ACLK] [get_bd_pins axi_interconnect_4/S02_ACLK] [get_bd_pins axi_interconnect_4/S03_ACLK] [get_bd_pins axi_interconnect_5/ACLK] [get_bd_pins axi_interconnect_5/M00_ACLK] [get_bd_pins axi_interconnect_5/S00_ACLK] [get_bd_pins axi_interconnect_5/S01_ACLK] [get_bd_pins axi_interconnect_5/S02_ACLK] [get_bd_pins axi_interconnect_5/S03_ACLK] [get_bd_pins debugger_0/clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/M_AXI_GP1_ACLK] [get_bd_pins processing_system7_0/S_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_GP1_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP1_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP2_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP3_ACLK] [get_bd_pins ps7_0_axi_periph_0/ACLK] [get_bd_pins ps7_0_axi_periph_0/M00_ACLK] [get_bd_pins ps7_0_axi_periph_0/M01_ACLK] [get_bd_pins ps7_0_axi_periph_0/M02_ACLK] [get_bd_pins ps7_0_axi_periph_0/M03_ACLK] [get_bd_pins ps7_0_axi_periph_0/M04_ACLK] [get_bd_pins ps7_0_axi_periph_0/M05_ACLK] [get_bd_pins ps7_0_axi_periph_0/M06_ACLK] [get_bd_pins ps7_0_axi_periph_0/M07_ACLK] [get_bd_pins ps7_0_axi_periph_0/M08_ACLK] [get_bd_pins ps7_0_axi_periph_0/M09_ACLK] [get_bd_pins ps7_0_axi_periph_0/M10_ACLK] [get_bd_pins ps7_0_axi_periph_0/M11_ACLK] [get_bd_pins ps7_0_axi_periph_0/M12_ACLK] [get_bd_pins ps7_0_axi_periph_0/M13_ACLK] [get_bd_pins ps7_0_axi_periph_0/M14_ACLK] [get_bd_pins ps7_0_axi_periph_0/M15_ACLK] [get_bd_pins ps7_0_axi_periph_0/S00_ACLK] [get_bd_pins ps7_0_axi_periph_1/ACLK] [get_bd_pins ps7_0_axi_periph_1/M00_ACLK] [get_bd_pins ps7_0_axi_periph_1/M01_ACLK] [get_bd_pins ps7_0_axi_periph_1/M02_ACLK] [get_bd_pins ps7_0_axi_periph_1/M03_ACLK] [get_bd_pins ps7_0_axi_periph_1/M04_ACLK] [get_bd_pins ps7_0_axi_periph_1/M05_ACLK] [get_bd_pins ps7_0_axi_periph_1/M06_ACLK] [get_bd_pins ps7_0_axi_periph_1/M07_ACLK] [get_bd_pins ps7_0_axi_periph_1/M08_ACLK] [get_bd_pins ps7_0_axi_periph_1/M09_ACLK] [get_bd_pins ps7_0_axi_periph_1/M10_ACLK] [get_bd_pins ps7_0_axi_periph_1/M11_ACLK] [get_bd_pins ps7_0_axi_periph_1/M12_ACLK] [get_bd_pins ps7_0_axi_periph_1/M13_ACLK] [get_bd_pins ps7_0_axi_periph_1/M14_ACLK] [get_bd_pins ps7_0_axi_periph_1/M15_ACLK] [get_bd_pins ps7_0_axi_periph_1/S00_ACLK] [get_bd_pins rst_ps7_0_100M/slowest_sync_clk] [get_bd_pins zcore16_0/ap_clk] [get_bd_pins zcore16_1/ap_clk] [get_bd_pins zcore16_10/ap_clk] [get_bd_pins zcore16_11/ap_clk] [get_bd_pins zcore16_12/ap_clk] [get_bd_pins zcore16_13/ap_clk] [get_bd_pins zcore16_14/ap_clk] [get_bd_pins zcore16_15/ap_clk] [get_bd_pins zcore16_2/ap_clk] [get_bd_pins zcore16_3/ap_clk] [get_bd_pins zcore16_4/ap_clk] [get_bd_pins zcore16_5/ap_clk] [get_bd_pins zcore16_6/ap_clk] [get_bd_pins zcore16_7/ap_clk] [get_bd_pins zcore16_8/ap_clk] [get_bd_pins zcore16_9/ap_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_100M/ext_reset_in]
  connect_bd_net -net rst_ps7_0_100M_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_interconnect_2/ARESETN] [get_bd_pins axi_interconnect_3/ARESETN] [get_bd_pins axi_interconnect_4/ARESETN] [get_bd_pins axi_interconnect_5/ARESETN] [get_bd_pins ps7_0_axi_periph_0/ARESETN] [get_bd_pins ps7_0_axi_periph_1/ARESETN] [get_bd_pins rst_ps7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_dma_1/axi_resetn] [get_bd_pins axi_dma_10/axi_resetn] [get_bd_pins axi_dma_11/axi_resetn] [get_bd_pins axi_dma_12/axi_resetn] [get_bd_pins axi_dma_13/axi_resetn] [get_bd_pins axi_dma_14/axi_resetn] [get_bd_pins axi_dma_15/axi_resetn] [get_bd_pins axi_dma_2/axi_resetn] [get_bd_pins axi_dma_3/axi_resetn] [get_bd_pins axi_dma_4/axi_resetn] [get_bd_pins axi_dma_5/axi_resetn] [get_bd_pins axi_dma_6/axi_resetn] [get_bd_pins axi_dma_7/axi_resetn] [get_bd_pins axi_dma_8/axi_resetn] [get_bd_pins axi_dma_9/axi_resetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_interconnect_0/S02_ARESETN] [get_bd_pins axi_interconnect_0/S03_ARESETN] [get_bd_pins axi_interconnect_0/S04_ARESETN] [get_bd_pins axi_interconnect_0/S05_ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_interconnect_1/S01_ARESETN] [get_bd_pins axi_interconnect_1/S02_ARESETN] [get_bd_pins axi_interconnect_1/S03_ARESETN] [get_bd_pins axi_interconnect_1/S04_ARESETN] [get_bd_pins axi_interconnect_1/S05_ARESETN] [get_bd_pins axi_interconnect_2/M00_ARESETN] [get_bd_pins axi_interconnect_2/S00_ARESETN] [get_bd_pins axi_interconnect_2/S01_ARESETN] [get_bd_pins axi_interconnect_2/S02_ARESETN] [get_bd_pins axi_interconnect_2/S03_ARESETN] [get_bd_pins axi_interconnect_2/S04_ARESETN] [get_bd_pins axi_interconnect_2/S05_ARESETN] [get_bd_pins axi_interconnect_3/M00_ARESETN] [get_bd_pins axi_interconnect_3/S00_ARESETN] [get_bd_pins axi_interconnect_3/S01_ARESETN] [get_bd_pins axi_interconnect_3/S02_ARESETN] [get_bd_pins axi_interconnect_3/S03_ARESETN] [get_bd_pins axi_interconnect_3/S04_ARESETN] [get_bd_pins axi_interconnect_3/S05_ARESETN] [get_bd_pins axi_interconnect_4/M00_ARESETN] [get_bd_pins axi_interconnect_4/S00_ARESETN] [get_bd_pins axi_interconnect_4/S01_ARESETN] [get_bd_pins axi_interconnect_4/S02_ARESETN] [get_bd_pins axi_interconnect_4/S03_ARESETN] [get_bd_pins axi_interconnect_5/M00_ARESETN] [get_bd_pins axi_interconnect_5/S00_ARESETN] [get_bd_pins axi_interconnect_5/S01_ARESETN] [get_bd_pins axi_interconnect_5/S02_ARESETN] [get_bd_pins axi_interconnect_5/S03_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M00_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M01_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M02_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M03_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M04_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M05_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M06_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M07_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M08_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M09_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M10_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M11_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M12_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M13_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M14_ARESETN] [get_bd_pins ps7_0_axi_periph_0/M15_ARESETN] [get_bd_pins ps7_0_axi_periph_0/S00_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M00_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M01_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M02_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M03_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M04_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M05_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M06_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M07_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M08_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M09_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M10_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M11_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M12_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M13_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M14_ARESETN] [get_bd_pins ps7_0_axi_periph_1/M15_ARESETN] [get_bd_pins ps7_0_axi_periph_1/S00_ARESETN] [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins zcore16_0/ap_rst_n] [get_bd_pins zcore16_1/ap_rst_n] [get_bd_pins zcore16_10/ap_rst_n] [get_bd_pins zcore16_11/ap_rst_n] [get_bd_pins zcore16_12/ap_rst_n] [get_bd_pins zcore16_13/ap_rst_n] [get_bd_pins zcore16_14/ap_rst_n] [get_bd_pins zcore16_15/ap_rst_n] [get_bd_pins zcore16_2/ap_rst_n] [get_bd_pins zcore16_3/ap_rst_n] [get_bd_pins zcore16_4/ap_rst_n] [get_bd_pins zcore16_5/ap_rst_n] [get_bd_pins zcore16_6/ap_rst_n] [get_bd_pins zcore16_7/ap_rst_n] [get_bd_pins zcore16_8/ap_rst_n] [get_bd_pins zcore16_9/ap_rst_n]
  connect_bd_net -net sel_1 [get_bd_ports sel] [get_bd_pins debugger_0/sel]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins debugger_0/intr] [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_8/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_8/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_9/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_9/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_10/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_10/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_11/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_11/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x18000000 [get_bd_addr_spaces axi_dma_12/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] SEG_processing_system7_0_GP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x1A000000 [get_bd_addr_spaces axi_dma_12/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_DDR_LOWOCM] SEG_processing_system7_0_GP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x18000000 [get_bd_addr_spaces axi_dma_13/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] SEG_processing_system7_0_GP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x1A000000 [get_bd_addr_spaces axi_dma_13/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_DDR_LOWOCM] SEG_processing_system7_0_GP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x18000000 [get_bd_addr_spaces axi_dma_14/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] SEG_processing_system7_0_GP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x1A000000 [get_bd_addr_spaces axi_dma_14/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_DDR_LOWOCM] SEG_processing_system7_0_GP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x18000000 [get_bd_addr_spaces axi_dma_15/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] SEG_processing_system7_0_GP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x1A000000 [get_bd_addr_spaces axi_dma_15/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_DDR_LOWOCM] SEG_processing_system7_0_GP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00010000 -offset 0x40400000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x404A0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_10/S_AXI_LITE/Reg] SEG_axi_dma_10_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x404B0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_11/S_AXI_LITE/Reg] SEG_axi_dma_11_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x404C0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_12/S_AXI_LITE/Reg] SEG_axi_dma_12_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x404D0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_13/S_AXI_LITE/Reg] SEG_axi_dma_13_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x404E0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_14/S_AXI_LITE/Reg] SEG_axi_dma_14_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x404F0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_15/S_AXI_LITE/Reg] SEG_axi_dma_15_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40410000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_1/S_AXI_LITE/Reg] SEG_axi_dma_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40420000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_2/S_AXI_LITE/Reg] SEG_axi_dma_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40430000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_3/S_AXI_LITE/Reg] SEG_axi_dma_3_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40440000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_4/S_AXI_LITE/Reg] SEG_axi_dma_4_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40450000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_5/S_AXI_LITE/Reg] SEG_axi_dma_5_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40460000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_6/S_AXI_LITE/Reg] SEG_axi_dma_6_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40470000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_7/S_AXI_LITE/Reg] SEG_axi_dma_7_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40480000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_8/S_AXI_LITE/Reg] SEG_axi_dma_8_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40490000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_9/S_AXI_LITE/Reg] SEG_axi_dma_9_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_0/s_axi_control/Reg] SEG_zcore16_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83CA0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_10/s_axi_control/Reg] SEG_zcore16_10_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83CB0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_11/s_axi_control/Reg] SEG_zcore16_11_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83CC0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_12/s_axi_control/Reg] SEG_zcore16_12_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83CD0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_13/s_axi_control/Reg] SEG_zcore16_13_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83CE0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_14/s_axi_control/Reg] SEG_zcore16_14_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83CF0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_15/s_axi_control/Reg] SEG_zcore16_15_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_1/s_axi_control/Reg] SEG_zcore16_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_2/s_axi_control/Reg] SEG_zcore16_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_3/s_axi_control/Reg] SEG_zcore16_3_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_4/s_axi_control/Reg] SEG_zcore16_4_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C50000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_5/s_axi_control/Reg] SEG_zcore16_5_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C60000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_6/s_axi_control/Reg] SEG_zcore16_6_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C70000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_7/s_axi_control/Reg] SEG_zcore16_7_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C80000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_8/s_axi_control/Reg] SEG_zcore16_8_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C90000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zcore16_9/s_axi_control/Reg] SEG_zcore16_9_Reg

  # Exclude Address Segments
  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_12/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] SEG_processing_system7_0_GP0_IOP
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_MM2S/SEG_processing_system7_0_GP0_IOP]

  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_12/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0] SEG_processing_system7_0_GP0_M_AXI_GP0
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_MM2S/SEG_processing_system7_0_GP0_M_AXI_GP0]

  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_12/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP1] SEG_processing_system7_0_GP0_M_AXI_GP1
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_MM2S/SEG_processing_system7_0_GP0_M_AXI_GP1]

  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_12/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] SEG_processing_system7_0_GP0_QSPI_LINEAR
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_MM2S/SEG_processing_system7_0_GP0_QSPI_LINEAR]

  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_12/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_IOP] SEG_processing_system7_0_GP1_IOP
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_S2MM/SEG_processing_system7_0_GP1_IOP]

  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_12/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP0] SEG_processing_system7_0_GP1_M_AXI_GP0
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_S2MM/SEG_processing_system7_0_GP1_M_AXI_GP0]

  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_12/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP1] SEG_processing_system7_0_GP1_M_AXI_GP1
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_S2MM/SEG_processing_system7_0_GP1_M_AXI_GP1]

  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_12/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_QSPI_LINEAR] SEG_processing_system7_0_GP1_QSPI_LINEAR
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_S2MM/SEG_processing_system7_0_GP1_QSPI_LINEAR]

  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_13/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] SEG_processing_system7_0_GP0_IOP
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_MM2S/SEG_processing_system7_0_GP0_IOP]

  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_13/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0] SEG_processing_system7_0_GP0_M_AXI_GP0
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_MM2S/SEG_processing_system7_0_GP0_M_AXI_GP0]

  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_13/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP1] SEG_processing_system7_0_GP0_M_AXI_GP1
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_MM2S/SEG_processing_system7_0_GP0_M_AXI_GP1]

  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_13/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] SEG_processing_system7_0_GP0_QSPI_LINEAR
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_MM2S/SEG_processing_system7_0_GP0_QSPI_LINEAR]

  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_13/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_IOP] SEG_processing_system7_0_GP1_IOP
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_S2MM/SEG_processing_system7_0_GP1_IOP]

  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_13/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP0] SEG_processing_system7_0_GP1_M_AXI_GP0
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_S2MM/SEG_processing_system7_0_GP1_M_AXI_GP0]

  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_13/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP1] SEG_processing_system7_0_GP1_M_AXI_GP1
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_S2MM/SEG_processing_system7_0_GP1_M_AXI_GP1]

  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_13/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_QSPI_LINEAR] SEG_processing_system7_0_GP1_QSPI_LINEAR
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_S2MM/SEG_processing_system7_0_GP1_QSPI_LINEAR]

  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_14/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] SEG_processing_system7_0_GP0_IOP
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_MM2S/SEG_processing_system7_0_GP0_IOP]

  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_14/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0] SEG_processing_system7_0_GP0_M_AXI_GP0
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_MM2S/SEG_processing_system7_0_GP0_M_AXI_GP0]

  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_14/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP1] SEG_processing_system7_0_GP0_M_AXI_GP1
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_MM2S/SEG_processing_system7_0_GP0_M_AXI_GP1]

  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_14/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] SEG_processing_system7_0_GP0_QSPI_LINEAR
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_MM2S/SEG_processing_system7_0_GP0_QSPI_LINEAR]

  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_14/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_IOP] SEG_processing_system7_0_GP1_IOP
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_S2MM/SEG_processing_system7_0_GP1_IOP]

  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_14/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP0] SEG_processing_system7_0_GP1_M_AXI_GP0
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_S2MM/SEG_processing_system7_0_GP1_M_AXI_GP0]

  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_14/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP1] SEG_processing_system7_0_GP1_M_AXI_GP1
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_S2MM/SEG_processing_system7_0_GP1_M_AXI_GP1]

  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_14/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_QSPI_LINEAR] SEG_processing_system7_0_GP1_QSPI_LINEAR
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_S2MM/SEG_processing_system7_0_GP1_QSPI_LINEAR]

  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_15/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] SEG_processing_system7_0_GP0_IOP
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_MM2S/SEG_processing_system7_0_GP0_IOP]

  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_15/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0] SEG_processing_system7_0_GP0_M_AXI_GP0
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_MM2S/SEG_processing_system7_0_GP0_M_AXI_GP0]

  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_15/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP1] SEG_processing_system7_0_GP0_M_AXI_GP1
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_MM2S/SEG_processing_system7_0_GP0_M_AXI_GP1]

  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_15/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] SEG_processing_system7_0_GP0_QSPI_LINEAR
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_MM2S/SEG_processing_system7_0_GP0_QSPI_LINEAR]

  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_15/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_IOP] SEG_processing_system7_0_GP1_IOP
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_S2MM/SEG_processing_system7_0_GP1_IOP]

  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces axi_dma_15/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP0] SEG_processing_system7_0_GP1_M_AXI_GP0
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_S2MM/SEG_processing_system7_0_GP1_M_AXI_GP0]

  create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_15/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_M_AXI_GP1] SEG_processing_system7_0_GP1_M_AXI_GP1
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_S2MM/SEG_processing_system7_0_GP1_M_AXI_GP1]

  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces axi_dma_15/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_GP1/GP1_QSPI_LINEAR] SEG_processing_system7_0_GP1_QSPI_LINEAR
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_S2MM/SEG_processing_system7_0_GP1_QSPI_LINEAR]



  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


