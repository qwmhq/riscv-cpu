# Copyright (C) 2021  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details, at
# https://fpgasoftware.intel.com/eula.

# Quartus Prime: Generate Tcl File for Project
# File: riscv_cpu.tcl
# Generated on: Thu Jul 25 20:35:16 2024

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "riscv_cpu"]} {
		puts "Project riscv_cpu is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists riscv_cpu]} {
		project_open -revision riscv_cpu riscv_cpu
	} else {
		project_new -revision riscv_cpu riscv_cpu
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone IV E"
	set_global_assignment -name DEVICE EP4CE15F23C8
	set_global_assignment -name TOP_LEVEL_ENTITY riscv_cpu
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 21.1.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "06:09:04  JULY 13, 2024"
	set_global_assignment -name LAST_QUARTUS_VERSION "21.1.0 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name EDA_SIMULATION_TOOL "Questa Intel FPGA (VHDL)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_RUN_TOOL_AUTOMATICALLY OFF -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_timing
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_symbol
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_signal_integrity
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_boundary_scan
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name VHDL_INPUT_VERSION VHDL_2008
	set_global_assignment -name VHDL_SHOW_LMF_MAPPING_MESSAGES OFF
	set_global_assignment -name VHDL_FILE ControlUnit_TB.vhd
	set_global_assignment -name VHDL_FILE ControlUnit.vhd
	set_global_assignment -name VHDL_FILE ProgramCounter_TB.vhd
	set_global_assignment -name VHDL_FILE ProgramCounter.vhd
	set_global_assignment -name VECTOR_WAVEFORM_FILE RegisterFile.vwf
	set_global_assignment -name VHDL_FILE RegisterFile.vhd
	set_global_assignment -name VHDL_FILE riscv_cpu.vhd
	set_global_assignment -name VHDL_FILE RegisterFile_TB.vhd
	set_global_assignment -name VHDL_FILE ALU.vhd
	set_global_assignment -name VHDL_FILE ALU_TB.vhd
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name QIP_FILE RAM.qip
	set_global_assignment -name VHDL_FILE RAM_TB.vhd
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
