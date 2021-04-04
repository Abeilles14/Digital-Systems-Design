module clock_divider_tb ();
	logic inclk;
	logic outclk;
	logic [31:0] div_clk_count;
	logic reset;

	clock_divider DUT(
		.inclk(inclk),
		.div_clk_count(div_clk_count),
		.outclk(outclk),
		.reset(reset));
	
	initial				//initial block
	begin
		reset = 1'b1;
		div_clk_count = 32'h17D7840;	//25M for 1hz clk

    	inclk = 0;		//simulates clk every 5ps
    	#5;
    	forever
    	begin
      		inclk = 1 ;			//simulate clk
      		#5;
      		inclk = 0 ;
      		#5;
    	end
  	end

	initial
	begin
		#1000;
	end
endmodule