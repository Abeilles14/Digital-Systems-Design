onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /address_counter_tb/DUT/clk22K
add wave -noupdate /address_counter_tb/DUT/dir
add wave -noupdate /address_counter_tb/DUT/read_addr_start
add wave -noupdate /address_counter_tb/DUT/addr_ready_flag
add wave -noupdate -radix hexadecimal /address_counter_tb/DUT/current_address
add wave -noupdate -radix hexadecimal /address_counter_tb/DUT/flash_data
add wave -noupdate -radix hexadecimal /address_counter_tb/DUT/audio_out
add wave -noupdate /address_counter_tb/DUT/reset
add wave -noupdate /address_counter_tb/DUT/data_even_flag
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
WaveRestoreZoom {0 ps} {114 ps}
