
################################################################
# This is a generated script based on design: pb8_32
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
# source pb8_32_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name pb8_32

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
CONFIG.c_m_axis_mm2s_tdata_width {32} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {8} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_0

  # Create instance: axi_dma_1, and set properties
  set axi_dma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_1 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {32} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {8} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_1

  # Create instance: axi_dma_2, and set properties
  set axi_dma_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_2 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {32} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {8} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_2

  # Create instance: axi_dma_3, and set properties
  set axi_dma_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_3 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {32} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {8} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_3

  # Create instance: axi_dma_4, and set properties
  set axi_dma_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_4 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {32} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {8} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_4

  # Create instance: axi_dma_5, and set properties
  set axi_dma_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_5 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {32} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {8} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_5

  # Create instance: axi_dma_6, and set properties
  set axi_dma_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_6 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_6

  # Create instance: axi_dma_7, and set properties
  set axi_dma_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_7 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_7

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {145} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_M_AXI_GP1 {0} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.PCW_USE_S_AXI_HP1 {1} \
CONFIG.PCW_USE_S_AXI_HP2 {1} \
CONFIG.PCW_USE_S_AXI_HP3 {1} \
CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
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
CONFIG.NUM_MI {16} \
CONFIG.NUM_SI {1} \
CONFIG.S00_HAS_DATA_FIFO {1} \
CONFIG.S00_HAS_REGSLICE {1} \
 ] $ps7_0_axi_periph

  # Create instance: rst_ps7_0_100M, and set properties
  set rst_ps7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
CONFIG.ADVANCED_PROPERTIES {     __view__ { }    } \
CONFIG.HAS_ARESETN {0} \
CONFIG.NUM_MI {4} \
CONFIG.NUM_SI {16} \
 ] $smartconnect_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {8} \
 ] $xlconcat_0

  # Create instance: zcore32_0, and set properties
  set zcore32_0 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.3 zcore32_0 ]

  # Create instance: zcore32_1, and set properties
  set zcore32_1 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.3 zcore32_1 ]

  # Create instance: zcore32_2, and set properties
  set zcore32_2 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.3 zcore32_2 ]

  # Create instance: zcore32_3, and set properties
  set zcore32_3 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.3 zcore32_3 ]

  # Create instance: zcore32_4, and set properties
  set zcore32_4 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.3 zcore32_4 ]

  # Create instance: zcore32_5, and set properties
  set zcore32_5 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.3 zcore32_5 ]

  # Create instance: zcore32_6, and set properties
  set zcore32_6 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.3 zcore32_6 ]

  # Create instance: zcore32_7, and set properties
  set zcore32_7 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.3 zcore32_7 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins zcore32_0/src]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXIS_MM2S [get_bd_intf_pins axi_dma_1/M_AXIS_MM2S] [get_bd_intf_pins zcore32_1/src]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_MM2S [get_bd_intf_pins axi_dma_1/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_S2MM [get_bd_intf_pins axi_dma_1/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXIS_MM2S [get_bd_intf_pins axi_dma_2/M_AXIS_MM2S] [get_bd_intf_pins zcore32_2/src]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_MM2S [get_bd_intf_pins axi_dma_2/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_S2MM [get_bd_intf_pins axi_dma_2/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXIS_MM2S [get_bd_intf_pins axi_dma_3/M_AXIS_MM2S] [get_bd_intf_pins zcore32_3/src]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXI_MM2S [get_bd_intf_pins axi_dma_3/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S06_AXI]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXI_S2MM [get_bd_intf_pins axi_dma_3/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S07_AXI]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXIS_MM2S [get_bd_intf_pins axi_dma_4/M_AXIS_MM2S] [get_bd_intf_pins zcore32_4/src]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXI_MM2S [get_bd_intf_pins axi_dma_4/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S08_AXI]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXI_S2MM [get_bd_intf_pins axi_dma_4/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S09_AXI]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXIS_MM2S [get_bd_intf_pins axi_dma_5/M_AXIS_MM2S] [get_bd_intf_pins zcore32_5/src]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXI_MM2S [get_bd_intf_pins axi_dma_5/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S10_AXI]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXI_S2MM [get_bd_intf_pins axi_dma_5/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S11_AXI]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXIS_MM2S [get_bd_intf_pins axi_dma_6/M_AXIS_MM2S] [get_bd_intf_pins zcore32_6/src]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_MM2S [get_bd_intf_pins axi_dma_6/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S12_AXI]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_S2MM [get_bd_intf_pins axi_dma_6/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S13_AXI]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXIS_MM2S [get_bd_intf_pins axi_dma_7/M_AXIS_MM2S] [get_bd_intf_pins zcore32_7/src]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXI_MM2S [get_bd_intf_pins axi_dma_7/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S14_AXI]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXI_S2MM [get_bd_intf_pins axi_dma_7/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S15_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M00_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M01_AXI [get_bd_intf_pins axi_dma_1/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M02_AXI [get_bd_intf_pins axi_dma_2/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M03_AXI [get_bd_intf_pins axi_dma_3/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M04_AXI [get_bd_intf_pins axi_dma_4/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M05_AXI [get_bd_intf_pins axi_dma_5/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M06_AXI [get_bd_intf_pins axi_dma_6/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_0_M07_AXI [get_bd_intf_pins axi_dma_7/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M08_AXI [get_bd_intf_pins ps7_0_axi_periph/M08_AXI] [get_bd_intf_pins zcore32_0/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M09_AXI [get_bd_intf_pins ps7_0_axi_periph/M09_AXI] [get_bd_intf_pins zcore32_1/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M10_AXI [get_bd_intf_pins ps7_0_axi_periph/M10_AXI] [get_bd_intf_pins zcore32_2/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M11_AXI [get_bd_intf_pins ps7_0_axi_periph/M11_AXI] [get_bd_intf_pins zcore32_3/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M12_AXI [get_bd_intf_pins ps7_0_axi_periph/M12_AXI] [get_bd_intf_pins zcore32_4/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M13_AXI [get_bd_intf_pins ps7_0_axi_periph/M13_AXI] [get_bd_intf_pins zcore32_5/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M14_AXI [get_bd_intf_pins ps7_0_axi_periph/M14_AXI] [get_bd_intf_pins zcore32_6/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M15_AXI [get_bd_intf_pins ps7_0_axi_periph/M15_AXI] [get_bd_intf_pins zcore32_7/s_axi_control]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP0] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP1] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP2] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP3] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net zcore32_0_dst [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins zcore32_0/dst]
  connect_bd_intf_net -intf_net zcore32_1_dst [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM] [get_bd_intf_pins zcore32_1/dst]
  connect_bd_intf_net -intf_net zcore32_2_dst [get_bd_intf_pins axi_dma_2/S_AXIS_S2MM] [get_bd_intf_pins zcore32_2/dst]
  connect_bd_intf_net -intf_net zcore32_3_dst [get_bd_intf_pins axi_dma_3/S_AXIS_S2MM] [get_bd_intf_pins zcore32_3/dst]
  connect_bd_intf_net -intf_net zcore32_4_dst [get_bd_intf_pins axi_dma_4/S_AXIS_S2MM] [get_bd_intf_pins zcore32_4/dst]
  connect_bd_intf_net -intf_net zcore32_5_dst [get_bd_intf_pins axi_dma_5/S_AXIS_S2MM] [get_bd_intf_pins zcore32_5/dst]
  connect_bd_intf_net -intf_net zcore32_6_dst [get_bd_intf_pins axi_dma_6/S_AXIS_S2MM] [get_bd_intf_pins zcore32_6/dst]
  connect_bd_intf_net -intf_net zcore32_7_dst [get_bd_intf_pins axi_dma_7/S_AXIS_S2MM] [get_bd_intf_pins zcore32_7/dst]

  # Create port connections
  connect_bd_net -net axi_dma_0_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_0/mm2s_prmry_reset_out_n] [get_bd_pins zcore32_0/ap_rst_n]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_dma_1_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_1/mm2s_prmry_reset_out_n] [get_bd_pins zcore32_1/ap_rst_n]
  connect_bd_net -net axi_dma_1_s2mm_introut [get_bd_pins axi_dma_1/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_dma_2_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_2/mm2s_prmry_reset_out_n] [get_bd_pins zcore32_2/ap_rst_n]
  connect_bd_net -net axi_dma_2_s2mm_introut [get_bd_pins axi_dma_2/s2mm_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_dma_3_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_3/mm2s_prmry_reset_out_n] [get_bd_pins zcore32_3/ap_rst_n]
  connect_bd_net -net axi_dma_3_s2mm_introut [get_bd_pins axi_dma_3/s2mm_introut] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_dma_4_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_4/mm2s_prmry_reset_out_n] [get_bd_pins zcore32_4/ap_rst_n]
  connect_bd_net -net axi_dma_4_s2mm_introut [get_bd_pins axi_dma_4/s2mm_introut] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_dma_5_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_5/mm2s_prmry_reset_out_n] [get_bd_pins zcore32_5/ap_rst_n]
  connect_bd_net -net axi_dma_5_s2mm_introut [get_bd_pins axi_dma_5/s2mm_introut] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net axi_dma_6_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_6/mm2s_prmry_reset_out_n] [get_bd_pins zcore32_6/ap_rst_n]
  connect_bd_net -net axi_dma_6_s2mm_introut [get_bd_pins axi_dma_6/s2mm_introut] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net axi_dma_7_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_7/mm2s_prmry_reset_out_n] [get_bd_pins zcore32_7/ap_rst_n]
  connect_bd_net -net axi_dma_7_s2mm_introut [get_bd_pins axi_dma_7/s2mm_introut] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_dma_1/m_axi_mm2s_aclk] [get_bd_pins axi_dma_1/m_axi_s2mm_aclk] [get_bd_pins axi_dma_1/s_axi_lite_aclk] [get_bd_pins axi_dma_2/m_axi_mm2s_aclk] [get_bd_pins axi_dma_2/m_axi_s2mm_aclk] [get_bd_pins axi_dma_2/s_axi_lite_aclk] [get_bd_pins axi_dma_3/m_axi_mm2s_aclk] [get_bd_pins axi_dma_3/m_axi_s2mm_aclk] [get_bd_pins axi_dma_3/s_axi_lite_aclk] [get_bd_pins axi_dma_4/m_axi_mm2s_aclk] [get_bd_pins axi_dma_4/m_axi_s2mm_aclk] [get_bd_pins axi_dma_4/s_axi_lite_aclk] [get_bd_pins axi_dma_5/m_axi_mm2s_aclk] [get_bd_pins axi_dma_5/m_axi_s2mm_aclk] [get_bd_pins axi_dma_5/s_axi_lite_aclk] [get_bd_pins axi_dma_6/m_axi_mm2s_aclk] [get_bd_pins axi_dma_6/m_axi_s2mm_aclk] [get_bd_pins axi_dma_6/s_axi_lite_aclk] [get_bd_pins axi_dma_7/m_axi_mm2s_aclk] [get_bd_pins axi_dma_7/m_axi_s2mm_aclk] [get_bd_pins axi_dma_7/s_axi_lite_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP1_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP2_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP3_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/M04_ACLK] [get_bd_pins ps7_0_axi_periph/M05_ACLK] [get_bd_pins ps7_0_axi_periph/M06_ACLK] [get_bd_pins ps7_0_axi_periph/M07_ACLK] [get_bd_pins ps7_0_axi_periph/M08_ACLK] [get_bd_pins ps7_0_axi_periph/M09_ACLK] [get_bd_pins ps7_0_axi_periph/M10_ACLK] [get_bd_pins ps7_0_axi_periph/M11_ACLK] [get_bd_pins ps7_0_axi_periph/M12_ACLK] [get_bd_pins ps7_0_axi_periph/M13_ACLK] [get_bd_pins ps7_0_axi_periph/M14_ACLK] [get_bd_pins ps7_0_axi_periph/M15_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins rst_ps7_0_100M/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins zcore32_0/ap_clk] [get_bd_pins zcore32_1/ap_clk] [get_bd_pins zcore32_2/ap_clk] [get_bd_pins zcore32_3/ap_clk] [get_bd_pins zcore32_4/ap_clk] [get_bd_pins zcore32_5/ap_clk] [get_bd_pins zcore32_6/ap_clk] [get_bd_pins zcore32_7/ap_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_100M/ext_reset_in]
  connect_bd_net -net rst_ps7_0_100M_interconnect_aresetn [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins rst_ps7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_dma_1/axi_resetn] [get_bd_pins axi_dma_2/axi_resetn] [get_bd_pins axi_dma_3/axi_resetn] [get_bd_pins axi_dma_4/axi_resetn] [get_bd_pins axi_dma_5/axi_resetn] [get_bd_pins axi_dma_6/axi_resetn] [get_bd_pins axi_dma_7/axi_resetn] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/M04_ARESETN] [get_bd_pins ps7_0_axi_periph/M05_ARESETN] [get_bd_pins ps7_0_axi_periph/M06_ARESETN] [get_bd_pins ps7_0_axi_periph/M07_ARESETN] [get_bd_pins ps7_0_axi_periph/M08_ARESETN] [get_bd_pins ps7_0_axi_periph/M09_ARESETN] [get_bd_pins ps7_0_axi_periph/M10_ARESETN] [get_bd_pins ps7_0_axi_periph/M11_ARESETN] [get_bd_pins ps7_0_axi_periph/M12_ARESETN] [get_bd_pins ps7_0_axi_periph/M13_ARESETN] [get_bd_pins ps7_0_axi_periph/M14_ARESETN] [get_bd_pins ps7_0_axi_periph/M15_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps7_0_100M/peripheral_aresetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x08000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x0C000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x00010000 -offset 0x40400000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40410000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_1/S_AXI_LITE/Reg] SEG_axi_dma_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40420000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_2/S_AXI_LITE/Reg] SEG_axi_dma_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40430000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_3/S_AXI_LITE/Reg] SEG_axi_dma_3_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40440000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_4/S_AXI_LITE/Reg] SEG_axi_dma_4_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40450000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_5/S_AXI_LITE/Reg] SEG_axi_dma_5_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40460000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_6/S_AXI_LITE/Reg] SEG_axi_dma_6_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40470000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_7/S_AXI_LITE/Reg] SEG_axi_dma_7_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


