	// radix define States {
	// 	7'b000_0000 "IDLE",
	// 	7'b001_0001 "S_MEM_INIT",
	// 	7'b010_0010 "S_MEM_SWAP",
	// 	7'b011_0100 "S_MEM_DECRYPT",
	// 	7'b100_1000 "DONE",
	//  -default hex
	// }

module datapath_tb();
	logic clk;
	logic [23:0] secret_key;
	logic [23:0] key_start_value;
	logic key_found_flag;
	logic datapath_start_flag;
	logic datapath_done_flag;
	logic stop;
	logic reset;
	
	datapath DUT (
    .clk(clk),
    .secret_key(secret_key),
    .key_start_value(key_start_value),
    .key_found_flag(key_found_flag),
    .datapath_start_flag(datapath_start_flag),
    .datapath_done_flag(datapath_done_flag),
    .stop(stop),
    .reset(reset));

	initial				//initial block
	begin
		datapath_start_flag = 1'b1;
		key_start_value = 24'h000000;
		stop = 1'b0;
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

	initial begin
		#100000;
		//wait (dut.state == 11'b000_0011_0000);
		// $stop;
	end
endmodule
