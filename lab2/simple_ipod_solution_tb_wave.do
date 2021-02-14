onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /simple_ipod_solution_tb/read_FLASH_DUT/clk50M
add wave -noupdate /simple_ipod_solution_tb/generate_22khz_clock_DUT/outclk
add wave -noupdate /simple_ipod_solution_tb/generate_22khz_clock_DUT/div_clk_count
add wave -noupdate /simple_ipod_solution_tb/generate_22khz_clock_DUT/clk_count
add wave -noupdate /simple_ipod_solution_tb/read_FLASH_DUT/state
add wave -noupdate /simple_ipod_solution_tb/read_FLASH_DUT/start_read_flag
add wave -noupdate /simple_ipod_solution_tb/read_FLASH_DUT/read_addr_flag
add wave -noupdate /simple_ipod_solution_tb/read_FLASH_DUT/addr_retrieved_flag
add wave -noupdate /simple_ipod_solution_tb/count_addr_DUT/current_address
add wave -noupdate /simple_ipod_solution_tb/read_FLASH_DUT/read_data_flag
add wave -noupdate /simple_ipod_solution_tb/read_FLASH_DUT/data_output_flag
add wave -noupdate /simple_ipod_solution_tb/read_FLASH_DUT/data_even_flag
add wave -noupdate -radix hexadecimal /simple_ipod_solution_tb/read_FLASH_DUT/flash_data
add wave -noupdate -radix hexadecimal /simple_ipod_solution_tb/read_FLASH_DUT/data_out
add wave -noupdate -radix hexadecimal /simple_ipod_solution_tb/read_FLASH_DUT/audio_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {34145 ps} 0}
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
WaveRestoreZoom {34082 ps} {34280 ps}
