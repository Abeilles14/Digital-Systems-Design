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
  		s_data_out = 8'hA8;

  		#30
  		s_data_out = 8'h59; //get_F_VALUE

  		#30
  		d_data_out = 8'h74;	//DECRYPT
  		#10000;
  	end
endmodule