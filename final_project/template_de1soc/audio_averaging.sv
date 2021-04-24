module audio_averaging(
	input logic clk,
	input logic start_averaging_flag,
	input logic [7:0] input_audio,
	output logic [7:0] led_out,
	output logic led0);

	logic [3:0] state;
	logic [7:0] abs_sample, avg_sample, counter;
	logic [15:0] sum_sample;

	parameter IDLE = 4'b0000;
	parameter SUM = 4'b0010;
	parameter OUTPUT_LED = 4'b0011;
	parameter DONE = 4'b0100;

	//assign abs_sample = input_audio[7] ? -input_audio : input_audio;		//absolute value
	assign abs_sample = (input_audio < 8'h80) ? (~input_audio + 1'b1) : input_audio;

	initial begin
		counter = 8'b0;
		sum_sample = 16'b0;
		avg_sample = 8'b0;
		state <= IDLE;
	end

	always_ff @(posedge clk)
	begin
		case(state)
			IDLE: begin
				if(start_averaging_flag)
					state <= SUM;
				else
					state <= IDLE;
			end
			SUM: begin
				if (counter > 8'd255)
				begin
					avg_sample <= (sum_sample >> 8);	//divide sum by 256
					state <= OUTPUT_LED;
				end
				else
				begin
					counter <= counter + 1'b1;
					sum_sample <= sum_sample + abs_sample;
					state <= IDLE;
				end
			end
			OUTPUT_LED: begin
				led0 <= 1'b1;

				if (avg_sample > 8'h80)
					led_out <= 8'b1111_1111;
				else if (avg_sample > 8'h40)
					led_out <= 8'b1111_1110;
				else if (avg_sample > 8'h20)
					led_out <= 8'b1111_1100;
				else if (avg_sample > 8'h10)
					led_out <= 8'b1111_1000;
				else if (avg_sample > 8'h08)
					led_out <= 8'b1111_0000;
				else if (avg_sample > 8'h04)
					led_out <= 8'b1110_0000;
				else if (avg_sample > 8'h02)
					led_out <= 8'b1100_0000;
				else if (avg_sample > 8'h01)
					led_out <= 8'b1000_0000;
				else
				begin
					led_out <= 8'b0000_0000;
					led0 <= 1'b0;
				end

				state <= DONE;
			end
			DONE: begin
				counter <= 8'b0;
				sum_sample <= 16'b0;
				avg_sample <= 8'b0;
				state <= IDLE;
			end
			default: begin
				counter <= 8'b0;
				sum_sample <= 16'b0;
				avg_sample <= 8'b0;
				state <= IDLE;
			end
		endcase
	end
endmodule