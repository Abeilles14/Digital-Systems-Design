onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /keyboard_control_tb/DUT/clk
add wave -noupdate /keyboard_control_tb/DUT/read_keyboard_flag
add wave -noupdate -radix hexadecimal /keyboard_control_tb/DUT/character
add wave -noupdate /keyboard_control_tb/DUT/read_addr_start
add wave -noupdate /keyboard_control_tb/DUT/dir
add wave -noupdate /keyboard_control_tb/DUT/reset
add wave -noupdate /keyboard_control_tb/DUT/start
add wave -noupdate /keyboard_control_tb/DUT/restart
add wave -noupdate /keyboard_control_tb/DUT/direction
add wave -noupdate /keyboard_control_tb/DUT/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {179 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {188 ps}
