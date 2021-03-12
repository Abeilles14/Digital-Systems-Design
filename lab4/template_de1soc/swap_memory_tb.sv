module swap_memory_tb();
	logic clk;
	logic [7:0] address;		//s_mem address
	logic [7:0] data_in;		//data in s_mem data
	logic [7:0] data_out;		//data out s_mem q
	logic wren;				//write enable
	logic [23:0] secret_key;
	logic start_flag;
	logic done_flag;
	logic reset;

	swap_memory DUT (
	    .clk(clk),
	    .address(address),
	    .data_in(data_in),
	    .data_out(data_out),
	    .wren(wren),
	    .secret_key(secret_key),
	    .start_flag(start_flag),
	    .done_flag(done_flag),
	    .reset(reset));


	initial				//initial block
	begin
		data_out = 8'hFF;
		secret_key = 24'h000249;
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
      		//data_out = data_out + 8'h01;		//simulate data out of s_mem
    	end
  	end

  	initial
  	begin
  		#1000;
  	end
endmodule