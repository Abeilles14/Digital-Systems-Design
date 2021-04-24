`define F_E 4'b0011		//play forward
`define F_D	4'b0010		//pause going forward

module keyboard_control
	(input logic clk,
	 input logic read_keyboard_flag,		//sync with 7200hz clk
	 input logic [7:0] character,			//keyboard input ascii
	 output logic [7:0] valid_char,			//keyboard output ascii
	 output logic error_flag,				//if char not valid
	 output logic read_addr_start,			//play/pause
	 input logic picoblaze_done_flag,
	 input logic audio_done_flag,
	 output logic led0,
	 output logic led1);

	logic [3:0] state;

	parameter IDLE = 4'b0000;
	parameter WAIT_DIGIT_1 = 4'b0001;
	parameter WAIT_SIGN = 4'b0010;
	parameter WAIT_DIGIT_2 = 4'b0011;
	parameter WAIT_EQUAL = 4'b0100;
	parameter CALCULATE = 4'b0101;
	parameter DONE = 4'b0110;

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
		led1 = 1'b0;
		read_addr_start = 1'b0;
		valid_char = 8'hxx;
        state = IDLE;		//initially start forward enabled
    end

	always_ff @(posedge clk)
	begin
		case(state)
			IDLE: begin
				read_addr_start <= 1'b0;
				valid_char <= 8'hxx;
				state <= WAIT_DIGIT_1;
			end
			WAIT_DIGIT_1: begin
				if(read_keyboard_flag)
				begin
					led0 <= ~led0;
					read_addr_start <= 1'b1;
					valid_char <= character;

					if(audio_done_flag)
					begin
						led1 <= ~led1;
						state <= DONE;
					end
				end
				else
				begin
					//valid_char <= 8'hxx;
					state <= WAIT_DIGIT_1;
				end
			end
			DONE: begin
				read_addr_start <= 1'b0;
				valid_char <= 8'hxx;
				state <= IDLE;
			end
			default: begin
				read_addr_start <= 1'b0;
				valid_char <= 8'hxx;
				state <= IDLE;
			end
		endcase
	end
endmodule