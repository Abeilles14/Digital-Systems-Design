//freq divider tb
module freq_divider_tb ();
	logic inclk;
	logic outclk;
	logic [31:0] div_clk_count;
	logic reset;

	freq_divider DUT(
		.inclk(inclk),
		.div_clk_count(div_clk_count),
		.outclk(outclk),
		.reset(reset));
	
	initial				//initial block
	begin
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
		reset = 1'b1;

		div_clk_count = 32'h0471;	//high at 11000ps
		//32'hBAB9 //523Hz
		#5
		$display("Output is %d, expected %d", outclk, 0);		//ps delay count for 523Hz

		//wait for 478015ps
		#478015;
		$display("Output is %d, expected %d", outclk, 1);		//clk_count has reached 32'hBAB9, reset count to 0
	end
	$stop;
endmodule
