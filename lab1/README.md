University of British Columbia

*Isabelle Andre*

# Digital Systems Design
5 Labs and 3 Assignments completed using System Verilog, VHDL, Picoblaze, Assembly, and a DE1-SoC.

## Lab 1 Single Octave Frequency Organ

A basic 1-octave frequency organ was created using a clock divider to generate the sound frequencies of the notes "Do Re Mi Fa So La Si Do", defined as "523Hz 587Hz 659Hz 698Hz 783Hz 880Hz 987Hz 1046Hz". The clock division is controllable from the switches SW[3:1]
SW[0] enables the audio output.
SignalTap was used as a debugging tool in order to emulate an LCD on the DE1-SoC and retrieve snapshots of data from the FPGA
When a certain audio frequency is selected, this wave can be observed in the Signal Tap oscilloscope with the appropriate note label, and when in Information Console mode, the bottom line displays the position of the switches as well as the current audio data in hexadecimal.
Finally, an LED control FSM was created in order to control the LEDs to flash sequentially side to side.