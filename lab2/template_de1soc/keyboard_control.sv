`define F_E 3'b011		//play forward
`define F_D	3'b010		//pause going forward

`define B_E 3'b001		//play backward
`define B_D 3'b000		//pause going backward

`define F_R	3'b111		//reset going forward
`define B_R	3'b101		//reset going backward

module keyboard_control
	(input logic clk22K,
	 input logic read_keyboard_flag,
	 input logic [7:0] character,
	 output logic read_addr_start,
	 output logic dir,
	 output logic reset);

	logic start, restart, direction;
	logic [2:0] state;

	parameter character_B =8'h42;
	parameter character_D =8'h44;
	parameter character_E =8'h45;
	parameter character_F =8'h46;
	parameter character_R =8'h52;

	assign start = state[0];
	assign direction = state[1];
	assign restart = state[2];

	initial begin
        state = `F_D;		//initially wait for keyboard input E to go forward
    end

	always_ff @(posedge read_keyboard_flag)
	begin
		case(state)
			`F_E: begin
				case(character)
					character_D:
						state <= `F_D;
					character_B:
						state <= `B_E;
					character_R:
						state <= `F_R;
					default:
						state <= `F_E;
				endcase
			end
			`F_D: begin
				case(character)
					character_E:
						state <= `F_E;
					character_B:
						state <= `B_D;
					character_R:
						state <= `F_R;
					default:
						state <= `F_D;
				endcase
			end
			`B_E: begin
				case(character)
					character_D:
						state <= `B_D;
					character_F:
						state <= `F_E;
					character_R:
						state <= `B_R;
					default:
						state <= `B_E;
				endcase
			end
			`B_D: begin
				case(character)
					character_E:
						state <= `B_E;
					character_F:
						state <= `F_D;
					character_R:
						state <= `B_R;
					default:
						state <= `B_D;
				endcase
			end
			`F_R: begin
				state <= `F_E;
			end	
			`B_R: begin
				state <= `B_E;
			end	
			default:
				state <= `F_D;
		endcase
	end
	
	always_ff @(posedge clk22K)
	begin
		read_addr_start <= start;
		dir <= direction;
		reset <= restart;
	end
endmodule