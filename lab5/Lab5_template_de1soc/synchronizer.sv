//sync data output to CLK_50
//from HW1
module synchronizer (
	input logic vcc,
	input logic gnd,
	input logic async_sig,
	input logic outclk,
	output logic out_sync_sig);

	wire fdc_aq, fdc_bq, fdc_1q;
	
	FlopR #(1) FDC_A(async_sig, fdc_1q, vcc, fdc_aq);
	FlopR #(1) FDC_B(outclk, gnd, fdc_aq, fdc_bq);
	FlopR #(1) FDC_C(outclk, gnd, fdc_bq, out_sync_sig);
	FlopR #(1) FDC_1(outclk, gnd, out_sync_sig, fdc_1q);
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
