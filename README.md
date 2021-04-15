University of British Columbia

*Isabelle Andre*

# Digital Systems Design
5 Labs and 3 Assignments completed using a System Verilog, VHDL, Assembly, with a DE1-SoC.

## Lab 1 Single Octave Frequency Organ

A basic 1-octave frequency organ was created using a clock divider to generate the sound frequencies of the notes "Do Re Mi Fa So La Si Do", defined as "523Hz 587Hz 659Hz 698Hz 783Hz 880Hz 987Hz 1046Hz". The clock division is controllable from the switches SW[3:1]
SW[0] enables the audio output.
SignalTap was used as a debugging tool in order to emulate an LCD on the DE1-SoC and retrieve snapshots of data from the FPGA
When a certain audio frequency is selected, this wave can be observed in the Signal Tap oscilloscope with the appropriate note label, and when in Information Console mode, the bottom line displays the position of the switches as well as the current audio data in hexadecimal.
Finally, an LED control FSM was created in order to control the LEDs to flash sequentially side to side.

## Lab 2 Simple Ipod

An MP3 Player was developed in this lab using a DE1-SoC while interfacing with the Altera Flash Controller and a Keyboard for sound controls.

### Address Increment/Decrement
A total of 0x200000 16-bit audio samples were read from flash memory and written to the 8-bit audio output through a D/A converter. An address counter FSM was used to increment or decrement the 32-bit addresses at which the 16-bit audio samples are read from the 32-bit Flash data.
The even addresses are in the lower bytes, whereas the odd addresses are in the higher bytes, therefore the first 16-bit audio sample is located in the lower-half of the data at address 0, and the last sample is located in the upper half of the data at address 0x7FFFF
For instance:
    Data at Address 0: 32'hBBBBAAAA
    * 1st Audio Data: 16'hAAAA (even)
    * 2nd Audio Data: 16'hBBBB (odd)
    Data at Address 32'hFFFFEEEE:
    * 2nd Last Audio Data: 16'hEEEE (even)
    * Last Audio Data: 16'hFFFF (odd)
Note: The prof goofed lol only need first 8-bits of audio data (last 8-bits ignored). Also addresses are only 23-bits, not 32-bits.

### Sampling Rate
A new value is read from the Flash memory and sent to the audio output every 0.045ms for a 22KHz sampling rate of the song. A frequency divider was used to divide the 50MHz clock to obtain a 22KHz clock, with each rising edge of the 22KHz clock being a stimulus for the Address Counter FSM to read a new value of the Flash Memory and write to the audio D/A converter.

Note: Prof did an oopsie again, song sample rate was supposed to be 44KHz. A second frequency divider and additional functionalities to implement a 44KHz Sampling rate was added as a bonus.

### Clock Domain Crossing

Clock domain crossing logic was implemented with synchronizers to synchronize the Keyboard and Sampling clock domains.

## Lab 3



## Lab 4



## Lab 5
