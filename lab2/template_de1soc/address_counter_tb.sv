module address_counter_tb();
	logic clk;				//50 MHz
	logic direction_flag;				//going fwd or bck
	logic flash_mem_read;		//flag to check if ready to read next addr
	logic [22:0] read_address;		//address to read data from
	logic addr_retrieved_flag;	//address has been read
	logic reset_flag;

	address_counter DUT(
		.clk(clk),				//50 MHz
		.dir(direction_flag),				//going fwd or bck
		.read_addr_flag(flash_mem_read),		//flag to check if ready to read next addr
		.current_address(read_address),
		.addr_retrieved_flag(addr_retrieved_flag),		//address to read data from
		.reset(reset_flag));

	initial				//initial block
	begin
		reset_flag = 1'b0;
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

	initial begin
		direction_flag = 1'b1;
		flash_mem_read = 1'b0;
		#5;

		flash_mem_read = 1'b1;
		#5;
		$display("Address retrieved flag: %b, expected %d", addr_retrieved_flag, 1'b1);
		$display("Current address: %b", read_address);

		flash_mem_read = 1'b0;
		#10;
		$display("Address retrieved flag: %b, expected %d", addr_retrieved_flag, 1'b0);
		$display("Current address: %b", read_address);

		flash_mem_read = 1'b1;
		#5;
		$display("Address retrieved flag: %b, expected %d", addr_retrieved_flag, 1'b0);
		$display("Current address: %b", read_address);
		#10;

		$display("Address retrieved flag: %b, expected %d", addr_retrieved_flag, 1'b1);
		$display("Current address: %b", read_address);
	end
endmodule