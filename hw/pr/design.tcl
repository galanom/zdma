set tclDir "./tcl"

####Source required Tcl Procs
source $tclDir/design_utils.tcl
source $tclDir/log_utils.tcl
source $tclDir/synth_utils.tcl
source $tclDir/impl_utils.tcl
source $tclDir/hd_floorplan_utils.tcl

###############################################################
### Define Part, Package, Speedgrade 
###############################################################
set device       "xc7z020"
set package      "clg484"
set speed        "-1"
set part         $device$package$speed
check_part $part

###############################################################
###  Setup Variables
###############################################################
#set tclParams [list <param1> <value> <param2> <value> ... <paramN> <value>]
set tclParams [list hd.visual 1 \
              ]

####flow control
set run.rmSynth        1
set run.prImpl         1
set run.prVerify       1
set run.writeBitstream 1
set run.flatImpl       0

####Report and DCP controls - values: 0-required min; 1-few extra; 2-all
set verbose      1
set dcpLevel     1

####Output Directories
set synthDir  "./synth"
set implDir   "./impl"
set dcpDir    "./dcp"
set bitDir    "./bitstream"

set srcDir	""

###############################################################
### Top Definition
###############################################################

set top "zed_asym_cc"
set top_xdc	[list "../base/base.srcs/$top/new/pblocks.xdc" "../base/base.srcs/$top/new/io.xdc" ]

set static "${top}_static"
add_module $static
set_attribute module $static moduleName      $top
set_attribute module $static top_level       1
set_attribute module $static synthCheckpoint "$dcpDir/${top}.dcp"

####################################################################
### RP Module Definitions
####################################################################

foreach core [list "contrast" "loopback" "gauss" "sobel" "sharpen" "emboss" "outline" "negative" "threshold"] {
	set part_list [list [list $static $top [expr {$core == "contrast" ? "implement" : "import"}] ] ]
	
	foreach i [list 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15] {
		set instance "zcore16_${i}"
		set variant "${instance}_${core}"
		if {(($core in [list "gauss" "sobel" "sharpen" "emboss" "outline"]) && ($i in [list 2 3 6 7 10 11]))} {
			lappend part_list [list "${instance}_loopback" "${top}_i/$instance" "implement"]
		} else {
			lappend part_list [list $variant "${top}_i/$instance" "implement"]
		}

		add_module $variant
		set_attribute module $variant moduleName "${top}_${instance}_0"
		set_attribute module $variant prj	"./prj/${instance}/${core}.prj"
		set_attribute module $variant xdc	"../base/base.srcs/sources_1/bd/${top}/ip/${top}_${instance}_0/constraints/zcore16_ooc.xdc"
		set_attribute module $variant synth	${run.rmSynth}
		#set_attribute module $variant synth_options "-fanout_limit 400 -fsm_extraction one_hot -keep_equivalent_registers -resource_sharing off -shreg_min_size 5"
		#set_attribute module $variant synth_options "-directive AreaOptimized_high -control_set_opt_threshold 1"
	}
	
	puts $part_list
	set config "config_${core}"
	add_implementation $config
	set_attribute impl $config top		$top
	#set_attribute impl $config opt_directive "Default"
	set_attribute impl $config place_directive "ExtraPostPlacementOpt"
	set_attribute impl $config phys_directive "Explore"
	set_attribute impl $config route_directive "Explore"
	set_attribute impl $config pr.impl	1
	set_attribute impl $config implXDC	$top_xdc	
	set_attribute impl $config impl		${run.prImpl}
	set_attribute impl $config partitions	$part_list
	set_attribute impl $config verify	${run.prVerify}
	set_attribute impl $config bitstream	${run.writeBitstream}
	set_attribute impl $config cfgmem.pcap	1
}

source $tclDir/run.tcl
exit

