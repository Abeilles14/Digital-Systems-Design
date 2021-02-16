module speed_controller(
	input logic clk50M,
	input logic up,
	input logic down,
	output logic [31:0] div,
	input logic rst);

	//parameter clk_22khz_freq_50M = 32'h0471;
	//parameter clk_44khz_freq_50M = 32'h0238;
	//parameter div_clk_22khz_27M = 32'h0265;		//sampling rate for 22khz 27M
	parameter div_clk_44khz_27M = 32'h0132;			//sampling rate for 44khz 27M
	
	initial begin
		div = div_clk_44khz_27M;
	end
	
	always @(posedge clk50M)
	begin
			
		if(rst)
			div <= div_clk_44khz_27M;
		else if(up)
			div <= div - 2;
		else if(down)
			div <= div + 2;
		else
			div <= div;
	end	
endmodule	