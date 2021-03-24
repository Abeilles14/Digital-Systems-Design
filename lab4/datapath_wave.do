onerror {resume}
radix define States {
    "7'b000_0000" "IDLE",
    "7'b001_0001" "S_MEM_INIT",
    "7'b010_0010" "S_MEM_SWAP",
    "7'b011_0100" "S_MEM_DECRYPT",
    "7'b100_1000" "DONE",
    -default hexadecimal
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_tb/DUT/clk
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/secret_key
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/key_start_value
add wave -noupdate /datapath_tb/DUT/key_found_flag
add wave -noupdate /datapath_tb/DUT/datapath_start_flag
add wave -noupdate /datapath_tb/DUT/datapath_done_flag
add wave -noupdate /datapath_tb/DUT/stop
add wave -noupdate /datapath_tb/DUT/reset
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/s_mem_addr
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/s_mem_data_in
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/s_mem_data_out
add wave -noupdate /datapath_tb/DUT/s_mem_write
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/d_mem_addr
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/d_mem_data_in
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/d_mem_data_out
add wave -noupdate /datapath_tb/DUT/d_mem_write
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/e_mem_addr
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/e_mem_data_out
add wave -noupdate -radix States /datapath_tb/DUT/state
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/s_init_addr
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/s_init_data_in
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/s_swap_addr
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/s_swap_data_in
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/s_decrypt_data_in
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/decrypt_addr
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/e_decrypt_addr
add wave -noupdate /datapath_tb/DUT/s_init_write
add wave -noupdate /datapath_tb/DUT/s_swap_write
add wave -noupdate /datapath_tb/DUT/s_decrypt_write
add wave -noupdate /datapath_tb/DUT/d_decrypt_write
add wave -noupdate /datapath_tb/DUT/init_start_flag
add wave -noupdate /datapath_tb/DUT/swap_start_flag
add wave -noupdate /datapath_tb/DUT/decrypt_start_flag
add wave -noupdate /datapath_tb/DUT/init_done_flag
add wave -noupdate /datapath_tb/DUT/swap_done_flag
add wave -noupdate /datapath_tb/DUT/decrypt_done_flag
add wave -noupdate /datapath_tb/DUT/invalid_key_flag
add wave -noupdate -radix hexadecimal /datapath_tb/DUT/key_end_value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3000 ps} 0}
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
WaveRestoreZoom {2540 ps} {2692 ps}
