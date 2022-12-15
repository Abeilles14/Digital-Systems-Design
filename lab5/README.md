University of British Columbia

*Isabelle Andre*

# Digital Systems Design
5 Labs and 3 Assignments completed using System Verilog, VHDL, Picoblaze, Assembly, and a DE1-SoC.

## Lab 5 Real-Time Digital Signal Processing

This lab introduces the topics of Nios, Qsys, DDS (Direct Digital Synthesis), LFSR (Linear Feedback Shift Registers), Modulations (ASK, BPSK, FSK) and clock domain crossing. A VGA monitor is used with audio and real-time signal processing in the FPGA, giving an outlook of Real-Time Operating System (RTOS), in this case, the MicroC OS-II.  
The signals were shown on the VGA screen. a DDS and LFSR were instantiated and connected to a Nios based Qsys system and the VGA oscilloscope. In the Qsys system, 3 PIO modules to connect the Qsys system to the DDS and the LFSR in order to generate the following modulations:  
* ASK (Amplitude Shift Keying - On-Off Keying OOK)  
* BPSK (Binary Phase Shift Keying)  
* FSK (Frequency Shift Keying)  

A 5-bit LFSR running at a clock rate of 1 Hz, generated using a frequency divider, and synchronized using a fast-to-slow synchronizer to handle the clock domain crossing logic. A DDS was instantiated to generate a 3 Hz carrier sine wave. The LFSR was then used to modulate the DDS carrier sine to generate ASK (OOK) and BPSK signals.  
The modulated signals and DDS outputs and LFSR were connected through muxes controlled by the Nios, to the VGA oscilloscope for display. To generate the FSK signal, the LFSR, LFSR clock, and DDS signalsy were connected to the Qsys using the Nios and interrupts. Through out the process, appropriate clock crossing logic was implemented to handle instances of clock domain crossing.
