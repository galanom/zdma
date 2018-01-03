#if {[get_pblocks -quiet] ne ""} {
#	puts "pblocks are already defined, please disable constraints file"
#	exit 1
#}

set top [string trim [get_cells *_i] "*_i"]
#source ../base/base.srcs/$top/new/pblocks.xdc

set modules [list [get_cells -hierarchical  zcore16_?] [get_cells -hierarchical  zcore16_??]]

foreach module $modules { update_design -cell $module -black_box }

write_checkpoint dcp/$top

