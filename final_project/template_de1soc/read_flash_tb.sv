module read_flash_tb();
	logic clk;
    logic start_read_flag;
    logic read_data_valid;
    logic read_data_flag;
    logic done_read_flag;


	read_flash DUT(
		.clk(clk),
		.start_read_flag(start_read_flag),
		.read_data_valid(read_data_valid),
	    .read_data_flag(read_data_flag),	
		.done_read_flag(done_read_flag));		

	initial				//initial block
	begin
		start_read_flag = 1'b0;
		read_data_flag = 1'b0;
		read_data_valid = 1'b0;

    	clk = 0;		//simulates clk every 5ps
    	#5;
    	forever
    	begin
      		clk = 1 ;			//simulate clk
      		#5;
      		clk = 0 ;
      		#5;
    	end
  	end

	initial begin
		//IDLE
		start_read_flag = 1'b1;

		//READ_DATA
		#20;
		read_data_flag = 1'b1;
		start_read_flag = 1'b0;

		#20
		//WAIT_READ_DATA
		read_data_valid = 1'b1;
		#15;

		//IDLE
		read_data_flag = 1'b0;
		#5000;
	end
endmodule