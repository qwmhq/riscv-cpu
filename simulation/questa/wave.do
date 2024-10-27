onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/UUT/reset
add wave -noupdate /cpu_tb/UUT/clk
add wave -noupdate -expand -group {program counter} /cpu_tb/UUT/pc
add wave -noupdate -expand -group {program counter} /cpu_tb/UUT/pc_next_val
add wave -noupdate -expand -group {program counter} /cpu_tb/UUT/wr_pc
add wave -noupdate -expand -group {instruction fields} /cpu_tb/UUT/inst
add wave -noupdate -expand -group {instruction fields} -radix binary /cpu_tb/UUT/opcode
add wave -noupdate -expand -group {instruction fields} -radix unsigned /cpu_tb/UUT/rs1
add wave -noupdate -expand -group {instruction fields} -radix unsigned /cpu_tb/UUT/rs2
add wave -noupdate -expand -group {instruction fields} -radix unsigned /cpu_tb/UUT/rd
add wave -noupdate -expand -group {instruction fields} -radix binary /cpu_tb/UUT/func3
add wave -noupdate -expand -group {instruction fields} -radix binary /cpu_tb/UUT/func7
add wave -noupdate -expand -group {other values} /cpu_tb/UUT/imm
add wave -noupdate -expand -group {other values} /cpu_tb/UUT/r1
add wave -noupdate -expand -group {other values} /cpu_tb/UUT/r2
add wave -noupdate -expand -group {other values} /cpu_tb/UUT/alu_x
add wave -noupdate -expand -group {other values} /cpu_tb/UUT/alu_y
add wave -noupdate -expand -group {other values} /cpu_tb/UUT/alu_z
add wave -noupdate /cpu_tb/UUT/imm
add wave -noupdate -expand -group {destination register} /cpu_tb/UUT/rd_val
add wave -noupdate -expand -group {destination register} /cpu_tb/UUT/wr_rd
add wave -noupdate -expand -group memory /cpu_tb/UUT/mem_in
add wave -noupdate -expand -group memory /cpu_tb/UUT/mem_addr
add wave -noupdate -expand -group memory /cpu_tb/UUT/mem_out
add wave -noupdate -expand -group memory /cpu_tb/UUT/mem_mode
add wave -noupdate -expand -group memory /cpu_tb/UUT/wr_mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {507 ns} {638 ns}
