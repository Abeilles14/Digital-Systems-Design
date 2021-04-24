
`default_nettype none
 `define USE_PACOBLAZE
module picoblaze_template #( parameter clk_freq_in_hz = 25000000) (
        input clk,
        input reg [7:0] input_data,
        input reg error_flag,
        input interrupt_flag,
        output [7:0] phoneme_out,
        input reg start_phoneme_flag,
        input reg start_word_flag,
        output reg done_phoneme_flag,
        output reg done_word_flag);


  
//--
//------------------------------------------------------------------------------------
//--
//-- Signals used to connect KCPSM3 to program ROM and I/O logic
//--

wire[9:0]  address;
wire[17:0]  instruction;
wire[7:0]  port_id;
wire[7:0]  out_port;
reg[7:0]  in_port;
wire  write_strobe;
wire  read_strobe;
wire  interrupt_ack;
reg interrupt;
wire  kcpsm3_reset;

//--
//-- Signals used to generate interrupt 
//--
reg[26:0] int_count;
//reg event_1hz;

//-- Signals for LCD operation
//--
//--

reg        lcd_rw_control;
reg[7:0]   lcd_output_data;
pacoblaze3 led_8seg_kcpsm
(
                  .address(address),
               .instruction(instruction),
                   .port_id(port_id),
              .write_strobe(write_strobe),
                  .out_port(out_port),
               .read_strobe(read_strobe),
                   .in_port(in_port),
                 .interrupt(interrupt),
             .interrupt_ack(interrupt_ack),
                     .reset(kcpsm3_reset),
                       .clk(clk));

 wire [19:0] raw_instruction;
  
  pacoblaze_instruction_memory 
  pacoblaze_instruction_memory_inst(
      .addr(address),
      .outdata(raw_instruction)
  );
  
  always @ (posedge clk)
  begin
        instruction <= raw_instruction[17:0];
  end

    assign kcpsm3_reset = 0;                       
  
//  ----------------------------------------------------------------------------------------------------------------------------------
//  -- Interrupt 
//  ----------------------------------------------------------------------------------------------------------------------------------
//  --
//  --
//  -- Interrupt is used to provide a 1 second time reference.
//  --
//  --
//  -- A simple binary counter is used to divide the 50MHz system clock and provide interrupt pulses.
//  --


// Note that because we are using clock enable we DO NOT need to synchronize with clk

 //  always @ (posedge clk)
 //  begin
 //      //--divide 50MHz by 50,000,000 to form 1Hz pulses
 //      if (int_count==(clk_freq_in_hz-1)) //clock enable
 //    begin
 //         int_count <= 0;
 //         event_1hz <= 1;
 //      end else
 //    begin
 //         int_count <= int_count + 1;
 //         event_1hz <= 0;
 //      end
 // end



 //interrupts

 always @ (posedge clk or posedge interrupt_ack)  //FF with clock "clk" and reset "interrupt_ack"
 begin
      if (interrupt_ack) //if we get reset, reset interrupt in order to wait for next clock.
            interrupt <= 0;
      else
    begin 
          if (interrupt_flag)   //clock enable
                interrupt <= 1;
              else
                interrupt <= interrupt;
      end
 end

//  --
//  ----------------------------------------------------------------------------------------------------------------------------------
//  -- KCPSM3 input ports 
//  ----------------------------------------------------------------------------------------------------------------------------------
//  --
//  --
//  -- The inputs connect via a pipelined multiplexer
//  --

 always @ (posedge clk)
 begin
    case (port_id[7:0])
        8'h00: in_port <= start_phoneme_flag;     //0000_0000 start_phoneme_flag PORT 00
        8'h02: in_port <= start_word_flag;        //0000_0010 start_word_flag PORT 02
        8'h40: in_port <= input_data;            //0100_0000 valid char PORT 40
        8'h20: in_port <= error_flag;            //0010_0000 error flag PORT 20
        default: in_port <= 8'bx;
    endcase
end
   
//
//  --
//  ----------------------------------------------------------------------------------------------------------------------------------
//  -- KCPSM3 output ports 
//  ----------------------------------------------------------------------------------------------------------------------------------
//  --
//  -- adding the output registers to the processor
//  --
//   
  always @ (posedge clk)
  begin

        //port 80 hex 
        if (write_strobe & port_id[7])  //1000_0000 phoneme_out PORT 80
          phoneme_out <= out_port;
        //port 01 hex 
        if (write_strobe & port_id[0])  //0000_0001 done_phoneme_flag PORT 01
          done_phoneme_flag <= out_port;

        //port 10 hex
        if (write_strobe & port_id[4])  //0001_0000 done_word_flag PORT 10
          done_word_flag <= out_port;
  end
endmodule
