module init_memory_tb();
	logic clk;
	logic [7:0] address;
	logic [7:0] data;
	logic wren;
	logic start_flag;
	logic done_flag;
	logic reset;

	init_memory DUT(
		.clk(clk),
		.address(address),
		.data(data),
		.wren(wren),
		.start_flag(start_flag),
		.done_flag(done_flag),
		.reset(reset));

	initial				//initial block
	begin
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
  		#1000;
  	end
endmodule