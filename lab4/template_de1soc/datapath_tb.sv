module datapath_tb();
	logic clk;
	logic [7:0] s_mem_addr;
	logic [7:0] s_mem_data_in;
	logic [7:0] s_mem_data_out;
	logic s_mem_write;
	logic [23:0] secret_key;
	logic datapath_start_flag;
	logic reset_n;
	
	datapath DUT (
    .clk(clk),
    .s_mem_addr(s_mem_addr),
    .s_mem_data_in(s_mem_data_in),
    .s_mem_data_out(s_mem_data_out),
    .s_mem_write(s_mem_write),
    .secret_key(secret_key),
    .datapath_start_flag(datapath_start_flag),
    .reset(reset_n));


	initial				//initial block
	begin
		s_mem_data_out = 8'h00;
		secret_key = 24'h000249;
		datapath_start_flag = 1'b1;
		reset_n = 1'b0;

    	clk = 0;		//simulates clk every 5ps
    	#5;

    	forever
    	begin
      		clk = 1;			//simulate clk
      		#5;
      		clk = 0;
      		#5;
      		s_mem_data_out = s_mem_data_out + 8'h01;		//simulate data out of s_mem
    	end
  	end

	initial begin
		#3000;
		
		//wait (dut.state == 11'b000_0011_0000);
		// $stop;
	end
endmodule
