//trap rising edge of async_sig and synchronize it to clk, output trapped_edge
//trapped edge high until async reset asserted
module trap_edge(
	input logic async_sig,
	input logic clk,
	output logic trapped_edge,
	input logic reset);

	logic trap;

always_ff @(posedge async_sig or posedge reset)
begin
	if(reset)
		trapped_edge <= 1'b0;
	else
		trap <= 1'b1;
end

always_ff @(posedge clk)
begin
	trapped_edge <= trap;
end
endmodule