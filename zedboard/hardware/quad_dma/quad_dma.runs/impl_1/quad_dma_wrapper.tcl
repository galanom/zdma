proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}


start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  create_project -in_memory -part xc7z020clg484-1
  set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir /home/igalanommatis/work/zdma/zedboard/hardware/quad_dma/quad_dma.cache/wt [current_project]
  set_property parent.project_path /home/igalanommatis/work/zdma/zedboard/hardware/quad_dma/quad_dma.xpr [current_project]
  set_property ip_output_repo /home/igalanommatis/work/zdma/zedboard/hardware/quad_dma/quad_dma.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  add_files -quiet /home/igalanommatis/work/zdma/zedboard/hardware/quad_dma/quad_dma.runs/synth_1/quad_dma_wrapper.dcp
  set_msg_config -source 4 -id {BD 41-1661} -suppress
  set_param project.isImplRun true
  add_files /home/igalanommatis/work/zdma/zedboard/hardware/quad_dma/quad_dma.srcs/sources_1/bd/quad_dma/quad_dma.bd
  set_property is_locked true [get_files /home/igalanommatis/work/zdma/zedboard/hardware/quad_dma/quad_dma.srcs/sources_1/bd/quad_dma/quad_dma.bd]
  set_param project.isImplRun false
  set_param project.isImplRun true
  link_design -top quad_dma_wrapper -part xc7z020clg484-1
  set_param project.isImplRun false
  write_hwdef -force -file quad_dma_wrapper.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force quad_dma_wrapper_opt.dcp
  catch { report_drc -file quad_dma_wrapper_drc_opted.rpt }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force quad_dma_wrapper_placed.dcp
  catch { report_io -file quad_dma_wrapper_io_placed.rpt }
  catch { report_utilization -file quad_dma_wrapper_utilization_placed.rpt -pb quad_dma_wrapper_utilization_placed.pb }
  catch { report_control_sets -verbose -file quad_dma_wrapper_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force quad_dma_wrapper_routed.dcp
  catch { report_drc -file quad_dma_wrapper_drc_routed.rpt -pb quad_dma_wrapper_drc_routed.pb -rpx quad_dma_wrapper_drc_routed.rpx }
  catch { report_methodology -file quad_dma_wrapper_methodology_drc_routed.rpt -rpx quad_dma_wrapper_methodology_drc_routed.rpx }
  catch { report_power -file quad_dma_wrapper_power_routed.rpt -pb quad_dma_wrapper_power_summary_routed.pb -rpx quad_dma_wrapper_power_routed.rpx }
  catch { report_route_status -file quad_dma_wrapper_route_status.rpt -pb quad_dma_wrapper_route_status.pb }
  catch { report_clock_utilization -file quad_dma_wrapper_clock_utilization_routed.rpt }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file quad_dma_wrapper_timing_summary_routed.rpt -rpx quad_dma_wrapper_timing_summary_routed.rpx }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force quad_dma_wrapper_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  catch { write_mem_info -force quad_dma_wrapper.mmi }
  write_bitstream -force quad_dma_wrapper.bit 
  catch { write_sysdef -hwdef quad_dma_wrapper.hwdef -bitfile quad_dma_wrapper.bit -meminfo quad_dma_wrapper.mmi -file quad_dma_wrapper.sysdef }
  catch {write_debug_probes -no_partial_ltxfile -quiet -force debug_nets}
  catch {file copy -force debug_nets.ltx quad_dma_wrapper.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

