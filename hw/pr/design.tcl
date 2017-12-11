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

set top "pb8_axis32"
set top_xdc	[list	"../base/base.srcs/$top/new/io.xdc" \
			"../base/base.srcs/$top/new/pblocks.xdc" ]

set static "${top}_static"
add_module $static
set_attribute module $static moduleName      $top
set_attribute module $static top_level       1
set_attribute module $static synthCheckpoint "$dcpDir/$top.dcp"

####################################################################
### RP Module Definitions
####################################################################

foreach core [list "gauss" "sobel" "sharpen" "emboss" "outline" "loopback" "negative" "contrast" "threshold"] {
	set part_list [list [list $static $top [expr {$core == "gauss" ? "implement" : "import"}] ] ]
	
	foreach i [list 0 1 2 3 4 5 6 7] {
		set instance "zdma_core_${i}"
		set variant "${instance}_${core}"
		lappend part_list [list $variant "${top}_i/$instance" "implement"]
		add_module $variant
		set_attribute module $variant moduleName "${top}_${instance}_0"
		set_attribute module $variant prj	"./prj/${instance}/${core}.prj"
		set_attribute module $variant xdc	"../base/base.srcs/sources_1/bd/${top}/ip/${top}_${instance}_0/constraints/zdma_core_ooc.xdc"
		set_attribute module $variant synth	${run.rmSynth}
	}
	
	puts $part_list
	set config "config_${core}"
	add_implementation $config
	set_attribute impl $config top		$top
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

