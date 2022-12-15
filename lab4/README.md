University of British Columbia

*Isabelle Andre*

# Digital Systems Design
5 Labs and 3 Assignments completed using System Verilog, VHDL, Picoblaze, Assembly, and a DE1-SoC.

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
