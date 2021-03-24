onerror {resume}
radix define States {
    "10'b00000_00000" "IDLE",
    "10'b00001_00000" "SET_I_ADDR",
    "10'b10000_00000" "WAIT_I_ADDR",
    "10'b00010_01010" "GET_I_DATA",
    "10'b00011_00000" "ADD_SUM_J",
    "10'b00100_00000" "SET_J_ADDR",
    "10'b11000_00000" "WAIT_J_ADDR",
    "10'b00101_01000" "GET_J_DATA",
    "10'b00111_00110" "SWAP_DATA_I",
    "10'b01001_00101" "SWAP_DATA_J",
    "10'b01010_00000" "INCREMENT",
    "10'b01011_10000" "DONE",
    -default hexadecimal
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /swap_memory_tb/DUT/clk
add wave -noupdate -radix hexadecimal /swap_memory_tb/DUT/address
add wave -noupdate -radix hexadecimal /swap_memory_tb/DUT/data_in
add wave -noupdate -radix hexadecimal /swap_memory_tb/DUT/data_out
add wave -noupdate /swap_memory_tb/DUT/wren
add wave -noupdate -radix hexadecimal /swap_memory_tb/DUT/secret_key
add wave -noupdate /swap_memory_tb/DUT/start_flag
add wave -noupdate /swap_memory_tb/DUT/done_flag
add wave -noupdate /swap_memory_tb/DUT/reset
add wave -noupdate -radix States /swap_memory_tb/DUT/state
add wave -noupdate -radix hexadecimal /swap_memory_tb/DUT/keylength
add wave -noupdate -radix hexadecimal /swap_memory_tb/DUT/i_index
add wave -noupdate -radix hexadecimal /swap_memory_tb/DUT/j_index
add wave -noupdate -radix hexadecimal /swap_memory_tb/DUT/i_data
add wave -noupdate -radix hexadecimal /swap_memory_tb/DUT/j_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {126 ps}
