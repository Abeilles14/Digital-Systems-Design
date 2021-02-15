module speed_controller(
	input logic clk50M,
	input logic up,
	input logic down,
	output logic [31:0] div,
	input logic rst);

	parameter div_clk_22khz = 32'h0265;		//sampling rate for 27M
	
	initial begin
		div = div_clk_22khz;
	end
	
	always @(posedge clk50M)
	begin
			
		if(rst)
			div <= div_clk_22khz;
		else if(up)
			div <= div - 2;
		else if(down)
			div <= div + 2;
		else
			div <= div;
	end	
endmodule	