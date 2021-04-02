module scope_selector(
	input logic clk,
	input logic [3:0] sig_sel,
	input logic [3:0] mod_sel,
	input logic [11:0] sin_sig,
	input logic [11:0] cos_sig,
	input logic [11:0] saw_sig,
	input logic [11:0] squ_sig,
	input logic [11:0] ask_mod,
	//input logic [11:0] fsk_mod,
	input logic [11:0] bpsk_mod,
	input logic lfsr_mod,
	output logic [11:0] sig_out,
	output logic [11:0] mod_out
);

initial begin
	mod_out = 12'b0;
	sig_out = 12'b0;
end

always @(posedge clk) begin
	case(sig_sel)				//select signal (sin, cos, saw, squ)
		4'b0000: begin
			sig_out <= sin_sig;
		end
		4'b0001: begin
			sig_out <= cos_sig;
		end
		4'b0010: begin
			sig_out <= saw_sig;
		end
		4'b0011: begin
			sig_out <= squ_sig;
		end
		default: begin
			sig_out <= 12'b0;
		end
	endcase

	case(mod_sel)		//select modulation (ask, fsk, bpsk, lfsr)
		4'b0000: begin
			mod_out <= ask_mod;
		end
		4'b0001: begin
			mod_out <= sin_sig;			//fsk - same as sin wave
		end
		4'b0010: begin
			mod_out <= bpsk_mod;
		end
		4'b0011: begin
			mod_out <= lfsr_mod ? 12'b1000_0000_0000 : 12'b0;		//lfsr
		end
		default: begin
			mod_out <= 12'b0;
		end
	endcase
end
endmodule