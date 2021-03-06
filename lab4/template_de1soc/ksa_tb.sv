module ksa_tb();
logic clk, reset_n;						
logic s_mem_write, d_mem_write, datapath_start_flag, datapath_done_flag, key_found_flag;
logic [7:0] s_mem_addr, s_mem_data_in, s_mem_data_out;
logic [7:0] d_mem_addr, d_mem_data_in, d_mem_data_out;
logic [7:0] e_mem_addr, e_mem_data_out;
logic [23:0] secret_key;


s_memory s_mem_DUT (
    .address(s_mem_addr),
    .clock(clk),
    .data(s_mem_data_in),
    .wren(s_mem_write),
    .q(s_mem_data_out));

  // TEST BENCH
    
    RAM s_mem (address, clk, data, wren, q);

    RAM #(.ADDR_WIDTH(5), .DATA_WIDTH(8), .DEPTH(32)) d_mem (decryptionAddress, clk, decryptionData, decryptionWrite, decryptedOutput);

    ROM #(.ADDR_WIDTH(5), .DATA_WIDTH(8), .DEPTH(32)) e_mem (messageAddress, clk, messageMem);

datapath DUT (
    .clk(clk),
    .s_mem_addr(s_mem_addr),
    .s_mem_data_in(s_mem_data_in),
    .s_mem_data_out(s_mem_data_out),
    .s_mem_write(s_mem_write),
    .secret_key(secret_key),
    .datapath_start_flag(datapath_start_flag),
    .reset(!reset_n));
    

    initial				//initial block
	begin
		reset_n = 1'b1;
		secret_key = 24'h000249;
		datapath_start_flag = 1'b1;

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
		#5000;
	end
endmodule