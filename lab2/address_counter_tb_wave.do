onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /address_counter_tb/DUT/clk
add wave -noupdate /address_counter_tb/DUT/dir
add wave -noupdate /address_counter_tb/DUT/read_addr_flag
add wave -noupdate /address_counter_tb/DUT/current_address
add wave -noupdate /address_counter_tb/DUT/addr_retrieved_flag
add wave -noupdate /address_counter_tb/DUT/reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {74 ps}
