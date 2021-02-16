module read_flash_tb();
	logic clk50M;
    logic start_read_flag;
    logic read_data_flag;
    logic read_addr_flag;
    logic [31:0] flash_data_in;
    logic [31:0] flash_data_out;


	read_flash DUT(
		.clk50M(clk50M),
		.start_read_flag(start_read_flag),			//in
		.read_data_flag(read_data_flag),	//in
	    .read_addr_flag(read_addr_flag),			//out
		.flash_data_in(flash_data_in),			//in
		.flash_data_out(flash_data_out));			//out

	initial				//initial block
	begin
		start_read_flag = 1'b0;
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

	initial begin
		//IDLE 3'b000
		#5;
		start_read_flag = 1'b1;

		//READ_ADDR 3'b001
		#10;
		read_data_flag = 1'b1;
		start_read_flag = 1'b0;

		//READ_DATA 3'b011
		flash_data_in = 32'hBBBBAAAA;
		#15;

		//IDLE 3'b000
		read_data_flag = 1'b0;
		#40;
	end
endmodule