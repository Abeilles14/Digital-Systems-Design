module fast_to_slow_synchronizer_tb();
	logic clk1;
	logic clk2;
	logic [11:0] data_in;
  logic [11:0] data_out;

	fast_to_slow_synchronizer DUT(
		.clk1(clk1),
    .clk2(clk2),
    .data_in(data_in),
    .data_out(data_out));

	initial				//initial block
	begin
    data_in = 12'b0000_0000_0001;

    clk1 = 0;		//simulates clk every 5ps
    #5;
    forever
    begin
   		clk1 = 1 ;			//simulate clk
  		#5;
  		clk1 = 0 ;
  		#5;
    end
  end

  initial				//initial block
	begin
    clk2 = 0;
    #15;
    forever
  	begin
    	clk2 = 1 ;			//simulate clk
      #15;
      clk2 = 0 ;
      #15;
    end
  end
endmodule
