module LFSR(
	input logic clk,
	output logic [4:0] lfsr
);

initial begin
	lfsr = 5'b00001;
end

always @(posedge clk) begin
	lfsr <= lfsr >> 1;				//shift registers every posedge
	lfsr[4] <= lfsr[0] ^ lfsr[2];	//xor rap lfsr[0] and lfsr[2]
end
endmodule
