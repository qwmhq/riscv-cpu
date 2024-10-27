onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory_tb/clock
add wave -noupdate /memory_tb/clocken
add wave -noupdate /memory_tb/addr_a
add wave -noupdate /memory_tb/data_in_a
add wave -noupdate /memory_tb/wren_a
add wave -noupdate -radix binary /memory_tb/mode_a
add wave -noupdate /memory_tb/data_out_a
add wave -noupdate /memory_tb/addr_b
add wave -noupdate /memory_tb/data_in_b
add wave -noupdate /memory_tb/wren_b
add wave -noupdate -radix binary /memory_tb/mode_b
add wave -noupdate /memory_tb/data_out_b
add wave -noupdate /memory_tb/in_port_data
add wave -noupdate /memory_tb/out_port_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {206 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 182
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
WaveRestoreZoom {1833 ns} {2009 ns}
