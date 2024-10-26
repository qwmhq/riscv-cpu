# Define the project paths
set proj_path "/home/quwam/programming-stuff/cpu-stuff/riscv-cpu"
set src_path "$proj_path/src"
set tb_path "$proj_path/tb"
set waves_path "$proj_path/waves"
set work_lib "work"

# Create a work library
vlib $work_lib
vmap $work_lib $work_lib

# Compile source files
vcom -2008 -work $work_lib $src_path/common_pkg.vhd
vcom -2008 -work $work_lib $src_path/IPRAM2.vhd
vcom -2008 -work $work_lib $src_path/InstMem.vhd
vcom -2008 -work $work_lib $src_path/IPRAM.vhd
vcom -2008 -work $work_lib $src_path/RAM.vhd
vcom -2008 -work $work_lib $src_path/InstDecoder.vhd
vcom -2008 -work $work_lib $src_path/ALU.vhd
vcom -2008 -work $work_lib $src_path/RegisterFile.vhd
vcom -2008 -work $work_lib $src_path/ControlUnit.vhd
vcom -2008 -work $work_lib $src_path/ProgramCounter.vhd
vcom -2008 -work $work_lib $src_path/CPU.vhd
vcom -2008 -work $work_lib $src_path/top.vhd

# Compile testbench files
vcom -2008 -work $work_lib $tb_path/top_tb.vhd

# Load the top level testbench
vsim -voptargs=+acc work.top_tb

# add waves to viewer
add wave -position end sim:/top_tb/clk sim:/top_tb/reset sim:/top_tb/UUT/pc sim:/top_tb/UUT/inst sim:/top_tb/UUT/CPU/CU/state sim:/top_tb/UUT/CPU/opcode sim:/top_tb/UUT/CPU/rs1 sim:/top_tb/UUT/CPU/rs2 sim:/top_tb/UUT/CPU/rd sim:/top_tb/UUT/CPU/imm sim:/top_tb/UUT/CPU/r1 sim:/top_tb/UUT/CPU/r2 sim:/top_tb/UUT/CPU/rd_val sim:/top_tb/UUT/CPU/wr_rd sim:/top_tb/UUT/CPU/mem_addr sim:/top_tb/UUT/CPU/mem_mode sim:/top_tb/UUT/CPU/mem_out sim:/top_tb/UUT/CPU/wr_mem 

# save waves to vcd file
vcd file $waves_path/top_wave.vcd
vcd add -r /*

# Run the simulation
run 4000ns

quit -f
