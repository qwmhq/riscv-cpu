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
vcom -2008 -work $work_lib $src_path/Memory.vhd
vcom -2008 -work $work_lib $src_path/IpMem.vhd
vcom -2008 -work $work_lib $src_path/InstDecoder.vhd
vcom -2008 -work $work_lib $src_path/ALU.vhd
vcom -2008 -work $work_lib $src_path/RegisterFile.vhd
vcom -2008 -work $work_lib $src_path/ControlUnit.vhd
vcom -2008 -work $work_lib $src_path/ProgramCounter.vhd
vcom -2008 -work $work_lib $src_path/CPU.vhd

# Compile testbench files
vcom -2008 -work $work_lib $tb_path/top_tb.vhd

# Load the top level testbench
vsim -voptargs=+acc work.top_tb

# add waves to viewer
add wave -position end sim:/top_tb/clk sim:/top_tb/reset sim:/top_tb/CPU/clk sim:/top_tb/CPU/inst sim:/top_tb/CPU/mem_in sim:/top_tb/CPU/pc sim:/top_tb/CPU/wr_pc sim:/top_tb/CPU/mem_addr sim:/top_tb/CPU/mem_out sim:/top_tb/CPU/mem_mode sim:/top_tb/CPU/wr_mem sim:/top_tb/CPU/rd sim:/top_tb/CPU/rd_val sim:/top_tb/CPU/wr_rd 

# save waves to vcd file
vcd file $waves_path/top_wave.vcd
vcd add -r /*

# Run the simulation
run -all

# quit -f
