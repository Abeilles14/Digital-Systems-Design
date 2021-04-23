module address_counter_tb();
	logic clk22K;
	logic dir;
	logic read_addr_start;
	logic addr_ready_flag;
	logic [22:0] current_address;
	logic [31:0] flash_data;
	logic [7:0] audio_out;
	logic [23:0] start_addr;
	logic [23:0] end_addr;
	logic silent_flag;
	logic picoblaze_start_flag;
	logic picoblaze_done_flag;
	logic reset;

	address_counter DUT(
		.clk22K(clk22K),
		.dir(dir),
		.read_addr_start(read_addr_start),	
		.addr_ready_flag(addr_ready_flag),
		.current_address(current_address),
		.flash_data(flash_data),
		.audio_out(audio_out),
		.start_addr(start_addr),
		.end_addr(end_addr),
		.silent_flag(silent_flag),
		.picoblaze_start_flag(picoblaze_start_flag),
		.picoblaze_done_flag(picoblaze_done_flag),
		.reset(reset));

	FLASH memory(
		.clk(clk22K),
		.address(current_address),
		.q(flash_data));

	initial				//initial block
	begin
		read_addr_start = 1'b1;

		start_addr = 23'd6;
		end_addr = 23'd8;
		silent_flag = 1'b0;

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
		#20;

		#5000;
	end
endmodule