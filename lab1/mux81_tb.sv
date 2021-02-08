parameter do_freq = 32'hBAB9;
parameter re_freq = 32'hA65D;
parameter mi_freq = 32'h9430;
parameter fa_freq = 32'h8BE8;
parameter sol_freq = 32'h7CB8;
parameter la_freq = 32'h6EF9;
parameter si_freq = 32'h62F1;
parameter do2_freq = 32'h5D5D;

module mux81_tb ();
	logic [32:0] d0, d1, d2, d3, d4, d5, d6, d7;
	logic [2:0] s;
	logic [32:0] q;

	MUX_81 DUT(
		.d0(do_freq),
		.d1(re_freq),
		.d2(mi_freq),
		.d3(fa_freq),
		.d4(sol_freq),
		.d5(la_freq),
		.d6(si_freq),
		.d7(do2_freq),
		.s(s),
		.q(q));

	initial
	begin
		s = 3'b000;		//Do
		#5
		$display("Output is %h, expected %h", q, 32'hBAB9);

		s = 3'b001;		//Re
		#5
		$display("Output is %h, expected %h", q, 32'hA65D);

		s = 3'b010;		//Mi
		#5
		$display("Output is %h, expected %h", q, 32'h9430);

		s = 3'b011;		//Fa
		#5
		$display("Output is %h, expected %h", q, 32'h8BE8);

		s = 3'b100;		//Sol
		#5
		$display("Output is %h, expected %h", q, 32'h7CB8);

		s = 3'b101;		//La
		#5
		$display("Output is %h, expected %h", q, 32'h6EF9);

		s = 3'b110;		//Si
		#5
		$display("Output is %h, expected %h", q, 32'h62F1);

		s = 3'b111;		//Do2
		#5
		$display("Output is %h, expected %h", q, 32'h5D5D);
	end
	$stop;
endmodule
