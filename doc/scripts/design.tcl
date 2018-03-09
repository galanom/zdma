#!/usr/bin/env vivado -mode batch -source
# Xilinx-provided scripts
set tclDir "./tcl"
source $tclDir/design_utils.tcl
source $tclDir/log_utils.tcl
source $tclDir/synth_utils.tcl
source $tclDir/impl_utils.tcl
source $tclDir/hd_floorplan_utils.tcl

### FPGA part number
set zedboard "xc7z020clg484-1"
set zcu102 "xczu9eg-ffvb1156-2-i"
set part $zedboard
check_part $part

### Setup Variables
# set tclParams [list <param1> <value> <param2> <value> ... <paramN> <value>]
set tclParams [list hd.visual 1]

### Workflow control
set run.rmSynth        0
set run.prImpl         1
set run.prVerify       0
set run.writeBitstream 0
set run.flatImpl       0

### Report and DCP controls - values: 0-required min; 1-few extra; 2-all
set verbose      1
set dcpLevel     1

### Output Directories
set synthDir	"./synth"
set implDir	"./impl"
set dcpDir	"./dcp"
set bitDir	"./bit"
set srcDir	""

###############################################################
### Top Definition
###############################################################

set proj_dir	"../base/"
set proj_name	"base"
set top		"zed_asym_cc_alt"

set top_dcp	"${dcpDir}/base/${top}.dcp"
set top_xdc	[list	"${proj_dir}/${proj_name}.srcs/$top/new/pblocks.xdc" \
		"${proj_dir}/${proj_name}.srcs/$top/new/io.xdc" ]


set static "${top}_static"
add_module $static
set_attribute module $static moduleName      $top
set_attribute module $static top_level       1
set_attribute module $static synthCheckpoint $top_dcp

####################################################################
### RP Module Definitions
####################################################################

set core_basename "zcore16"
set core_easiest "loopback"
set core_hardest "contrast"
set cores_with_alt_settings [list "gauss" "sobel"]
set core_list [list "gauss" "loopback" "contrast" "sobel" "sharpen" "emboss" "outline" "negative" "threshold"]
set pblock_list [list 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]

# Heterogenuous case: Define which modules require big partitions...
set core_big_list [list "gauss" "sobel" "sharpen" "emboss" "outline"]
# ...and which partitions cannot fit them
set pblock_small_list [list 4 5 10 11 14 15]
# Homogenuous case: $core_big_list is equal to $core_list and pblock_small_list is empty
### set core_big_list $core_list
### set pblock_small_list [list]

####################################################################
### Configuration generation
####################################################################

foreach core $core_list {
	# The hardest to route module shall be used to define the partition pins 
	# between static and reconfigurable regions. It will be the "initial configuration".
	set partition_list [list [list $static $top [expr {$core == $core_hardest ? "implement" : "import"}] ] ]

	foreach pblock $pblock_list {
		# The generic reconfigurable module, 
		# in the form of ${module}_${pblock}
		set instance "${core_basename}_${pblock}"

		# The logic implemented in that reconfigurable module
		set variant "${instance}_${core}"
		
		# HDL modules created by Vivado have the form of 
		# ${design_name}_${module}_n_m, usually n=[0,1,2...] and m=0,
		# but if module was copied-pasted in IP-Integrator,
		# naming is not well predictable and therefore we do not attempt
		# to guess it. The prj file has discovered it by parsing 
		# the top module, therefore it will be correct.
		set module_name [exec /bin/grep "${instance}_" ./prj/${variant}.prj | sed s@.*/@@ | sed s/.v$//]
		
		# Assume two sizes of pblocks. If the logic is ``big'' and the 
		# pblock is ``small'', then use a simple placeholder logic. 
		# The generated bitstream will be discarded.
		if {((${core} in ${core_big_list}) && (${pblock} in ${pblock_small_list}))} {
			lappend partition_list [list "${instance}_${core_easiest}" "${top}_i/${instance}" "implement"]
		} else {
			lappend partition_list [list ${variant} "${top}_i/${instance}" "implement"]
		}

		# Create Xilinx TCL variables for this module variant
		add_module $variant
		set_attribute module $variant moduleName ${module_name}
		set_attribute module $variant prj	"./prj/${variant}.prj"
		set_attribute module $variant xdc	"${proj_dir}/${proj_name}.srcs/sources_1/bd/${top}/ip/${module_name}/constraints/${core_basename}_ooc.xdc"
		set_attribute module $variant synth	${run.rmSynth}
	}
	
	# Define configuration. There will be one configuration for each 
	# module design, that will be implemented in all reconfigurable 
	# partitions. If the design is too big for the module, 
	# placeholder was assigned in previous step
	set config "config_${core}"
	add_implementation $config
	set_attribute impl $config top		$top

	# Implementation parameters. 
	# Xilinx scripts were created for Vivado 2014.2 and therefore some 
	# newer options are recognized or some older may no longer be valid.
	# Modify tcl/implementation.tcl if that problem arises.
	
	set_attribute impl $config opt_directive   "Explore"
	if {$core in $cores_with_alt_settings} {
		set_attribute impl $config place_directive "ExtraTimingOpt"
		set_attribute impl $config phys_directive  "Explore"
	} else {
		set_attribute impl $config place_directive "ExtraPostPlacementOpt"
		set_attribute impl $config phys_directive  "AlternateFlowWithRetiming"
	}
	set_attribute impl $config route_directive "Explore"

	# Xilinx PR script parameters. The user-configurable ones (ie run.*) are defined above
	set_attribute impl $config pr.impl	1
	set_attribute impl $config implXDC	${top_xdc}
	set_attribute impl $config impl		${run.prImpl}
	set_attribute impl $config partitions	${partition_list}
	set_attribute impl $config verify	${run.prVerify}
	set_attribute impl $config bitstream	${run.writeBitstream}
	set_attribute impl $config cfgmem.pcap	1
}

# Configuration is done, call Xilinx PR scrips
source $tclDir/run.tcl
exit

