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

## Lab 3 Adding a Strength Meter to the Simple Ipod

This lab consisted in enhancing the previous lab's MP3 Player by adding an LED strength meter showing the strength of the audio signal using Embedded Processors, Signal Professing, and Basic Filtering/Averaging. This was accomplished with an embedded PicoBlaze processor to further explore Digital Signal Processing with real-time averaging (a basic form of filtering).

This lab was written in Assembly, with modules instantiated in the top level Verilog file. An interrupt routine is activated each time a new value is read from the Flash memory. Each sound sample has its own "intensity" or absolute value. Once the interrupt accumulates and sums 256 of these values, the interrupt routine divides this sum by 256 every 256th interrupt triggered, therefore creating an averaging filter operation.
The PicoBlaze interrupt routine then outputs this average value to LEDR[9:2], with the LEDs being filled from left to right ( make the LEDs light up to the value of the most significant binary digit of the average). After each averaged value is output to the appropriate LEDs, the accumulator is set to 0 to prepare to average the next 256 values, and so on.

## Lab 4 RC4 Decryption

This lab introduces the concepts of Memory, Scheduling, and Decryption. an RC4 Decryption circuit was created. The secret key is obtained from a bank of switches on the DE1-SoC board, and the encrypted message is given as a ROM initialization file.
The basic decryption circuit was first created and was later extended to build an RC4 cracking circuit, using a "brute-force" attack on RC4 by cycling through the entire keyspace and stopping when
a successful decryption is performed. A multi-core system of multiple functional units were used to cycle through a portion of the keyspace in parallel for faster cracking as a Bonus.

### Background: RC4 Decryption
RC4 is a popular stream cypher, and until recently was widely used in encrypting web traffic among other uses. RC4 has now been deemed insecure and has been replaced by several variants. Still, RC4 is an important algorithm and provides a good vehicle for studying digital circuits that made
extensive use of on-chip memory.  
Based on a key, the algorithm generates a series of bytes. Each byte is XOR’ed with one byte of a message to produce the decoded text.  

The basic RC4 algorithm is as follows:  
```
// Input:
// secret_key [] : array of bytes that represent the secret key. In our implementation,
// we will assume a key of 24 bits, meaning this array is 3 bytes long
// encrypted_input []: array of bytes that represent the encrypted message. In our
// implementation, we will assume the input message is 32 bytes
// Output:
// decrypted _output []: array of bytes that represent the decrypted result. This will
// always be the same length as encrypted_input [].
// initialize s array. You will build this in Task 1
for i = 0 to 255 {
   s[i] = i;
}
// shuffle the array based on the secret key
j = 0
for i = 0 to 255 {
   j = (j + s[i] + secret_key[i mod keylength] ) mod 256 //keylength is 3 in our impl.
   swap values of s[i] and s[j]
}
// compute one byte per character in the encrypted message
i = 0, j=0
for k = 0 to message_length-1 { // message_length is 32 in our implementation
   i = (i+1) mod 256
   j = (j+s[i]) mod 256
   swap values of s[i] and s[j]
   f = s[ (s[i]+s[j]) mod 256 ]
   decrypted_output[k] = f xor encrypted_input[k] // 8 bit wide XOR function
}
```

The length of the secret key can vary in different applications, but is typically 40 bits (8 bytes). In our implementation, we will assume a 24 bit (3 byte) key.

### Creating and instantiating the RAM
A RAM block was created using the Megafunction Wizard, creating circuitry to fill the memory, and observing the memory contents using the In-System Memory Content Editor. The memory was instantiated incrementally with values from 0-255 as shown in the first for-loop, using an initialization FSM.

### Building a Single Decryption Core
A single decryption core was created given a given key and an encrypted message in a ROM. The system consists of three memories and a state machine/datapath. The initial encrypted
message is stored in a 32-bit ROM initialized using a .mif file when compiling. The result is stored in a 32-word RAM.  

A 2nd FSM was created to shuffle the array created from instantiating the RAM as shown in the second for-loop, using a shuffling/swapping FSM.  
Two more memories were instantiated, a ROM to store the encrypted message, and another RAM to store the decrypted message. A 3rd FSM was created to decrypt the message and write the decrypted output to the RAM block, as shown in the 3rd for-loop.  
All 3 FSMs are controlled and scheduled from a datapath indicating when each of the 3 FSMs may begin their operations.

### Multi-Core Cracking
As a Bonus, multiple instantiations of the decryption cores (datapath) were created in order to search subsets of the keyspace simultaneously. Each of the 4 instantiated cores search 1/4 of the search space and once the correct key is found, all units are signaled to stop. The current Key being tested is shown on the DE1-SoC HEX display, and once the Key is found, the LED corresponding to the core having found the key is enabled.

## Lab 5

This lab introduces the topics of Nios, Qsys, DDS (Direct Digital Synthesis), LFSR (Linear Feedback Shift Registers), Modulations (ASK, BPSK, FSK) and clock domain crossing. A VGA monitor is used with audio and real-time signal processing in the FPGA, giving an outlook of Real-Time Operating System (RTOS), in this case, the MicroC OS-II.  
The signals were shown on the VGA screen. a DDS and LFSR were instantiated and connected to a Nios based Qsys system and the VGA oscilloscope. In the Qsys system, 3 PIO modules to connect the Qsys system to the DDS and the LFSR in order to generate the following modulations:  
* ASK (Amplitude Shift Keying - On-Off Keying OOK)  
* BPSK (Binary Phase Shift Keying)  
* FSK (Frequency Shift Keying)  

A 5-bit LFSR running at a clock rate of 1 Hz, generated using a frequency divider, and synchronized using a fast-to-slow synchronizer to handle the clock domain crossing logic. A DDS was instantiated to generate a 3 Hz carrier sine wave. The LFSR was then used to modulate the DDS carrier sine to generate ASK (OOK) and BPSK signals.  
The modulated signals and DDS outputs and LFSR were connected through muxes controlled by the Nios, to the VGA oscilloscope for display. To generate the FSK signal, the LFSR, LFSR clock, and DDS signalsy were connected to the Qsys using the Nios and interrupts. Through out the process, appropriate clock crossing logic was implemented to handle instances of clock domain crossing.

## Final Project

In this final project acting as the course's final exam, a talking calculator was created using code that emulates the SPO256 speech synthesizer controlled by a Picoblaze processor, and will be able to pronounce any words based on their phonetic decomposition into phonemes. The speed of the speech will be controlled by the buttons and the calculator will be controlled via the keyboard. The calculator functionality was implemented in the Picoblaze processor in Assembly.

### Phonemes
The audio samples of the phonemes were sampled at a rate of 7200 Hz. This is also the nominal rate at
which they need to be played back.

The phonemes will be stored in the flash memory. The Picoblaze processor will interface to FSMs that read that flash memory in order to play phonemes to form words.

The narrator_ctrl.v file contains a registered MUX which provides the outputs "start_address", "end_address", and "silent" that correspond to each phoneme code. The signals "start_address" and "end_address" are the start address and end address in the flash memory containing the audio data of the phoneme. There are five phonemes (PA1 to PA5) which are silence phonemes. These correspond to the "silent" signal being turned on and this signal should be used to silence the audio for the duration of the read from flash for these phonemes.

### Audio Samples
Layout of the audio: the audio is 8 bit audio, with four 8-bit samples per 32-bit word in flash, as follows:

```
Word Address 0:|Sample 3(8-bits) |Sample 2(8-bits) |Sample 1(8-bits)|Sample 0(8-bits)|
Word Address 1:|Sample 7(8-bits) |Sample 6(8-bits) |Sample 5(8-bits)|Sample 4(8-bits)|
Word Address 2:|Sample 11(8-bits)|Sample 10(8-bits)|Sample 9(8-bits)|Sample 8(8-bits)|
```

Sample 0 is in bits [7:0], sample 1 is in bits [15:8], sample 2 is in bits [23:16], sample 3 is in bits [31:24], etcetera.

### Volume Intensity Meter
Additionally, an LED display showing the averaged intensity of the audio signal, identical to Lab 3 except calculated via an FSM in Verilog rather than in the Picoblaze.  
* The absolute value of the 8-bit audio samples was taken
* The sum of absolute values of the 256 audio samples was taken
* Every 256 audio samples get the average of the previous 256 samples by dividing the sum of those samples by 256 using shift right by the correct number of bits
* The LEDs light up to the value of the most significant binary digit of the average. For example, if the average of the absolute values is, in binary, 00101101, then since the highest bit that is "1" is bit #5 (where bit #0 is the LSB), the LEDs should be XXXXXX00 (where "X" is on and "0" is off)

### 8b10b Coding and Decoding
An 8b10b serial link was partially emulated to practice using 8b10b codes. The 8 bit audio data were encoded it using 8b10b coding then decoded The decoded audio data (which should be identical to the original data) is sent to the audio.
The "silent" signal should also be passed through the 8b10b encode/decode process as a control character, the K28.5 character. When this character is detected after decoding, the audio is muted.
