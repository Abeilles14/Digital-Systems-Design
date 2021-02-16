onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synchronizer_tb/DUT/vcc
add wave -noupdate /synchronizer_tb/DUT/gnd
add wave -noupdate /synchronizer_tb/DUT/async_sig
add wave -noupdate /synchronizer_tb/DUT/outclk
add wave -noupdate /synchronizer_tb/DUT/out_sync_sig
add wave -noupdate /synchronizer_tb/DUT/fdc_aq
add wave -noupdate /synchronizer_tb/DUT/fdc_bq
add wave -noupdate /synchronizer_tb/DUT/fdc_1q
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
WaveRestoreZoom {0 ps} {364 ps}
