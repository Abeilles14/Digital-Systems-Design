module DDS(
	input logic clk,
	input logic reset,
	input logic en,
	input logic [31:0] phase_inc,
	output logic [11:0] sin_out,
	output logic [11:0] cos_out,
	output logic [11:0] squ_out,
	output logic [11:0] saw_out
);

waveform_gen waveform(
	.clk(clk),
	.reset(reset),
	.en(en),
	.phase_inc(phase_inc),
	.sin_out(sin_out),
	.cos_out(cos_out),
	.squ_out(squ_out),
	.saw_out(saw_out));

// always @(posedge clk) begin

// end
endmodule