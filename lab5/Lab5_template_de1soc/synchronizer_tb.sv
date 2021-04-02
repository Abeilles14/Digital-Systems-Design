//synchronizer tb

module synchronizer_tb();
	logic vcc;
	logic gnd;
	logic async_sig;
	logic outclk;
	logic out_sync_sig;

	synchronizer DUT(
		.vcc(vcc),
		.gnd(gnd),
		.async_sig(async_sig),
		.outclk(outclk),
		.out_sync_sig(out_sync_sig));

	initial				//initial block
	begin
		vcc = 1'b1;
		gnd = 1'b0;

    	outclk = 0;		//simulates clk every 5ps
    	#5;
    	forever
    	begin
      		outclk = 1 ;			//simulate clk
      		#5;
      		outclk = 0 ;
      		#5;
    	end
  	end

  	initial				//initial block
	begin
    	async_sig = 0;		//simulates clk every 15ps
    	#15;
    	forever
    	begin
      		async_sig = 1 ;			//simulate clk
      		#15;
      		async_sig = 0 ;
      		#15;
    	end
  	end
endmodule
