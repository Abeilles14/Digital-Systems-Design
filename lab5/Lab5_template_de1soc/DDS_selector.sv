module DDS_selector(
	input logic clk,
	input logic reset,
	input logic en,
	input logic lfsr,
	input logic [31:0] phase_inc,
	input logic [7:0] sig_sel,
	input logic [3:0] mod_sel,
	output logic [11:0] sig_out,
	output logic [11:0] mod_out
);

logic [11:0] sin_out;
logic [11:0] cos_out;
logic [11:0] squ_out;
logic [11:0] saw_out;

waveform_gen waveform(
	.clk(clk),
	.reset(reset),
	.en(en),
	.phase_inc(phase_inc),
	.sin_out(sin_out),
	.cos_out(cos_out),
	.squ_out(squ_out),
	.saw_out(saw_out));


initial begin
	mod_out = 12'b0;
	sig_out = 12'b0;
end

always @(posedge clk) begin
	case(sig_sel)				//select signal (sin, cos, saw, squ)
		8'b0000_0000: sig_out <= sin_out;
		8'b0000_0001: sig_out <= cos_out;
		8'b0000_0010: sig_out <= saw_out;
		8'b0000_0011: sig_out <= squ_out;
		default: sig_out <= 12'b0;
	endcase

	case(mod_sel)		//select modulation (ask, fsk, bpsk, lfsr)
		4'b0000: mod_out <= lfsr ? sin_out : 12'b0;		//ask
		4'b0001: mod_out <= 12'b0;			//fsk??
		4'b0010: mod_out <= lfsr ? sin_out : (~sin_out + 1'b1);  //bpsk - 2s complement of sin wave
		4'b0011: mod_out <= lfsr ? 12'b0 : 12'b1000_0000_0000;		//lfsr
		default: mod_out <= 12'b0;
	endcase
end
endmodule