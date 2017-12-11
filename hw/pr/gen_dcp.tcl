if {[get_pblocks] ne ""} {
	puts "pblocks are already defined, please disable constraints file"
	exit 1
}

set top [string trim [get_cells *_i] "*_i"]
source ../base/base.srcs/$top/new/pblocks.xdc

set modules [get_cells -hierarchical zdma_core_?]

foreach module $modules {
	update_design -cell $module -black_box
}

write_checkpoint dcp/$top
