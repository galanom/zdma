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
set synthDir  "./Synth"
set implDir   "./Implement"
set dcpDir    "./Checkpoint"
set bitDir    "./Bitstreams"

####Input Directories
set srcDir     "./srcs"
set xdcDir     "./constrs"
set rtlDir     "$srcDir/hdl"
set ipDir      "$srcDir/ip"
set prjDir     "$srcDir/prj"

###############################################################
### Top Definition
###############################################################

set top "quad_dma"
set top_xdc	[list	"../base/base.srcs/constrs_1/new/io.xdc" \
			"../base/base.srcs/constrs_1/new/pblocks.xdc" ]

set static "static"
add_module $static
set_attribute module $static moduleName      $top
set_attribute module $static top_level       1
set_attribute module $static synthCheckpoint "../base/quad_dma_static.dcp"
#../base/base.runs/synth_1/quad_dma.dcp
####################################################################
### RP Module Definitions
####################################################################

foreach module_instance [list "zdma_core_0" "zdma_core_1" "zdma_core_2" "zdma_core_3"] {
	set module_name "quad_dma_${module_instance}_0"
	set module_xdc "../base/base.srcs/sources_1/bd/quad_dma/ip/quad_dma_${module_instance}_0/constraints/zdma_core_ooc.xdc"

	foreach core [list "loopback" "gauss" "sobel" "emboss" "outline" "sharpen"] {
		set variant "${module_instance}_${core}"
		add_module $variant
		set_attribute module $variant moduleName $module_name
		set_attribute module $variant prj	"./prj/${module_instance}/$core.prj"
		set_attribute module $variant xdc	$module_xdc
		set_attribute module $variant synth	${run.rmSynth}

		set config "Config_${variant}"
		add_implementation $config
		set_attribute impl $config top		$top
		set_attribute impl $config pr.impl	1
		set_attribute impl $config implXDC	$top_xdc	
		set_attribute impl $config impl		${run.prImpl}
		set_attribute impl $config partitions	[list \
				[list $static	$top	\
					[expr {$core == "loopback" ? "implement" : "import"}] ] \
				[list $variant	$module_instance "implement" ] \
			]
		set_attribute impl $config verify	${run.prVerify}
		set_attribute impl $config bitstream	${run.writeBitstream}
		set_attribute impl $config cfgmem.pcap	1
	}
}

#add_implementation Flat
#set_attribute impl Flat top          $top
#set_attribute impl Flat implXDC      $top_xdc
#set_attribute impl Flat partitions	[list	[list $static	$top		implement] \
#						[list "zdma_core_0_zdma_core"	"zdma_core_0"	implement] \
#						[list "zdma_core_1_zdma_core"	"zdma_core_1"	implement] \
#						[list "zdma_core_2_zdma_core"	"zdma_core_2"	implement] \
#						[list "zdma_core_3_zdma_core"	"zdma_core_3"	implement] \
#					]
#set_attribute impl Flat impl         ${run.flatImpl}

source $tclDir/run.tcl
exit

