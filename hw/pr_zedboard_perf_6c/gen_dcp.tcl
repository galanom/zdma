set top [string trim [get_cells *_i] "*_i"]

set modules [get_cells -hierarchical  zcore64_?]

foreach module $modules { update_design -cell $module -black_box }

write_checkpoint -force dcp/base/$top

