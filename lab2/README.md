University of British Columbia

*Isabelle Andre*

# Digital Systems Design
5 Labs and 3 Assignments completed using System Verilog, VHDL, Picoblaze, Assembly, and a DE1-SoC.

## Lab 2 Simple Ipod

An MP3 Player was developed in this lab using a DE1-SoC while interfacing with the Altera Flash Controller and a Keyboard for sound controls.

### Address Increment/Decrement
A total of 0x200000 16-bit audio samples were read from flash memory and written to the 8-bit audio output through a D/A converter. An address counter FSM was used to increment or decrement the 32-bit addresses at which the 16-bit audio samples are read from the 32-bit Flash data.
The even addresses are in the lower bytes, whereas the odd addresses are in the higher bytes, therefore the first 16-bit audio sample is located in the lower-half of the data at address 0, and the last sample is located in the upper half of the data at address 0x7FFFF.  
For instance:  
* Data at Address 0: 32'hBBBBAAAA  
    * 1st Audio Data: 16'hAAAA (even)  
    * 2nd Audio Data: 16'hBBBB (odd)  
* Data at Address 32'hFFFFEEEE:  
    * 2nd Last Audio Data: 16'hEEEE (even)  
    * Last Audio Data: 16'hFFFF (odd)  

Note: The prof goofed lol only need first 8-bits of audio data (last 8-bits ignored). Also addresses are only 23-bits, not 32-bits.  

### Sampling Rate
A new value is read from the Flash memory and sent to the audio output every 0.045ms for a 22KHz sampling rate of the song. A frequency divider was used to divide the 50MHz clock to obtain a 22KHz clock, with each rising edge of the 22KHz clock being a stimulus for the Address Counter FSM to read a new value of the Flash Memory and write to the audio D/A converter.

As a bonus, the input pin TD_CLK27 was used as a 27MHz clock for the frequency divider that generates the 22 KHz clock. This resulted in a a truly asynchronous 22KHz clock as compared to the 50MHz FSM clock.

Note: Prof did an oopsie again, song sample rate was supposed to be 44KHz. A second frequency divider and additional functionalities to implement a 44KHz Sampling rate was added as a bonus.  

#### Nyquist Sampling Theorem
* Q: Why does a 44 KHz reproduced signal sounds better than 22KHz song?  
* A: The Nyquist Sampling Theorem: A bandlimited continuous-time signal can be sampled and perfectly reconstructed from its samples if the waveform is sampled over twice as fast as its highest frequency component.  
    * Due to the Nyquist limit, a 22khz sample rate is limited to 11khz max sound reproduction. A 44khz is limited to 22khz, covering the entire human hearing range.  
    * To produce a basic audio tone, a minimum of two samples per cycle is required, one positive and one negative. Any given number of Hz requires at least twice that many samples/sec to produce or record digitally.  

### Clock Domain Crossing
As the 22KHz and 44KHz clocks were not synchronized with the FSM's 50MHz clock, a method to detect the 22KHz clock was required to generate stimulus. Clock domain crossing logic was implemented with synchronizers to synchronize the Keyboard, FSMs, and Sampling clock domains.

### Keyboard Interface and Speed Control
An interface between the FSMs and the ASCII code received from the keyboard to control the music was constructed. The keyboard controls are as follows:  
* D - Pause  
* E - Play  
* R - Reset  
* B - Rewind  
* F - Forward

The DE1-SoC Keys KEY[2:0] are used to control audio speed, by changing the frequency that generates the stimulus to the FSMs that reads data from the Flash. The normal frequency begins at 22KHz.  
* KEY0 will increase the speed
* KEY1 will decrease the speed
* KEY2 will reset the speed to the original sample rate
