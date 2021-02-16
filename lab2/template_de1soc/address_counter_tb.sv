module address_counter_tb();
	logic clk22K;
	logic dir;
	logic read_addr_start;
	logic addr_ready_flag;
	logic [22:0] current_address;
	logic [31:0] flash_data;
	logic [15:0] audio_out;
	logic reset;

	address_counter DUT(
		.clk22K(clk22K),
		.dir(dir),
		.read_addr_start(read_addr_start),	
		.addr_ready_flag(addr_ready_flag),
		.current_address(current_address),
		.flash_data(flash_data),
		.audio_out(audio_out),
		.reset(reset));

	initial				//initial block
	begin
		read_addr_start = 1'b1;
		dir = 1'b1;
		reset = 1'b0;

    	clk22K = 0;		//simulates clk every 5ps
    	#5;

    	forever
    	begin
      		clk22K = 1;			//simulate clk
      		#5;
      		clk22K = 0;
      		#5;
    	end
  	end

	initial begin
		#15;

		flash_data = 32'hBBBBAAAA;

		#20;
		flash_data = 32'hDDDDCCCC;

		#50;
	end
endmodule