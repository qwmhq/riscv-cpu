# Define the project paths
set src_path "../.."
set work_lib "work"

# Create a work library
vlib $work_lib
vmap $work_lib $work_lib

# Compile source files
vcom -work $work_lib $src_path/ByteEnabledRAM.vhd

# Compile testbench files
vcom -work $work_lib $src_path/ByteEnabledRAM_TB.vhd

# Load the top level testbench
vsim -voptargs=+acc work.byteenabledram_tb

# Add signals to waveform viewer
add wave -position end  sim:/byteenabledram_tb/clock
add wave -position end  sim:/byteenabledram_tb/address
add wave -position end  sim:/byteenabledram_tb/data
add wave -position end  sim:/byteenabledram_tb/wr_mode
add wave -position end  sim:/byteenabledram_tb/wren
add wave -position end  sim:/byteenabledram_tb/q_w
add wave -position end  sim:/byteenabledram_tb/q_h
add wave -position end  sim:/byteenabledram_tb/q_b

# Run simulation
run -all
