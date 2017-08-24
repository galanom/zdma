
################################################################
# This is a generated script based on design: quad_dma
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
set scripts_vivado_version 2017.1
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
# source quad_dma_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./hardware/axiomboard.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project axiomboard hardware -part xczu9eg-ffvc900-1-e-es2
}


# CHANGE DESIGN NAME HERE
set design_name quad_dma

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
  set IIC_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0 ]

  # Create ports
  set TRACE_CLK [ create_bd_port -dir O -type clk TRACE_CLK ]
  set TRACE_CTL [ create_bd_port -dir O TRACE_CTL ]
  set TRACE_DATA [ create_bd_port -dir O -from 15 -to 0 TRACE_DATA ]
  set WDT_TRIG [ create_bd_port -dir O WDT_TRIG ]

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {64} \
CONFIG.c_m_axis_mm2s_tdata_width {64} \
CONFIG.c_mm2s_burst_size {8} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_0

  # Create instance: axi_dma_1, and set properties
  set axi_dma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_1 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {64} \
CONFIG.c_m_axis_mm2s_tdata_width {64} \
CONFIG.c_mm2s_burst_size {8} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_1

  # Create instance: axi_dma_2, and set properties
  set axi_dma_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_2 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {64} \
CONFIG.c_m_axis_mm2s_tdata_width {64} \
CONFIG.c_mm2s_burst_size {8} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_2

  # Create instance: axi_dma_3, and set properties
  set axi_dma_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_3 ]
  set_property -dict [ list \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {64} \
CONFIG.c_m_axis_mm2s_tdata_width {64} \
CONFIG.c_mm2s_burst_size {8} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_3

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [ list \
CONFIG.NUM_MI {4} \
CONFIG.NUM_SI {8} \
 ] $axi_smc

  # Create instance: ps8_0_axi_periph, and set properties
  set ps8_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps8_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {4} \
 ] $ps8_0_axi_periph

  # Create instance: rst_ps8_0_100M, and set properties
  set rst_ps8_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_100M ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {8} \
 ] $xlconcat_0

  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.0 zynq_ultra_ps_e_0 ]
  set_property -dict [ list \
CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x80000000} \
CONFIG.PSU_MIO_0_DIRECTION {out} \
CONFIG.PSU_MIO_10_DIRECTION {inout} \
CONFIG.PSU_MIO_11_DIRECTION {inout} \
CONFIG.PSU_MIO_12_DIRECTION {out} \
CONFIG.PSU_MIO_13_DIRECTION {inout} \
CONFIG.PSU_MIO_13_SLEW {fast} \
CONFIG.PSU_MIO_14_DIRECTION {inout} \
CONFIG.PSU_MIO_14_SLEW {fast} \
CONFIG.PSU_MIO_15_DIRECTION {inout} \
CONFIG.PSU_MIO_15_SLEW {fast} \
CONFIG.PSU_MIO_16_DIRECTION {inout} \
CONFIG.PSU_MIO_16_SLEW {fast} \
CONFIG.PSU_MIO_17_DIRECTION {inout} \
CONFIG.PSU_MIO_17_SLEW {fast} \
CONFIG.PSU_MIO_18_DIRECTION {inout} \
CONFIG.PSU_MIO_18_SLEW {fast} \
CONFIG.PSU_MIO_19_DIRECTION {inout} \
CONFIG.PSU_MIO_19_SLEW {fast} \
CONFIG.PSU_MIO_1_DIRECTION {inout} \
CONFIG.PSU_MIO_20_DIRECTION {inout} \
CONFIG.PSU_MIO_20_SLEW {fast} \
CONFIG.PSU_MIO_21_DIRECTION {inout} \
CONFIG.PSU_MIO_21_SLEW {fast} \
CONFIG.PSU_MIO_22_DIRECTION {out} \
CONFIG.PSU_MIO_22_SLEW {fast} \
CONFIG.PSU_MIO_23_DIRECTION {out} \
CONFIG.PSU_MIO_23_SLEW {fast} \
CONFIG.PSU_MIO_24_DIRECTION {inout} \
CONFIG.PSU_MIO_25_DIRECTION {inout} \
CONFIG.PSU_MIO_26_DIRECTION {out} \
CONFIG.PSU_MIO_27_DIRECTION {out} \
CONFIG.PSU_MIO_28_DIRECTION {out} \
CONFIG.PSU_MIO_29_DIRECTION {out} \
CONFIG.PSU_MIO_2_DIRECTION {inout} \
CONFIG.PSU_MIO_30_DIRECTION {out} \
CONFIG.PSU_MIO_31_DIRECTION {out} \
CONFIG.PSU_MIO_32_DIRECTION {in} \
CONFIG.PSU_MIO_33_DIRECTION {in} \
CONFIG.PSU_MIO_34_DIRECTION {in} \
CONFIG.PSU_MIO_35_DIRECTION {in} \
CONFIG.PSU_MIO_36_DIRECTION {in} \
CONFIG.PSU_MIO_37_DIRECTION {in} \
CONFIG.PSU_MIO_38_DIRECTION {inout} \
CONFIG.PSU_MIO_39_DIRECTION {inout} \
CONFIG.PSU_MIO_3_DIRECTION {inout} \
CONFIG.PSU_MIO_40_DIRECTION {out} \
CONFIG.PSU_MIO_41_DIRECTION {in} \
CONFIG.PSU_MIO_42_DIRECTION {in} \
CONFIG.PSU_MIO_43_DIRECTION {out} \
CONFIG.PSU_MIO_44_DIRECTION {inout} \
CONFIG.PSU_MIO_45_DIRECTION {in} \
CONFIG.PSU_MIO_46_DIRECTION {inout} \
CONFIG.PSU_MIO_46_SLEW {fast} \
CONFIG.PSU_MIO_47_DIRECTION {inout} \
CONFIG.PSU_MIO_47_SLEW {fast} \
CONFIG.PSU_MIO_48_DIRECTION {inout} \
CONFIG.PSU_MIO_48_SLEW {fast} \
CONFIG.PSU_MIO_49_DIRECTION {inout} \
CONFIG.PSU_MIO_49_SLEW {fast} \
CONFIG.PSU_MIO_4_DIRECTION {inout} \
CONFIG.PSU_MIO_50_DIRECTION {inout} \
CONFIG.PSU_MIO_50_SLEW {fast} \
CONFIG.PSU_MIO_51_DIRECTION {out} \
CONFIG.PSU_MIO_51_SLEW {fast} \
CONFIG.PSU_MIO_52_DIRECTION {in} \
CONFIG.PSU_MIO_53_DIRECTION {in} \
CONFIG.PSU_MIO_54_DIRECTION {inout} \
CONFIG.PSU_MIO_55_DIRECTION {in} \
CONFIG.PSU_MIO_56_DIRECTION {inout} \
CONFIG.PSU_MIO_57_DIRECTION {inout} \
CONFIG.PSU_MIO_58_DIRECTION {out} \
CONFIG.PSU_MIO_59_DIRECTION {inout} \
CONFIG.PSU_MIO_5_DIRECTION {out} \
CONFIG.PSU_MIO_60_DIRECTION {inout} \
CONFIG.PSU_MIO_61_DIRECTION {inout} \
CONFIG.PSU_MIO_62_DIRECTION {inout} \
CONFIG.PSU_MIO_63_DIRECTION {inout} \
CONFIG.PSU_MIO_64_DIRECTION {in} \
CONFIG.PSU_MIO_65_DIRECTION {in} \
CONFIG.PSU_MIO_66_DIRECTION {inout} \
CONFIG.PSU_MIO_67_DIRECTION {in} \
CONFIG.PSU_MIO_68_DIRECTION {inout} \
CONFIG.PSU_MIO_69_DIRECTION {inout} \
CONFIG.PSU_MIO_6_DIRECTION {inout} \
CONFIG.PSU_MIO_70_DIRECTION {out} \
CONFIG.PSU_MIO_71_DIRECTION {inout} \
CONFIG.PSU_MIO_72_DIRECTION {inout} \
CONFIG.PSU_MIO_73_DIRECTION {inout} \
CONFIG.PSU_MIO_74_DIRECTION {inout} \
CONFIG.PSU_MIO_75_DIRECTION {inout} \
CONFIG.PSU_MIO_76_DIRECTION {out} \
CONFIG.PSU_MIO_77_DIRECTION {inout} \
CONFIG.PSU_MIO_7_DIRECTION {out} \
CONFIG.PSU_MIO_8_DIRECTION {inout} \
CONFIG.PSU_MIO_9_DIRECTION {inout} \
CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO0 MIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#I2C 1#I2C 1#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#GPIO1 MIO#GPIO1 MIO#UART 1#UART 1#UART 0#UART 0#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#MDIO 0#MDIO 0} \
CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#so_mo1#mo2#mo3#si_mi0#n_ss_out#gpio0[6]#n_ss_out_upper#mo_upper[0]#mo_upper[1]#mo_upper[2]#mo_upper[3]#sclk_out_upper#sdio0_data_out[0]#sdio0_data_out[1]#sdio0_data_out[2]#sdio0_data_out[3]#sdio0_data_out[4]#sdio0_data_out[5]#sdio0_data_out[6]#sdio0_data_out[7]#sdio0_cmd_out#sdio0_clk_out#sdio0_bus_pow#scl_out#sda_out#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gpio1[38]#gpio1[39]#txd#rxd#rxd#txd#gpio1[44]#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#gem0_mdc#gem0_mdio_out} \
CONFIG.PSU__ACT_DDR_FREQ_MHZ {1066.656006} \
CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1199.988} \
CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {72} \
CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.997} \
CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__ACT_FREQMHZ {250.000000} \
CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {2} \
CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.997} \
CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {533.328} \
CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {2} \
CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067} \
CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {599.994} \
CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {64} \
CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {24.358730} \
CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {64} \
CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {23.529177} \
CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {6} \
CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {10} \
CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {133.332001} \
CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {RPLL} \
CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {599.994} \
CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {499.995} \
CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {1} \
CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.999} \
CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {533.328} \
CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {64} \
CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {2} \
CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {499.995} \
CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {51.724} \
CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {499.995} \
CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.997} \
CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.985} \
CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__ACT_FREQMHZ {124.999} \
CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__ACT_FREQMHZ {124.999} \
CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__ACT_FREQMHZ {124.999} \
CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {124.999} \
CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {99.999} \
CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {99.999} \
CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {249.997} \
CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {6} \
CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.999} \
CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {499.995} \
CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {166.665} \
CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {9} \
CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {RPLL} \
CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {99.999} \
CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {15} \
CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {15.957} \
CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {100} \
CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {RPLL} \
CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {299.997} \
CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {90} \
CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {3} \
CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__ACT_FREQMHZ {50.000} \
CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {30} \
CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__FREQMHZ {50} \
CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__SRCSEL {RPLL} \
CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {50.000} \
CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {30} \
CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {50} \
CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {RPLL} \
CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {99.999} \
CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {15} \
CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.999} \
CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {99.999} \
CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {249.997} \
CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__ACT_FREQMHZ {249.997} \
CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {20.000} \
CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {25} \
CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {3} \
CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
CONFIG.PSU__DDRC__CL {15} \
CONFIG.PSU__DDRC__CWL {14} \
CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
CONFIG.PSU__DDRC__DEEP_PWR_DOWN_EN {0} \
CONFIG.PSU__DDRC__DEVICE_CAPACITY {4096 MBits} \
CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
CONFIG.PSU__DDRC__SB_TARGET {15-15-15} \
CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
CONFIG.PSU__DDRC__T_FAW {30.0} \
CONFIG.PSU__DDRC__T_RAS_MIN {33} \
CONFIG.PSU__DDRC__T_RC {47.06} \
CONFIG.PSU__DDRC__T_RCD {15} \
CONFIG.PSU__DDRC__T_RP {15} \
CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.500} \
CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {0} \
CONFIG.PSU__DISPLAYPORT__LANE0__IO {<Select>} \
CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {0} \
CONFIG.PSU__DISPLAYPORT__LANE1__IO {<Select>} \
CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {0} \
CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {0} \
CONFIG.PSU__DPAUX__PERIPHERAL__IO {<Select>} \
CONFIG.PSU__DP__LANE_SEL {<Select>} \
CONFIG.PSU__DP__REF_CLK_FREQ {<Select>} \
CONFIG.PSU__DP__REF_CLK_SEL {<Select>} \
CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {1} \
CONFIG.PSU__ENET0__GRP_MDIO__IO {MIO 76 .. 77} \
CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__ENET0__PERIPHERAL__IO {MIO 26 .. 37} \
CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {0} \
CONFIG.PSU__ENET2__PERIPHERAL__ENABLE {0} \
CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {0} \
CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {0} \
CONFIG.PSU__EN_EMIO_TRACE {1} \
CONFIG.PSU__FPGA_PL1_ENABLE {0} \
CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__GPIO2_MIO__PERIPHERAL__ENABLE {0} \
CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {0} \
CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {<Select>} \
CONFIG.PSU__GPIO_EMIO__WIDTH {[94:0]} \
CONFIG.PSU__GT__LINK_SPEED {<Select>} \
CONFIG.PSU__GT__PRE_EMPH_LVL_4 {} \
CONFIG.PSU__GT__VLT_SWNG_LVL_4 {} \
CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__I2C0__PERIPHERAL__IO {EMIO} \
CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 24 .. 25} \
CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {99.999001} \
CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {99.999001} \
CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
CONFIG.PSU__PCIE__ACS_VIOLAION {0} \
CONFIG.PSU__PJTAG__PERIPHERAL__ENABLE {0} \
CONFIG.PSU__PROTECTION__DEBUG {0} \
CONFIG.PSU__PROTECTION__FPD_SEGMENTS {NONE} \
CONFIG.PSU__PROTECTION__LPD_SEGMENTS {NONE} \
CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;1|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;1|S_AXI_HP2_FPD:NA;1|S_AXI_HP1_FPD:NA;1|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;1|SATA1:NonSecure;0|SATA0:NonSecure;0|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;0|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;1|FDMA:NonSecure;1|DP:NonSecure;0|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
CONFIG.PSU__PROTECTION__MASTERS_TZ {GEM0:NonSecure|SD1:NonSecure|GEM2:NonSecure|GEM1:NonSecure|GEM3:NonSecure|PCIe:NonSecure|DP:NonSecure|NAND:NonSecure|GPU:NonSecure|USB1:NonSecure|USB0:NonSecure|LDMA:NonSecure|FDMA:NonSecure|QSPI:NonSecure|SD0:NonSecure} \
CONFIG.PSU__PROTECTION__PRESUBSYSTEMS {NONE} \
CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;1|LPD;USB3_1;FF9E0000;FF9EFFFF;1|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;0|LPD;TTC2;FF130000;FF13FFFF;0|LPD;TTC1;FF120000;FF12FFFF;0|LPD;TTC0;FF110000;FF11FFFF;0|FPD;SWDT1;FD4D0000;FD4DFFFF;0|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;1|FPD;SATA;FD0C0000;FD0CFFFF;0|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|FPD;RCPU_GIC;F9000000;F900FFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;0|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;1|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_GPV;FD700000;FD7FFFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;0|FPD;DPDMA;FD4C0000;FD4CFFFF;0|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;0|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|FPD;CCI_GPV;FD6E0000;FD6EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9000000;F907FFFF;1} \
CONFIG.PSU__PROTECTION__SUBSYSTEMS {NONE} \
CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 12} \
CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel} \
CONFIG.PSU__SD0__DATA_TRANSFER_MODE {8Bit} \
CONFIG.PSU__SD0__GRP_POW__ENABLE {1} \
CONFIG.PSU__SD0__GRP_POW__IO {MIO 23} \
CONFIG.PSU__SD0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__SD0__PERIPHERAL__IO {MIO 13 .. 22} \
CONFIG.PSU__SD0__RESET__ENABLE {1} \
CONFIG.PSU__SD0__SLOT_TYPE {eMMC} \
CONFIG.PSU__SD1__DATA_TRANSFER_MODE {4Bit} \
CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 46 .. 51} \
CONFIG.PSU__SD1__SLOT_TYPE {SD 2.0} \
CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__SWDT0__RESET__ENABLE {1} \
CONFIG.PSU__SWDT0__RESET__IO {EMIO} \
CONFIG.PSU__TRACE__INTERNAL_WIDTH {16} \
CONFIG.PSU__TRACE__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__TRACE__PERIPHERAL__IO {EMIO} \
CONFIG.PSU__TRACE__WIDTH {16Bit} \
CONFIG.PSU__UART0__BAUD_RATE {115200} \
CONFIG.PSU__UART0__MODEM__ENABLE {0} \
CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 42 .. 43} \
CONFIG.PSU__UART1__BAUD_RATE {115200} \
CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 40 .. 41} \
CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
CONFIG.PSU__USB1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__USB1__PERIPHERAL__IO {MIO 64 .. 75} \
CONFIG.PSU__USB1__REF_CLK_FREQ {26} \
CONFIG.PSU__USB1__REF_CLK_SEL {Ref Clk2} \
CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
CONFIG.PSU__USB2_1__EMIO__ENABLE {0} \
CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
CONFIG.PSU__USB3_1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__USB3_1__PERIPHERAL__IO {GT Lane3} \
CONFIG.PSU__USE__IRQ0 {1} \
CONFIG.PSU__USE__M_AXI_GP0 {1} \
CONFIG.PSU__USE__M_AXI_GP2 {0} \
CONFIG.PSU__USE__S_AXI_GP0 {0} \
CONFIG.PSU__USE__S_AXI_GP2 {1} \
CONFIG.PSU__USE__S_AXI_GP3 {1} \
CONFIG.PSU__USE__S_AXI_GP4 {1} \
CONFIG.PSU__USE__S_AXI_GP5 {1} \
 ] $zynq_ultra_ps_e_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXIS_MM2S [get_bd_intf_pins axi_dma_1/M_AXIS_MM2S] [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_MM2S [get_bd_intf_pins axi_dma_1/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_S2MM [get_bd_intf_pins axi_dma_1/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXIS_MM2S [get_bd_intf_pins axi_dma_2/M_AXIS_MM2S] [get_bd_intf_pins axi_dma_2/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_MM2S [get_bd_intf_pins axi_dma_2/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_S2MM [get_bd_intf_pins axi_dma_2/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXIS_MM2S [get_bd_intf_pins axi_dma_3/M_AXIS_MM2S] [get_bd_intf_pins axi_dma_3/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXI_MM2S [get_bd_intf_pins axi_dma_3/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S06_AXI]
  connect_bd_intf_net -intf_net axi_dma_3_M_AXI_S2MM [get_bd_intf_pins axi_dma_3/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S07_AXI]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net axi_smc_M01_AXI [get_bd_intf_pins axi_smc/M01_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP1_FPD]
  connect_bd_intf_net -intf_net axi_smc_M02_AXI [get_bd_intf_pins axi_smc/M02_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP2_FPD]
  connect_bd_intf_net -intf_net axi_smc_M03_AXI [get_bd_intf_pins axi_smc/M03_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP3_FPD]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M01_AXI [get_bd_intf_pins axi_dma_1/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M02_AXI [get_bd_intf_pins axi_dma_2/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M03_AXI [get_bd_intf_pins axi_dma_3/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_IIC_0 [get_bd_intf_ports IIC_0] [get_bd_intf_pins zynq_ultra_ps_e_0/IIC_0]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins ps8_0_axi_periph/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]

  # Create port connections
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins axi_dma_0/mm2s_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_dma_1_mm2s_introut [get_bd_pins axi_dma_1/mm2s_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_dma_1_s2mm_introut [get_bd_pins axi_dma_1/s2mm_introut] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_dma_2_mm2s_introut [get_bd_pins axi_dma_2/mm2s_introut] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_dma_2_s2mm_introut [get_bd_pins axi_dma_2/s2mm_introut] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net axi_dma_3_mm2s_introut [get_bd_pins axi_dma_3/mm2s_introut] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net axi_dma_3_s2mm_introut [get_bd_pins axi_dma_3/s2mm_introut] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net rst_ps8_0_100M_interconnect_aresetn [get_bd_pins ps8_0_axi_periph/ARESETN] [get_bd_pins rst_ps8_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_ps8_0_100M_peripheral_aresetn [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_dma_1/axi_resetn] [get_bd_pins axi_dma_2/axi_resetn] [get_bd_pins axi_dma_3/axi_resetn] [get_bd_pins axi_smc/aresetn] [get_bd_pins ps8_0_axi_periph/M00_ARESETN] [get_bd_pins ps8_0_axi_periph/M01_ARESETN] [get_bd_pins ps8_0_axi_periph/M02_ARESETN] [get_bd_pins ps8_0_axi_periph/M03_ARESETN] [get_bd_pins ps8_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps8_0_100M/peripheral_aresetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
  connect_bd_net -net zynq_ultra_ps_e_0_emio_wdt0_rst_o [get_bd_ports WDT_TRIG] [get_bd_pins zynq_ultra_ps_e_0/emio_wdt0_rst_o]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_dma_1/m_axi_mm2s_aclk] [get_bd_pins axi_dma_1/m_axi_s2mm_aclk] [get_bd_pins axi_dma_1/s_axi_lite_aclk] [get_bd_pins axi_dma_2/m_axi_mm2s_aclk] [get_bd_pins axi_dma_2/m_axi_s2mm_aclk] [get_bd_pins axi_dma_2/s_axi_lite_aclk] [get_bd_pins axi_dma_3/m_axi_mm2s_aclk] [get_bd_pins axi_dma_3/m_axi_s2mm_aclk] [get_bd_pins axi_dma_3/s_axi_lite_aclk] [get_bd_pins axi_smc/aclk] [get_bd_pins ps8_0_axi_periph/ACLK] [get_bd_pins ps8_0_axi_periph/M00_ACLK] [get_bd_pins ps8_0_axi_periph/M01_ACLK] [get_bd_pins ps8_0_axi_periph/M02_ACLK] [get_bd_pins ps8_0_axi_periph/M03_ACLK] [get_bd_pins ps8_0_axi_periph/S00_ACLK] [get_bd_pins rst_ps8_0_100M/slowest_sync_clk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_trace_clk] [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp1_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp2_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp3_fpd_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins rst_ps8_0_100M/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
  connect_bd_net -net zynq_ultra_ps_e_0_ps_pl_tracectl [get_bd_ports TRACE_CTL] [get_bd_pins zynq_ultra_ps_e_0/ps_pl_tracectl]
  connect_bd_net -net zynq_ultra_ps_e_0_ps_pl_tracedata [get_bd_ports TRACE_DATA] [get_bd_pins zynq_ultra_ps_e_0/ps_pl_tracedata]
  connect_bd_net -net zynq_ultra_ps_e_0_trace_clk_out [get_bd_ports TRACE_CLK] [get_bd_pins zynq_ultra_ps_e_0/trace_clk_out]

  # Create address segments
  create_bd_addr_seg -range 0x04000000 -offset 0x70000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x70000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x74000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x74000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFF400000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFF400000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xC8000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xC8000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x78000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x78000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFF800000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFF800000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xD0000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xD0000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x7C000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x7C000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFFC00000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFFC00000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xD8000000 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xD8000000 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x70000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x70000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x74000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x74000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFF400000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFF400000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xC8000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xC8000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x78000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x78000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFF800000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFF800000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xD0000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xD0000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x7C000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x7C000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFFC00000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFFC00000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xD8000000 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xD8000000 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x70000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x70000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x74000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x74000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFF400000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFF400000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xC8000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xC8000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x78000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x78000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFF800000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFF800000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xD0000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xD0000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x7C000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x7C000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFFC00000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFFC00000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xD8000000 [get_bd_addr_spaces axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xD8000000 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x70000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x70000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFF000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xC0000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x74000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x74000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFF400000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFF400000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xC8000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xC8000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x78000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x78000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFF800000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFF800000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xD0000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xD0000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x04000000 -offset 0x7C000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x04000000 -offset 0x7C000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x00400000 -offset 0xFFC00000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  create_bd_addr_seg -range 0x00400000 -offset 0xFFC00000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  create_bd_addr_seg -range 0x08000000 -offset 0xD8000000 [get_bd_addr_spaces axi_dma_3/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x08000000 -offset 0xD8000000 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x00010000 -offset 0xA0000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0010000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_1/S_AXI_LITE/Reg] SEG_axi_dma_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0020000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_2/S_AXI_LITE/Reg] SEG_axi_dma_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0030000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_3/S_AXI_LITE/Reg] SEG_axi_dma_3_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


