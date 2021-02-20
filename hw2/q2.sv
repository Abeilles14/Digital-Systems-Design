module fsm2 (Out1, Out2, goto_third, state, odd, even, terminal, pause, restart, clk, rst);
	input goto_third, pause, restart, clk, rst;
	output [2:0] Out1, Out2;
	output odd, even, terminal;
	output [8:0] state;

	logic [8:0] state;
	logic odd, even, terminal;

	parameter [8:0] FIRST = 9'b0_011_010_0_1;		//terminal_Out1_Out2_even_odd
	parameter [8:0] SECOND = 9'b0_101_100_1_0;
	parameter [8:0] THIRD = 9'b0_010_111_0_1;
	parameter [8:0] FOURTH = 9'b0_110_011_1_0;
	parameter [8:0] FIFTH = 9'b1_101_010_0_1;

	always_ff @(posedge clk or posedge rst) // sequential
	begin
		if (rst) state <= FIRST;
	else
		begin
			case(state)
				FIRST: 
					if (restart|pause) state <= FIRST;
					else state <= SECOND;
				SECOND: 
					if (restart) state <= FIRST;
					else if (pause) state <= SECOND;
					else state <= THIRD;
				THIRD:
					if (restart) state <= FIRST;
					else if (pause) state <= THIRD;
					else state <= FOURTH ;
				FOURTH:
					if (restart) state <= FIRST;
					else if (pause) state <= FOURTH;
					else state <= FIFTH;
				FIFTH:
					if (goto_third) state <= THIRD;
					else if (restart) state <= FIRST;
					else state <= FIFTH;
				default: state <= FIRST;
			endcase
		end
	end
	
	// output logic described using procedural assignment
	always_comb begin
		terminal = state[8];
		Out1 = state[7:5];
		Out2 = state[4:2];
		even = state[1];
		odd = state[0];
	end
endmodule