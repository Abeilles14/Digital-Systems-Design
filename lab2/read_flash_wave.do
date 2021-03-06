onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /read_flash_tb/DUT/clk50M
add wave -noupdate /read_flash_tb/DUT/start_read_flag
add wave -noupdate /read_flash_tb/DUT/read_data_flag
add wave -noupdate /read_flash_tb/DUT/read_addr_flag
add wave -noupdate -radix hexadecimal /read_flash_tb/DUT/flash_data_in
add wave -noupdate -radix hexadecimal /read_flash_tb/DUT/flash_data_out
add wave -noupdate /read_flash_tb/DUT/state
add wave -noupdate -radix hexadecimal /read_flash_tb/DUT/data_output_flag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {54 ps} 0}
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
WaveRestoreZoom {0 ps} {55 ps}
