module read_flash_tb();
	logic clk50M;               //50 MHz
    logic clk22K;
    logic start_read_flag;
    logic addr_retrieved_flag;
    logic read_data_flag;
    logic read_addr_flag;
    logic [31:0] flash_data;
    logic [15:0] audio_out;
    logic reset;

	read_flash DUT(
		.clk50M(clk50M),               //50 MHz
		.clk22K(clk22K),
		.start_read_flag(start_read_flag),
		.addr_retrieved_flag(addr_retrieved_flag),
	    .read_data_flag(read_data_flag),
	    .read_addr_flag(read_addr_flag),
		.flash_data(flash_data),
		.audio_out(audio_out),
		.reset(reset));


	initial				//initial block
	begin
		reset = 1'b0;
		start_read_flag = 1'b0;
		addr_retrieved_flag = 1'b0;
		read_data_flag = 1'b0;

    	clk50M = 0;		//simulates clk every 5ps
    	#5;
    	forever
    	begin
      		clk50M = 1 ;			//simulate clk
      		#5;
      		clk50M = 0 ;
      		#5;
    	end
  	end

  	initial				//initial block
	begin
    	clk22K = 0;		//simulates clk every 15ps
    	#15;
    	forever
    	begin
      		clk22K = 1 ;			//simulate clk
      		#15;
      		clk22K = 0 ;
      		#15;
    	end
  	end


	initial begin
		//IDLE 00_000 #0
		#5;
		start_read_flag = 1'b1;

		//READ_ADDR 00_001 #5
		#15;
		start_read_flag = 1'b0;
		addr_retrieved_flag = 1'b1;
		#5;

		//WAIT_DATA_READ 10_000 #25
		#10;
		addr_retrieved_flag = 1'b0;
		read_data_flag = 1'b1;
		flash_data = 32'hBBBBAAAA;

		//WAIT_CLK_22K_EVEN 01_000 #35
		#15;
		read_data_flag = 1'b0;

		//READ_DATA_EVEN 00_110 #45
		$display("audio_out is %h, expected %h", audio_out, 16'hAAAA);

		//WAIT_CLK_22K_ODD 11_000 #55
		#15;

		//READ_DATA_ODD 00_010 #75
		#25;
		$display("audio_out is %h, expected %h", audio_out, 16'hBBBB);

		#40;
	end
endmodule