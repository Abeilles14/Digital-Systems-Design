onerror {resume}
radix define States {
    "11'b000_0000_0000" "IDLE",
    "11'b000_0001_0000" "SET_I_ADDR",
    "11'b000_0010_0000" "WAIT_I_ADDR",
    "11'b000_0011_0000" "GET_I_DATA",
    "11'b000_0100_0000" "SET_J_ADDR",
    "11'b000_0101_0000" "WAIT_J_ADDR",
    "11'b000_0110_0000" "GET_J_DATA",
    "11'b000_0111_0010" "SET_SWAP_I_ADDR",
    "11'b000_1000_0010" "SWAP_DATA_I",
    "11'b000_1001_0000" "SET_SWAP_J_ADDR",
    "11'b000_1010_0010" "SWAP_DATA_J",
    "11'b001_1011_0000" "SET_F_ADDR",
    "11'b000_1100_0000" "WAIT_F_ADDR",
    "11'b000_1101_0000" "GET_F_VALUE",
    "11'b000_1110_0000" "SET_K_ADDR",
    "11'b000_1111_0000" "WAIT_K_ADDR",
    "11'b001_0000_0100" "DECRYPT",
    "11'b001_0001_0100" "VALIDATE",
    "11'b001_0011_0000" "INCREMENT",
    "11'b001_0100_0001" "DONE",
    -default hexadecimal
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /decrypt_memory_tb/DUT/clk
add wave -noupdate -radix hexadecimal /decrypt_memory_tb/DUT/address
add wave -noupdate -radix hexadecimal /decrypt_memory_tb/DUT/s_data_in
add wave -noupdate -radix hexadecimal /decrypt_memory_tb/DUT/s_data_out
add wave -noupdate -radix hexadecimal /decrypt_memory_tb/DUT/d_data_in
add wave -noupdate -radix hexadecimal /decrypt_memory_tb/DUT/d_data_out
add wave -noupdate -radix hexadecimal /decrypt_memory_tb/DUT/e_data_out
add wave -noupdate /decrypt_memory_tb/DUT/s_wren
add wave -noupdate /decrypt_memory_tb/DUT/d_wren
add wave -noupdate /decrypt_memory_tb/DUT/key_found_flag
add wave -noupdate /decrypt_memory_tb/DUT/start_flag
add wave -noupdate /decrypt_memory_tb/DUT/done_flag
add wave -noupdate /decrypt_memory_tb/DUT/reset
add wave -noupdate -radix States /decrypt_memory_tb/DUT/state
add wave -noupdate -radix hexadecimal /decrypt_memory_tb/DUT/i_index
add wave -noupdate -radix hexadecimal /decrypt_memory_tb/DUT/j_index
add wave -noupdate -radix hexadecimal /decrypt_memory_tb/DUT/k_index
add wave -noupdate -radix hexadecimal /decrypt_memory_tb/DUT/f_value
add wave -noupdate -radix hexadecimal /decrypt_memory_tb/DUT/i_data
add wave -noupdate -radix hexadecimal /decrypt_memory_tb/DUT/j_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {259 ps} 0}
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
WaveRestoreZoom {0 ps} {108 ps}
