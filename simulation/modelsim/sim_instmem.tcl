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
vcom -work $work_lib $src_path/common_pkg.vhd
vcom -work $work_lib $src_path/IPRAM2.vhd
vcom -work $work_lib $src_path/InstMem.vhd

# Compile testbench files
vcom -work $work_lib $tb_path/InstMem_TB.vhd

# Load the top level testbench
vsim -voptargs=+acc work.instmem_tb

# save waves to vcd file
vcd file $waves_path/instmem_wave.vcd
vcd add -r /*

# Run the simulation
run -all

quit -f
