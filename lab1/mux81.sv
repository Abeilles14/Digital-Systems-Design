//frequency and label selector 8 to 1 mux
module MUX_81 #(parameter N = 32)
	(input logic [N-1:0] d0, d1, d2, d3, d4, d5, d6, d7,
	input logic [2:0] s,
	output logic [N-1:0] q);

	always_comb
		case(s)
			3'b000: q = d0;
			3'b001: q = d1;
			3'b010: q = d2;
			3'b011: q = d3;
			3'b100: q = d4;
			3'b101: q = d5;
			3'b110: q = d6;
			3'b111: q = d7;
			default: q = {N{1'b0}};
		endcase
endmodule