module LFSR_tb();
	logic clk;
	logic [4:0] lfsr;

	LFSR DUT(
		.clk(clk),
		.lfsr(lfsr));

	initial				//initial block
	begin
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

  	initial
  	begin
  		#1000;
  	end
endmodule