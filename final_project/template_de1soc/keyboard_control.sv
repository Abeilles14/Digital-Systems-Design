`define F_E 4'b0011		//play forward
`define F_D	4'b0010		//pause going forward

module keyboard_control
	(input logic clk,
	 input logic read_keyboard_flag,		//sync with 7200hz clk
	 input logic [7:0] character,			//keyboard input ascii
	 output logic read_addr_start,			//play/pause
	 output logic reset);

	logic start, restart;
	logic [3:0] state;

	// parameter IDLE = 4'b0000;
	// parameter WAIT_DIGIT_1 = 4'b0001;
	// parameter WAIT_SIGN = 4'b0010;
	// parameter WAIT_DIGIT_2 = 4'b0011;
	// parameter WAIT_EQUAL = 4'b0100;
	// parameter CALCULATE = 4'b0101;
	// parameter DONE = 4'b0110;

	parameter character_D =8'h44;
	parameter character_E =8'h45;

	assign start = state[0];
	assign restart = state[2];

	initial begin
        state = `F_E;		//initially start forward enabled
    end

	always_ff @(posedge read_keyboard_flag)
	begin
		case(state)
			`F_E: begin
				case(character)
					character_D:
						state <= `F_D;
					default:
						state <= `F_E;
				endcase
			end
			`F_D: begin
				case(character)
					character_E:
						state <= `F_E;
					default:
						state <= `F_D;
				endcase
			end
			default:
				state <= `F_D;
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		read_addr_start <= start;
		reset <= restart;
	end
endmodule