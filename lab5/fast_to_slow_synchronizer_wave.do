onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fast_to_slow_synchronizer_tb/DUT/clk1
add wave -noupdate /fast_to_slow_synchronizer_tb/DUT/clk2
add wave -noupdate /fast_to_slow_synchronizer_tb/DUT/data_in
add wave -noupdate /fast_to_slow_synchronizer_tb/DUT/data_out
add wave -noupdate /fast_to_slow_synchronizer_tb/DUT/reg1_out
add wave -noupdate /fast_to_slow_synchronizer_tb/DUT/reg3_out
add wave -noupdate /fast_to_slow_synchronizer_tb/DUT/clk_reg1_out
add wave -noupdate /fast_to_slow_synchronizer_tb/DUT/clk_reg2_out
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
WaveRestoreZoom {0 ps} {500 ps}
