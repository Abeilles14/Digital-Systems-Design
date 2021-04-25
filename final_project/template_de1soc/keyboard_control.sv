module keyboard_control
	(input logic clk,
	 input logic read_keyboard_flag,		//key stroke detected
	 input logic [7:0] character,			//keyboard input ascii
	 output logic read_addr_start,			//play/pause
	 input logic audio_done_flag);

	logic [6:0] state;

	parameter IDLE = 7'b00000_00;
	parameter WAIT_DIGIT = 7'b00001_00;
	parameter WAIT_AUDIO = 7'b00010_01;
	parameter DONE = 7'b11111_00;

	initial begin
		read_addr_start = 1'b0;
        state = IDLE;		//initially start forward enabled
    end

    assign read_addr_start = state[0];

	always_ff @(posedge clk)
	begin
		case(state)
			IDLE: begin
				if(read_keyboard_flag)
				begin
					state <= WAIT_DIGIT;
				end
				else
					state <= IDLE;
			end
			WAIT_DIGIT: begin
				state <= WAIT_AUDIO;
			end
			WAIT_AUDIO: begin
				if(audio_done_flag)
				begin
					state <= DONE;
				end
				else
				begin
					state <= WAIT_AUDIO;
				end
			end
			DONE: begin
				state <= IDLE;
			end
			default: begin
				state <= IDLE;
			end
		endcase
	end
endmodule