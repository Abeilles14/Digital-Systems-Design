	// radix define States {
	// 	11'b000_0000_0000 "IDLE",
	// 	11'b000_0001_0000 "SET_I_ADDR",
	// 	11'b000_0010_0000 "WAIT_I_ADDR",
	// 	11'b000_0011_0000 "GET_I_DATA",
	// 	11'b000_0100_0000 "SET_J_ADDR",
	// 	11'b000_0101_0000 "WAIT_J_ADDR",
	// 	11'b000_0110_0000 "GET_J_DATA",
	// 	11'b000_0111_0010 "SET_SWAP_I_ADDR",
	// 	11'b000_1000_0010 "SWAP_DATA_I",
	// 	11'b000_1001_0000 "SET_SWAP_J_ADDR",
	// 	11'b000_1010_0010 "SWAP_DATA_J",
	// 	11'b001_1011_0000 "SET_F_ADDR",
	// 	11'b000_1100_0000 "WAIT_F_ADDR",
	// 	11'b000_1101_0000 "GET_F_VALUE",
	// 	11'b000_1110_0000 "SET_K_ADDR",
	// 	11'b000_1111_0000 "WAIT_K_ADDR",
	// 	11'b001_0000_0100 "DECRYPT",
	// 	11'b001_0001_0100 "VALIDATE",
	// 	11'b001_0011_0000 "INCREMENT",
	// 	11'b001_0100_0001 "DONE",
	//  -default hex
	// }

module decrypt_memory_tb();
	logic clk;
	logic [7:0] address;		//s_mem address
	logic [7:0] s_data_in;		//data in s_mem data
	logic [7:0] s_data_out;		//data out s_mem q
	logic [7:0] d_data_in;		//data in decrypted RAM d_mem data
	logic [7:0] d_data_out;		//data out decrypted RAM d_mem data
	logic [7:0] e_data_out;		//data out encrypted ROM e_mem q
	logic s_wren;				//s write enable
	logic d_wren;				//d write enable
	logic start_flag;
	logic done_flag;
	logic reset;

	decrypt_memory DUT (
	    .clk(clk),
	    .address(address),
	    .s_data_in(s_data_in),
	    .s_data_out(s_data_out),
	    .d_data_in(d_data_in),
	    .d_data_out(d_data_out),
	    .e_data_out(e_data_out),
	    .s_wren(s_wren),
	    .d_wren(d_wren),
	    .start_flag(start_flag),
	    .done_flag(done_flag),
	    .reset(reset));

	initial				//initial block
	begin
		s_data_out = 8'hxx;
		d_data_out = 8'hxx;
		e_data_out = 8'h2D;
		start_flag = 1'b1;
		reset = 1'b0;

    	clk = 0;		//simulates clk every 5ps
    	#5;

    	forever
    	begin
      		clk = 1;			//simulate clk
      		#5;
      		clk = 0;
      		#5;
    	end
  	end

  	initial
  	begin
  		#25	
  		s_data_out = 8'hA8;	//GET_I_DATA

  		#40
  		s_data_out = 8'h59;	//GET_J_DATA

  		#30
  		s_data_out = 8'hA8; //

  		#30
  		s_data_out = 8'h59; //get_F_VALUE

  		#30
  		d_data_out = 8'h74;	//DECRYPT
  		#10000;
  	end
endmodule