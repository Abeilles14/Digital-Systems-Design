module fast_to_slow_synchronizer #(parameter N = 12) (
	input logic clk1,
	input logic clk2,
	input logic [N-1:0] data_in,
	output logic [N-1:0] data_out
	);

	logic [N-1:0] reg1_out, reg3_out;
	logic clk_reg1_out, clk_reg2_out;
	
	FlopR #(12) Reg1(.clk(clk1), .en(1'b1), .d(data_in), .q(reg1_out));
	FlopR #(12) Reg3(.clk(clk1), .en(clk_reg2_out), .d(reg1_out), .q(reg3_out));
	FlopR #(12) Reg2(.clk(clk2), .en(1'b1), .d(reg3_out), .q(data_out));

	FlopR #(1) clk_Reg1(.clk(~clk1), .en(1'b1), .d(clk2), .q(clk_reg1_out));
	FlopR #(1) clk_Reg2(.clk(~clk1), .en(1'b1), .d(clk_reg1_out), .q(clk_reg2_out));
endmodule

module FlopR #(parameter N = 12) (
	input logic clk,
	input logic en,
	input logic [N-1:0] d,
	output logic [N-1:0] q);
	
	always_ff @(posedge clk)
	begin
		q <= en ? d : q;
	end
endmodule

