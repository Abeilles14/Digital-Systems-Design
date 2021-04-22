//direction encodings
`define UP 1'b1
`define DOWN 1'b0

//start and end addresses
`define START 23'h00000
`define END 23'h7FFFF

module address_counter
	(input logic clk22K,				//50 MHz
	input logic dir,
	input logic read_addr_start,		//keyboard pause/start
	output logic addr_ready_flag,		//flag to check if ready to read next addr
	output logic [22:0] current_address,		//address to read data from
	input logic [31:0] flash_data,
	output logic [7:0] audio_out,
	input logic [23:0] start_addr,
	input logic [23:0] end_addr,
	input logic silent_flag,
	output logic picoblaze_start_flag,
	input logic picoblaze_done_flag,
	input logic reset);

	logic data_even_flag;
	logic [2:0] byte_count;
	logic [3:0] state;

	parameter IDLE = 4'b0000;
	parameter WAIT_AUDIO = 4'b0001;
	parameter AUDIO_BYTE = 4'b0010;
	parameter INCREMENT = 4'b0011;
	parameter SELECT = 4'b0100;
	parameter DONE = 4'b0101;

	initial begin
		addr_ready_flag = 1'b0;
		current_address = start_addr;
		audio_out = 8'h00;
		byte_count = 3'b1;
		state = WAIT_AUDIO;
	end

	always_ff @(posedge clk22K or posedge reset)
	begin
		if(reset)	//start from address 0
		begin
			addr_ready_flag <= 1'b0;
			current_address <= start_addr;
			audio_out <= 8'h00;
			byte_count <= 3'b0;
			state <= WAIT_AUDIO;
		end
		else
		begin
			case(state)
				WAIT_AUDIO: begin
					addr_ready_flag <= addr_ready_flag;
					current_address <= current_address;
					audio_out <= 8'h00;
					byte_count <= byte_count;

					if (read_addr_start)
					begin
						state <= AUDIO_BYTE;
					end
				end
				AUDIO_BYTE: begin
					if (silent_flag)				//silent
					begin
						audio_out <= 8'hBC;
						byte_count <= byte_count;
						addr_ready_flag <= 1'b1;
						state <= WAIT_AUDIO;
					end

					else if(byte_count == 3'd1)		//1st byte audio
					begin
						audio_out <= flash_data[7:0];
						byte_count <= byte_count + 1;
						addr_ready_flag <= 1'b1;
						state <= WAIT_AUDIO;
					end
					else if(byte_count == 3'd2)		//2nd byte audio
					begin
						audio_out <= flash_data[15:8];
						byte_count <= byte_count + 1;
						addr_ready_flag <= 1'b1;
						state <= WAIT_AUDIO;
					end
					else if(byte_count == 3'd3)		//3rd byte audio
					begin
						audio_out <= flash_data[23:16];
						byte_count <= byte_count + 1;
						addr_ready_flag <= 1'b1;
						state <= WAIT_AUDIO;
					end
					else if(byte_count == 3'd4)		//4th byte audio
					begin
						audio_out <= flash_data[31:24];
						byte_count <= byte_count + 1;
						addr_ready_flag <= 1'b1;
						state <= WAIT_AUDIO;
					end
					else		//byte_count = 3'd5 (reset and increase addr)
					begin
						audio_out <= audio_out;
						byte_count <= 3'd1;
						addr_ready_flag <= 1'b0;
						//state <= WAIT_AUDIO;
						state <= INCREMENT;
					end
				end
				INCREMENT: begin
					if(current_address <= (end_addr/4))
					begin
						picoblaze_start_flag <= 1'b1;
						state <= SELECT;
					end
					else
					begin
						current_address <= current_address + 1'b1;
						state <= WAIT_AUDIO;
						//check if go to pause state ??
					end
				end
				SELECT: begin
					if(picoblaze_done_flag)
					begin
						current_address <= start_addr/4;
						picoblaze_start_flag <= 1'b1;
						state <= WAIT_AUDIO;
					end
					else
					begin
						state <= SELECT;
					end

					audio_out <= 8'h00;
					byte_count <= 3'd1;
					addr_ready_flag <= 1'b0;
				end
				// DONE: begin
				// 	addr_ready_flag <= 1'b0;
				// 	current_address <= current_address;
				// 	audio_out <= 8'h00;
				// 	byte_count <= byte_count;
				// 	state <= DONE;
				// end



				// //`UP: begin
				// 	addr_ready_flag <= 1'b0;

				// 	if(silent_flag)
				// 	begin
				// 		audio_out <= 8'BC;
				// 	end
				// 	else
				// 	begin
				// 		if(byte_count == 3'b001)
				// 		begin
				// 			audio_out <= flash_data[7:0];
				// 		end
				// 	end

				// 	addr_ready_flag <= 1;
				// 	data_even_flag <= !data_even_flag;
				// 	audio_out = data_even_flag ? flash_data[15:0] : flash_data[31:16];

				// 	if(data_even_flag)
				// 	begin
				// 		if (current_address == `END)		//if at last address, go to first
				// 			current_address <= `START;
				// 		else
				// 			current_address <= current_address + 23'h01;		//incr addr by 1
				// 			addr_ready_flag <= 1'b1;
				// 	end
				//end
				// `DOWN: begin
				// 	addr_ready_flag <= 0;
				// 	data_even_flag <= !data_even_flag;
				// 	audio_out = data_even_flag ? flash_data[31:16] : flash_data[15:0];

				// 	if(data_even_flag)
				// 	begin
				// 		if (current_address == `START)		//if at last address, go to first
				// 			current_address <= `END;
				// 		else
				// 			current_address <= current_address - 23'h01;		//incr addr by 1
				// 			addr_ready_flag <= 1'b1;
				// 	end
				// end
				default: begin
					audio_out <= 8'h00;
					byte_count <= 3'd1;
					current_address <= start_addr;
					addr_ready_flag <= 1'b0;
				end
			endcase
		end
	end
endmodule