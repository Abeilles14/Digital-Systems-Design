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
	logic [7:0] s_mem_addr;
	logic [7:0] s_mem_data_in;
	logic [7:0] s_mem_data_out;
	logic s_mem_write;
	logic [7:0] d_mem_addr;
	logic [7:0] d_mem_data_in;
	logic [7:0] d_mem_data_out;
	logic d_mem_write;
	logic [7:0] e_mem_addr;
	logic [7:0] e_mem_data_out;
	logic [23:0] secret_key;
	logic key_flag;
	logic datapath_start_flag;
	logic datapath_done_flag;
	logic reset;
	
	datapath DUT (
    .clk(clk),
    .s_mem_addr(s_mem_addr),
    .s_mem_data_in(s_mem_data_in),
    .s_mem_data_out(s_mem_data_out),
    .s_mem_write(s_mem_write),
    .d_mem_addr(s_mem_addr),
    .d_mem_data_in(s_mem_data_in),
    .d_mem_data_out(s_mem_data_out),
    .d_mem_write(s_mem_write),
    .e_mem_addr(e_mem_addr),
    .e_mem_data_out(e_mem_data_out),
    .secret_key(secret_key),
    .key_flag(key_flag),
    .datapath_start_flag(datapath_start_flag),
    .datapath_done_flag(datapath_done_flag),
    .reset(reset));


	initial				//initial block
	begin
		s_mem_data_out = 8'h00;
		d_mem_data_out = 8'h00;
		e_mem_data_out = 8'h00;
		secret_key = 24'h000249;
		datapath_start_flag = 1'b1;
		reset = 1'b0;

    	clk = 0;		//simulates clk every 5ps
    	#5;

    	forever
    	begin
      		clk = 1;			//simulate clk
      		#5;
      		clk = 0;
      		#5;
      		//s_mem_data_out = s_mem_data_out + 8'h01;		//simulate data out of s_mem
    	end
  	end

	initial begin
		s_mem_data_out = 8'hAA;
		d_mem_data_out = 8'hBB;
		e_mem_data_out = 8'hCC;
		#3000;
		//wait (dut.state == 11'b000_0011_0000);
		// $stop;
	end
endmodule
