module hw1 (
	input logic vcc,
	input logic gnd,
	input logic async_sig,
	input logic outclk,
	output out_sync_sig);
	
	//assign vcc = 1'b1;
	//assign gnd = 1'b0;

	wire fdc_aq, fdc_bq, fdc_1q;
	
	FlopR FDC_A(async_sig, fdc_1q, vcc, fdc_aq);
	FlopR FDC_B(outclk, gnd, fdc_aq, fdc_bq);
	FlopR FDC_C(outclk, gnd, fdc_bq, out_sync_sig);
	FlopR FDC_1(outclk, gnd, out_sync_sig, fdc_1q);
endmodule

module FlopR (
	input logic clk,
	input logic clr,
	input logic d,
	output logic q);
	
	always_ff @(posedge clk, posedge clr)
		if(clr) q <= 1'b0;
		else q <= d;
endmodule

