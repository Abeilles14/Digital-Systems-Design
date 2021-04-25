`define F_E 4'b0011		//play forward
`define F_D	4'b0010		//pause going forward

module keyboard_control
	(input logic clk,
	 input logic read_keyboard_flag,		//key stroke detected
	 input logic [7:0] character,			//keyboard input ascii
	 output logic [7:0] valid_char,			//keyboard output ascii
	 output logic error_flag,				//if char not valid
	 output logic read_addr_start,			//play/pause
	 input logic audio_done_flag,
	 output logic led0);

	logic [4:0] state;

	parameter IDLE = 5'b000_00;
	parameter WAIT_DIGIT_1 = 5'b001_00;
	parameter WAIT_AUDIO = 5'b010_01;

	parameter WAIT_SIGN = 5'b011_00;
	parameter WAIT_DIGIT_2 = 5'b100_00;
	parameter WAIT_EQUAL = 5'b101_00;
	parameter CALCULATE = 5'b110_00;
	parameter DONE = 5'b111_10;

	parameter character_0 =8'h30;
	parameter character_1 =8'h31;
	parameter character_2 =8'h32;
	parameter character_3 =8'h33;
	parameter character_4 =8'h34;
	parameter character_5 =8'h35;
	parameter character_6 =8'h36;
	parameter character_7 =8'h37;
	parameter character_8 =8'h38;
	parameter character_9 =8'h39;

	parameter character_minus = 8'h2D;         //'-'
	parameter character_plus = 8'h2B;          //'+'
	parameter character_equals = 8'h3D;         //'='

	parameter character_D = 8'h44;
	parameter character_E = 8'h45;

	initial begin
		led0 = 1'b0;
		read_addr_start = 1'b0;
		valid_char = 8'hxx;
        state = IDLE;		//initially start forward enabled
    end

    assign read_addr_start = state[0];

	always_ff @(posedge clk)
	begin
		case(state)
			IDLE: begin
				if(read_keyboard_flag)
				begin
					valid_char <= character;
					state <= WAIT_DIGIT_1;
				end
				else
					state <= IDLE;
			end
			WAIT_DIGIT_1: begin
				led0 <= ~led0;
				state <= WAIT_AUDIO;
			end
			WAIT_AUDIO: begin
				if(audio_done_flag)
				begin
					valid_char <= 8'hxx;
					state <= DONE;
				end
				else
				begin
					valid_char <= valid_char;
					state <= WAIT_AUDIO;
				end
			end
			DONE: begin
				valid_char <= 8'hxx;
				state <= IDLE;
			end
			default: begin
				valid_char <= 8'hxx;
				state <= IDLE;
			end
		endcase
	end
endmodule