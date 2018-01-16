
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/debugger_v2_6.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "blink_rate" -parent ${Page_0} -widget comboBox
  set intr_width [ipgui::add_param $IPINST -name "intr_width" -parent ${Page_0}]
  set_property tooltip {The number of interrupts driven to the LEDs} ${intr_width}


}

proc update_PARAM_VALUE.sel_width { PARAM_VALUE.sel_width PARAM_VALUE.intr_width } {
	# Procedure called to update sel_width when any of the dependent parameters in the arguments change
	
	set sel_width ${PARAM_VALUE.sel_width}
	set intr_width ${PARAM_VALUE.intr_width}
	set values(intr_width) [get_property value $intr_width]
	set_property value [gen_USERPARAMETER_sel_width_VALUE $values(intr_width)] $sel_width
}

proc validate_PARAM_VALUE.sel_width { PARAM_VALUE.sel_width } {
	# Procedure called to validate sel_width
	return true
}

proc update_PARAM_VALUE.blink_off { PARAM_VALUE.blink_off } {
	# Procedure called to update blink_off when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.blink_off { PARAM_VALUE.blink_off } {
	# Procedure called to validate blink_off
	return true
}

proc update_PARAM_VALUE.blink_on { PARAM_VALUE.blink_on } {
	# Procedure called to update blink_on when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.blink_on { PARAM_VALUE.blink_on } {
	# Procedure called to validate blink_on
	return true
}

proc update_PARAM_VALUE.blink_rate { PARAM_VALUE.blink_rate } {
	# Procedure called to update blink_rate when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.blink_rate { PARAM_VALUE.blink_rate } {
	# Procedure called to validate blink_rate
	return true
}

proc update_PARAM_VALUE.intr_width { PARAM_VALUE.intr_width } {
	# Procedure called to update intr_width when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.intr_width { PARAM_VALUE.intr_width } {
	# Procedure called to validate intr_width
	return true
}


proc update_MODELPARAM_VALUE.blink_rate { MODELPARAM_VALUE.blink_rate PARAM_VALUE.blink_rate } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.blink_rate}] ${MODELPARAM_VALUE.blink_rate}
}

proc update_MODELPARAM_VALUE.blink_off { MODELPARAM_VALUE.blink_off PARAM_VALUE.blink_off } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.blink_off}] ${MODELPARAM_VALUE.blink_off}
}

proc update_MODELPARAM_VALUE.blink_on { MODELPARAM_VALUE.blink_on PARAM_VALUE.blink_on } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.blink_on}] ${MODELPARAM_VALUE.blink_on}
}

proc update_MODELPARAM_VALUE.intr_width { MODELPARAM_VALUE.intr_width PARAM_VALUE.intr_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.intr_width}] ${MODELPARAM_VALUE.intr_width}
}

proc update_MODELPARAM_VALUE.sel_width { MODELPARAM_VALUE.sel_width PARAM_VALUE.sel_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.sel_width}] ${MODELPARAM_VALUE.sel_width}
}

