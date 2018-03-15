
################################################################
# This is a generated script based on design: sym
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
# source sym_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu9eg-ffvb1156-2-i
   set_property BOARD_PART xilinx.com:zcu102:part0:3.0 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name sym

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

  # Create ports

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_0

  # Create instance: axi_dma_1, and set properties
  set axi_dma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_1 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_1

  # Create instance: axi_dma_2, and set properties
  set axi_dma_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_2 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_2

  # Create instance: axi_dma_3, and set properties
  set axi_dma_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_3 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_3

  # Create instance: axi_dma_4, and set properties
  set axi_dma_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_4 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_4

  # Create instance: axi_dma_5, and set properties
  set axi_dma_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_5 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_5

  # Create instance: axi_dma_6, and set properties
  set axi_dma_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_6 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_6

  # Create instance: axi_dma_7, and set properties
  set axi_dma_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_7 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_7

  # Create instance: axi_dma_8, and set properties
  set axi_dma_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_8 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_8

  # Create instance: axi_dma_9, and set properties
  set axi_dma_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_9 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_9

  # Create instance: axi_dma_10, and set properties
  set axi_dma_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_10 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_10

  # Create instance: axi_dma_11, and set properties
  set axi_dma_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_11 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_11

  # Create instance: axi_dma_12, and set properties
  set axi_dma_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_12 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_12

  # Create instance: axi_dma_13, and set properties
  set axi_dma_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_13 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_13

  # Create instance: axi_dma_14, and set properties
  set axi_dma_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_14 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_14

  # Create instance: axi_dma_15, and set properties
  set axi_dma_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_15 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_15

  # Create instance: axi_dma_16, and set properties
  set axi_dma_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_16 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_16

  # Create instance: axi_dma_17, and set properties
  set axi_dma_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_17 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_17

  # Create instance: axi_dma_18, and set properties
  set axi_dma_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_18 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_18

  # Create instance: axi_dma_19, and set properties
  set axi_dma_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_19 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_19

  # Create instance: axi_dma_20, and set properties
  set axi_dma_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_20 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_20

  # Create instance: axi_dma_21, and set properties
  set axi_dma_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_21 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_21

  # Create instance: axi_dma_22, and set properties
  set axi_dma_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_22 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_22

  # Create instance: axi_dma_23, and set properties
  set axi_dma_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_23 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_23

  # Create instance: axi_dma_24, and set properties
  set axi_dma_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_24 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_24

  # Create instance: axi_dma_25, and set properties
  set axi_dma_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_25 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_25

  # Create instance: axi_dma_26, and set properties
  set axi_dma_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_26 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_26

  # Create instance: axi_dma_27, and set properties
  set axi_dma_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_27 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_27

  # Create instance: axi_dma_28, and set properties
  set axi_dma_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_28 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_28

  # Create instance: axi_dma_29, and set properties
  set axi_dma_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_29 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_29

  # Create instance: axi_dma_30, and set properties
  set axi_dma_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_30 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_30

  # Create instance: axi_dma_31, and set properties
  set axi_dma_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_31 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_31

  # Create instance: axi_dma_32, and set properties
  set axi_dma_32 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_32 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_32

  # Create instance: axi_dma_33, and set properties
  set axi_dma_33 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_33 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_33

  # Create instance: axi_dma_34, and set properties
  set axi_dma_34 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_34 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_34

  # Create instance: axi_dma_35, and set properties
  set axi_dma_35 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_35 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_35

  # Create instance: axi_dma_36, and set properties
  set axi_dma_36 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_36 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_36

  # Create instance: axi_dma_37, and set properties
  set axi_dma_37 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_37 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_37

  # Create instance: axi_dma_38, and set properties
  set axi_dma_38 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_38 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_38

  # Create instance: axi_dma_39, and set properties
  set axi_dma_39 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_39 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_39

  # Create instance: axi_dma_40, and set properties
  set axi_dma_40 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_40 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_40

  # Create instance: axi_dma_41, and set properties
  set axi_dma_41 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_41 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_41

  # Create instance: axi_dma_42, and set properties
  set axi_dma_42 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_42 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_42

  # Create instance: axi_dma_43, and set properties
  set axi_dma_43 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_43 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_43

  # Create instance: axi_dma_44, and set properties
  set axi_dma_44 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_44 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_44

  # Create instance: axi_dma_45, and set properties
  set axi_dma_45 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_45 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_45

  # Create instance: axi_dma_46, and set properties
  set axi_dma_46 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_46 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_46

  # Create instance: axi_dma_47, and set properties
  set axi_dma_47 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_47 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_47

  # Create instance: axi_dma_48, and set properties
  set axi_dma_48 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_48 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_48

  # Create instance: axi_dma_49, and set properties
  set axi_dma_49 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_49 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_49

  # Create instance: axi_dma_50, and set properties
  set axi_dma_50 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_50 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_50

  # Create instance: axi_dma_51, and set properties
  set axi_dma_51 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_51 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_51

  # Create instance: axi_dma_52, and set properties
  set axi_dma_52 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_52 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_52

  # Create instance: axi_dma_53, and set properties
  set axi_dma_53 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_53 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_53

  # Create instance: axi_dma_54, and set properties
  set axi_dma_54 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_54 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_54

  # Create instance: axi_dma_55, and set properties
  set axi_dma_55 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_55 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_55

  # Create instance: axi_dma_56, and set properties
  set axi_dma_56 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_56 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_56

  # Create instance: axi_dma_57, and set properties
  set axi_dma_57 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_57 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_57

  # Create instance: axi_dma_58, and set properties
  set axi_dma_58 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_58 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_58

  # Create instance: axi_dma_59, and set properties
  set axi_dma_59 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_59 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_59

  # Create instance: axi_dma_60, and set properties
  set axi_dma_60 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_60 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_60

  # Create instance: axi_dma_61, and set properties
  set axi_dma_61 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_61 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_61

  # Create instance: axi_dma_62, and set properties
  set axi_dma_62 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_62 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_62

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]
  set_property -dict [ list \
CONFIG.C_IRQ_CONNECTION {1} \
 ] $axi_intc_0

  # Create instance: axi_intc_1, and set properties
  set axi_intc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_1 ]
  set_property -dict [ list \
CONFIG.C_IRQ_CONNECTION {1} \
 ] $axi_intc_1

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {16} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
CONFIG.S06_HAS_REGSLICE {1} \
CONFIG.S07_HAS_REGSLICE {1} \
CONFIG.S08_HAS_REGSLICE {1} \
CONFIG.S09_HAS_REGSLICE {1} \
CONFIG.S10_HAS_REGSLICE {1} \
CONFIG.S11_HAS_REGSLICE {1} \
CONFIG.S12_HAS_REGSLICE {1} \
CONFIG.S13_HAS_REGSLICE {1} \
CONFIG.S14_HAS_REGSLICE {1} \
CONFIG.S15_HAS_REGSLICE {1} \
 ] $axi_interconnect_0

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {16} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
CONFIG.S06_HAS_REGSLICE {1} \
CONFIG.S07_HAS_REGSLICE {1} \
CONFIG.S08_HAS_REGSLICE {1} \
CONFIG.S09_HAS_REGSLICE {1} \
CONFIG.S10_HAS_REGSLICE {1} \
CONFIG.S11_HAS_REGSLICE {1} \
CONFIG.S12_HAS_REGSLICE {1} \
CONFIG.S13_HAS_REGSLICE {1} \
CONFIG.S14_HAS_REGSLICE {1} \
CONFIG.S15_HAS_REGSLICE {1} \
 ] $axi_interconnect_1

  # Create instance: axi_interconnect_2, and set properties
  set axi_interconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_2 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {16} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
CONFIG.S06_HAS_REGSLICE {1} \
CONFIG.S07_HAS_REGSLICE {1} \
CONFIG.S08_HAS_REGSLICE {1} \
CONFIG.S09_HAS_REGSLICE {1} \
CONFIG.S10_HAS_REGSLICE {1} \
CONFIG.S11_HAS_REGSLICE {1} \
CONFIG.S12_HAS_REGSLICE {1} \
CONFIG.S13_HAS_REGSLICE {1} \
CONFIG.S14_HAS_REGSLICE {1} \
CONFIG.S15_HAS_REGSLICE {1} \
 ] $axi_interconnect_2

  # Create instance: axi_interconnect_3, and set properties
  set axi_interconnect_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_3 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {16} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
CONFIG.S06_HAS_REGSLICE {1} \
CONFIG.S07_HAS_REGSLICE {1} \
CONFIG.S08_HAS_REGSLICE {1} \
CONFIG.S09_HAS_REGSLICE {1} \
CONFIG.S10_HAS_REGSLICE {1} \
CONFIG.S11_HAS_REGSLICE {1} \
CONFIG.S12_HAS_REGSLICE {1} \
CONFIG.S13_HAS_REGSLICE {1} \
CONFIG.S14_HAS_REGSLICE {1} \
CONFIG.S15_HAS_REGSLICE {1} \
 ] $axi_interconnect_3

  # Create instance: axi_interconnect_4, and set properties
  set axi_interconnect_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_4 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {16} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
CONFIG.S06_HAS_REGSLICE {1} \
CONFIG.S07_HAS_REGSLICE {1} \
CONFIG.S08_HAS_REGSLICE {1} \
CONFIG.S09_HAS_REGSLICE {1} \
CONFIG.S10_HAS_REGSLICE {1} \
CONFIG.S11_HAS_REGSLICE {1} \
CONFIG.S12_HAS_REGSLICE {1} \
CONFIG.S13_HAS_REGSLICE {1} \
CONFIG.S14_HAS_REGSLICE {1} \
CONFIG.S15_HAS_REGSLICE {1} \
 ] $axi_interconnect_4

  # Create instance: axi_interconnect_5, and set properties
  set axi_interconnect_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_5 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {16} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
CONFIG.S06_HAS_REGSLICE {1} \
CONFIG.S07_HAS_REGSLICE {1} \
CONFIG.S08_HAS_REGSLICE {1} \
CONFIG.S09_HAS_REGSLICE {1} \
CONFIG.S10_HAS_REGSLICE {1} \
CONFIG.S11_HAS_REGSLICE {1} \
CONFIG.S12_HAS_REGSLICE {1} \
CONFIG.S13_HAS_REGSLICE {1} \
CONFIG.S14_HAS_REGSLICE {1} \
CONFIG.S15_HAS_REGSLICE {1} \
 ] $axi_interconnect_5

  # Create instance: axi_interconnect_6, and set properties
  set axi_interconnect_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_6 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {15} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
CONFIG.S06_HAS_REGSLICE {1} \
CONFIG.S07_HAS_REGSLICE {1} \
CONFIG.S08_HAS_REGSLICE {1} \
CONFIG.S09_HAS_REGSLICE {1} \
CONFIG.S10_HAS_REGSLICE {1} \
CONFIG.S11_HAS_REGSLICE {1} \
CONFIG.S12_HAS_REGSLICE {1} \
CONFIG.S13_HAS_REGSLICE {1} \
CONFIG.S14_HAS_REGSLICE {1} \
CONFIG.S15_HAS_REGSLICE {1} \
 ] $axi_interconnect_6

  # Create instance: axi_interconnect_7, and set properties
  set axi_interconnect_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_7 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {15} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.S04_HAS_REGSLICE {1} \
CONFIG.S05_HAS_REGSLICE {1} \
CONFIG.S06_HAS_REGSLICE {1} \
CONFIG.S07_HAS_REGSLICE {1} \
CONFIG.S08_HAS_REGSLICE {1} \
CONFIG.S09_HAS_REGSLICE {1} \
CONFIG.S10_HAS_REGSLICE {1} \
CONFIG.S11_HAS_REGSLICE {1} \
CONFIG.S12_HAS_REGSLICE {1} \
CONFIG.S13_HAS_REGSLICE {1} \
CONFIG.S14_HAS_REGSLICE {1} \
CONFIG.S15_HAS_REGSLICE {1} \
 ] $axi_interconnect_7

  # Create instance: axi_interconnect_8, and set properties
  set axi_interconnect_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_8 ]
  set_property -dict [ list \
CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {2} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
 ] $axi_interconnect_8

  # Create instance: ps8_0_axi_periph_0, and set properties
  set ps8_0_axi_periph_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps8_0_axi_periph_0 ]
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
CONFIG.M32_HAS_REGSLICE {1} \
CONFIG.M33_HAS_REGSLICE {1} \
CONFIG.M34_HAS_REGSLICE {1} \
CONFIG.M35_HAS_REGSLICE {1} \
CONFIG.M36_HAS_REGSLICE {1} \
CONFIG.M37_HAS_REGSLICE {1} \
CONFIG.M38_HAS_REGSLICE {1} \
CONFIG.M39_HAS_REGSLICE {1} \
CONFIG.M40_HAS_REGSLICE {1} \
CONFIG.M41_HAS_REGSLICE {1} \
CONFIG.M42_HAS_REGSLICE {1} \
CONFIG.M43_HAS_REGSLICE {1} \
CONFIG.M44_HAS_REGSLICE {1} \
CONFIG.M45_HAS_REGSLICE {1} \
CONFIG.M46_HAS_REGSLICE {1} \
CONFIG.M47_HAS_REGSLICE {1} \
CONFIG.M48_HAS_REGSLICE {1} \
CONFIG.M49_HAS_REGSLICE {1} \
CONFIG.M50_HAS_REGSLICE {1} \
CONFIG.M51_HAS_REGSLICE {1} \
CONFIG.M52_HAS_REGSLICE {1} \
CONFIG.M53_HAS_REGSLICE {1} \
CONFIG.M54_HAS_REGSLICE {1} \
CONFIG.M55_HAS_REGSLICE {1} \
CONFIG.M56_HAS_REGSLICE {1} \
CONFIG.M57_HAS_REGSLICE {1} \
CONFIG.M58_HAS_REGSLICE {1} \
CONFIG.M59_HAS_REGSLICE {1} \
CONFIG.M60_HAS_REGSLICE {1} \
CONFIG.M61_HAS_REGSLICE {1} \
CONFIG.M62_HAS_REGSLICE {1} \
CONFIG.M63_HAS_REGSLICE {1} \
CONFIG.NUM_MI {64} \
CONFIG.NUM_SI {1} \
CONFIG.S00_HAS_DATA_FIFO {0} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
 ] $ps8_0_axi_periph_0

  # Create instance: ps8_0_axi_periph_1, and set properties
  set ps8_0_axi_periph_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps8_0_axi_periph_1 ]
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
CONFIG.M32_HAS_REGSLICE {1} \
CONFIG.M33_HAS_REGSLICE {1} \
CONFIG.M34_HAS_REGSLICE {1} \
CONFIG.M35_HAS_REGSLICE {1} \
CONFIG.M36_HAS_REGSLICE {1} \
CONFIG.M37_HAS_REGSLICE {1} \
CONFIG.M38_HAS_REGSLICE {1} \
CONFIG.M39_HAS_REGSLICE {1} \
CONFIG.M40_HAS_REGSLICE {1} \
CONFIG.M41_HAS_REGSLICE {1} \
CONFIG.M42_HAS_REGSLICE {1} \
CONFIG.M43_HAS_REGSLICE {1} \
CONFIG.M44_HAS_REGSLICE {1} \
CONFIG.M45_HAS_REGSLICE {1} \
CONFIG.M46_HAS_REGSLICE {1} \
CONFIG.M47_HAS_REGSLICE {1} \
CONFIG.M48_HAS_REGSLICE {1} \
CONFIG.M49_HAS_REGSLICE {1} \
CONFIG.M50_HAS_REGSLICE {1} \
CONFIG.M51_HAS_REGSLICE {1} \
CONFIG.M52_HAS_REGSLICE {1} \
CONFIG.M53_HAS_REGSLICE {1} \
CONFIG.M54_HAS_REGSLICE {1} \
CONFIG.M55_HAS_REGSLICE {1} \
CONFIG.M56_HAS_REGSLICE {1} \
CONFIG.M57_HAS_REGSLICE {1} \
CONFIG.M58_HAS_REGSLICE {1} \
CONFIG.M59_HAS_REGSLICE {1} \
CONFIG.M60_HAS_REGSLICE {1} \
CONFIG.M61_HAS_REGSLICE {1} \
CONFIG.M62_HAS_REGSLICE {1} \
CONFIG.M63_HAS_REGSLICE {1} \
CONFIG.NUM_MI {64} \
CONFIG.NUM_SI {1} \
CONFIG.S00_HAS_DATA_FIFO {0} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
 ] $ps8_0_axi_periph_1

  # Create instance: rst_ps8_0_99M, and set properties
  set rst_ps8_0_99M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_99M ]

  # Create instance: rst_ps8_0_99M_1, and set properties
  set rst_ps8_0_99M_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_99M_1 ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {2} \
 ] $xlconcat_1

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {31} \
 ] $xlconcat_2

  # Create instance: zcore32_0, and set properties
  set zcore32_0 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_0 ]

  # Create instance: zcore32_1, and set properties
  set zcore32_1 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_1 ]

  # Create instance: zcore32_2, and set properties
  set zcore32_2 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_2 ]

  # Create instance: zcore32_3, and set properties
  set zcore32_3 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_3 ]

  # Create instance: zcore32_4, and set properties
  set zcore32_4 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_4 ]

  # Create instance: zcore32_5, and set properties
  set zcore32_5 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_5 ]

  # Create instance: zcore32_6, and set properties
  set zcore32_6 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_6 ]

  # Create instance: zcore32_7, and set properties
  set zcore32_7 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_7 ]

  # Create instance: zcore32_8, and set properties
  set zcore32_8 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_8 ]

  # Create instance: zcore32_9, and set properties
  set zcore32_9 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_9 ]

  # Create instance: zcore32_10, and set properties
  set zcore32_10 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_10 ]

  # Create instance: zcore32_11, and set properties
  set zcore32_11 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_11 ]

  # Create instance: zcore32_12, and set properties
  set zcore32_12 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_12 ]

  # Create instance: zcore32_13, and set properties
  set zcore32_13 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_13 ]

  # Create instance: zcore32_14, and set properties
  set zcore32_14 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_14 ]

  # Create instance: zcore32_15, and set properties
  set zcore32_15 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_15 ]

  # Create instance: zcore32_16, and set properties
  set zcore32_16 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_16 ]

  # Create instance: zcore32_17, and set properties
  set zcore32_17 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_17 ]

  # Create instance: zcore32_18, and set properties
  set zcore32_18 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_18 ]

  # Create instance: zcore32_19, and set properties
  set zcore32_19 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_19 ]

  # Create instance: zcore32_20, and set properties
  set zcore32_20 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_20 ]

  # Create instance: zcore32_21, and set properties
  set zcore32_21 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_21 ]

  # Create instance: zcore32_22, and set properties
  set zcore32_22 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_22 ]

  # Create instance: zcore32_23, and set properties
  set zcore32_23 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_23 ]

  # Create instance: zcore32_24, and set properties
  set zcore32_24 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_24 ]

  # Create instance: zcore32_25, and set properties
  set zcore32_25 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_25 ]

  # Create instance: zcore32_26, and set properties
  set zcore32_26 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_26 ]

  # Create instance: zcore32_27, and set properties
  set zcore32_27 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_27 ]

  # Create instance: zcore32_28, and set properties
  set zcore32_28 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_28 ]

  # Create instance: zcore32_29, and set properties
  set zcore32_29 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_29 ]

  # Create instance: zcore32_30, and set properties
  set zcore32_30 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_30 ]

  # Create instance: zcore32_31, and set properties
  set zcore32_31 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_31 ]

  # Create instance: zcore32_32, and set properties
  set zcore32_32 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_32 ]

  # Create instance: zcore32_33, and set properties
  set zcore32_33 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_33 ]

  # Create instance: zcore32_34, and set properties
  set zcore32_34 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_34 ]

  # Create instance: zcore32_35, and set properties
  set zcore32_35 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_35 ]

  # Create instance: zcore32_36, and set properties
  set zcore32_36 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_36 ]

  # Create instance: zcore32_37, and set properties
  set zcore32_37 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_37 ]

  # Create instance: zcore32_38, and set properties
  set zcore32_38 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_38 ]

  # Create instance: zcore32_39, and set properties
  set zcore32_39 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_39 ]

  # Create instance: zcore32_40, and set properties
  set zcore32_40 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_40 ]

  # Create instance: zcore32_41, and set properties
  set zcore32_41 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_41 ]

  # Create instance: zcore32_42, and set properties
  set zcore32_42 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_42 ]

  # Create instance: zcore32_43, and set properties
  set zcore32_43 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_43 ]

  # Create instance: zcore32_44, and set properties
  set zcore32_44 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_44 ]

  # Create instance: zcore32_45, and set properties
  set zcore32_45 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_45 ]

  # Create instance: zcore32_46, and set properties
  set zcore32_46 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_46 ]

  # Create instance: zcore32_47, and set properties
  set zcore32_47 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_47 ]

  # Create instance: zcore32_48, and set properties
  set zcore32_48 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_48 ]

  # Create instance: zcore32_49, and set properties
  set zcore32_49 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_49 ]

  # Create instance: zcore32_50, and set properties
  set zcore32_50 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_50 ]

  # Create instance: zcore32_51, and set properties
  set zcore32_51 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_51 ]

  # Create instance: zcore32_52, and set properties
  set zcore32_52 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_52 ]

  # Create instance: zcore32_53, and set properties
  set zcore32_53 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_53 ]

  # Create instance: zcore32_54, and set properties
  set zcore32_54 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_54 ]

  # Create instance: zcore32_55, and set properties
  set zcore32_55 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_55 ]

  # Create instance: zcore32_56, and set properties
  set zcore32_56 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_56 ]

  # Create instance: zcore32_57, and set properties
  set zcore32_57 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_57 ]

  # Create instance: zcore32_58, and set properties
  set zcore32_58 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_58 ]

  # Create instance: zcore32_59, and set properties
  set zcore32_59 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_59 ]

  # Create instance: zcore32_60, and set properties
  set zcore32_60 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_60 ]

  # Create instance: zcore32_61, and set properties
  set zcore32_61 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_61 ]

  # Create instance: zcore32_62, and set properties
  set zcore32_62 [ create_bd_cell -type ip -vlnv tuc:hls:zcore32:3.7 zcore32_62 ]

  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.0 zynq_ultra_ps_e_0 ]
  set_property -dict [ list \
CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__CAN1__PERIPHERAL__IO {MIO 24 .. 25} \
CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067} \
CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__FREQMHZ {250} \
CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.33} \
CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {15} \
CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {267} \
CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {RPLL} \
CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {125} \
CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__DDRC__BANK_ADDR_COUNT {2} \
CONFIG.PSU__DDRC__BG_ADDR_COUNT {2} \
CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
CONFIG.PSU__DDRC__CL {15} \
CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
CONFIG.PSU__DDRC__COL_ADDR_COUNT {10} \
CONFIG.PSU__DDRC__COMPONENTS {UDIMM} \
CONFIG.PSU__DDRC__CWL {14} \
CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
CONFIG.PSU__DDRC__DEVICE_CAPACITY {4096 MBits} \
CONFIG.PSU__DDRC__DIMM_ADDR_MIRROR {0} \
CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
CONFIG.PSU__DDRC__DRAM_WIDTH {8 Bits} \
CONFIG.PSU__DDRC__ECC {Disabled} \
CONFIG.PSU__DDRC__FGRM {1X} \
CONFIG.PSU__DDRC__LP_ASR {manual normal} \
CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
CONFIG.PSU__DDRC__ROW_ADDR_COUNT {15} \
CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
CONFIG.PSU__DDRC__T_FAW {30.0} \
CONFIG.PSU__DDRC__T_RAS_MIN {33} \
CONFIG.PSU__DDRC__T_RC {47.06} \
CONFIG.PSU__DDRC__T_RCD {15} \
CONFIG.PSU__DDRC__T_RP {15} \
CONFIG.PSU__DDRC__VREF {1} \
CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
CONFIG.PSU__DP__LANE_SEL {Single Lower} \
CONFIG.PSU__DP__REF_CLK_FREQ {27} \
CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk3} \
CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
CONFIG.PSU__FPGA_PL0_ENABLE {1} \
CONFIG.PSU__FPGA_PL1_ENABLE {1} \
CONFIG.PSU__FPGA_PL2_ENABLE {0} \
CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15} \
CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
CONFIG.PSU__MAXIGP0__DATA_WIDTH {32} \
CONFIG.PSU__MAXIGP1__DATA_WIDTH {32} \
CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
CONFIG.PSU__PCIE__BAR0_ENABLE {0} \
CONFIG.PSU__PCIE__CLASS_CODE_BASE {0x06} \
CONFIG.PSU__PCIE__CLASS_CODE_SUB {0x4} \
CONFIG.PSU__PCIE__CRS_SW_VISIBILITY {1} \
CONFIG.PSU__PCIE__DEVICE_ID {0xD021} \
CONFIG.PSU__PCIE__DEVICE_PORT_TYPE {Root Port} \
CONFIG.PSU__PCIE__LANE1__ENABLE {0} \
CONFIG.PSU__PCIE__LINK_SPEED {5.0 Gb/s} \
CONFIG.PSU__PCIE__MAXIMUM_LINK_WIDTH {x1} \
CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_IO {MIO 31} \
CONFIG.PSU__PCIE__REF_CLK_FREQ {100} \
CONFIG.PSU__PCIE__REF_CLK_SEL {Ref Clk0} \
CONFIG.PSU__PMU__GPI0__ENABLE {0} \
CONFIG.PSU__PMU__GPI1__ENABLE {0} \
CONFIG.PSU__PMU__GPI2__ENABLE {0} \
CONFIG.PSU__PMU__GPI3__ENABLE {0} \
CONFIG.PSU__PMU__GPI4__ENABLE {0} \
CONFIG.PSU__PMU__GPI5__ENABLE {0} \
CONFIG.PSU__PMU__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.333} \
CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 12} \
CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel} \
CONFIG.PSU__SATA__LANE1__ENABLE {1} \
CONFIG.PSU__SATA__LANE1__IO {GT Lane3} \
CONFIG.PSU__SATA__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__SATA__REF_CLK_FREQ {125} \
CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk1} \
CONFIG.PSU__SAXIGP0__DATA_WIDTH {32} \
CONFIG.PSU__SAXIGP1__DATA_WIDTH {32} \
CONFIG.PSU__SAXIGP2__DATA_WIDTH {32} \
CONFIG.PSU__SAXIGP3__DATA_WIDTH {32} \
CONFIG.PSU__SAXIGP4__DATA_WIDTH {32} \
CONFIG.PSU__SAXIGP5__DATA_WIDTH {32} \
CONFIG.PSU__SAXIGP6__DATA_WIDTH {32} \
CONFIG.PSU__SD1__DATA_TRANSFER_MODE {8Bit} \
CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
CONFIG.PSU__SD1__GRP_POW__ENABLE {1} \
CONFIG.PSU__SD1__GRP_POW__IO {MIO 43} \
CONFIG.PSU__SD1__GRP_WP__ENABLE {1} \
CONFIG.PSU__SD1__GRP_WP__IO {MIO 44} \
CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 39 .. 51} \
CONFIG.PSU__SD1__SLOT_TYPE {SD 3.0} \
CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 20 .. 21} \
CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
CONFIG.PSU__USE__IRQ0 {1} \
CONFIG.PSU__USE__M_AXI_GP0 {1} \
CONFIG.PSU__USE__M_AXI_GP1 {1} \
CONFIG.PSU__USE__M_AXI_GP2 {0} \
CONFIG.PSU__USE__S_AXI_ACE {0} \
CONFIG.PSU__USE__S_AXI_ACP {0} \
CONFIG.PSU__USE__S_AXI_GP0 {1} \
CONFIG.PSU__USE__S_AXI_GP1 {1} \
CONFIG.PSU__USE__S_AXI_GP2 {1} \
CONFIG.PSU__USE__S_AXI_GP3 {1} \
CONFIG.PSU__USE__S_AXI_GP4 {1} \
CONFIG.PSU__USE__S_AXI_GP5 {1} \
CONFIG.PSU__USE__S_AXI_GP6 {1} \
 ] $zynq_ultra_ps_e_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins zcore32_0/src]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_10_M_AXIS_MM2S [get_bd_intf_pins axi_dma_10/M_AXIS_MM2S] [get_bd_intf_pins zcore32_10/src]
  connect_bd_intf_net -intf_net axi_dma_10_M_AXI_MM2S [get_bd_intf_pins axi_dma_10/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S10_AXI]
  connect_bd_intf_net -intf_net axi_dma_10_M_AXI_S2MM [get_bd_intf_pins axi_dma_10/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S10_AXI]
  connect_bd_intf_net -intf_net axi_dma_11_M_AXIS_MM2S [get_bd_intf_pins axi_dma_11/M_AXIS_MM2S] [get_bd_intf_pins zcore32_11/src]
  connect_bd_intf_net -intf_net axi_dma_11_M_AXI_MM2S [get_bd_intf_pins axi_dma_11/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S11_AXI]
  connect_bd_intf_net -intf_net axi_dma_11_M_AXI_S2MM [get_bd_intf_pins axi_dma_11/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S11_AXI]
  connect_bd_intf_net -intf_net axi_dma_12_M_AXIS_MM2S [get_bd_intf_pins axi_dma_12/M_AXIS_MM2S] [get_bd_intf_pins zcore32_12/src]
  connect_bd_intf_net -intf_net axi_dma_12_M_AXI_MM2S [get_bd_intf_pins axi_dma_12/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S12_AXI]
  connect_bd_intf_net -intf_net axi_dma_12_M_AXI_S2MM [get_bd_intf_pins axi_dma_12/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S12_AXI]
  connect_bd_intf_net -intf_net axi_dma_13_M_AXIS_MM2S [get_bd_intf_pins axi_dma_13/M_AXIS_MM2S] [get_bd_intf_pins zcore32_13/src]
  connect_bd_intf_net -intf_net axi_dma_13_M_AXI_MM2S [get_bd_intf_pins axi_dma_13/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S13_AXI]
  connect_bd_intf_net -intf_net axi_dma_13_M_AXI_S2MM [get_bd_intf_pins axi_dma_13/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S13_AXI]
  connect_bd_intf_net -intf_net axi_dma_14_M_AXIS_MM2S [get_bd_intf_pins axi_dma_14/M_AXIS_MM2S] [get_bd_intf_pins zcore32_14/src]
  connect_bd_intf_net -intf_net axi_dma_14_M_AXI_MM2S [get_bd_intf_pins axi_dma_14/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S14_AXI]
  connect_bd_intf_net -intf_net axi_dma_14_M_AXI_S2MM [get_bd_intf_pins axi_dma_14/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S14_AXI]
  connect_bd_intf_net -intf_net axi_dma_15_M_AXIS_MM2S [get_bd_intf_pins axi_dma_15/M_AXIS_MM2S] [get_bd_intf_pins zcore32_15/src]
  connect_bd_intf_net -intf_net axi_dma_15_M_AXI_MM2S [get_bd_intf_pins axi_dma_15/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S15_AXI]
  connect_bd_intf_net -intf_net axi_dma_15_M_AXI_S2MM [get_bd_intf_pins axi_dma_15/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S15_AXI]
  connect_bd_intf_net -intf_net axi_dma_16_M_AXIS_MM2S [get_bd_intf_pins axi_dma_16/M_AXIS_MM2S] [get_bd_intf_pins zcore32_16/src]
  connect_bd_intf_net -intf_net axi_dma_16_M_AXI_MM2S [get_bd_intf_pins axi_dma_16/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_16_M_AXI_S2MM [get_bd_intf_pins axi_dma_16/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_17_M_AXIS_MM2S [get_bd_intf_pins axi_dma_17/M_AXIS_MM2S] [get_bd_intf_pins zcore32_17/src]
  connect_bd_intf_net -intf_net axi_dma_17_M_AXI_MM2S [get_bd_intf_pins axi_dma_17/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_17_M_AXI_S2MM [get_bd_intf_pins axi_dma_17/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_18_M_AXIS_MM2S [get_bd_intf_pins axi_dma_18/M_AXIS_MM2S] [get_bd_intf_pins zcore32_18/src]
  connect_bd_intf_net -intf_net axi_dma_18_M_AXI_MM2S [get_bd_intf_pins axi_dma_18/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_18_M_AXI_S2MM [get_bd_intf_pins axi_dma_18/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_19_M_AXIS_MM2S [get_bd_intf_pins axi_dma_19/M_AXIS_MM2S] [get_bd_intf_pins zcore32_19/src]
  connect_bd_intf_net -intf_net axi_dma_19_M_AXI_MM2S [get_bd_intf_pins axi_dma_19/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_19_M_AXI_S2MM [get_bd_intf_pins axi_dma_19/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXIS_MM2S [get_bd_intf_pins axi_dma_1/M_AXIS_MM2S] [get_bd_intf_pins zcore32_1/src]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_MM2S [get_bd_intf_pins axi_dma_1/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_S2MM [get_bd_intf_pins axi_dma_1/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_20_M_AXIS_MM2S [get_bd_intf_pins axi_dma_20/M_AXIS_MM2S] [get_bd_intf_pins zcore32_20/src]
  connect_bd_intf_net -intf_net axi_dma_20_M_AXI_MM2S [get_bd_intf_pins axi_dma_20/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_20_M_AXI_S2MM [get_bd_intf_pins axi_dma_20/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_21_M_AXIS_MM2S [get_bd_intf_pins axi_dma_21/M_AXIS_MM2S] [get_bd_intf_pins zcore32_21/src]
  connect_bd_intf_net -intf_net axi_dma_21_M_AXI_MM2S [get_bd_intf_pins axi_dma_21/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_21_M_AXI_S2MM [get_bd_intf_pins axi_dma_21/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_22_M_AXIS_MM2S [get_bd_intf_pins axi_dma_22/M_AXIS_MM2S] [get_bd_intf_pins zcore32_22/src]
  connect_bd_intf_net -intf_net axi_dma_22_M_AXI_MM2S [get_bd_intf_pins axi_dma_22/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S06_AXI]
  connect_bd_intf_net -intf_net axi_dma_22_M_AXI_S2MM [get_bd_intf_pins axi_dma_22/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S06_AXI]
  connect_bd_intf_net -intf_net axi_dma_23_M_AXIS_MM2S [get_bd_intf_pins axi_dma_23/M_AXIS_MM2S] [get_bd_intf_pins zcore32_23/src]
  connect_bd_intf_net -intf_net axi_dma_23_M_AXI_MM2S [get_bd_intf_pins axi_dma_23/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S07_AXI]
  connect_bd_intf_net -intf_net axi_dma_23_M_AXI_S2MM [get_bd_intf_pins axi_dma_23/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S07_AXI]
  connect_bd_intf_net -intf_net axi_dma_24_M_AXIS_MM2S [get_bd_intf_pins axi_dma_24/M_AXIS_MM2S] [get_bd_intf_pins zcore32_24/src]
  connect_bd_intf_net -intf_net axi_dma_24_M_AXI_MM2S [get_bd_intf_pins axi_dma_24/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S08_AXI]
  connect_bd_intf_net -intf_net axi_dma_24_M_AXI_S2MM [get_bd_intf_pins axi_dma_24/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S08_AXI]
  connect_bd_intf_net -intf_net axi_dma_25_M_AXIS_MM2S [get_bd_intf_pins axi_dma_25/M_AXIS_MM2S] [get_bd_intf_pins zcore32_25/src]
  connect_bd_intf_net -intf_net axi_dma_25_M_AXI_MM2S [get_bd_intf_pins axi_dma_25/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S09_AXI]
  connect_bd_intf_net -intf_net axi_dma_25_M_AXI_S2MM [get_bd_intf_pins axi_dma_25/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S09_AXI]
  connect_bd_intf_net -intf_net axi_dma_26_M_AXIS_MM2S [get_bd_intf_pins axi_dma_26/M_AXIS_MM2S] [get_bd_intf_pins zcore32_26/src]
  connect_bd_intf_net -intf_net axi_dma_26_M_AXI_MM2S [get_bd_intf_pins axi_dma_26/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S10_AXI]
  connect_bd_intf_net -intf_net axi_dma_26_M_AXI_S2MM [get_bd_intf_pins axi_dma_26/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S10_AXI]
  connect_bd_intf_net -intf_net axi_dma_27_M_AXIS_MM2S [get_bd_intf_pins axi_dma_27/M_AXIS_MM2S] [get_bd_intf_pins zcore32_27/src]
  connect_bd_intf_net -intf_net axi_dma_27_M_AXI_MM2S [get_bd_intf_pins axi_dma_27/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S11_AXI]
  connect_bd_intf_net -intf_net axi_dma_27_M_AXI_S2MM [get_bd_intf_pins axi_dma_27/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S11_AXI]
  connect_bd_intf_net -intf_net axi_dma_28_M_AXIS_MM2S [get_bd_intf_pins axi_dma_28/M_AXIS_MM2S] [get_bd_intf_pins zcore32_28/src]
  connect_bd_intf_net -intf_net axi_dma_28_M_AXI_MM2S [get_bd_intf_pins axi_dma_28/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S12_AXI]
  connect_bd_intf_net -intf_net axi_dma_28_M_AXI_S2MM [get_bd_intf_pins axi_dma_28/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S12_AXI]
  connect_bd_intf_net -intf_net axi_dma_29_M_AXIS_MM2S [get_bd_intf_pins axi_dma_29/M_AXIS_MM2S] [get_bd_intf_pins zcore32_29/src]
  connect_bd_intf_net -intf_net axi_dma_29_M_AXI_MM2S [get_bd_intf_pins axi_dma_29/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S13_AXI]
  connect_bd_intf_net -intf_net axi_dma_29_M_AXI_S2MM [get_bd_intf_pins axi_dma_29/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S13_AXI]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXIS_MM2S [get_bd_intf_pins axi_dma_2/M_AXIS_MM2S] [get_bd_intf_pins zcore32_2/src]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_MM2S [get_bd_intf_pins axi_dma_2/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_S2MM [get_bd_intf_pins axi_dma_2/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_30_M_AXIS_MM2S [get_bd_intf_pins axi_dma_30/M_AXIS_MM2S] [get_bd_intf_pins zcore32_30/src]
  connect_bd_intf_net -intf_net axi_dma_30_M_AXI_MM2S [get_bd_intf_pins axi_dma_30/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S14_AXI]
  connect_bd_intf_net -intf_net axi_dma_30_M_AXI_S2MM [get_bd_intf_pins axi_dma_30/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S14_AXI]
  connect_bd_intf_net -intf_net axi_dma_31_M_AXIS_MM2S [get_bd_intf_pins axi_dma_31/M_AXIS_MM2S] [get_bd_intf_pins zcore32_31/src]
  connect_bd_intf_net -intf_net axi_dma_31_M_AXI_MM2S [get_bd_intf_pins axi_dma_31/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S15_AXI]
  connect_bd_intf_net -intf_net axi_dma_31_M_AXI_S2MM [get_bd_intf_pins axi_dma_31/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_3/S15_AXI]
  connect_bd_intf_net -intf_net axi_dma_32_M_AXIS_MM2S [get_bd_intf_pins axi_dma_32/M_AXIS_MM2S] [get_bd_intf_pins zcore32_32/src]
  connect_bd_intf_net -intf_net axi_dma_32_M_AXI_MM2S [get_bd_intf_pins axi_dma_32/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_32_M_AXI_S2MM [get_bd_intf_pins axi_dma_32/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_33_M_AXIS_MM2S [get_bd_intf_pins axi_dma_33/M_AXIS_MM2S] [get_bd_intf_pins zcore32_33/src]
  connect_bd_intf_net -intf_net axi_dma_33_M_AXI_MM2S [get_bd_intf_pins axi_dma_33/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_33_M_AXI_S2MM [get_bd_intf_pins axi_dma_33/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_34_M_AXIS_MM2S [get_bd_intf_pins axi_dma_34/M_AXIS_MM2S] [get_bd_intf_pins zcore32_34/src]
  connect_bd_intf_net -intf_net axi_dma_34_M_AXI_MM2S [get_bd_intf_pins axi_dma_34/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_34_M_AXI_S2MM [get_bd_intf_pins axi_dma_34/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_35_M_AXIS_MM2S [get_bd_intf_pins axi_dma_35/M_AXIS_MM2S] [get_bd_intf_pins zcore32_35/src]
  connect_bd_intf_net -intf_net axi_dma_35_M_AXI_MM2S [get_bd_intf_pins axi_dma_35/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_35_M_AXI_S2MM [get_bd_intf_pins axi_dma_35/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_36_M_AXIS_MM2S [get_bd_intf_pins axi_dma_36/M_AXIS_MM2S] [get_bd_intf_pins zcore32_36/src]
  connect_bd_intf_net -intf_net axi_dma_36_M_AXI_MM2S [get_bd_intf_pins axi_dma_36/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_36_M_AXI_S2MM [get_bd_intf_pins axi_dma_36/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_37_M_AXIS_MM2S [get_bd_intf_pins axi_dma_37/M_AXIS_MM2S] [get_bd_intf_pins zcore32_37/src]
  connect_bd_intf_net -intf_net axi_dma_37_M_AXI_MM2S [get_bd_intf_pins axi_dma_37/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_37_M_AXI_S2MM [get_bd_intf_pins axi_dma_37/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_38_M_AXIS_MM2S [get_bd_intf_pins axi_dma_38/M_AXIS_MM2S] [get_bd_intf_pins zcore32_38/src]
  connect_bd_intf_net -intf_net axi_dma_38_M_AXI_MM2S [get_bd_intf_pins axi_dma_38/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S06_AXI]
  connect_bd_intf_net -intf_net axi_dma_38_M_AXI_S2MM [get_bd_intf_pins axi_dma_38/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S06_AXI]
  connect_bd_intf_net -intf_net axi_dma_39_M_AXIS_MM2S [get_bd_intf_pins axi_dma_39/M_AXIS_MM2S] [get_bd_intf_pins zcore32_39/src]
  connect_bd_intf_net -intf_net axi_dma_39_M_AXI_MM2S [get_bd_intf_pins axi_dma_39/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S07_AXI]
  connect_bd_intf_net -intf_net axi_dma_39_M_AXI_S2MM [get_bd_intf_pins axi_dma_39/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S07_AXI]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXIS_MM2S [get_bd_intf_pins axi_dma_3/M_AXIS_MM2S] [get_bd_intf_pins zcore32_3/src]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXI_MM2S [get_bd_intf_pins axi_dma_3/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXI_S2MM [get_bd_intf_pins axi_dma_3/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_40_M_AXIS_MM2S [get_bd_intf_pins axi_dma_40/M_AXIS_MM2S] [get_bd_intf_pins zcore32_40/src]
  connect_bd_intf_net -intf_net axi_dma_40_M_AXI_MM2S [get_bd_intf_pins axi_dma_40/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S08_AXI]
  connect_bd_intf_net -intf_net axi_dma_40_M_AXI_S2MM [get_bd_intf_pins axi_dma_40/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S08_AXI]
  connect_bd_intf_net -intf_net axi_dma_41_M_AXIS_MM2S [get_bd_intf_pins axi_dma_41/M_AXIS_MM2S] [get_bd_intf_pins zcore32_41/src]
  connect_bd_intf_net -intf_net axi_dma_41_M_AXI_MM2S [get_bd_intf_pins axi_dma_41/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S09_AXI]
  connect_bd_intf_net -intf_net axi_dma_41_M_AXI_S2MM [get_bd_intf_pins axi_dma_41/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S09_AXI]
  connect_bd_intf_net -intf_net axi_dma_42_M_AXIS_MM2S [get_bd_intf_pins axi_dma_42/M_AXIS_MM2S] [get_bd_intf_pins zcore32_42/src]
  connect_bd_intf_net -intf_net axi_dma_42_M_AXI_MM2S [get_bd_intf_pins axi_dma_42/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S10_AXI]
  connect_bd_intf_net -intf_net axi_dma_42_M_AXI_S2MM [get_bd_intf_pins axi_dma_42/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S10_AXI]
  connect_bd_intf_net -intf_net axi_dma_43_M_AXIS_MM2S [get_bd_intf_pins axi_dma_43/M_AXIS_MM2S] [get_bd_intf_pins zcore32_43/src]
  connect_bd_intf_net -intf_net axi_dma_43_M_AXI_MM2S [get_bd_intf_pins axi_dma_43/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S11_AXI]
  connect_bd_intf_net -intf_net axi_dma_43_M_AXI_S2MM [get_bd_intf_pins axi_dma_43/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S11_AXI]
  connect_bd_intf_net -intf_net axi_dma_44_M_AXIS_MM2S [get_bd_intf_pins axi_dma_44/M_AXIS_MM2S] [get_bd_intf_pins zcore32_44/src]
  connect_bd_intf_net -intf_net axi_dma_44_M_AXI_MM2S [get_bd_intf_pins axi_dma_44/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S12_AXI]
  connect_bd_intf_net -intf_net axi_dma_44_M_AXI_S2MM [get_bd_intf_pins axi_dma_44/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S12_AXI]
  connect_bd_intf_net -intf_net axi_dma_45_M_AXIS_MM2S [get_bd_intf_pins axi_dma_45/M_AXIS_MM2S] [get_bd_intf_pins zcore32_45/src]
  connect_bd_intf_net -intf_net axi_dma_45_M_AXI_MM2S [get_bd_intf_pins axi_dma_45/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S13_AXI]
  connect_bd_intf_net -intf_net axi_dma_45_M_AXI_S2MM [get_bd_intf_pins axi_dma_45/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S13_AXI]
  connect_bd_intf_net -intf_net axi_dma_46_M_AXIS_MM2S [get_bd_intf_pins axi_dma_46/M_AXIS_MM2S] [get_bd_intf_pins zcore32_46/src]
  connect_bd_intf_net -intf_net axi_dma_46_M_AXI_MM2S [get_bd_intf_pins axi_dma_46/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S14_AXI]
  connect_bd_intf_net -intf_net axi_dma_46_M_AXI_S2MM [get_bd_intf_pins axi_dma_46/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S14_AXI]
  connect_bd_intf_net -intf_net axi_dma_47_M_AXIS_MM2S [get_bd_intf_pins axi_dma_47/M_AXIS_MM2S] [get_bd_intf_pins zcore32_47/src]
  connect_bd_intf_net -intf_net axi_dma_47_M_AXI_MM2S [get_bd_intf_pins axi_dma_47/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_4/S15_AXI]
  connect_bd_intf_net -intf_net axi_dma_47_M_AXI_S2MM [get_bd_intf_pins axi_dma_47/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_5/S15_AXI]
  connect_bd_intf_net -intf_net axi_dma_48_M_AXIS_MM2S [get_bd_intf_pins axi_dma_48/M_AXIS_MM2S] [get_bd_intf_pins zcore32_48/src]
  connect_bd_intf_net -intf_net axi_dma_48_M_AXI_MM2S [get_bd_intf_pins axi_dma_48/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_48_M_AXI_S2MM [get_bd_intf_pins axi_dma_48/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_49_M_AXIS_MM2S [get_bd_intf_pins axi_dma_49/M_AXIS_MM2S] [get_bd_intf_pins zcore32_49/src]
  connect_bd_intf_net -intf_net axi_dma_49_M_AXI_MM2S [get_bd_intf_pins axi_dma_49/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_49_M_AXI_S2MM [get_bd_intf_pins axi_dma_49/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXIS_MM2S [get_bd_intf_pins axi_dma_4/M_AXIS_MM2S] [get_bd_intf_pins zcore32_4/src]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXI_MM2S [get_bd_intf_pins axi_dma_4/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXI_S2MM [get_bd_intf_pins axi_dma_4/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_50_M_AXIS_MM2S [get_bd_intf_pins axi_dma_50/M_AXIS_MM2S] [get_bd_intf_pins zcore32_50/src]
  connect_bd_intf_net -intf_net axi_dma_50_M_AXI_MM2S [get_bd_intf_pins axi_dma_50/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_50_M_AXI_S2MM [get_bd_intf_pins axi_dma_50/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_51_M_AXIS_MM2S [get_bd_intf_pins axi_dma_51/M_AXIS_MM2S] [get_bd_intf_pins zcore32_51/src]
  connect_bd_intf_net -intf_net axi_dma_51_M_AXI_MM2S [get_bd_intf_pins axi_dma_51/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_51_M_AXI_S2MM [get_bd_intf_pins axi_dma_51/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_52_M_AXIS_MM2S [get_bd_intf_pins axi_dma_52/M_AXIS_MM2S] [get_bd_intf_pins zcore32_52/src]
  connect_bd_intf_net -intf_net axi_dma_52_M_AXI_MM2S [get_bd_intf_pins axi_dma_52/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_52_M_AXI_S2MM [get_bd_intf_pins axi_dma_52/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_53_M_AXIS_MM2S [get_bd_intf_pins axi_dma_53/M_AXIS_MM2S] [get_bd_intf_pins zcore32_53/src]
  connect_bd_intf_net -intf_net axi_dma_53_M_AXI_MM2S [get_bd_intf_pins axi_dma_53/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_53_M_AXI_S2MM [get_bd_intf_pins axi_dma_53/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_54_M_AXIS_MM2S [get_bd_intf_pins axi_dma_54/M_AXIS_MM2S] [get_bd_intf_pins zcore32_54/src]
  connect_bd_intf_net -intf_net axi_dma_54_M_AXI_MM2S [get_bd_intf_pins axi_dma_54/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S06_AXI]
  connect_bd_intf_net -intf_net axi_dma_54_M_AXI_S2MM [get_bd_intf_pins axi_dma_54/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S06_AXI]
  connect_bd_intf_net -intf_net axi_dma_55_M_AXIS_MM2S [get_bd_intf_pins axi_dma_55/M_AXIS_MM2S] [get_bd_intf_pins zcore32_55/src]
  connect_bd_intf_net -intf_net axi_dma_55_M_AXI_MM2S [get_bd_intf_pins axi_dma_55/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S07_AXI]
  connect_bd_intf_net -intf_net axi_dma_55_M_AXI_S2MM [get_bd_intf_pins axi_dma_55/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S07_AXI]
  connect_bd_intf_net -intf_net axi_dma_56_M_AXIS_MM2S [get_bd_intf_pins axi_dma_56/M_AXIS_MM2S] [get_bd_intf_pins zcore32_56/src]
  connect_bd_intf_net -intf_net axi_dma_56_M_AXI_MM2S [get_bd_intf_pins axi_dma_56/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S08_AXI]
  connect_bd_intf_net -intf_net axi_dma_56_M_AXI_S2MM [get_bd_intf_pins axi_dma_56/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S08_AXI]
  connect_bd_intf_net -intf_net axi_dma_57_M_AXIS_MM2S [get_bd_intf_pins axi_dma_57/M_AXIS_MM2S] [get_bd_intf_pins zcore32_57/src]
  connect_bd_intf_net -intf_net axi_dma_57_M_AXI_MM2S [get_bd_intf_pins axi_dma_57/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S09_AXI]
  connect_bd_intf_net -intf_net axi_dma_57_M_AXI_S2MM [get_bd_intf_pins axi_dma_57/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S09_AXI]
  connect_bd_intf_net -intf_net axi_dma_58_M_AXIS_MM2S [get_bd_intf_pins axi_dma_58/M_AXIS_MM2S] [get_bd_intf_pins zcore32_58/src]
  connect_bd_intf_net -intf_net axi_dma_58_M_AXI_MM2S [get_bd_intf_pins axi_dma_58/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S10_AXI]
  connect_bd_intf_net -intf_net axi_dma_58_M_AXI_S2MM [get_bd_intf_pins axi_dma_58/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S10_AXI]
  connect_bd_intf_net -intf_net axi_dma_59_M_AXIS_MM2S [get_bd_intf_pins axi_dma_59/M_AXIS_MM2S] [get_bd_intf_pins zcore32_59/src]
  connect_bd_intf_net -intf_net axi_dma_59_M_AXI_MM2S [get_bd_intf_pins axi_dma_59/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S11_AXI]
  connect_bd_intf_net -intf_net axi_dma_59_M_AXI_S2MM [get_bd_intf_pins axi_dma_59/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S11_AXI]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXIS_MM2S [get_bd_intf_pins axi_dma_5/M_AXIS_MM2S] [get_bd_intf_pins zcore32_5/src]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXI_MM2S [get_bd_intf_pins axi_dma_5/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_5_M_AXI_S2MM [get_bd_intf_pins axi_dma_5/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_60_M_AXIS_MM2S [get_bd_intf_pins axi_dma_60/M_AXIS_MM2S] [get_bd_intf_pins zcore32_60/src]
  connect_bd_intf_net -intf_net axi_dma_60_M_AXI_MM2S [get_bd_intf_pins axi_dma_60/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S12_AXI]
  connect_bd_intf_net -intf_net axi_dma_60_M_AXI_S2MM [get_bd_intf_pins axi_dma_60/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S12_AXI]
  connect_bd_intf_net -intf_net axi_dma_61_M_AXIS_MM2S [get_bd_intf_pins axi_dma_61/M_AXIS_MM2S] [get_bd_intf_pins zcore32_61/src]
  connect_bd_intf_net -intf_net axi_dma_61_M_AXI_MM2S [get_bd_intf_pins axi_dma_61/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S13_AXI]
  connect_bd_intf_net -intf_net axi_dma_61_M_AXI_S2MM [get_bd_intf_pins axi_dma_61/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S13_AXI]
  connect_bd_intf_net -intf_net axi_dma_62_M_AXIS_MM2S [get_bd_intf_pins axi_dma_62/M_AXIS_MM2S] [get_bd_intf_pins zcore32_62/src]
  connect_bd_intf_net -intf_net axi_dma_62_M_AXI_MM2S [get_bd_intf_pins axi_dma_62/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_6/S14_AXI]
  connect_bd_intf_net -intf_net axi_dma_62_M_AXI_S2MM [get_bd_intf_pins axi_dma_62/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_7/S14_AXI]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXIS_MM2S [get_bd_intf_pins axi_dma_6/M_AXIS_MM2S] [get_bd_intf_pins zcore32_6/src]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_MM2S [get_bd_intf_pins axi_dma_6/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S06_AXI]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_S2MM [get_bd_intf_pins axi_dma_6/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S06_AXI]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXIS_MM2S [get_bd_intf_pins axi_dma_7/M_AXIS_MM2S] [get_bd_intf_pins zcore32_7/src]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXI_MM2S [get_bd_intf_pins axi_dma_7/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S07_AXI]
  connect_bd_intf_net -intf_net axi_dma_7_M_AXI_S2MM [get_bd_intf_pins axi_dma_7/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S07_AXI]
  connect_bd_intf_net -intf_net axi_dma_8_M_AXIS_MM2S [get_bd_intf_pins axi_dma_8/M_AXIS_MM2S] [get_bd_intf_pins zcore32_8/src]
  connect_bd_intf_net -intf_net axi_dma_8_M_AXI_MM2S [get_bd_intf_pins axi_dma_8/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S08_AXI]
  connect_bd_intf_net -intf_net axi_dma_8_M_AXI_S2MM [get_bd_intf_pins axi_dma_8/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S08_AXI]
  connect_bd_intf_net -intf_net axi_dma_9_M_AXIS_MM2S [get_bd_intf_pins axi_dma_9/M_AXIS_MM2S] [get_bd_intf_pins zcore32_9/src]
  connect_bd_intf_net -intf_net axi_dma_9_M_AXI_MM2S [get_bd_intf_pins axi_dma_9/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S09_AXI]
  connect_bd_intf_net -intf_net axi_dma_9_M_AXI_S2MM [get_bd_intf_pins axi_dma_9/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_1/S09_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP1_FPD]
  connect_bd_intf_net -intf_net axi_interconnect_2_M00_AXI [get_bd_intf_pins axi_interconnect_2/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP3_FPD]
  connect_bd_intf_net -intf_net axi_interconnect_3_M00_AXI [get_bd_intf_pins axi_interconnect_3/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP2_FPD]
  connect_bd_intf_net -intf_net axi_interconnect_4_M00_AXI [get_bd_intf_pins axi_interconnect_4/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HPC0_FPD]
  connect_bd_intf_net -intf_net axi_interconnect_5_M00_AXI [get_bd_intf_pins axi_interconnect_5/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HPC1_FPD]
  connect_bd_intf_net -intf_net axi_interconnect_6_M00_AXI [get_bd_intf_pins axi_interconnect_6/M00_AXI] [get_bd_intf_pins axi_interconnect_8/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_7_M00_AXI [get_bd_intf_pins axi_interconnect_7/M00_AXI] [get_bd_intf_pins axi_interconnect_8/S01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_8_M00_AXI [get_bd_intf_pins axi_interconnect_8/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_LPD]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M16_AXI [get_bd_intf_pins axi_dma_16/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M16_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M17_AXI [get_bd_intf_pins axi_dma_17/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M17_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M18_AXI [get_bd_intf_pins axi_dma_18/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M18_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M19_AXI [get_bd_intf_pins axi_dma_19/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M19_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M20_AXI [get_bd_intf_pins axi_dma_20/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M20_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M21_AXI [get_bd_intf_pins axi_dma_21/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M21_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M22_AXI [get_bd_intf_pins axi_dma_22/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M22_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M23_AXI [get_bd_intf_pins axi_dma_23/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M23_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M24_AXI [get_bd_intf_pins axi_dma_24/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M24_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M25_AXI [get_bd_intf_pins axi_dma_25/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M25_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M26_AXI [get_bd_intf_pins axi_dma_26/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M26_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M27_AXI [get_bd_intf_pins axi_dma_27/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M27_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M28_AXI [get_bd_intf_pins axi_dma_28/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M28_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M29_AXI [get_bd_intf_pins axi_dma_29/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M29_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M30_AXI [get_bd_intf_pins axi_dma_30/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M30_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M31_AXI [get_bd_intf_pins axi_dma_31/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M31_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M32_AXI [get_bd_intf_pins axi_dma_32/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M32_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M33_AXI [get_bd_intf_pins axi_dma_33/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M33_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M34_AXI [get_bd_intf_pins axi_dma_34/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M34_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M35_AXI [get_bd_intf_pins axi_dma_35/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M35_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M36_AXI [get_bd_intf_pins axi_dma_36/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M36_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M37_AXI [get_bd_intf_pins axi_dma_37/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M37_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M38_AXI [get_bd_intf_pins axi_dma_38/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M38_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M39_AXI [get_bd_intf_pins axi_dma_39/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M39_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M40_AXI [get_bd_intf_pins axi_dma_40/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M40_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M41_AXI [get_bd_intf_pins axi_dma_41/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M41_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M42_AXI [get_bd_intf_pins axi_dma_42/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M42_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M43_AXI [get_bd_intf_pins axi_dma_43/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M43_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M44_AXI [get_bd_intf_pins axi_dma_44/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M44_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M45_AXI [get_bd_intf_pins axi_dma_45/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M45_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M46_AXI [get_bd_intf_pins axi_dma_46/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M46_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M47_AXI [get_bd_intf_pins axi_dma_47/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M47_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M48_AXI [get_bd_intf_pins axi_dma_48/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M48_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M49_AXI [get_bd_intf_pins axi_dma_49/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M49_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M50_AXI [get_bd_intf_pins axi_dma_50/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M50_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M51_AXI [get_bd_intf_pins axi_dma_51/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M51_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M52_AXI [get_bd_intf_pins axi_dma_52/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M52_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M53_AXI [get_bd_intf_pins axi_dma_53/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M53_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M54_AXI [get_bd_intf_pins axi_dma_54/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M54_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M55_AXI [get_bd_intf_pins axi_dma_55/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M55_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M56_AXI [get_bd_intf_pins axi_dma_56/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M56_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M57_AXI [get_bd_intf_pins axi_dma_57/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M57_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M58_AXI [get_bd_intf_pins axi_dma_58/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M58_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M59_AXI [get_bd_intf_pins axi_dma_59/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M59_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M60_AXI [get_bd_intf_pins axi_dma_60/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M60_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M61_AXI [get_bd_intf_pins axi_dma_61/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M61_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M62_AXI [get_bd_intf_pins axi_dma_62/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M62_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_0_M63_AXI [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins ps8_0_axi_periph_0/M63_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M00_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M00_AXI] [get_bd_intf_pins zcore32_0/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M01_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M01_AXI] [get_bd_intf_pins zcore32_1/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M02_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M02_AXI] [get_bd_intf_pins zcore32_2/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M03_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M03_AXI] [get_bd_intf_pins zcore32_3/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M04_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M04_AXI] [get_bd_intf_pins zcore32_4/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M05_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M05_AXI] [get_bd_intf_pins zcore32_5/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M06_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M06_AXI] [get_bd_intf_pins zcore32_6/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M07_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M07_AXI] [get_bd_intf_pins zcore32_7/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M08_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M08_AXI] [get_bd_intf_pins zcore32_8/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M09_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M09_AXI] [get_bd_intf_pins zcore32_9/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M10_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M10_AXI] [get_bd_intf_pins zcore32_10/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M11_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M11_AXI] [get_bd_intf_pins zcore32_11/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M12_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M12_AXI] [get_bd_intf_pins zcore32_12/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M13_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M13_AXI] [get_bd_intf_pins zcore32_13/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M14_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M14_AXI] [get_bd_intf_pins zcore32_14/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M15_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M15_AXI] [get_bd_intf_pins zcore32_15/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M16_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M16_AXI] [get_bd_intf_pins zcore32_16/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M17_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M17_AXI] [get_bd_intf_pins zcore32_17/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M18_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M18_AXI] [get_bd_intf_pins zcore32_18/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M19_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M19_AXI] [get_bd_intf_pins zcore32_19/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M20_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M20_AXI] [get_bd_intf_pins zcore32_20/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M21_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M21_AXI] [get_bd_intf_pins zcore32_21/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M22_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M22_AXI] [get_bd_intf_pins zcore32_22/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M23_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M23_AXI] [get_bd_intf_pins zcore32_23/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M24_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M24_AXI] [get_bd_intf_pins zcore32_24/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M25_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M25_AXI] [get_bd_intf_pins zcore32_25/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M26_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M26_AXI] [get_bd_intf_pins zcore32_26/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M27_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M27_AXI] [get_bd_intf_pins zcore32_27/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M28_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M28_AXI] [get_bd_intf_pins zcore32_28/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M29_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M29_AXI] [get_bd_intf_pins zcore32_29/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M30_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M30_AXI] [get_bd_intf_pins zcore32_30/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M31_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M31_AXI] [get_bd_intf_pins zcore32_31/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M32_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M32_AXI] [get_bd_intf_pins zcore32_32/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M33_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M33_AXI] [get_bd_intf_pins zcore32_33/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M34_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M34_AXI] [get_bd_intf_pins zcore32_34/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M35_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M35_AXI] [get_bd_intf_pins zcore32_35/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M36_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M36_AXI] [get_bd_intf_pins zcore32_36/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M37_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M37_AXI] [get_bd_intf_pins zcore32_37/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M38_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M38_AXI] [get_bd_intf_pins zcore32_38/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M39_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M39_AXI] [get_bd_intf_pins zcore32_39/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M40_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M40_AXI] [get_bd_intf_pins zcore32_40/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M41_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M41_AXI] [get_bd_intf_pins zcore32_41/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M42_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M42_AXI] [get_bd_intf_pins zcore32_42/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M43_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M43_AXI] [get_bd_intf_pins zcore32_43/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M44_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M44_AXI] [get_bd_intf_pins zcore32_44/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M45_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M45_AXI] [get_bd_intf_pins zcore32_45/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M46_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M46_AXI] [get_bd_intf_pins zcore32_46/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M47_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M47_AXI] [get_bd_intf_pins zcore32_47/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M48_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M48_AXI] [get_bd_intf_pins zcore32_48/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M49_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M49_AXI] [get_bd_intf_pins zcore32_49/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M50_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M50_AXI] [get_bd_intf_pins zcore32_50/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M51_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M51_AXI] [get_bd_intf_pins zcore32_51/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M52_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M52_AXI] [get_bd_intf_pins zcore32_52/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M53_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M53_AXI] [get_bd_intf_pins zcore32_53/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M54_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M54_AXI] [get_bd_intf_pins zcore32_54/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M55_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M55_AXI] [get_bd_intf_pins zcore32_55/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M56_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M56_AXI] [get_bd_intf_pins zcore32_56/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M57_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M57_AXI] [get_bd_intf_pins zcore32_57/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M58_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M58_AXI] [get_bd_intf_pins zcore32_58/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M59_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M59_AXI] [get_bd_intf_pins zcore32_59/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M60_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M60_AXI] [get_bd_intf_pins zcore32_60/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M61_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M61_AXI] [get_bd_intf_pins zcore32_61/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M62_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M62_AXI] [get_bd_intf_pins zcore32_62/s_axi_control]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M63_AXI [get_bd_intf_pins axi_intc_1/s_axi] [get_bd_intf_pins ps8_0_axi_periph_1/M63_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M00_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M01_AXI [get_bd_intf_pins axi_dma_1/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M01_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M02_AXI [get_bd_intf_pins axi_dma_2/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M02_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M03_AXI [get_bd_intf_pins axi_dma_3/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M03_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M04_AXI [get_bd_intf_pins axi_dma_4/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M04_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M05_AXI [get_bd_intf_pins axi_dma_5/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M05_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins axi_dma_6/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M06_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M07_AXI [get_bd_intf_pins axi_dma_7/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M07_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M08_AXI [get_bd_intf_pins axi_dma_8/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M08_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M09_AXI [get_bd_intf_pins axi_dma_9/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M09_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M10_AXI [get_bd_intf_pins axi_dma_10/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M10_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M11_AXI [get_bd_intf_pins axi_dma_11/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M11_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M12_AXI [get_bd_intf_pins axi_dma_12/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M12_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M13_AXI [get_bd_intf_pins axi_dma_13/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M13_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M14_AXI [get_bd_intf_pins axi_dma_14/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M14_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M15_AXI [get_bd_intf_pins axi_dma_15/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph_0/M15_AXI]
  connect_bd_intf_net -intf_net zcore32_0_dst [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins zcore32_0/dst]
  connect_bd_intf_net -intf_net zcore32_10_dst [get_bd_intf_pins axi_dma_10/S_AXIS_S2MM] [get_bd_intf_pins zcore32_10/dst]
  connect_bd_intf_net -intf_net zcore32_11_dst [get_bd_intf_pins axi_dma_11/S_AXIS_S2MM] [get_bd_intf_pins zcore32_11/dst]
  connect_bd_intf_net -intf_net zcore32_12_dst [get_bd_intf_pins axi_dma_12/S_AXIS_S2MM] [get_bd_intf_pins zcore32_12/dst]
  connect_bd_intf_net -intf_net zcore32_13_dst [get_bd_intf_pins axi_dma_13/S_AXIS_S2MM] [get_bd_intf_pins zcore32_13/dst]
  connect_bd_intf_net -intf_net zcore32_14_dst [get_bd_intf_pins axi_dma_14/S_AXIS_S2MM] [get_bd_intf_pins zcore32_14/dst]
  connect_bd_intf_net -intf_net zcore32_15_dst [get_bd_intf_pins axi_dma_15/S_AXIS_S2MM] [get_bd_intf_pins zcore32_15/dst]
  connect_bd_intf_net -intf_net zcore32_16_dst [get_bd_intf_pins axi_dma_16/S_AXIS_S2MM] [get_bd_intf_pins zcore32_16/dst]
  connect_bd_intf_net -intf_net zcore32_17_dst [get_bd_intf_pins axi_dma_17/S_AXIS_S2MM] [get_bd_intf_pins zcore32_17/dst]
  connect_bd_intf_net -intf_net zcore32_18_dst [get_bd_intf_pins axi_dma_18/S_AXIS_S2MM] [get_bd_intf_pins zcore32_18/dst]
  connect_bd_intf_net -intf_net zcore32_19_dst [get_bd_intf_pins axi_dma_19/S_AXIS_S2MM] [get_bd_intf_pins zcore32_19/dst]
  connect_bd_intf_net -intf_net zcore32_1_dst [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM] [get_bd_intf_pins zcore32_1/dst]
  connect_bd_intf_net -intf_net zcore32_20_dst [get_bd_intf_pins axi_dma_20/S_AXIS_S2MM] [get_bd_intf_pins zcore32_20/dst]
  connect_bd_intf_net -intf_net zcore32_21_dst [get_bd_intf_pins axi_dma_21/S_AXIS_S2MM] [get_bd_intf_pins zcore32_21/dst]
  connect_bd_intf_net -intf_net zcore32_22_dst [get_bd_intf_pins axi_dma_22/S_AXIS_S2MM] [get_bd_intf_pins zcore32_22/dst]
  connect_bd_intf_net -intf_net zcore32_23_dst [get_bd_intf_pins axi_dma_23/S_AXIS_S2MM] [get_bd_intf_pins zcore32_23/dst]
  connect_bd_intf_net -intf_net zcore32_24_dst [get_bd_intf_pins axi_dma_24/S_AXIS_S2MM] [get_bd_intf_pins zcore32_24/dst]
  connect_bd_intf_net -intf_net zcore32_25_dst [get_bd_intf_pins axi_dma_25/S_AXIS_S2MM] [get_bd_intf_pins zcore32_25/dst]
  connect_bd_intf_net -intf_net zcore32_26_dst [get_bd_intf_pins axi_dma_26/S_AXIS_S2MM] [get_bd_intf_pins zcore32_26/dst]
  connect_bd_intf_net -intf_net zcore32_27_dst [get_bd_intf_pins axi_dma_27/S_AXIS_S2MM] [get_bd_intf_pins zcore32_27/dst]
  connect_bd_intf_net -intf_net zcore32_28_dst [get_bd_intf_pins axi_dma_28/S_AXIS_S2MM] [get_bd_intf_pins zcore32_28/dst]
  connect_bd_intf_net -intf_net zcore32_29_dst [get_bd_intf_pins axi_dma_29/S_AXIS_S2MM] [get_bd_intf_pins zcore32_29/dst]
  connect_bd_intf_net -intf_net zcore32_2_dst [get_bd_intf_pins axi_dma_2/S_AXIS_S2MM] [get_bd_intf_pins zcore32_2/dst]
  connect_bd_intf_net -intf_net zcore32_30_dst [get_bd_intf_pins axi_dma_30/S_AXIS_S2MM] [get_bd_intf_pins zcore32_30/dst]
  connect_bd_intf_net -intf_net zcore32_31_dst [get_bd_intf_pins axi_dma_31/S_AXIS_S2MM] [get_bd_intf_pins zcore32_31/dst]
  connect_bd_intf_net -intf_net zcore32_32_dst [get_bd_intf_pins axi_dma_32/S_AXIS_S2MM] [get_bd_intf_pins zcore32_32/dst]
  connect_bd_intf_net -intf_net zcore32_33_dst [get_bd_intf_pins axi_dma_33/S_AXIS_S2MM] [get_bd_intf_pins zcore32_33/dst]
  connect_bd_intf_net -intf_net zcore32_34_dst [get_bd_intf_pins axi_dma_34/S_AXIS_S2MM] [get_bd_intf_pins zcore32_34/dst]
  connect_bd_intf_net -intf_net zcore32_35_dst [get_bd_intf_pins axi_dma_35/S_AXIS_S2MM] [get_bd_intf_pins zcore32_35/dst]
  connect_bd_intf_net -intf_net zcore32_36_dst [get_bd_intf_pins axi_dma_36/S_AXIS_S2MM] [get_bd_intf_pins zcore32_36/dst]
  connect_bd_intf_net -intf_net zcore32_37_dst [get_bd_intf_pins axi_dma_37/S_AXIS_S2MM] [get_bd_intf_pins zcore32_37/dst]
  connect_bd_intf_net -intf_net zcore32_38_dst [get_bd_intf_pins axi_dma_38/S_AXIS_S2MM] [get_bd_intf_pins zcore32_38/dst]
  connect_bd_intf_net -intf_net zcore32_39_dst [get_bd_intf_pins axi_dma_39/S_AXIS_S2MM] [get_bd_intf_pins zcore32_39/dst]
  connect_bd_intf_net -intf_net zcore32_3_dst [get_bd_intf_pins axi_dma_3/S_AXIS_S2MM] [get_bd_intf_pins zcore32_3/dst]
  connect_bd_intf_net -intf_net zcore32_40_dst [get_bd_intf_pins axi_dma_40/S_AXIS_S2MM] [get_bd_intf_pins zcore32_40/dst]
  connect_bd_intf_net -intf_net zcore32_41_dst [get_bd_intf_pins axi_dma_41/S_AXIS_S2MM] [get_bd_intf_pins zcore32_41/dst]
  connect_bd_intf_net -intf_net zcore32_42_dst [get_bd_intf_pins axi_dma_42/S_AXIS_S2MM] [get_bd_intf_pins zcore32_42/dst]
  connect_bd_intf_net -intf_net zcore32_43_dst [get_bd_intf_pins axi_dma_43/S_AXIS_S2MM] [get_bd_intf_pins zcore32_43/dst]
  connect_bd_intf_net -intf_net zcore32_44_dst [get_bd_intf_pins axi_dma_44/S_AXIS_S2MM] [get_bd_intf_pins zcore32_44/dst]
  connect_bd_intf_net -intf_net zcore32_45_dst [get_bd_intf_pins axi_dma_45/S_AXIS_S2MM] [get_bd_intf_pins zcore32_45/dst]
  connect_bd_intf_net -intf_net zcore32_46_dst [get_bd_intf_pins axi_dma_46/S_AXIS_S2MM] [get_bd_intf_pins zcore32_46/dst]
  connect_bd_intf_net -intf_net zcore32_47_dst [get_bd_intf_pins axi_dma_47/S_AXIS_S2MM] [get_bd_intf_pins zcore32_47/dst]
  connect_bd_intf_net -intf_net zcore32_48_dst [get_bd_intf_pins axi_dma_48/S_AXIS_S2MM] [get_bd_intf_pins zcore32_48/dst]
  connect_bd_intf_net -intf_net zcore32_49_dst [get_bd_intf_pins axi_dma_49/S_AXIS_S2MM] [get_bd_intf_pins zcore32_49/dst]
  connect_bd_intf_net -intf_net zcore32_4_dst [get_bd_intf_pins axi_dma_4/S_AXIS_S2MM] [get_bd_intf_pins zcore32_4/dst]
  connect_bd_intf_net -intf_net zcore32_50_dst [get_bd_intf_pins axi_dma_50/S_AXIS_S2MM] [get_bd_intf_pins zcore32_50/dst]
  connect_bd_intf_net -intf_net zcore32_51_dst [get_bd_intf_pins axi_dma_51/S_AXIS_S2MM] [get_bd_intf_pins zcore32_51/dst]
  connect_bd_intf_net -intf_net zcore32_52_dst [get_bd_intf_pins axi_dma_52/S_AXIS_S2MM] [get_bd_intf_pins zcore32_52/dst]
  connect_bd_intf_net -intf_net zcore32_53_dst [get_bd_intf_pins axi_dma_53/S_AXIS_S2MM] [get_bd_intf_pins zcore32_53/dst]
  connect_bd_intf_net -intf_net zcore32_54_dst [get_bd_intf_pins axi_dma_54/S_AXIS_S2MM] [get_bd_intf_pins zcore32_54/dst]
  connect_bd_intf_net -intf_net zcore32_55_dst [get_bd_intf_pins axi_dma_55/S_AXIS_S2MM] [get_bd_intf_pins zcore32_55/dst]
  connect_bd_intf_net -intf_net zcore32_56_dst [get_bd_intf_pins axi_dma_56/S_AXIS_S2MM] [get_bd_intf_pins zcore32_56/dst]
  connect_bd_intf_net -intf_net zcore32_57_dst [get_bd_intf_pins axi_dma_57/S_AXIS_S2MM] [get_bd_intf_pins zcore32_57/dst]
  connect_bd_intf_net -intf_net zcore32_58_dst [get_bd_intf_pins axi_dma_58/S_AXIS_S2MM] [get_bd_intf_pins zcore32_58/dst]
  connect_bd_intf_net -intf_net zcore32_59_dst [get_bd_intf_pins axi_dma_59/S_AXIS_S2MM] [get_bd_intf_pins zcore32_59/dst]
  connect_bd_intf_net -intf_net zcore32_5_dst [get_bd_intf_pins axi_dma_5/S_AXIS_S2MM] [get_bd_intf_pins zcore32_5/dst]
  connect_bd_intf_net -intf_net zcore32_60_dst [get_bd_intf_pins axi_dma_60/S_AXIS_S2MM] [get_bd_intf_pins zcore32_60/dst]
  connect_bd_intf_net -intf_net zcore32_61_dst [get_bd_intf_pins axi_dma_61/S_AXIS_S2MM] [get_bd_intf_pins zcore32_61/dst]
  connect_bd_intf_net -intf_net zcore32_62_dst [get_bd_intf_pins axi_dma_62/S_AXIS_S2MM] [get_bd_intf_pins zcore32_62/dst]
  connect_bd_intf_net -intf_net zcore32_6_dst [get_bd_intf_pins axi_dma_6/S_AXIS_S2MM] [get_bd_intf_pins zcore32_6/dst]
  connect_bd_intf_net -intf_net zcore32_7_dst [get_bd_intf_pins axi_dma_7/S_AXIS_S2MM] [get_bd_intf_pins zcore32_7/dst]
  connect_bd_intf_net -intf_net zcore32_8_dst [get_bd_intf_pins axi_dma_8/S_AXIS_S2MM] [get_bd_intf_pins zcore32_8/dst]
  connect_bd_intf_net -intf_net zcore32_9_dst [get_bd_intf_pins axi_dma_9/S_AXIS_S2MM] [get_bd_intf_pins zcore32_9/dst]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins ps8_0_axi_periph_0/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM1_FPD [get_bd_intf_pins ps8_0_axi_periph_1/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM1_FPD]

  # Create port connections
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_dma_10_s2mm_introut [get_bd_pins axi_dma_10/s2mm_introut] [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net axi_dma_11_s2mm_introut [get_bd_pins axi_dma_11/s2mm_introut] [get_bd_pins xlconcat_0/In11]
  connect_bd_net -net axi_dma_12_s2mm_introut [get_bd_pins axi_dma_12/s2mm_introut] [get_bd_pins xlconcat_0/In12]
  connect_bd_net -net axi_dma_13_s2mm_introut [get_bd_pins axi_dma_13/s2mm_introut] [get_bd_pins xlconcat_0/In13]
  connect_bd_net -net axi_dma_14_s2mm_introut [get_bd_pins axi_dma_14/s2mm_introut] [get_bd_pins xlconcat_0/In14]
  connect_bd_net -net axi_dma_15_s2mm_introut [get_bd_pins axi_dma_15/s2mm_introut] [get_bd_pins xlconcat_0/In15]
  connect_bd_net -net axi_dma_16_s2mm_introut [get_bd_pins axi_dma_16/s2mm_introut] [get_bd_pins xlconcat_0/In16]
  connect_bd_net -net axi_dma_17_s2mm_introut [get_bd_pins axi_dma_17/s2mm_introut] [get_bd_pins xlconcat_0/In17]
  connect_bd_net -net axi_dma_18_s2mm_introut [get_bd_pins axi_dma_18/s2mm_introut] [get_bd_pins xlconcat_0/In18]
  connect_bd_net -net axi_dma_19_s2mm_introut [get_bd_pins axi_dma_19/s2mm_introut] [get_bd_pins xlconcat_0/In19]
  connect_bd_net -net axi_dma_1_s2mm_introut [get_bd_pins axi_dma_1/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_dma_20_s2mm_introut [get_bd_pins axi_dma_20/s2mm_introut] [get_bd_pins xlconcat_0/In20]
  connect_bd_net -net axi_dma_21_s2mm_introut [get_bd_pins axi_dma_21/s2mm_introut] [get_bd_pins xlconcat_0/In21]
  connect_bd_net -net axi_dma_22_s2mm_introut [get_bd_pins axi_dma_22/s2mm_introut] [get_bd_pins xlconcat_0/In22]
  connect_bd_net -net axi_dma_23_s2mm_introut [get_bd_pins axi_dma_23/s2mm_introut] [get_bd_pins xlconcat_0/In23]
  connect_bd_net -net axi_dma_24_s2mm_introut [get_bd_pins axi_dma_24/s2mm_introut] [get_bd_pins xlconcat_0/In24]
  connect_bd_net -net axi_dma_25_s2mm_introut [get_bd_pins axi_dma_25/s2mm_introut] [get_bd_pins xlconcat_0/In25]
  connect_bd_net -net axi_dma_26_s2mm_introut [get_bd_pins axi_dma_26/s2mm_introut] [get_bd_pins xlconcat_0/In26]
  connect_bd_net -net axi_dma_27_s2mm_introut [get_bd_pins axi_dma_27/s2mm_introut] [get_bd_pins xlconcat_0/In27]
  connect_bd_net -net axi_dma_28_s2mm_introut [get_bd_pins axi_dma_28/s2mm_introut] [get_bd_pins xlconcat_0/In28]
  connect_bd_net -net axi_dma_29_s2mm_introut [get_bd_pins axi_dma_29/s2mm_introut] [get_bd_pins xlconcat_0/In29]
  connect_bd_net -net axi_dma_2_s2mm_introut [get_bd_pins axi_dma_2/s2mm_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_dma_30_s2mm_introut [get_bd_pins axi_dma_30/s2mm_introut] [get_bd_pins xlconcat_0/In30]
  connect_bd_net -net axi_dma_31_s2mm_introut [get_bd_pins axi_dma_31/s2mm_introut] [get_bd_pins xlconcat_0/In31]
  connect_bd_net -net axi_dma_32_s2mm_introut [get_bd_pins axi_dma_32/s2mm_introut] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net axi_dma_33_s2mm_introut [get_bd_pins axi_dma_33/s2mm_introut] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net axi_dma_34_s2mm_introut [get_bd_pins axi_dma_34/s2mm_introut] [get_bd_pins xlconcat_2/In2]
  connect_bd_net -net axi_dma_35_s2mm_introut [get_bd_pins axi_dma_35/s2mm_introut] [get_bd_pins xlconcat_2/In3]
  connect_bd_net -net axi_dma_36_s2mm_introut [get_bd_pins axi_dma_36/s2mm_introut] [get_bd_pins xlconcat_2/In4]
  connect_bd_net -net axi_dma_37_s2mm_introut [get_bd_pins axi_dma_37/s2mm_introut] [get_bd_pins xlconcat_2/In5]
  connect_bd_net -net axi_dma_38_s2mm_introut [get_bd_pins axi_dma_38/s2mm_introut] [get_bd_pins xlconcat_2/In6]
  connect_bd_net -net axi_dma_39_s2mm_introut [get_bd_pins axi_dma_39/s2mm_introut] [get_bd_pins xlconcat_2/In7]
  connect_bd_net -net axi_dma_3_s2mm_introut [get_bd_pins axi_dma_3/s2mm_introut] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_dma_40_s2mm_introut [get_bd_pins axi_dma_40/s2mm_introut] [get_bd_pins xlconcat_2/In8]
  connect_bd_net -net axi_dma_41_s2mm_introut [get_bd_pins axi_dma_41/s2mm_introut] [get_bd_pins xlconcat_2/In9]
  connect_bd_net -net axi_dma_42_s2mm_introut [get_bd_pins axi_dma_42/s2mm_introut] [get_bd_pins xlconcat_2/In10]
  connect_bd_net -net axi_dma_43_s2mm_introut [get_bd_pins axi_dma_43/s2mm_introut] [get_bd_pins xlconcat_2/In11]
  connect_bd_net -net axi_dma_44_s2mm_introut [get_bd_pins axi_dma_44/s2mm_introut] [get_bd_pins xlconcat_2/In12]
  connect_bd_net -net axi_dma_45_s2mm_introut [get_bd_pins axi_dma_45/s2mm_introut] [get_bd_pins xlconcat_2/In13]
  connect_bd_net -net axi_dma_46_s2mm_introut [get_bd_pins axi_dma_46/s2mm_introut] [get_bd_pins xlconcat_2/In14]
  connect_bd_net -net axi_dma_47_s2mm_introut [get_bd_pins axi_dma_47/s2mm_introut] [get_bd_pins xlconcat_2/In15]
  connect_bd_net -net axi_dma_48_s2mm_introut [get_bd_pins axi_dma_48/s2mm_introut] [get_bd_pins xlconcat_2/In16]
  connect_bd_net -net axi_dma_49_s2mm_introut [get_bd_pins axi_dma_49/s2mm_introut] [get_bd_pins xlconcat_2/In17]
  connect_bd_net -net axi_dma_4_s2mm_introut [get_bd_pins axi_dma_4/s2mm_introut] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_dma_50_s2mm_introut [get_bd_pins axi_dma_50/s2mm_introut] [get_bd_pins xlconcat_2/In18]
  connect_bd_net -net axi_dma_51_s2mm_introut [get_bd_pins axi_dma_51/s2mm_introut] [get_bd_pins xlconcat_2/In19]
  connect_bd_net -net axi_dma_52_s2mm_introut [get_bd_pins axi_dma_52/s2mm_introut] [get_bd_pins xlconcat_2/In20]
  connect_bd_net -net axi_dma_53_s2mm_introut [get_bd_pins axi_dma_53/s2mm_introut] [get_bd_pins xlconcat_2/In21]
  connect_bd_net -net axi_dma_54_s2mm_introut [get_bd_pins axi_dma_54/s2mm_introut] [get_bd_pins xlconcat_2/In22]
  connect_bd_net -net axi_dma_55_s2mm_introut [get_bd_pins axi_dma_55/s2mm_introut] [get_bd_pins xlconcat_2/In23]
  connect_bd_net -net axi_dma_56_s2mm_introut [get_bd_pins axi_dma_56/s2mm_introut] [get_bd_pins xlconcat_2/In24]
  connect_bd_net -net axi_dma_57_s2mm_introut [get_bd_pins axi_dma_57/s2mm_introut] [get_bd_pins xlconcat_2/In25]
  connect_bd_net -net axi_dma_58_s2mm_introut [get_bd_pins axi_dma_58/s2mm_introut] [get_bd_pins xlconcat_2/In26]
  connect_bd_net -net axi_dma_59_s2mm_introut [get_bd_pins axi_dma_59/s2mm_introut] [get_bd_pins xlconcat_2/In27]
  connect_bd_net -net axi_dma_5_s2mm_introut [get_bd_pins axi_dma_5/s2mm_introut] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net axi_dma_60_s2mm_introut [get_bd_pins axi_dma_60/s2mm_introut] [get_bd_pins xlconcat_2/In28]
  connect_bd_net -net axi_dma_61_s2mm_introut [get_bd_pins axi_dma_61/s2mm_introut] [get_bd_pins xlconcat_2/In29]
  connect_bd_net -net axi_dma_62_s2mm_introut [get_bd_pins axi_dma_62/s2mm_introut] [get_bd_pins xlconcat_2/In30]
  connect_bd_net -net axi_dma_6_s2mm_introut [get_bd_pins axi_dma_6/s2mm_introut] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net axi_dma_7_s2mm_introut [get_bd_pins axi_dma_7/s2mm_introut] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net axi_dma_8_s2mm_introut [get_bd_pins axi_dma_8/s2mm_introut] [get_bd_pins xlconcat_0/In8]
  connect_bd_net -net axi_dma_9_s2mm_introut [get_bd_pins axi_dma_9/s2mm_introut] [get_bd_pins xlconcat_0/In9]
  connect_bd_net -net axi_intc_0_irq [get_bd_pins axi_intc_0/irq] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net axi_intc_1_irq [get_bd_pins axi_intc_1/irq] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net rst_ps8_0_99M_1_peripheral_aresetn [get_bd_pins axi_dma_48/axi_resetn] [get_bd_pins axi_dma_49/axi_resetn] [get_bd_pins axi_dma_50/axi_resetn] [get_bd_pins axi_dma_51/axi_resetn] [get_bd_pins axi_dma_52/axi_resetn] [get_bd_pins axi_dma_53/axi_resetn] [get_bd_pins axi_dma_54/axi_resetn] [get_bd_pins axi_dma_55/axi_resetn] [get_bd_pins axi_dma_56/axi_resetn] [get_bd_pins axi_dma_57/axi_resetn] [get_bd_pins axi_dma_58/axi_resetn] [get_bd_pins axi_dma_59/axi_resetn] [get_bd_pins axi_dma_60/axi_resetn] [get_bd_pins axi_dma_61/axi_resetn] [get_bd_pins axi_dma_62/axi_resetn] [get_bd_pins ps8_0_axi_periph_0/M50_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M51_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M52_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M53_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M54_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M55_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M56_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M57_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M58_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M59_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M60_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M61_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M62_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M63_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M48_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M49_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M50_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M51_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M52_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M53_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M54_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M55_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M56_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M57_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M58_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M59_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M60_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M61_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M62_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M63_ARESETN] [get_bd_pins rst_ps8_0_99M_1/peripheral_aresetn] [get_bd_pins zcore32_48/ap_rst_n] [get_bd_pins zcore32_49/ap_rst_n] [get_bd_pins zcore32_50/ap_rst_n] [get_bd_pins zcore32_51/ap_rst_n] [get_bd_pins zcore32_52/ap_rst_n] [get_bd_pins zcore32_53/ap_rst_n] [get_bd_pins zcore32_54/ap_rst_n] [get_bd_pins zcore32_55/ap_rst_n] [get_bd_pins zcore32_56/ap_rst_n] [get_bd_pins zcore32_57/ap_rst_n] [get_bd_pins zcore32_58/ap_rst_n] [get_bd_pins zcore32_59/ap_rst_n] [get_bd_pins zcore32_60/ap_rst_n] [get_bd_pins zcore32_61/ap_rst_n] [get_bd_pins zcore32_62/ap_rst_n]
  connect_bd_net -net rst_ps8_0_99M_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_interconnect_2/ARESETN] [get_bd_pins axi_interconnect_3/ARESETN] [get_bd_pins axi_interconnect_4/ARESETN] [get_bd_pins axi_interconnect_5/ARESETN] [get_bd_pins axi_interconnect_6/ARESETN] [get_bd_pins axi_interconnect_7/ARESETN] [get_bd_pins axi_interconnect_8/ARESETN] [get_bd_pins ps8_0_axi_periph_0/ARESETN] [get_bd_pins ps8_0_axi_periph_1/ARESETN] [get_bd_pins rst_ps8_0_99M/interconnect_aresetn]
  connect_bd_net -net rst_ps8_0_99M_peripheral_aresetn [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_dma_1/axi_resetn] [get_bd_pins axi_dma_10/axi_resetn] [get_bd_pins axi_dma_11/axi_resetn] [get_bd_pins axi_dma_12/axi_resetn] [get_bd_pins axi_dma_13/axi_resetn] [get_bd_pins axi_dma_14/axi_resetn] [get_bd_pins axi_dma_15/axi_resetn] [get_bd_pins axi_dma_16/axi_resetn] [get_bd_pins axi_dma_17/axi_resetn] [get_bd_pins axi_dma_18/axi_resetn] [get_bd_pins axi_dma_19/axi_resetn] [get_bd_pins axi_dma_2/axi_resetn] [get_bd_pins axi_dma_20/axi_resetn] [get_bd_pins axi_dma_21/axi_resetn] [get_bd_pins axi_dma_22/axi_resetn] [get_bd_pins axi_dma_23/axi_resetn] [get_bd_pins axi_dma_24/axi_resetn] [get_bd_pins axi_dma_25/axi_resetn] [get_bd_pins axi_dma_26/axi_resetn] [get_bd_pins axi_dma_27/axi_resetn] [get_bd_pins axi_dma_28/axi_resetn] [get_bd_pins axi_dma_29/axi_resetn] [get_bd_pins axi_dma_3/axi_resetn] [get_bd_pins axi_dma_30/axi_resetn] [get_bd_pins axi_dma_31/axi_resetn] [get_bd_pins axi_dma_32/axi_resetn] [get_bd_pins axi_dma_33/axi_resetn] [get_bd_pins axi_dma_34/axi_resetn] [get_bd_pins axi_dma_35/axi_resetn] [get_bd_pins axi_dma_36/axi_resetn] [get_bd_pins axi_dma_37/axi_resetn] [get_bd_pins axi_dma_38/axi_resetn] [get_bd_pins axi_dma_39/axi_resetn] [get_bd_pins axi_dma_4/axi_resetn] [get_bd_pins axi_dma_40/axi_resetn] [get_bd_pins axi_dma_41/axi_resetn] [get_bd_pins axi_dma_42/axi_resetn] [get_bd_pins axi_dma_43/axi_resetn] [get_bd_pins axi_dma_44/axi_resetn] [get_bd_pins axi_dma_45/axi_resetn] [get_bd_pins axi_dma_46/axi_resetn] [get_bd_pins axi_dma_47/axi_resetn] [get_bd_pins axi_dma_5/axi_resetn] [get_bd_pins axi_dma_6/axi_resetn] [get_bd_pins axi_dma_7/axi_resetn] [get_bd_pins axi_dma_8/axi_resetn] [get_bd_pins axi_dma_9/axi_resetn] [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins axi_intc_1/s_axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_interconnect_0/S02_ARESETN] [get_bd_pins axi_interconnect_0/S03_ARESETN] [get_bd_pins axi_interconnect_0/S04_ARESETN] [get_bd_pins axi_interconnect_0/S05_ARESETN] [get_bd_pins axi_interconnect_0/S06_ARESETN] [get_bd_pins axi_interconnect_0/S07_ARESETN] [get_bd_pins axi_interconnect_0/S08_ARESETN] [get_bd_pins axi_interconnect_0/S09_ARESETN] [get_bd_pins axi_interconnect_0/S10_ARESETN] [get_bd_pins axi_interconnect_0/S11_ARESETN] [get_bd_pins axi_interconnect_0/S12_ARESETN] [get_bd_pins axi_interconnect_0/S13_ARESETN] [get_bd_pins axi_interconnect_0/S14_ARESETN] [get_bd_pins axi_interconnect_0/S15_ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_interconnect_1/S01_ARESETN] [get_bd_pins axi_interconnect_1/S02_ARESETN] [get_bd_pins axi_interconnect_1/S03_ARESETN] [get_bd_pins axi_interconnect_1/S04_ARESETN] [get_bd_pins axi_interconnect_1/S05_ARESETN] [get_bd_pins axi_interconnect_1/S06_ARESETN] [get_bd_pins axi_interconnect_1/S07_ARESETN] [get_bd_pins axi_interconnect_1/S08_ARESETN] [get_bd_pins axi_interconnect_1/S09_ARESETN] [get_bd_pins axi_interconnect_1/S10_ARESETN] [get_bd_pins axi_interconnect_1/S11_ARESETN] [get_bd_pins axi_interconnect_1/S12_ARESETN] [get_bd_pins axi_interconnect_1/S13_ARESETN] [get_bd_pins axi_interconnect_1/S14_ARESETN] [get_bd_pins axi_interconnect_1/S15_ARESETN] [get_bd_pins axi_interconnect_2/M00_ARESETN] [get_bd_pins axi_interconnect_2/S00_ARESETN] [get_bd_pins axi_interconnect_2/S01_ARESETN] [get_bd_pins axi_interconnect_2/S02_ARESETN] [get_bd_pins axi_interconnect_2/S03_ARESETN] [get_bd_pins axi_interconnect_2/S04_ARESETN] [get_bd_pins axi_interconnect_2/S05_ARESETN] [get_bd_pins axi_interconnect_2/S06_ARESETN] [get_bd_pins axi_interconnect_2/S07_ARESETN] [get_bd_pins axi_interconnect_2/S08_ARESETN] [get_bd_pins axi_interconnect_2/S09_ARESETN] [get_bd_pins axi_interconnect_2/S10_ARESETN] [get_bd_pins axi_interconnect_2/S11_ARESETN] [get_bd_pins axi_interconnect_2/S12_ARESETN] [get_bd_pins axi_interconnect_2/S13_ARESETN] [get_bd_pins axi_interconnect_2/S14_ARESETN] [get_bd_pins axi_interconnect_2/S15_ARESETN] [get_bd_pins axi_interconnect_3/M00_ARESETN] [get_bd_pins axi_interconnect_3/S00_ARESETN] [get_bd_pins axi_interconnect_3/S01_ARESETN] [get_bd_pins axi_interconnect_3/S02_ARESETN] [get_bd_pins axi_interconnect_3/S03_ARESETN] [get_bd_pins axi_interconnect_3/S04_ARESETN] [get_bd_pins axi_interconnect_3/S05_ARESETN] [get_bd_pins axi_interconnect_3/S06_ARESETN] [get_bd_pins axi_interconnect_3/S07_ARESETN] [get_bd_pins axi_interconnect_3/S08_ARESETN] [get_bd_pins axi_interconnect_3/S09_ARESETN] [get_bd_pins axi_interconnect_3/S10_ARESETN] [get_bd_pins axi_interconnect_3/S11_ARESETN] [get_bd_pins axi_interconnect_3/S12_ARESETN] [get_bd_pins axi_interconnect_3/S13_ARESETN] [get_bd_pins axi_interconnect_3/S14_ARESETN] [get_bd_pins axi_interconnect_3/S15_ARESETN] [get_bd_pins axi_interconnect_4/M00_ARESETN] [get_bd_pins axi_interconnect_4/S00_ARESETN] [get_bd_pins axi_interconnect_4/S01_ARESETN] [get_bd_pins axi_interconnect_4/S02_ARESETN] [get_bd_pins axi_interconnect_4/S03_ARESETN] [get_bd_pins axi_interconnect_4/S04_ARESETN] [get_bd_pins axi_interconnect_4/S05_ARESETN] [get_bd_pins axi_interconnect_4/S06_ARESETN] [get_bd_pins axi_interconnect_4/S07_ARESETN] [get_bd_pins axi_interconnect_4/S08_ARESETN] [get_bd_pins axi_interconnect_4/S09_ARESETN] [get_bd_pins axi_interconnect_4/S10_ARESETN] [get_bd_pins axi_interconnect_4/S11_ARESETN] [get_bd_pins axi_interconnect_4/S12_ARESETN] [get_bd_pins axi_interconnect_4/S13_ARESETN] [get_bd_pins axi_interconnect_4/S14_ARESETN] [get_bd_pins axi_interconnect_4/S15_ARESETN] [get_bd_pins axi_interconnect_5/M00_ARESETN] [get_bd_pins axi_interconnect_5/S00_ARESETN] [get_bd_pins axi_interconnect_5/S01_ARESETN] [get_bd_pins axi_interconnect_5/S02_ARESETN] [get_bd_pins axi_interconnect_5/S03_ARESETN] [get_bd_pins axi_interconnect_5/S04_ARESETN] [get_bd_pins axi_interconnect_5/S05_ARESETN] [get_bd_pins axi_interconnect_5/S06_ARESETN] [get_bd_pins axi_interconnect_5/S07_ARESETN] [get_bd_pins axi_interconnect_5/S08_ARESETN] [get_bd_pins axi_interconnect_5/S09_ARESETN] [get_bd_pins axi_interconnect_5/S10_ARESETN] [get_bd_pins axi_interconnect_5/S11_ARESETN] [get_bd_pins axi_interconnect_5/S12_ARESETN] [get_bd_pins axi_interconnect_5/S13_ARESETN] [get_bd_pins axi_interconnect_5/S14_ARESETN] [get_bd_pins axi_interconnect_5/S15_ARESETN] [get_bd_pins axi_interconnect_6/M00_ARESETN] [get_bd_pins axi_interconnect_6/S00_ARESETN] [get_bd_pins axi_interconnect_6/S01_ARESETN] [get_bd_pins axi_interconnect_6/S02_ARESETN] [get_bd_pins axi_interconnect_6/S03_ARESETN] [get_bd_pins axi_interconnect_6/S04_ARESETN] [get_bd_pins axi_interconnect_6/S05_ARESETN] [get_bd_pins axi_interconnect_6/S06_ARESETN] [get_bd_pins axi_interconnect_6/S07_ARESETN] [get_bd_pins axi_interconnect_6/S08_ARESETN] [get_bd_pins axi_interconnect_6/S09_ARESETN] [get_bd_pins axi_interconnect_6/S10_ARESETN] [get_bd_pins axi_interconnect_6/S11_ARESETN] [get_bd_pins axi_interconnect_6/S12_ARESETN] [get_bd_pins axi_interconnect_6/S13_ARESETN] [get_bd_pins axi_interconnect_6/S14_ARESETN] [get_bd_pins axi_interconnect_7/M00_ARESETN] [get_bd_pins axi_interconnect_7/S00_ARESETN] [get_bd_pins axi_interconnect_7/S01_ARESETN] [get_bd_pins axi_interconnect_7/S02_ARESETN] [get_bd_pins axi_interconnect_7/S03_ARESETN] [get_bd_pins axi_interconnect_7/S04_ARESETN] [get_bd_pins axi_interconnect_7/S05_ARESETN] [get_bd_pins axi_interconnect_7/S06_ARESETN] [get_bd_pins axi_interconnect_7/S07_ARESETN] [get_bd_pins axi_interconnect_7/S08_ARESETN] [get_bd_pins axi_interconnect_7/S09_ARESETN] [get_bd_pins axi_interconnect_7/S10_ARESETN] [get_bd_pins axi_interconnect_7/S11_ARESETN] [get_bd_pins axi_interconnect_7/S12_ARESETN] [get_bd_pins axi_interconnect_7/S13_ARESETN] [get_bd_pins axi_interconnect_7/S14_ARESETN] [get_bd_pins axi_interconnect_8/M00_ARESETN] [get_bd_pins axi_interconnect_8/S00_ARESETN] [get_bd_pins axi_interconnect_8/S01_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M00_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M01_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M02_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M03_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M04_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M05_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M06_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M07_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M08_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M09_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M10_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M11_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M12_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M13_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M14_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M15_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M16_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M17_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M18_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M19_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M20_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M21_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M22_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M23_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M24_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M25_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M26_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M27_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M28_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M29_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M30_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M31_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M32_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M33_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M34_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M35_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M36_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M37_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M38_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M39_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M40_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M41_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M42_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M43_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M44_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M45_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M46_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M47_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M48_ARESETN] [get_bd_pins ps8_0_axi_periph_0/M49_ARESETN] [get_bd_pins ps8_0_axi_periph_0/S00_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M00_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M01_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M02_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M03_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M04_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M05_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M06_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M07_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M08_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M09_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M10_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M11_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M12_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M13_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M14_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M15_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M16_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M17_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M18_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M19_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M20_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M21_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M22_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M23_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M24_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M25_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M26_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M27_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M28_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M29_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M30_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M31_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M32_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M33_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M34_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M35_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M36_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M37_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M38_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M39_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M40_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M41_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M42_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M43_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M44_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M45_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M46_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M47_ARESETN] [get_bd_pins ps8_0_axi_periph_1/S00_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn] [get_bd_pins zcore32_0/ap_rst_n] [get_bd_pins zcore32_1/ap_rst_n] [get_bd_pins zcore32_10/ap_rst_n] [get_bd_pins zcore32_11/ap_rst_n] [get_bd_pins zcore32_12/ap_rst_n] [get_bd_pins zcore32_13/ap_rst_n] [get_bd_pins zcore32_14/ap_rst_n] [get_bd_pins zcore32_15/ap_rst_n] [get_bd_pins zcore32_16/ap_rst_n] [get_bd_pins zcore32_17/ap_rst_n] [get_bd_pins zcore32_18/ap_rst_n] [get_bd_pins zcore32_19/ap_rst_n] [get_bd_pins zcore32_2/ap_rst_n] [get_bd_pins zcore32_20/ap_rst_n] [get_bd_pins zcore32_21/ap_rst_n] [get_bd_pins zcore32_22/ap_rst_n] [get_bd_pins zcore32_23/ap_rst_n] [get_bd_pins zcore32_24/ap_rst_n] [get_bd_pins zcore32_25/ap_rst_n] [get_bd_pins zcore32_26/ap_rst_n] [get_bd_pins zcore32_27/ap_rst_n] [get_bd_pins zcore32_28/ap_rst_n] [get_bd_pins zcore32_29/ap_rst_n] [get_bd_pins zcore32_3/ap_rst_n] [get_bd_pins zcore32_30/ap_rst_n] [get_bd_pins zcore32_31/ap_rst_n] [get_bd_pins zcore32_32/ap_rst_n] [get_bd_pins zcore32_33/ap_rst_n] [get_bd_pins zcore32_34/ap_rst_n] [get_bd_pins zcore32_35/ap_rst_n] [get_bd_pins zcore32_36/ap_rst_n] [get_bd_pins zcore32_37/ap_rst_n] [get_bd_pins zcore32_38/ap_rst_n] [get_bd_pins zcore32_39/ap_rst_n] [get_bd_pins zcore32_4/ap_rst_n] [get_bd_pins zcore32_40/ap_rst_n] [get_bd_pins zcore32_41/ap_rst_n] [get_bd_pins zcore32_42/ap_rst_n] [get_bd_pins zcore32_43/ap_rst_n] [get_bd_pins zcore32_44/ap_rst_n] [get_bd_pins zcore32_45/ap_rst_n] [get_bd_pins zcore32_46/ap_rst_n] [get_bd_pins zcore32_47/ap_rst_n] [get_bd_pins zcore32_5/ap_rst_n] [get_bd_pins zcore32_6/ap_rst_n] [get_bd_pins zcore32_7/ap_rst_n] [get_bd_pins zcore32_8/ap_rst_n] [get_bd_pins zcore32_9/ap_rst_n]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins axi_intc_0/intr] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins xlconcat_1/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins axi_intc_1/intr] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_dma_1/m_axi_mm2s_aclk] [get_bd_pins axi_dma_1/m_axi_s2mm_aclk] [get_bd_pins axi_dma_1/s_axi_lite_aclk] [get_bd_pins axi_dma_10/m_axi_mm2s_aclk] [get_bd_pins axi_dma_10/m_axi_s2mm_aclk] [get_bd_pins axi_dma_10/s_axi_lite_aclk] [get_bd_pins axi_dma_11/m_axi_mm2s_aclk] [get_bd_pins axi_dma_11/m_axi_s2mm_aclk] [get_bd_pins axi_dma_11/s_axi_lite_aclk] [get_bd_pins axi_dma_12/m_axi_mm2s_aclk] [get_bd_pins axi_dma_12/m_axi_s2mm_aclk] [get_bd_pins axi_dma_12/s_axi_lite_aclk] [get_bd_pins axi_dma_13/m_axi_mm2s_aclk] [get_bd_pins axi_dma_13/m_axi_s2mm_aclk] [get_bd_pins axi_dma_13/s_axi_lite_aclk] [get_bd_pins axi_dma_14/m_axi_mm2s_aclk] [get_bd_pins axi_dma_14/m_axi_s2mm_aclk] [get_bd_pins axi_dma_14/s_axi_lite_aclk] [get_bd_pins axi_dma_15/m_axi_mm2s_aclk] [get_bd_pins axi_dma_15/m_axi_s2mm_aclk] [get_bd_pins axi_dma_15/s_axi_lite_aclk] [get_bd_pins axi_dma_16/m_axi_mm2s_aclk] [get_bd_pins axi_dma_16/m_axi_s2mm_aclk] [get_bd_pins axi_dma_16/s_axi_lite_aclk] [get_bd_pins axi_dma_17/m_axi_mm2s_aclk] [get_bd_pins axi_dma_17/m_axi_s2mm_aclk] [get_bd_pins axi_dma_17/s_axi_lite_aclk] [get_bd_pins axi_dma_18/m_axi_mm2s_aclk] [get_bd_pins axi_dma_18/m_axi_s2mm_aclk] [get_bd_pins axi_dma_18/s_axi_lite_aclk] [get_bd_pins axi_dma_19/m_axi_mm2s_aclk] [get_bd_pins axi_dma_19/m_axi_s2mm_aclk] [get_bd_pins axi_dma_19/s_axi_lite_aclk] [get_bd_pins axi_dma_2/m_axi_mm2s_aclk] [get_bd_pins axi_dma_2/m_axi_s2mm_aclk] [get_bd_pins axi_dma_2/s_axi_lite_aclk] [get_bd_pins axi_dma_20/m_axi_mm2s_aclk] [get_bd_pins axi_dma_20/m_axi_s2mm_aclk] [get_bd_pins axi_dma_20/s_axi_lite_aclk] [get_bd_pins axi_dma_21/m_axi_mm2s_aclk] [get_bd_pins axi_dma_21/m_axi_s2mm_aclk] [get_bd_pins axi_dma_21/s_axi_lite_aclk] [get_bd_pins axi_dma_22/m_axi_mm2s_aclk] [get_bd_pins axi_dma_22/m_axi_s2mm_aclk] [get_bd_pins axi_dma_22/s_axi_lite_aclk] [get_bd_pins axi_dma_23/m_axi_mm2s_aclk] [get_bd_pins axi_dma_23/m_axi_s2mm_aclk] [get_bd_pins axi_dma_23/s_axi_lite_aclk] [get_bd_pins axi_dma_24/m_axi_mm2s_aclk] [get_bd_pins axi_dma_24/m_axi_s2mm_aclk] [get_bd_pins axi_dma_24/s_axi_lite_aclk] [get_bd_pins axi_dma_25/m_axi_mm2s_aclk] [get_bd_pins axi_dma_25/m_axi_s2mm_aclk] [get_bd_pins axi_dma_25/s_axi_lite_aclk] [get_bd_pins axi_dma_26/m_axi_mm2s_aclk] [get_bd_pins axi_dma_26/m_axi_s2mm_aclk] [get_bd_pins axi_dma_26/s_axi_lite_aclk] [get_bd_pins axi_dma_27/m_axi_mm2s_aclk] [get_bd_pins axi_dma_27/m_axi_s2mm_aclk] [get_bd_pins axi_dma_27/s_axi_lite_aclk] [get_bd_pins axi_dma_28/m_axi_mm2s_aclk] [get_bd_pins axi_dma_28/m_axi_s2mm_aclk] [get_bd_pins axi_dma_28/s_axi_lite_aclk] [get_bd_pins axi_dma_29/m_axi_mm2s_aclk] [get_bd_pins axi_dma_29/m_axi_s2mm_aclk] [get_bd_pins axi_dma_29/s_axi_lite_aclk] [get_bd_pins axi_dma_3/m_axi_mm2s_aclk] [get_bd_pins axi_dma_3/m_axi_s2mm_aclk] [get_bd_pins axi_dma_3/s_axi_lite_aclk] [get_bd_pins axi_dma_30/m_axi_mm2s_aclk] [get_bd_pins axi_dma_30/m_axi_s2mm_aclk] [get_bd_pins axi_dma_30/s_axi_lite_aclk] [get_bd_pins axi_dma_31/m_axi_mm2s_aclk] [get_bd_pins axi_dma_31/m_axi_s2mm_aclk] [get_bd_pins axi_dma_31/s_axi_lite_aclk] [get_bd_pins axi_dma_32/m_axi_mm2s_aclk] [get_bd_pins axi_dma_32/m_axi_s2mm_aclk] [get_bd_pins axi_dma_32/s_axi_lite_aclk] [get_bd_pins axi_dma_33/m_axi_mm2s_aclk] [get_bd_pins axi_dma_33/m_axi_s2mm_aclk] [get_bd_pins axi_dma_33/s_axi_lite_aclk] [get_bd_pins axi_dma_34/m_axi_mm2s_aclk] [get_bd_pins axi_dma_34/m_axi_s2mm_aclk] [get_bd_pins axi_dma_34/s_axi_lite_aclk] [get_bd_pins axi_dma_35/m_axi_mm2s_aclk] [get_bd_pins axi_dma_35/m_axi_s2mm_aclk] [get_bd_pins axi_dma_35/s_axi_lite_aclk] [get_bd_pins axi_dma_36/m_axi_mm2s_aclk] [get_bd_pins axi_dma_36/m_axi_s2mm_aclk] [get_bd_pins axi_dma_36/s_axi_lite_aclk] [get_bd_pins axi_dma_37/m_axi_mm2s_aclk] [get_bd_pins axi_dma_37/m_axi_s2mm_aclk] [get_bd_pins axi_dma_37/s_axi_lite_aclk] [get_bd_pins axi_dma_38/m_axi_mm2s_aclk] [get_bd_pins axi_dma_38/m_axi_s2mm_aclk] [get_bd_pins axi_dma_38/s_axi_lite_aclk] [get_bd_pins axi_dma_39/m_axi_mm2s_aclk] [get_bd_pins axi_dma_39/m_axi_s2mm_aclk] [get_bd_pins axi_dma_39/s_axi_lite_aclk] [get_bd_pins axi_dma_4/m_axi_mm2s_aclk] [get_bd_pins axi_dma_4/m_axi_s2mm_aclk] [get_bd_pins axi_dma_4/s_axi_lite_aclk] [get_bd_pins axi_dma_40/m_axi_mm2s_aclk] [get_bd_pins axi_dma_40/m_axi_s2mm_aclk] [get_bd_pins axi_dma_40/s_axi_lite_aclk] [get_bd_pins axi_dma_41/m_axi_mm2s_aclk] [get_bd_pins axi_dma_41/m_axi_s2mm_aclk] [get_bd_pins axi_dma_41/s_axi_lite_aclk] [get_bd_pins axi_dma_42/m_axi_mm2s_aclk] [get_bd_pins axi_dma_42/m_axi_s2mm_aclk] [get_bd_pins axi_dma_42/s_axi_lite_aclk] [get_bd_pins axi_dma_43/m_axi_mm2s_aclk] [get_bd_pins axi_dma_43/m_axi_s2mm_aclk] [get_bd_pins axi_dma_43/s_axi_lite_aclk] [get_bd_pins axi_dma_44/m_axi_mm2s_aclk] [get_bd_pins axi_dma_44/m_axi_s2mm_aclk] [get_bd_pins axi_dma_44/s_axi_lite_aclk] [get_bd_pins axi_dma_45/m_axi_mm2s_aclk] [get_bd_pins axi_dma_45/m_axi_s2mm_aclk] [get_bd_pins axi_dma_45/s_axi_lite_aclk] [get_bd_pins axi_dma_46/m_axi_mm2s_aclk] [get_bd_pins axi_dma_46/m_axi_s2mm_aclk] [get_bd_pins axi_dma_46/s_axi_lite_aclk] [get_bd_pins axi_dma_47/m_axi_mm2s_aclk] [get_bd_pins axi_dma_47/m_axi_s2mm_aclk] [get_bd_pins axi_dma_47/s_axi_lite_aclk] [get_bd_pins axi_dma_48/m_axi_mm2s_aclk] [get_bd_pins axi_dma_48/m_axi_s2mm_aclk] [get_bd_pins axi_dma_48/s_axi_lite_aclk] [get_bd_pins axi_dma_49/m_axi_mm2s_aclk] [get_bd_pins axi_dma_49/m_axi_s2mm_aclk] [get_bd_pins axi_dma_49/s_axi_lite_aclk] [get_bd_pins axi_dma_5/m_axi_mm2s_aclk] [get_bd_pins axi_dma_5/m_axi_s2mm_aclk] [get_bd_pins axi_dma_5/s_axi_lite_aclk] [get_bd_pins axi_dma_50/m_axi_mm2s_aclk] [get_bd_pins axi_dma_50/m_axi_s2mm_aclk] [get_bd_pins axi_dma_50/s_axi_lite_aclk] [get_bd_pins axi_dma_51/m_axi_mm2s_aclk] [get_bd_pins axi_dma_51/m_axi_s2mm_aclk] [get_bd_pins axi_dma_51/s_axi_lite_aclk] [get_bd_pins axi_dma_52/m_axi_mm2s_aclk] [get_bd_pins axi_dma_52/m_axi_s2mm_aclk] [get_bd_pins axi_dma_52/s_axi_lite_aclk] [get_bd_pins axi_dma_53/m_axi_mm2s_aclk] [get_bd_pins axi_dma_53/m_axi_s2mm_aclk] [get_bd_pins axi_dma_53/s_axi_lite_aclk] [get_bd_pins axi_dma_54/m_axi_mm2s_aclk] [get_bd_pins axi_dma_54/m_axi_s2mm_aclk] [get_bd_pins axi_dma_54/s_axi_lite_aclk] [get_bd_pins axi_dma_55/m_axi_mm2s_aclk] [get_bd_pins axi_dma_55/m_axi_s2mm_aclk] [get_bd_pins axi_dma_55/s_axi_lite_aclk] [get_bd_pins axi_dma_56/m_axi_mm2s_aclk] [get_bd_pins axi_dma_56/m_axi_s2mm_aclk] [get_bd_pins axi_dma_56/s_axi_lite_aclk] [get_bd_pins axi_dma_57/m_axi_mm2s_aclk] [get_bd_pins axi_dma_57/m_axi_s2mm_aclk] [get_bd_pins axi_dma_57/s_axi_lite_aclk] [get_bd_pins axi_dma_58/m_axi_mm2s_aclk] [get_bd_pins axi_dma_58/m_axi_s2mm_aclk] [get_bd_pins axi_dma_58/s_axi_lite_aclk] [get_bd_pins axi_dma_59/m_axi_mm2s_aclk] [get_bd_pins axi_dma_59/m_axi_s2mm_aclk] [get_bd_pins axi_dma_59/s_axi_lite_aclk] [get_bd_pins axi_dma_6/m_axi_mm2s_aclk] [get_bd_pins axi_dma_6/m_axi_s2mm_aclk] [get_bd_pins axi_dma_6/s_axi_lite_aclk] [get_bd_pins axi_dma_60/m_axi_mm2s_aclk] [get_bd_pins axi_dma_60/m_axi_s2mm_aclk] [get_bd_pins axi_dma_60/s_axi_lite_aclk] [get_bd_pins axi_dma_61/m_axi_mm2s_aclk] [get_bd_pins axi_dma_61/m_axi_s2mm_aclk] [get_bd_pins axi_dma_61/s_axi_lite_aclk] [get_bd_pins axi_dma_62/m_axi_mm2s_aclk] [get_bd_pins axi_dma_62/m_axi_s2mm_aclk] [get_bd_pins axi_dma_62/s_axi_lite_aclk] [get_bd_pins axi_dma_7/m_axi_mm2s_aclk] [get_bd_pins axi_dma_7/m_axi_s2mm_aclk] [get_bd_pins axi_dma_7/s_axi_lite_aclk] [get_bd_pins axi_dma_8/m_axi_mm2s_aclk] [get_bd_pins axi_dma_8/m_axi_s2mm_aclk] [get_bd_pins axi_dma_8/s_axi_lite_aclk] [get_bd_pins axi_dma_9/m_axi_mm2s_aclk] [get_bd_pins axi_dma_9/m_axi_s2mm_aclk] [get_bd_pins axi_dma_9/s_axi_lite_aclk] [get_bd_pins axi_intc_0/s_axi_aclk] [get_bd_pins axi_intc_1/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_interconnect_0/S02_ACLK] [get_bd_pins axi_interconnect_0/S03_ACLK] [get_bd_pins axi_interconnect_0/S04_ACLK] [get_bd_pins axi_interconnect_0/S05_ACLK] [get_bd_pins axi_interconnect_0/S06_ACLK] [get_bd_pins axi_interconnect_0/S07_ACLK] [get_bd_pins axi_interconnect_0/S08_ACLK] [get_bd_pins axi_interconnect_0/S09_ACLK] [get_bd_pins axi_interconnect_0/S10_ACLK] [get_bd_pins axi_interconnect_0/S11_ACLK] [get_bd_pins axi_interconnect_0/S12_ACLK] [get_bd_pins axi_interconnect_0/S13_ACLK] [get_bd_pins axi_interconnect_0/S14_ACLK] [get_bd_pins axi_interconnect_0/S15_ACLK] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_interconnect_1/S01_ACLK] [get_bd_pins axi_interconnect_1/S02_ACLK] [get_bd_pins axi_interconnect_1/S03_ACLK] [get_bd_pins axi_interconnect_1/S04_ACLK] [get_bd_pins axi_interconnect_1/S05_ACLK] [get_bd_pins axi_interconnect_1/S06_ACLK] [get_bd_pins axi_interconnect_1/S07_ACLK] [get_bd_pins axi_interconnect_1/S08_ACLK] [get_bd_pins axi_interconnect_1/S09_ACLK] [get_bd_pins axi_interconnect_1/S10_ACLK] [get_bd_pins axi_interconnect_1/S11_ACLK] [get_bd_pins axi_interconnect_1/S12_ACLK] [get_bd_pins axi_interconnect_1/S13_ACLK] [get_bd_pins axi_interconnect_1/S14_ACLK] [get_bd_pins axi_interconnect_1/S15_ACLK] [get_bd_pins axi_interconnect_2/ACLK] [get_bd_pins axi_interconnect_2/M00_ACLK] [get_bd_pins axi_interconnect_2/S00_ACLK] [get_bd_pins axi_interconnect_2/S01_ACLK] [get_bd_pins axi_interconnect_2/S02_ACLK] [get_bd_pins axi_interconnect_2/S03_ACLK] [get_bd_pins axi_interconnect_2/S04_ACLK] [get_bd_pins axi_interconnect_2/S05_ACLK] [get_bd_pins axi_interconnect_2/S06_ACLK] [get_bd_pins axi_interconnect_2/S07_ACLK] [get_bd_pins axi_interconnect_2/S08_ACLK] [get_bd_pins axi_interconnect_2/S09_ACLK] [get_bd_pins axi_interconnect_2/S10_ACLK] [get_bd_pins axi_interconnect_2/S11_ACLK] [get_bd_pins axi_interconnect_2/S12_ACLK] [get_bd_pins axi_interconnect_2/S13_ACLK] [get_bd_pins axi_interconnect_2/S14_ACLK] [get_bd_pins axi_interconnect_2/S15_ACLK] [get_bd_pins axi_interconnect_3/ACLK] [get_bd_pins axi_interconnect_3/M00_ACLK] [get_bd_pins axi_interconnect_3/S00_ACLK] [get_bd_pins axi_interconnect_3/S01_ACLK] [get_bd_pins axi_interconnect_3/S02_ACLK] [get_bd_pins axi_interconnect_3/S03_ACLK] [get_bd_pins axi_interconnect_3/S04_ACLK] [get_bd_pins axi_interconnect_3/S05_ACLK] [get_bd_pins axi_interconnect_3/S06_ACLK] [get_bd_pins axi_interconnect_3/S07_ACLK] [get_bd_pins axi_interconnect_3/S08_ACLK] [get_bd_pins axi_interconnect_3/S09_ACLK] [get_bd_pins axi_interconnect_3/S10_ACLK] [get_bd_pins axi_interconnect_3/S11_ACLK] [get_bd_pins axi_interconnect_3/S12_ACLK] [get_bd_pins axi_interconnect_3/S13_ACLK] [get_bd_pins axi_interconnect_3/S14_ACLK] [get_bd_pins axi_interconnect_3/S15_ACLK] [get_bd_pins axi_interconnect_4/ACLK] [get_bd_pins axi_interconnect_4/M00_ACLK] [get_bd_pins axi_interconnect_4/S00_ACLK] [get_bd_pins axi_interconnect_4/S01_ACLK] [get_bd_pins axi_interconnect_4/S02_ACLK] [get_bd_pins axi_interconnect_4/S03_ACLK] [get_bd_pins axi_interconnect_4/S04_ACLK] [get_bd_pins axi_interconnect_4/S05_ACLK] [get_bd_pins axi_interconnect_4/S06_ACLK] [get_bd_pins axi_interconnect_4/S07_ACLK] [get_bd_pins axi_interconnect_4/S08_ACLK] [get_bd_pins axi_interconnect_4/S09_ACLK] [get_bd_pins axi_interconnect_4/S10_ACLK] [get_bd_pins axi_interconnect_4/S11_ACLK] [get_bd_pins axi_interconnect_4/S12_ACLK] [get_bd_pins axi_interconnect_4/S13_ACLK] [get_bd_pins axi_interconnect_4/S14_ACLK] [get_bd_pins axi_interconnect_4/S15_ACLK] [get_bd_pins axi_interconnect_5/ACLK] [get_bd_pins axi_interconnect_5/M00_ACLK] [get_bd_pins axi_interconnect_5/S00_ACLK] [get_bd_pins axi_interconnect_5/S01_ACLK] [get_bd_pins axi_interconnect_5/S02_ACLK] [get_bd_pins axi_interconnect_5/S03_ACLK] [get_bd_pins axi_interconnect_5/S04_ACLK] [get_bd_pins axi_interconnect_5/S05_ACLK] [get_bd_pins axi_interconnect_5/S06_ACLK] [get_bd_pins axi_interconnect_5/S07_ACLK] [get_bd_pins axi_interconnect_5/S08_ACLK] [get_bd_pins axi_interconnect_5/S09_ACLK] [get_bd_pins axi_interconnect_5/S10_ACLK] [get_bd_pins axi_interconnect_5/S11_ACLK] [get_bd_pins axi_interconnect_5/S12_ACLK] [get_bd_pins axi_interconnect_5/S13_ACLK] [get_bd_pins axi_interconnect_5/S14_ACLK] [get_bd_pins axi_interconnect_5/S15_ACLK] [get_bd_pins axi_interconnect_6/ACLK] [get_bd_pins axi_interconnect_6/M00_ACLK] [get_bd_pins axi_interconnect_6/S00_ACLK] [get_bd_pins axi_interconnect_6/S01_ACLK] [get_bd_pins axi_interconnect_6/S02_ACLK] [get_bd_pins axi_interconnect_6/S03_ACLK] [get_bd_pins axi_interconnect_6/S04_ACLK] [get_bd_pins axi_interconnect_6/S05_ACLK] [get_bd_pins axi_interconnect_6/S06_ACLK] [get_bd_pins axi_interconnect_6/S07_ACLK] [get_bd_pins axi_interconnect_6/S08_ACLK] [get_bd_pins axi_interconnect_6/S09_ACLK] [get_bd_pins axi_interconnect_6/S10_ACLK] [get_bd_pins axi_interconnect_6/S11_ACLK] [get_bd_pins axi_interconnect_6/S12_ACLK] [get_bd_pins axi_interconnect_6/S13_ACLK] [get_bd_pins axi_interconnect_6/S14_ACLK] [get_bd_pins axi_interconnect_7/ACLK] [get_bd_pins axi_interconnect_7/M00_ACLK] [get_bd_pins axi_interconnect_7/S00_ACLK] [get_bd_pins axi_interconnect_7/S01_ACLK] [get_bd_pins axi_interconnect_7/S02_ACLK] [get_bd_pins axi_interconnect_7/S03_ACLK] [get_bd_pins axi_interconnect_7/S04_ACLK] [get_bd_pins axi_interconnect_7/S05_ACLK] [get_bd_pins axi_interconnect_7/S06_ACLK] [get_bd_pins axi_interconnect_7/S07_ACLK] [get_bd_pins axi_interconnect_7/S08_ACLK] [get_bd_pins axi_interconnect_7/S09_ACLK] [get_bd_pins axi_interconnect_7/S10_ACLK] [get_bd_pins axi_interconnect_7/S11_ACLK] [get_bd_pins axi_interconnect_7/S12_ACLK] [get_bd_pins axi_interconnect_7/S13_ACLK] [get_bd_pins axi_interconnect_7/S14_ACLK] [get_bd_pins axi_interconnect_8/ACLK] [get_bd_pins axi_interconnect_8/M00_ACLK] [get_bd_pins axi_interconnect_8/S00_ACLK] [get_bd_pins axi_interconnect_8/S01_ACLK] [get_bd_pins ps8_0_axi_periph_0/ACLK] [get_bd_pins ps8_0_axi_periph_0/M00_ACLK] [get_bd_pins ps8_0_axi_periph_0/M01_ACLK] [get_bd_pins ps8_0_axi_periph_0/M02_ACLK] [get_bd_pins ps8_0_axi_periph_0/M03_ACLK] [get_bd_pins ps8_0_axi_periph_0/M04_ACLK] [get_bd_pins ps8_0_axi_periph_0/M05_ACLK] [get_bd_pins ps8_0_axi_periph_0/M06_ACLK] [get_bd_pins ps8_0_axi_periph_0/M07_ACLK] [get_bd_pins ps8_0_axi_periph_0/M08_ACLK] [get_bd_pins ps8_0_axi_periph_0/M09_ACLK] [get_bd_pins ps8_0_axi_periph_0/M10_ACLK] [get_bd_pins ps8_0_axi_periph_0/M11_ACLK] [get_bd_pins ps8_0_axi_periph_0/M12_ACLK] [get_bd_pins ps8_0_axi_periph_0/M13_ACLK] [get_bd_pins ps8_0_axi_periph_0/M14_ACLK] [get_bd_pins ps8_0_axi_periph_0/M15_ACLK] [get_bd_pins ps8_0_axi_periph_0/M16_ACLK] [get_bd_pins ps8_0_axi_periph_0/M17_ACLK] [get_bd_pins ps8_0_axi_periph_0/M18_ACLK] [get_bd_pins ps8_0_axi_periph_0/M19_ACLK] [get_bd_pins ps8_0_axi_periph_0/M20_ACLK] [get_bd_pins ps8_0_axi_periph_0/M21_ACLK] [get_bd_pins ps8_0_axi_periph_0/M22_ACLK] [get_bd_pins ps8_0_axi_periph_0/M23_ACLK] [get_bd_pins ps8_0_axi_periph_0/M24_ACLK] [get_bd_pins ps8_0_axi_periph_0/M25_ACLK] [get_bd_pins ps8_0_axi_periph_0/M26_ACLK] [get_bd_pins ps8_0_axi_periph_0/M27_ACLK] [get_bd_pins ps8_0_axi_periph_0/M28_ACLK] [get_bd_pins ps8_0_axi_periph_0/M29_ACLK] [get_bd_pins ps8_0_axi_periph_0/M30_ACLK] [get_bd_pins ps8_0_axi_periph_0/M31_ACLK] [get_bd_pins ps8_0_axi_periph_0/M32_ACLK] [get_bd_pins ps8_0_axi_periph_0/M33_ACLK] [get_bd_pins ps8_0_axi_periph_0/M34_ACLK] [get_bd_pins ps8_0_axi_periph_0/M35_ACLK] [get_bd_pins ps8_0_axi_periph_0/M36_ACLK] [get_bd_pins ps8_0_axi_periph_0/M37_ACLK] [get_bd_pins ps8_0_axi_periph_0/M38_ACLK] [get_bd_pins ps8_0_axi_periph_0/M39_ACLK] [get_bd_pins ps8_0_axi_periph_0/M40_ACLK] [get_bd_pins ps8_0_axi_periph_0/M41_ACLK] [get_bd_pins ps8_0_axi_periph_0/M42_ACLK] [get_bd_pins ps8_0_axi_periph_0/M43_ACLK] [get_bd_pins ps8_0_axi_periph_0/M44_ACLK] [get_bd_pins ps8_0_axi_periph_0/M45_ACLK] [get_bd_pins ps8_0_axi_periph_0/M46_ACLK] [get_bd_pins ps8_0_axi_periph_0/M47_ACLK] [get_bd_pins ps8_0_axi_periph_0/M48_ACLK] [get_bd_pins ps8_0_axi_periph_0/M49_ACLK] [get_bd_pins ps8_0_axi_periph_0/M50_ACLK] [get_bd_pins ps8_0_axi_periph_0/M51_ACLK] [get_bd_pins ps8_0_axi_periph_0/M52_ACLK] [get_bd_pins ps8_0_axi_periph_0/M53_ACLK] [get_bd_pins ps8_0_axi_periph_0/M54_ACLK] [get_bd_pins ps8_0_axi_periph_0/M55_ACLK] [get_bd_pins ps8_0_axi_periph_0/M56_ACLK] [get_bd_pins ps8_0_axi_periph_0/M57_ACLK] [get_bd_pins ps8_0_axi_periph_0/M58_ACLK] [get_bd_pins ps8_0_axi_periph_0/M59_ACLK] [get_bd_pins ps8_0_axi_periph_0/M60_ACLK] [get_bd_pins ps8_0_axi_periph_0/M61_ACLK] [get_bd_pins ps8_0_axi_periph_0/M62_ACLK] [get_bd_pins ps8_0_axi_periph_0/M63_ACLK] [get_bd_pins ps8_0_axi_periph_0/S00_ACLK] [get_bd_pins ps8_0_axi_periph_1/ACLK] [get_bd_pins ps8_0_axi_periph_1/M00_ACLK] [get_bd_pins ps8_0_axi_periph_1/M01_ACLK] [get_bd_pins ps8_0_axi_periph_1/M02_ACLK] [get_bd_pins ps8_0_axi_periph_1/M03_ACLK] [get_bd_pins ps8_0_axi_periph_1/M04_ACLK] [get_bd_pins ps8_0_axi_periph_1/M05_ACLK] [get_bd_pins ps8_0_axi_periph_1/M06_ACLK] [get_bd_pins ps8_0_axi_periph_1/M07_ACLK] [get_bd_pins ps8_0_axi_periph_1/M08_ACLK] [get_bd_pins ps8_0_axi_periph_1/M09_ACLK] [get_bd_pins ps8_0_axi_periph_1/M10_ACLK] [get_bd_pins ps8_0_axi_periph_1/M11_ACLK] [get_bd_pins ps8_0_axi_periph_1/M12_ACLK] [get_bd_pins ps8_0_axi_periph_1/M13_ACLK] [get_bd_pins ps8_0_axi_periph_1/M14_ACLK] [get_bd_pins ps8_0_axi_periph_1/M15_ACLK] [get_bd_pins ps8_0_axi_periph_1/M16_ACLK] [get_bd_pins ps8_0_axi_periph_1/M17_ACLK] [get_bd_pins ps8_0_axi_periph_1/M18_ACLK] [get_bd_pins ps8_0_axi_periph_1/M19_ACLK] [get_bd_pins ps8_0_axi_periph_1/M20_ACLK] [get_bd_pins ps8_0_axi_periph_1/M21_ACLK] [get_bd_pins ps8_0_axi_periph_1/M22_ACLK] [get_bd_pins ps8_0_axi_periph_1/M23_ACLK] [get_bd_pins ps8_0_axi_periph_1/M24_ACLK] [get_bd_pins ps8_0_axi_periph_1/M25_ACLK] [get_bd_pins ps8_0_axi_periph_1/M26_ACLK] [get_bd_pins ps8_0_axi_periph_1/M27_ACLK] [get_bd_pins ps8_0_axi_periph_1/M28_ACLK] [get_bd_pins ps8_0_axi_periph_1/M29_ACLK] [get_bd_pins ps8_0_axi_periph_1/M30_ACLK] [get_bd_pins ps8_0_axi_periph_1/M31_ACLK] [get_bd_pins ps8_0_axi_periph_1/M32_ACLK] [get_bd_pins ps8_0_axi_periph_1/M33_ACLK] [get_bd_pins ps8_0_axi_periph_1/M34_ACLK] [get_bd_pins ps8_0_axi_periph_1/M35_ACLK] [get_bd_pins ps8_0_axi_periph_1/M36_ACLK] [get_bd_pins ps8_0_axi_periph_1/M37_ACLK] [get_bd_pins ps8_0_axi_periph_1/M38_ACLK] [get_bd_pins ps8_0_axi_periph_1/M39_ACLK] [get_bd_pins ps8_0_axi_periph_1/M40_ACLK] [get_bd_pins ps8_0_axi_periph_1/M41_ACLK] [get_bd_pins ps8_0_axi_periph_1/M42_ACLK] [get_bd_pins ps8_0_axi_periph_1/M43_ACLK] [get_bd_pins ps8_0_axi_periph_1/M44_ACLK] [get_bd_pins ps8_0_axi_periph_1/M45_ACLK] [get_bd_pins ps8_0_axi_periph_1/M46_ACLK] [get_bd_pins ps8_0_axi_periph_1/M47_ACLK] [get_bd_pins ps8_0_axi_periph_1/M48_ACLK] [get_bd_pins ps8_0_axi_periph_1/M49_ACLK] [get_bd_pins ps8_0_axi_periph_1/M50_ACLK] [get_bd_pins ps8_0_axi_periph_1/M51_ACLK] [get_bd_pins ps8_0_axi_periph_1/M52_ACLK] [get_bd_pins ps8_0_axi_periph_1/M53_ACLK] [get_bd_pins ps8_0_axi_periph_1/M54_ACLK] [get_bd_pins ps8_0_axi_periph_1/M55_ACLK] [get_bd_pins ps8_0_axi_periph_1/M56_ACLK] [get_bd_pins ps8_0_axi_periph_1/M57_ACLK] [get_bd_pins ps8_0_axi_periph_1/M58_ACLK] [get_bd_pins ps8_0_axi_periph_1/M59_ACLK] [get_bd_pins ps8_0_axi_periph_1/M60_ACLK] [get_bd_pins ps8_0_axi_periph_1/M61_ACLK] [get_bd_pins ps8_0_axi_periph_1/M62_ACLK] [get_bd_pins ps8_0_axi_periph_1/M63_ACLK] [get_bd_pins ps8_0_axi_periph_1/S00_ACLK] [get_bd_pins rst_ps8_0_99M/slowest_sync_clk] [get_bd_pins rst_ps8_0_99M_1/slowest_sync_clk] [get_bd_pins zcore32_0/ap_clk] [get_bd_pins zcore32_1/ap_clk] [get_bd_pins zcore32_10/ap_clk] [get_bd_pins zcore32_11/ap_clk] [get_bd_pins zcore32_12/ap_clk] [get_bd_pins zcore32_13/ap_clk] [get_bd_pins zcore32_14/ap_clk] [get_bd_pins zcore32_15/ap_clk] [get_bd_pins zcore32_16/ap_clk] [get_bd_pins zcore32_17/ap_clk] [get_bd_pins zcore32_18/ap_clk] [get_bd_pins zcore32_19/ap_clk] [get_bd_pins zcore32_2/ap_clk] [get_bd_pins zcore32_20/ap_clk] [get_bd_pins zcore32_21/ap_clk] [get_bd_pins zcore32_22/ap_clk] [get_bd_pins zcore32_23/ap_clk] [get_bd_pins zcore32_24/ap_clk] [get_bd_pins zcore32_25/ap_clk] [get_bd_pins zcore32_26/ap_clk] [get_bd_pins zcore32_27/ap_clk] [get_bd_pins zcore32_28/ap_clk] [get_bd_pins zcore32_29/ap_clk] [get_bd_pins zcore32_3/ap_clk] [get_bd_pins zcore32_30/ap_clk] [get_bd_pins zcore32_31/ap_clk] [get_bd_pins zcore32_32/ap_clk] [get_bd_pins zcore32_33/ap_clk] [get_bd_pins zcore32_34/ap_clk] [get_bd_pins zcore32_35/ap_clk] [get_bd_pins zcore32_36/ap_clk] [get_bd_pins zcore32_37/ap_clk] [get_bd_pins zcore32_38/ap_clk] [get_bd_pins zcore32_39/ap_clk] [get_bd_pins zcore32_4/ap_clk] [get_bd_pins zcore32_40/ap_clk] [get_bd_pins zcore32_41/ap_clk] [get_bd_pins zcore32_42/ap_clk] [get_bd_pins zcore32_43/ap_clk] [get_bd_pins zcore32_44/ap_clk] [get_bd_pins zcore32_45/ap_clk] [get_bd_pins zcore32_46/ap_clk] [get_bd_pins zcore32_47/ap_clk] [get_bd_pins zcore32_48/ap_clk] [get_bd_pins zcore32_49/ap_clk] [get_bd_pins zcore32_5/ap_clk] [get_bd_pins zcore32_50/ap_clk] [get_bd_pins zcore32_51/ap_clk] [get_bd_pins zcore32_52/ap_clk] [get_bd_pins zcore32_53/ap_clk] [get_bd_pins zcore32_54/ap_clk] [get_bd_pins zcore32_55/ap_clk] [get_bd_pins zcore32_56/ap_clk] [get_bd_pins zcore32_57/ap_clk] [get_bd_pins zcore32_58/ap_clk] [get_bd_pins zcore32_59/ap_clk] [get_bd_pins zcore32_6/ap_clk] [get_bd_pins zcore32_60/ap_clk] [get_bd_pins zcore32_61/ap_clk] [get_bd_pins zcore32_62/ap_clk] [get_bd_pins zcore32_7/ap_clk] [get_bd_pins zcore32_8/ap_clk] [get_bd_pins zcore32_9/ap_clk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm1_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk1] [get_bd_pins zynq_ultra_ps_e_0/saxi_lpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp1_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp2_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp3_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihpc0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihpc1_fpd_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins rst_ps8_0_99M/ext_reset_in] [get_bd_pins rst_ps8_0_99M_1/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_8/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_8/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_9/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_9/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_10/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_10/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_11/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_11/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_12/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_12/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_13/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_13/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_14/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_14/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_15/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_15/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_16/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_16/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_17/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_17/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_18/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_18/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_19/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_19/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_20/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_20/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_21/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_21/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_22/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_22/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_23/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_23/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_24/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_24/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_25/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_25/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_26/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_26/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_27/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_27/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_28/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_28/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_29/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_29/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_30/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_30/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_31/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_31/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_32/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_32/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_33/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_33/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_34/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_34/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_35/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_35/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_36/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_36/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_37/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_37/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_38/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_38/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_39/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_39/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_40/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_40/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_41/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_41/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_42/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_42/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_43/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_43/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_44/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_44/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_45/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_45/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_46/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_46/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_47/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_47/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_48/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_48/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_49/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_49/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_50/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_50/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_51/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_51/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_52/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_52/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_53/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_53/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_54/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_54/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_55/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_55/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_56/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_56/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_57/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_57/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_58/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_58/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_59/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_59/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_60/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_60/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_61/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_61/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_62/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma_62/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] SEG_zynq_ultra_ps_e_0_LPD_DDR_LOW
  create_bd_addr_seg -range 0x00010000 -offset 0xA0000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA00A0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_10/S_AXI_LITE/Reg] SEG_axi_dma_10_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA00B0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_11/S_AXI_LITE/Reg] SEG_axi_dma_11_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA00C0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_12/S_AXI_LITE/Reg] SEG_axi_dma_12_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA00D0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_13/S_AXI_LITE/Reg] SEG_axi_dma_13_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA00E0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_14/S_AXI_LITE/Reg] SEG_axi_dma_14_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA00F0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_15/S_AXI_LITE/Reg] SEG_axi_dma_15_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0100000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_16/S_AXI_LITE/Reg] SEG_axi_dma_16_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0110000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_17/S_AXI_LITE/Reg] SEG_axi_dma_17_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0120000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_18/S_AXI_LITE/Reg] SEG_axi_dma_18_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0130000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_19/S_AXI_LITE/Reg] SEG_axi_dma_19_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0010000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_1/S_AXI_LITE/Reg] SEG_axi_dma_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0140000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_20/S_AXI_LITE/Reg] SEG_axi_dma_20_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0150000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_21/S_AXI_LITE/Reg] SEG_axi_dma_21_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0160000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_22/S_AXI_LITE/Reg] SEG_axi_dma_22_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0170000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_23/S_AXI_LITE/Reg] SEG_axi_dma_23_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0180000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_24/S_AXI_LITE/Reg] SEG_axi_dma_24_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0190000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_25/S_AXI_LITE/Reg] SEG_axi_dma_25_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA01A0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_26/S_AXI_LITE/Reg] SEG_axi_dma_26_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA01B0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_27/S_AXI_LITE/Reg] SEG_axi_dma_27_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA01C0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_28/S_AXI_LITE/Reg] SEG_axi_dma_28_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA01D0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_29/S_AXI_LITE/Reg] SEG_axi_dma_29_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0020000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_2/S_AXI_LITE/Reg] SEG_axi_dma_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA01E0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_30/S_AXI_LITE/Reg] SEG_axi_dma_30_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA01F0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_31/S_AXI_LITE/Reg] SEG_axi_dma_31_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0200000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_32/S_AXI_LITE/Reg] SEG_axi_dma_32_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0210000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_33/S_AXI_LITE/Reg] SEG_axi_dma_33_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0220000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_34/S_AXI_LITE/Reg] SEG_axi_dma_34_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0230000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_35/S_AXI_LITE/Reg] SEG_axi_dma_35_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0240000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_36/S_AXI_LITE/Reg] SEG_axi_dma_36_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0250000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_37/S_AXI_LITE/Reg] SEG_axi_dma_37_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0260000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_38/S_AXI_LITE/Reg] SEG_axi_dma_38_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0270000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_39/S_AXI_LITE/Reg] SEG_axi_dma_39_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0030000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_3/S_AXI_LITE/Reg] SEG_axi_dma_3_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0280000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_40/S_AXI_LITE/Reg] SEG_axi_dma_40_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0290000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_41/S_AXI_LITE/Reg] SEG_axi_dma_41_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA02A0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_42/S_AXI_LITE/Reg] SEG_axi_dma_42_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA02B0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_43/S_AXI_LITE/Reg] SEG_axi_dma_43_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA02C0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_44/S_AXI_LITE/Reg] SEG_axi_dma_44_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA02D0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_45/S_AXI_LITE/Reg] SEG_axi_dma_45_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA02E0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_46/S_AXI_LITE/Reg] SEG_axi_dma_46_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA02F0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_47/S_AXI_LITE/Reg] SEG_axi_dma_47_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0320000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_48/S_AXI_LITE/Reg] SEG_axi_dma_48_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0330000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_49/S_AXI_LITE/Reg] SEG_axi_dma_49_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0040000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_4/S_AXI_LITE/Reg] SEG_axi_dma_4_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0340000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_50/S_AXI_LITE/Reg] SEG_axi_dma_50_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0350000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_51/S_AXI_LITE/Reg] SEG_axi_dma_51_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0360000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_52/S_AXI_LITE/Reg] SEG_axi_dma_52_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0370000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_53/S_AXI_LITE/Reg] SEG_axi_dma_53_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0380000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_54/S_AXI_LITE/Reg] SEG_axi_dma_54_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0390000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_55/S_AXI_LITE/Reg] SEG_axi_dma_55_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA03A0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_56/S_AXI_LITE/Reg] SEG_axi_dma_56_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA03B0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_57/S_AXI_LITE/Reg] SEG_axi_dma_57_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA03C0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_58/S_AXI_LITE/Reg] SEG_axi_dma_58_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA03D0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_59/S_AXI_LITE/Reg] SEG_axi_dma_59_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0050000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_5/S_AXI_LITE/Reg] SEG_axi_dma_5_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA03E0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_60/S_AXI_LITE/Reg] SEG_axi_dma_60_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA03F0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_61/S_AXI_LITE/Reg] SEG_axi_dma_61_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0400000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_62/S_AXI_LITE/Reg] SEG_axi_dma_62_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0060000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_6/S_AXI_LITE/Reg] SEG_axi_dma_6_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0070000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_7/S_AXI_LITE/Reg] SEG_axi_dma_7_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0080000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_8/S_AXI_LITE/Reg] SEG_axi_dma_8_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0090000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_9/S_AXI_LITE/Reg] SEG_axi_dma_9_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0300000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] SEG_axi_intc_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB03F0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_intc_1/S_AXI/Reg] SEG_axi_intc_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_0/s_axi_control/Reg] SEG_zcore32_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB00A0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_10/s_axi_control/Reg] SEG_zcore32_10_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB00B0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_11/s_axi_control/Reg] SEG_zcore32_11_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB00C0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_12/s_axi_control/Reg] SEG_zcore32_12_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB00D0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_13/s_axi_control/Reg] SEG_zcore32_13_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB00E0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_14/s_axi_control/Reg] SEG_zcore32_14_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB00F0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_15/s_axi_control/Reg] SEG_zcore32_15_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0100000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_16/s_axi_control/Reg] SEG_zcore32_16_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0110000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_17/s_axi_control/Reg] SEG_zcore32_17_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0120000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_18/s_axi_control/Reg] SEG_zcore32_18_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0130000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_19/s_axi_control/Reg] SEG_zcore32_19_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0010000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_1/s_axi_control/Reg] SEG_zcore32_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0140000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_20/s_axi_control/Reg] SEG_zcore32_20_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0150000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_21/s_axi_control/Reg] SEG_zcore32_21_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0160000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_22/s_axi_control/Reg] SEG_zcore32_22_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0170000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_23/s_axi_control/Reg] SEG_zcore32_23_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0180000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_24/s_axi_control/Reg] SEG_zcore32_24_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0190000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_25/s_axi_control/Reg] SEG_zcore32_25_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB01A0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_26/s_axi_control/Reg] SEG_zcore32_26_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB01B0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_27/s_axi_control/Reg] SEG_zcore32_27_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB01C0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_28/s_axi_control/Reg] SEG_zcore32_28_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB01D0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_29/s_axi_control/Reg] SEG_zcore32_29_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0020000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_2/s_axi_control/Reg] SEG_zcore32_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB01E0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_30/s_axi_control/Reg] SEG_zcore32_30_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB01F0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_31/s_axi_control/Reg] SEG_zcore32_31_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0200000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_32/s_axi_control/Reg] SEG_zcore32_32_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0210000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_33/s_axi_control/Reg] SEG_zcore32_33_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0220000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_34/s_axi_control/Reg] SEG_zcore32_34_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0230000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_35/s_axi_control/Reg] SEG_zcore32_35_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0240000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_36/s_axi_control/Reg] SEG_zcore32_36_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0250000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_37/s_axi_control/Reg] SEG_zcore32_37_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0260000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_38/s_axi_control/Reg] SEG_zcore32_38_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0270000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_39/s_axi_control/Reg] SEG_zcore32_39_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0030000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_3/s_axi_control/Reg] SEG_zcore32_3_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0280000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_40/s_axi_control/Reg] SEG_zcore32_40_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0290000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_41/s_axi_control/Reg] SEG_zcore32_41_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB02A0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_42/s_axi_control/Reg] SEG_zcore32_42_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB02B0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_43/s_axi_control/Reg] SEG_zcore32_43_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB02C0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_44/s_axi_control/Reg] SEG_zcore32_44_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB02D0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_45/s_axi_control/Reg] SEG_zcore32_45_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB02E0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_46/s_axi_control/Reg] SEG_zcore32_46_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB02F0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_47/s_axi_control/Reg] SEG_zcore32_47_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0300000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_48/s_axi_control/Reg] SEG_zcore32_48_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0310000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_49/s_axi_control/Reg] SEG_zcore32_49_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0040000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_4/s_axi_control/Reg] SEG_zcore32_4_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0320000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_50/s_axi_control/Reg] SEG_zcore32_50_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0330000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_51/s_axi_control/Reg] SEG_zcore32_51_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0340000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_52/s_axi_control/Reg] SEG_zcore32_52_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0350000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_53/s_axi_control/Reg] SEG_zcore32_53_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0360000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_54/s_axi_control/Reg] SEG_zcore32_54_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0370000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_55/s_axi_control/Reg] SEG_zcore32_55_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0380000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_56/s_axi_control/Reg] SEG_zcore32_56_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0390000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_57/s_axi_control/Reg] SEG_zcore32_57_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB03A0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_58/s_axi_control/Reg] SEG_zcore32_58_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB03B0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_59/s_axi_control/Reg] SEG_zcore32_59_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0050000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_5/s_axi_control/Reg] SEG_zcore32_5_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB03C0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_60/s_axi_control/Reg] SEG_zcore32_60_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB03D0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_61/s_axi_control/Reg] SEG_zcore32_61_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB03E0000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_62/s_axi_control/Reg] SEG_zcore32_62_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0060000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_6/s_axi_control/Reg] SEG_zcore32_6_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0070000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_7/s_axi_control/Reg] SEG_zcore32_7_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0080000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_8/s_axi_control/Reg] SEG_zcore32_8_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xB0090000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs zcore32_9/s_axi_control/Reg] SEG_zcore32_9_Reg

  # Exclude Address Segments
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_1/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_1/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_1/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_1/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_1/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_1/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_10/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_10/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_10/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_10/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_10/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_10/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_10/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_10/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_10/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_10/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_10/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_10/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_11/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_11/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_11/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_11/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_11/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_11/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_11/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_11/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_11/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_11/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_11/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_11/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_12/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_12/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_12/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_12/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_12/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_12/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_12/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_13/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_13/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_13/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_13/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_13/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_13/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_13/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_14/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_14/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_14/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_14/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_14/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_14/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_14/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_15/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_15/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_15/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_15/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_15/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_15/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_15/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_16/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_16/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_16/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_16/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_16/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_16/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_16/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_16/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_16/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_16/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_16/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_16/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_17/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_17/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_17/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_17/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_17/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_17/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_17/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_17/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_17/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_17/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_17/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_17/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_18/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_18/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_18/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_18/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_18/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_18/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_18/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_18/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_18/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_18/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_18/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_18/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_19/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_19/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_19/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_19/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_19/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_19/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_19/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_19/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_19/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_19/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_19/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_19/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_2/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_2/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_2/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_2/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_2/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_2/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_20/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_20/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_20/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_20/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_20/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_20/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_20/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_20/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_20/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_20/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_20/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_20/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_21/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_21/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_21/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_21/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_21/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_21/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_21/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_21/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_21/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_21/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_21/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_21/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_22/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_22/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_22/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_22/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_22/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_22/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_22/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_22/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_22/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_22/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_22/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_22/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_23/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_23/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_23/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_23/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_23/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_23/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_23/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_23/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_23/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_23/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_23/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_23/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_24/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_24/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_24/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_24/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_24/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_24/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_24/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_24/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_24/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_24/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_24/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_24/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_25/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_25/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_25/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_25/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_25/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_25/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_25/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_25/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_25/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_25/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_25/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_25/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_26/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_26/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_26/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_26/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_26/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_26/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_26/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_26/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_26/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_26/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_26/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_26/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_27/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_27/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_27/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_27/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_27/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_27/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_27/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_27/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_27/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_27/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_27/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_27/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_28/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_28/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_28/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_28/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_28/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_28/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_28/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_28/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_28/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_28/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_28/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_28/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_29/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_29/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_29/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_29/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_29/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_29/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_29/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_29/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_29/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_29/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_29/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_29/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_3/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_3/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_3/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_3/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_3/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_3/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_30/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_30/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_30/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_30/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_30/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_30/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_30/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_30/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_30/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_30/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_30/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_30/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_31/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_31/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_31/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_31/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_31/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_31/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_31/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_31/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_31/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_31/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_31/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_31/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_32/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_32/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_32/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_32/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_32/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_32/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_32/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_32/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_32/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_32/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_32/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_32/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_33/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_33/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_33/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_33/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_33/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_33/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_33/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_33/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_33/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_33/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_33/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_33/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_34/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_34/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_34/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_34/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_34/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_34/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_34/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_34/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_34/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_34/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_34/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_34/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_35/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_35/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_35/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_35/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_35/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_35/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_35/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_35/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_35/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_35/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_35/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_35/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_36/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_36/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_36/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_36/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_36/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_36/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_36/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_36/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_36/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_36/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_36/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_36/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_37/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_37/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_37/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_37/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_37/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_37/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_37/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_37/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_37/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_37/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_37/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_37/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_38/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_38/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_38/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_38/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_38/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_38/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_38/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_38/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_38/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_38/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_38/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_38/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_39/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_39/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_39/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_39/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_39/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_39/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_39/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_39/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_39/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_39/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_39/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_39/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_4/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_4/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_4/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_4/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_4/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_4/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_4/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_4/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_40/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_40/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_40/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_40/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_40/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_40/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_40/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_40/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_40/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_40/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_40/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_40/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_41/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_41/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_41/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_41/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_41/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_41/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_41/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_41/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_41/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_41/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_41/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_41/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_42/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_42/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_42/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_42/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_42/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_42/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_42/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_42/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_42/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_42/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_42/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_42/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_43/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_43/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_43/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_43/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_43/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_43/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_43/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_43/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_43/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_43/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_43/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_43/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_44/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_44/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_44/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_44/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_44/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_44/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_44/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_44/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_44/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_44/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_44/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_44/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_45/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_45/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_45/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_45/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_45/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_45/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_45/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_45/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_45/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_45/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_45/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_45/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_46/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_46/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_46/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_46/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_46/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_46/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_46/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_46/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_46/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_46/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_46/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_46/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_47/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_47/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_47/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_47/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_47/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_47/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_47/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_47/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_47/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_47/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_47/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] SEG_zynq_ultra_ps_e_0_HPC1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_47/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_48/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_48/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_48/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_48/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_48/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_48/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_48/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_48/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_48/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_48/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_48/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_48/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_49/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_49/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_49/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_49/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_49/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_49/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_49/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_49/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_49/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_49/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_49/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_49/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_5/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_5/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_5/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_5/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_5/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_5/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_5/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_5/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_50/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_50/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_50/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_50/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_50/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_50/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_50/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_50/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_50/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_50/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_50/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_50/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_51/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_51/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_51/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_51/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_51/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_51/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_51/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_51/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_51/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_51/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_51/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_51/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_52/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_52/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_52/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_52/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_52/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_52/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_52/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_52/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_52/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_52/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_52/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_52/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_53/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_53/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_53/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_53/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_53/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_53/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_53/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_53/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_53/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_53/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_53/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_53/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_54/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_54/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_54/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_54/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_54/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_54/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_54/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_54/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_54/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_54/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_54/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_54/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_55/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_55/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_55/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_55/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_55/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_55/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_55/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_55/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_55/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_55/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_55/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_55/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_56/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_56/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_56/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_56/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_56/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_56/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_56/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_56/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_56/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_56/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_56/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_56/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_57/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_57/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_57/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_57/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_57/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_57/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_57/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_57/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_57/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_57/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_57/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_57/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_58/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_58/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_58/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_58/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_58/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_58/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_58/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_58/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_58/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_58/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_58/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_58/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_59/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_59/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_59/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_59/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_59/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_59/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_59/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_59/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_59/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_59/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_59/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_59/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_6/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_6/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_6/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_6/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_6/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_6/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_6/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_6/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_60/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_60/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_60/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_60/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_60/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_60/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_60/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_60/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_60/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_60/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_60/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_60/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_61/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_61/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_61/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_61/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_61/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_61/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_61/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_61/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_61/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_61/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_61/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_61/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_62/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_62/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_62/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_62/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_62/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_62/Data_MM2S/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_62/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM] SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_62/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_62/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_PCIE_LOW] SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_62/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_62/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_QSPI] SEG_zynq_ultra_ps_e_0_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_62/Data_S2MM/SEG_zynq_ultra_ps_e_0_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_7/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_7/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_7/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_7/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_7/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_7/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_7/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_7/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_8/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_8/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_8/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_8/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_8/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_8/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_8/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_8/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_8/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_8/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_8/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_8/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_9/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_9/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_9/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_9/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_9/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_9/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_9/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_9/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_dma_9/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_9/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_PCIE_LOW]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_9/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs axi_dma_9/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_QSPI]



  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


