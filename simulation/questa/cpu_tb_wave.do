onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/UUT/reset
add wave -noupdate /cpu_tb/UUT/clk
add wave -noupdate -expand -group {program counter} /cpu_tb/UUT/pc
add wave -noupdate -expand -group {program counter} /cpu_tb/UUT/pc_next
add wave -noupdate -expand -group {program counter} /cpu_tb/UUT/wr_pc
add wave -noupdate /cpu_tb/UUT/inst
add wave -noupdate -group {instruction fields} -radix binary /cpu_tb/UUT/opcode
add wave -noupdate -group {instruction fields} -radix unsigned /cpu_tb/UUT/rs1
add wave -noupdate -group {instruction fields} -radix unsigned /cpu_tb/UUT/rs2
add wave -noupdate -group {instruction fields} -radix unsigned /cpu_tb/UUT/rd
add wave -noupdate -group {instruction fields} -radix binary /cpu_tb/UUT/func3
add wave -noupdate -group {instruction fields} -radix binary /cpu_tb/UUT/func7
add wave -noupdate -expand -group {other values} /cpu_tb/UUT/imm
add wave -noupdate -expand -group {other values} /cpu_tb/UUT/r1
add wave -noupdate -expand -group {other values} /cpu_tb/UUT/r2
add wave -noupdate -expand -group {other values} /cpu_tb/UUT/alu_x
add wave -noupdate -expand -group {other values} /cpu_tb/UUT/alu_y
add wave -noupdate -expand -group {other values} -radix hexadecimal /cpu_tb/UUT/alu_z
add wave -noupdate /cpu_tb/UUT/imm
add wave -noupdate -group {destination register} -radix unsigned /cpu_tb/UUT/rd
add wave -noupdate -group {destination register} /cpu_tb/UUT/rd_val
add wave -noupdate -group {destination register} /cpu_tb/UUT/wr_rd
add wave -noupdate -expand -group {internal write signals} /cpu_tb/UUT/wr_mem
add wave -noupdate -expand -group {internal write signals} /cpu_tb/UUT/wr_rd
add wave -noupdate -expand -group {internal write signals} /cpu_tb/UUT/wr_pc
add wave -noupdate -group memory /cpu_tb/UUT/mem_in
add wave -noupdate -group memory /cpu_tb/UUT/mem_addr
add wave -noupdate -group memory /cpu_tb/UUT/mem_out
add wave -noupdate -group memory -radix binary /cpu_tb/UUT/mem_mode
add wave -noupdate -group memory /cpu_tb/UUT/wr_mem
add wave -noupdate -expand -group {control unit state machine} /cpu_tb/UUT/CU/current_state
add wave -noupdate -expand -group {control unit state machine} /cpu_tb/UUT/CU/state_ctr
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port a} /cpu_tb/mem/clock_a
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port a} /cpu_tb/mem/clocken_a
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port a} /cpu_tb/mem/addr_a
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port a} /cpu_tb/mem/data_in_a
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port a} /cpu_tb/mem/wren_a
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port a} /cpu_tb/mem/mode_a
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port a} /cpu_tb/mem/data_out_a
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port b} /cpu_tb/mem/clock_b
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port b} /cpu_tb/mem/clocken_b
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port b} /cpu_tb/mem/addr_b
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port b} /cpu_tb/mem/data_in_b
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port b} /cpu_tb/mem/wren_b
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port b} /cpu_tb/mem/mode_b
add wave -noupdate -group {memory component} -expand -group {memory component} -expand -group {port b} /cpu_tb/mem/data_out_b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {21 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 189
configure wave -valuecolwidth 95
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
WaveRestoreZoom {0 ns} {106 ns}
