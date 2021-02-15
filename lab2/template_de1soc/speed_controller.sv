module speed_controller(
	input logic clk50M,
	input logic init,
	input logic up,
	input logic down,
	output logic [31:0] div,
	input logic rst);

	parameter base = 32'h0471;
	
	initial begin
		div = base;
	end
	
	always @(posedge clk50M)
	begin
			
		if(rst)
			div <= base;
		else if(up)
			div <= div - 2;
		else if(down)
			div <= div + 2;
		else
			div <= div;
	end	
endmodule	