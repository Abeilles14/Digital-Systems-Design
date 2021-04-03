module DDS(
	input logic clk,
	input logic reset,
	input logic en,
	input logic lfsr,
	input logic [31:0] phase_inc,
	output logic [11:0] sin_out,
	output logic [11:0] cos_out,
	output logic [11:0] squ_out,
	output logic [11:0] saw_out,
	output logic [11:0] ask_out,
	output logic [11:0] bpsk_out
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

//generate ASK (OOK) and BPSK signals
initial begin
	ask_out = 12'b0;
	bpsk_out = 12'b0;
end

always @(posedge clk) begin
	if(lfsr == 1'b1)				//modulated carrier
	begin
		ask_out <= sin_out;			//amplitude shift keying (ASK  or OOK), ask = sin wave
		//fsk_out <= 12'b0;
		bpsk_out <= sin_out;
	end
	else
	begin
		ask_out <= 12'b0;				//if mod = 0, ask = 0
		bpsk_out <= ~sin_out + 1'b1;	//2s complement of sin wave
	end
end
endmodule