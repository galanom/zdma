
################################################################
# This is a generated script based on design: pb8
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
# source pb8_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name pb8

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
  set DC [ create_bd_port -dir O DC ]
  set LED [ create_bd_port -dir O -from 7 -to 0 LED ]
  set RES [ create_bd_port -dir O RES ]
  set SCLK [ create_bd_port -dir O SCLK ]
  set SDIN [ create_bd_port -dir O SDIN ]
  set SW [ create_bd_port -dir I -from 1 -to 0 SW ]
  set VBAT [ create_bd_port -dir O VBAT ]
  set VDD [ create_bd_port -dir O VDD ]

  # Create instance: ZedboardOLED_0, and set properties
  set ZedboardOLED_0 [ create_bd_cell -type ip -vlnv tamu.edu:user:ZedboardOLED:1.0 ZedboardOLED_0 ]

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axis_mm2s_tdata_width {32} \
CONFIG.c_mm2s_burst_size {16} \
CONFIG.c_s2mm_burst_size {16} \
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
CONFIG.c_s2mm_burst_size {16} \
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
CONFIG.c_s2mm_burst_size {16} \
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
CONFIG.c_s2mm_burst_size {16} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_3

  # Create instance: axi_dma_4, and set properties
  set axi_dma_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_4 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_4

  # Create instance: axi_dma_5, and set properties
  set axi_dma_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_5 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
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

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [ list \
CONFIG.NUM_MI {4} \
CONFIG.NUM_SI {16} \
 ] $axi_smc

  # Create instance: debug_1, and set properties
  set debug_1 [ create_bd_cell -type ip -vlnv galanom.info:zdma:debug:2.2 debug_1 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_HIGH_OCM {1} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.PCW_USE_S_AXI_HP1 {1} \
CONFIG.PCW_USE_S_AXI_HP2 {1} \
CONFIG.PCW_USE_S_AXI_HP3 {1} \
CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {17} \
 ] $ps7_0_axi_periph

  # Create instance: rst_ps7_0_100M, and set properties
  set rst_ps7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {16} \
 ] $xlconcat_0

  # Create instance: zdma_core_0, and set properties
  set zdma_core_0 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:2.1 zdma_core_0 ]

  # Create instance: zdma_core_1, and set properties
  set zdma_core_1 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:2.1 zdma_core_1 ]

  # Create instance: zdma_core_2, and set properties
  set zdma_core_2 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:2.1 zdma_core_2 ]

  # Create instance: zdma_core_3, and set properties
  set zdma_core_3 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:2.1 zdma_core_3 ]

  # Create instance: zdma_core_4, and set properties
  set zdma_core_4 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:2.1 zdma_core_4 ]

  # Create instance: zdma_core_5, and set properties
  set zdma_core_5 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:2.1 zdma_core_5 ]

  # Create instance: zdma_core_6, and set properties
  set zdma_core_6 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:2.1 zdma_core_6 ]

  # Create instance: zdma_core_7, and set properties
  set zdma_core_7 [ create_bd_cell -type ip -vlnv tuc:hls:zdma_core:2.1 zdma_core_7 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_0/src]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXIS_MM2S [get_bd_intf_pins axi_dma_1/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_1/src]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_MM2S [get_bd_intf_pins axi_dma_1/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_S2MM [get_bd_intf_pins axi_dma_1/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXIS_MM2S [get_bd_intf_pins axi_dma_2/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_2/src]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_MM2S [get_bd_intf_pins axi_dma_2/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_S2MM [get_bd_intf_pins axi_dma_2/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXIS_MM2S [get_bd_intf_pins axi_dma_3/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_3/src]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXI_MM2S [get_bd_intf_pins axi_dma_3/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S06_AXI]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXI_S2MM [get_bd_intf_pins axi_dma_3/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S07_AXI]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXIS_MM2S [get_bd_intf_pins axi_dma_4/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_4/src]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXI_MM2S [get_bd_intf_pins axi_dma_4/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S08_AXI]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXI_S2MM [get_bd_intf_pins axi_dma_4/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S09_AXI]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXIS_MM2S [get_bd_intf_pins axi_dma_5/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_5/src]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXI_MM2S [get_bd_intf_pins axi_dma_5/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S10_AXI]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXI_S2MM [get_bd_intf_pins axi_dma_5/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S11_AXI]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXIS_MM2S [get_bd_intf_pins axi_dma_6/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_6/src]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_MM2S [get_bd_intf_pins axi_dma_6/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S12_AXI]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_S2MM [get_bd_intf_pins axi_dma_6/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S13_AXI]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXIS_MM2S [get_bd_intf_pins axi_dma_7/M_AXIS_MM2S] [get_bd_intf_pins zdma_core_7/src]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXI_MM2S [get_bd_intf_pins axi_dma_7/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S14_AXI]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXI_S2MM [get_bd_intf_pins axi_dma_7/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S15_AXI]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_smc_M01_AXI [get_bd_intf_pins axi_smc/M01_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP1]
  connect_bd_intf_net -intf_net axi_smc_M02_AXI [get_bd_intf_pins axi_smc/M02_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP2]
  connect_bd_intf_net -intf_net axi_smc_M03_AXI [get_bd_intf_pins axi_smc/M03_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP3]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins ps7_0_axi_periph/M01_AXI] [get_bd_intf_pins zdma_core_0/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins axi_dma_1/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins ps7_0_axi_periph/M03_AXI] [get_bd_intf_pins zdma_core_1/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M04_AXI [get_bd_intf_pins axi_dma_2/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M05_AXI [get_bd_intf_pins axi_dma_3/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M06_AXI [get_bd_intf_pins ps7_0_axi_periph/M06_AXI] [get_bd_intf_pins zdma_core_2/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M07_AXI [get_bd_intf_pins ps7_0_axi_periph/M07_AXI] [get_bd_intf_pins zdma_core_3/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M08_AXI [get_bd_intf_pins axi_dma_4/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M09_AXI [get_bd_intf_pins ps7_0_axi_periph/M09_AXI] [get_bd_intf_pins zdma_core_4/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M10_AXI [get_bd_intf_pins axi_dma_5/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M11_AXI [get_bd_intf_pins ps7_0_axi_periph/M11_AXI] [get_bd_intf_pins zdma_core_5/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M12_AXI [get_bd_intf_pins axi_dma_6/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M12_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M13_AXI [get_bd_intf_pins ps7_0_axi_periph/M13_AXI] [get_bd_intf_pins zdma_core_6/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M14_AXI [get_bd_intf_pins axi_dma_7/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M14_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M15_AXI [get_bd_intf_pins ps7_0_axi_periph/M15_AXI] [get_bd_intf_pins zdma_core_7/s_axi_control]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M16_AXI [get_bd_intf_pins ZedboardOLED_0/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M16_AXI]
  connect_bd_intf_net -intf_net zdma_core_0_dst [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_0/dst]
  connect_bd_intf_net -intf_net zdma_core_1_dst [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_1/dst]
  connect_bd_intf_net -intf_net zdma_core_2_dst [get_bd_intf_pins axi_dma_2/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_2/dst]
  connect_bd_intf_net -intf_net zdma_core_3_dst [get_bd_intf_pins axi_dma_3/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_3/dst]
  connect_bd_intf_net -intf_net zdma_core_4_dst [get_bd_intf_pins axi_dma_4/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_4/dst]
  connect_bd_intf_net -intf_net zdma_core_5_dst [get_bd_intf_pins axi_dma_5/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_5/dst]
  connect_bd_intf_net -intf_net zdma_core_6_dst [get_bd_intf_pins axi_dma_6/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_6/dst]
  connect_bd_intf_net -intf_net zdma_core_7_dst [get_bd_intf_pins axi_dma_7/S_AXIS_S2MM] [get_bd_intf_pins zdma_core_7/dst]

  # Create port connections
  connect_bd_net -net SW_1 [get_bd_ports SW] [get_bd_pins debug_1/func]
  connect_bd_net -net ZedboardOLED_0_DC [get_bd_ports DC] [get_bd_pins ZedboardOLED_0/DC]
  connect_bd_net -net ZedboardOLED_0_RES [get_bd_ports RES] [get_bd_pins ZedboardOLED_0/RES]
  connect_bd_net -net ZedboardOLED_0_SCLK [get_bd_ports SCLK] [get_bd_pins ZedboardOLED_0/SCLK]
  connect_bd_net -net ZedboardOLED_0_SDIN [get_bd_ports SDIN] [get_bd_pins ZedboardOLED_0/SDIN]
  connect_bd_net -net ZedboardOLED_0_VBAT [get_bd_ports VBAT] [get_bd_pins ZedboardOLED_0/VBAT]
  connect_bd_net -net ZedboardOLED_0_VDD [get_bd_ports VDD] [get_bd_pins ZedboardOLED_0/VDD]
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins axi_dma_0/mm2s_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_dma_1_mm2s_introut [get_bd_pins axi_dma_1/mm2s_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_dma_1_s2mm_introut [get_bd_pins axi_dma_1/s2mm_introut] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_dma_2_mm2s_introut [get_bd_pins axi_dma_2/mm2s_introut] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_dma_2_s2mm_introut [get_bd_pins axi_dma_2/s2mm_introut] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net axi_dma_3_mm2s_introut [get_bd_pins axi_dma_3/mm2s_introut] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net axi_dma_3_s2mm_introut [get_bd_pins axi_dma_3/s2mm_introut] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net axi_dma_4_mm2s_introut [get_bd_pins axi_dma_4/mm2s_introut] [get_bd_pins xlconcat_0/In8]
  connect_bd_net -net axi_dma_4_s2mm_introut [get_bd_pins axi_dma_4/s2mm_introut] [get_bd_pins xlconcat_0/In9]
  connect_bd_net -net axi_dma_5_mm2s_introut [get_bd_pins axi_dma_5/mm2s_introut] [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net axi_dma_5_s2mm_introut [get_bd_pins axi_dma_5/s2mm_introut] [get_bd_pins xlconcat_0/In11]
  connect_bd_net -net axi_dma_6_mm2s_introut [get_bd_pins axi_dma_6/mm2s_introut] [get_bd_pins xlconcat_0/In12]
  connect_bd_net -net axi_dma_6_s2mm_introut [get_bd_pins axi_dma_6/s2mm_introut] [get_bd_pins xlconcat_0/In13]
  connect_bd_net -net axi_dma_7_mm2s_introut [get_bd_pins axi_dma_7/mm2s_introut] [get_bd_pins xlconcat_0/In14]
  connect_bd_net -net axi_dma_7_s2mm_introut [get_bd_pins axi_dma_7/s2mm_introut] [get_bd_pins xlconcat_0/In15]
  connect_bd_net -net debug_1_LED [get_bd_ports LED] [get_bd_pins debug_1/LED]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins ZedboardOLED_0/s00_axi_aclk] [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_dma_1/m_axi_mm2s_aclk] [get_bd_pins axi_dma_1/m_axi_s2mm_aclk] [get_bd_pins axi_dma_1/s_axi_lite_aclk] [get_bd_pins axi_dma_2/m_axi_mm2s_aclk] [get_bd_pins axi_dma_2/m_axi_s2mm_aclk] [get_bd_pins axi_dma_2/s_axi_lite_aclk] [get_bd_pins axi_dma_3/m_axi_mm2s_aclk] [get_bd_pins axi_dma_3/m_axi_s2mm_aclk] [get_bd_pins axi_dma_3/s_axi_lite_aclk] [get_bd_pins axi_dma_4/m_axi_mm2s_aclk] [get_bd_pins axi_dma_4/m_axi_s2mm_aclk] [get_bd_pins axi_dma_4/s_axi_lite_aclk] [get_bd_pins axi_dma_5/m_axi_mm2s_aclk] [get_bd_pins axi_dma_5/m_axi_s2mm_aclk] [get_bd_pins axi_dma_5/s_axi_lite_aclk] [get_bd_pins axi_dma_6/m_axi_mm2s_aclk] [get_bd_pins axi_dma_6/m_axi_s2mm_aclk] [get_bd_pins axi_dma_6/s_axi_lite_aclk] [get_bd_pins axi_dma_7/m_axi_mm2s_aclk] [get_bd_pins axi_dma_7/m_axi_s2mm_aclk] [get_bd_pins axi_dma_7/s_axi_lite_aclk] [get_bd_pins axi_smc/aclk] [get_bd_pins debug_1/clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP1_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP2_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP3_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/M04_ACLK] [get_bd_pins ps7_0_axi_periph/M05_ACLK] [get_bd_pins ps7_0_axi_periph/M06_ACLK] [get_bd_pins ps7_0_axi_periph/M07_ACLK] [get_bd_pins ps7_0_axi_periph/M08_ACLK] [get_bd_pins ps7_0_axi_periph/M09_ACLK] [get_bd_pins ps7_0_axi_periph/M10_ACLK] [get_bd_pins ps7_0_axi_periph/M11_ACLK] [get_bd_pins ps7_0_axi_periph/M12_ACLK] [get_bd_pins ps7_0_axi_periph/M13_ACLK] [get_bd_pins ps7_0_axi_periph/M14_ACLK] [get_bd_pins ps7_0_axi_periph/M15_ACLK] [get_bd_pins ps7_0_axi_periph/M16_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins rst_ps7_0_100M/slowest_sync_clk] [get_bd_pins zdma_core_0/ap_clk] [get_bd_pins zdma_core_1/ap_clk] [get_bd_pins zdma_core_2/ap_clk] [get_bd_pins zdma_core_3/ap_clk] [get_bd_pins zdma_core_4/ap_clk] [get_bd_pins zdma_core_5/ap_clk] [get_bd_pins zdma_core_6/ap_clk] [get_bd_pins zdma_core_7/ap_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_100M/ext_reset_in]
  connect_bd_net -net rst_ps7_0_100M_interconnect_aresetn [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins rst_ps7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins ZedboardOLED_0/s00_axi_aresetn] [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_dma_1/axi_resetn] [get_bd_pins axi_dma_2/axi_resetn] [get_bd_pins axi_dma_3/axi_resetn] [get_bd_pins axi_dma_4/axi_resetn] [get_bd_pins axi_dma_5/axi_resetn] [get_bd_pins axi_dma_6/axi_resetn] [get_bd_pins axi_dma_7/axi_resetn] [get_bd_pins axi_smc/aresetn] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/M04_ARESETN] [get_bd_pins ps7_0_axi_periph/M05_ARESETN] [get_bd_pins ps7_0_axi_periph/M06_ARESETN] [get_bd_pins ps7_0_axi_periph/M07_ARESETN] [get_bd_pins ps7_0_axi_periph/M08_ARESETN] [get_bd_pins ps7_0_axi_periph/M09_ARESETN] [get_bd_pins ps7_0_axi_periph/M10_ARESETN] [get_bd_pins ps7_0_axi_periph/M11_ARESETN] [get_bd_pins ps7_0_axi_periph/M12_ARESETN] [get_bd_pins ps7_0_axi_periph/M13_ARESETN] [get_bd_pins ps7_0_axi_periph/M14_ARESETN] [get_bd_pins ps7_0_axi_periph/M15_ARESETN] [get_bd_pins ps7_0_axi_periph/M16_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins zdma_core_0/ap_rst_n] [get_bd_pins zdma_core_1/ap_rst_n] [get_bd_pins zdma_core_2/ap_rst_n] [get_bd_pins zdma_core_3/ap_rst_n] [get_bd_pins zdma_core_4/ap_rst_n] [get_bd_pins zdma_core_5/ap_rst_n] [get_bd_pins zdma_core_6/ap_rst_n] [get_bd_pins zdma_core_7/ap_rst_n]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins debug_1/dma_intr] [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x10000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC0000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_HIGH_OCM] SEG_processing_system7_0_HP0_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x12000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFC8000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_HIGH_OCM] SEG_processing_system7_0_HP1_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x14000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD0000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_HIGH_OCM] SEG_processing_system7_0_HP2_HIGH_OCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x02000000 -offset 0x16000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x00008000 -offset 0xFFFD8000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_HIGH_OCM] SEG_processing_system7_0_HP3_HIGH_OCM
  create_bd_addr_seg -range 0x00010000 -offset 0x43CF0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ZedboardOLED_0/S00_AXI/S00_AXI_reg] SEG_ZedboardOLED_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40400000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40410000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_1/S_AXI_LITE/Reg] SEG_axi_dma_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40420000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_2/S_AXI_LITE/Reg] SEG_axi_dma_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40430000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_3/S_AXI_LITE/Reg] SEG_axi_dma_3_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40440000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_4/S_AXI_LITE/Reg] SEG_axi_dma_4_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40450000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_5/S_AXI_LITE/Reg] SEG_axi_dma_5_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40460000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_6/S_AXI_LITE/Reg] SEG_axi_dma_6_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40470000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_7/S_AXI_LITE/Reg] SEG_axi_dma_7_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_0/s_axi_control/Reg] SEG_zdma_core_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_1/s_axi_control/Reg] SEG_zdma_core_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_2/s_axi_control/Reg] SEG_zdma_core_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_3/s_axi_control/Reg] SEG_zdma_core_3_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_4/s_axi_control/Reg] SEG_zdma_core_4_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C50000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_5/s_axi_control/Reg] SEG_zdma_core_5_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C60000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_6/s_axi_control/Reg] SEG_zdma_core_6_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C70000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zdma_core_7/s_axi_control/Reg] SEG_zdma_core_7_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


