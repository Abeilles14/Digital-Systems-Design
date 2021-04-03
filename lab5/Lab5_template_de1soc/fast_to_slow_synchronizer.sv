// module fast_to_slow_synchronizer #(parameter N = 12) (
// 	input logic clk1,
// 	input logic clk2,
// 	input logic [N-1:0] data_in,
// 	output logic [N-1:0] data_out
// 	);

// 	logic [N-1:0] reg1_out, reg3_out;
// 	logic clk_reg1_out, clk_reg2_out;
	
// 	FlopR #(12) Reg1(.clk(clk1), .en(1'b1), .d(data_in), .q(reg1_out));
// 	FlopR #(12) Reg3(.clk(clk1), .en(clk_reg2_out), .d(reg1_out), .q(reg3_out));
// 	FlopR #(12) Reg2(.clk(clk2), .en(1'b1), .d(reg3_out), .q(data_out));

// 	FlopR #(1) clk_Reg1(.clk(~clk1), .en(1'b1), .d(clk2), .q(clk_reg1_out));
// 	FlopR #(1) clk_Reg2(.clk(~clk1), .en(1'b1), .d(clk_reg1_out), .q(clk_reg2_out));
// endmodule

module fast_to_slow_synchronizer
(
input clk1,
input clk2,
input [11:0] data_in,
output [11:0] data_out
);
	
	logic [11:0] reg1_out, reg3_out;
	logic en, temp;
	
	vDFF #(12) reg1 (data_in,		reg1_out,  	1'b1, 	clk1 );
	vDFF #(12) reg3 (reg1_out, 	reg3_out, 	en,   	clk1, );
	vDFF #(12) reg2 (reg3_out,  	data_out,	1'b1, 	clk2,);
	
	vDFF #(1)  s1 	(clk2, temp,	 1'b1,		~clk1);
	vDFF #(1)  s2 	(temp, en,		 1'b1, 		~clk1);
	
endmodule



module vDFF (D, Q, en, clk);

	parameter n = 12;
	
	input [n-1:0] D;
	input en;
	input clk;
	
	output reg [n-1: 0] Q;
	
	always_ff@(posedge clk)
		if(en) 		Q <= D;
		else 				Q <= D;
	
endmodule

