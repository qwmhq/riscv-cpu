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
vcom -work $work_lib $src_path/ByteEnableEncoder.vhd
vcom -work $work_lib $src_path/IPRAM.vhd
vcom -work $work_lib $src_path/RAM.vhd

# Compile testbench files
vcom -work $work_lib $tb_path/RAM_TB.vhd

# Load the top level testbench
vsim -voptargs=+acc work.ram_tb

# Add signals to waveform viewer (optional)
# add wave -position end	sim:/ram_tb/clock
# add wave -position end  sim:/ram_tb/address
# add wave -position end  sim:/ram_tb/data_in
# add wave -position end  sim:/ram_tb/mode
# add wave -position end  sim:/ram_tb/wren
# add wave -position end  sim:/ram_tb/data_out

# save waves to vcd file
vcd file $waves_path/ram_wave.vcd
vcd add -r /*

# Run the simulation
run -all

quit -f
