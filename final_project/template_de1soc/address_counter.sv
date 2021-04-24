
module address_counter(
	input logic clk,
	input logic clk_22khz_sync,
	output logic [22:0] current_address,
 	input logic [31:0] flash_data,
 	output logic read_data_flag,
	input logic pause,
	output logic led_start_flag,
	input logic start_read,
	input logic read_done_flag,
	output logic [7:0] audio_out,
	input logic [23:0] start_address,
 	input logic [23:0] end_address,
 	input logic silent_flag,
 	output logic picoblaze_start_flag,
 	input logic picoblaze_done_flag,
	input logic reset); 

logic [7:0] state;

logic [2:0] byte_count;

parameter IDLE = 8'b00001_00; 
parameter READ_DATA = 8'b00010_01;

parameter WAIT_AUDIO = 8'b00011_00;
parameter WAIT_SYNC = 8'b00100_00;
parameter AUDIO_BYTE = 8'b00101_10;

parameter INCREMENT = 8'b00110_00;
parameter GET_ADDRESS = 8'b00111_00;
parameter pause_state = 8'b11111_00;  

parameter DONE = 8'b01000_00;

assign read_data_flag = state[0];  //output
assign led_start_flag = state [1];		//start visualizer LED
		
always_ff@(posedge clk) begin 
	case(state) 
		
		IDLE: begin
			byte_count <= 3'd1;
			state <= READ_DATA;
		end
			  
		READ_DATA: begin
			if(read_done_flag)
				state <= WAIT_AUDIO;
		end

		WAIT_AUDIO: begin
			if(byte_count == 3'd5)
			begin
				state <= INCREMENT;
			end
			else
			begin
				state <= WAIT_SYNC;
			end
		end

		WAIT_SYNC: begin
			if(clk_22khz_sync) state <= AUDIO_BYTE;
		end


		AUDIO_BYTE: begin
			if(byte_count == 3'd1)		//1st byte audio
			begin
				if (silent_flag)
					audio_out <= 8'h00;
				else 
					audio_out <= flash_data[7:0];

				byte_count <= byte_count + 1'b1;
				current_address <= current_address;
			end
			else if(byte_count == 3'd2)		//2nd byte audio
			begin
				if (silent_flag)
					audio_out <= 8'h00;
				else 
					audio_out <= flash_data[15:8];

				byte_count <= byte_count + 1'b1;
				current_address <= current_address;
			end
			else if(byte_count == 3'd3)		//3rd byte audio
			begin
				if (silent_flag)
					audio_out <= 8'h00;
				else 
					audio_out <= flash_data[23:16];

				byte_count <= byte_count + 1'b1;
				current_address <= current_address;
			end
			else if(byte_count == 3'd4)		//4th byte audio
			begin
				if (silent_flag)
					audio_out <= 8'h00;
				else 
					audio_out <= flash_data[31:24];

				byte_count <= byte_count + 1'b1;
				current_address <= current_address;
			end
			else
			begin
				audio_out <= audio_out;
				byte_count <= 3'd1;
				current_address <= current_address;
				state <= IDLE;
			end

			state <= WAIT_AUDIO;
		end
		
		INCREMENT: begin
			if(current_address  == (end_address/4))
			begin
				state <= GET_ADDRESS;
				picoblaze_start_flag <= 1'b1;
			end
			else
			begin
				current_address <= current_address + 1'b1;

				if (pause)
					state  <= pause_state;
				else
					state <= DONE;
			end
		end
		
		GET_ADDRESS:begin
			if  (picoblaze_done_flag)begin
				current_address <= start_address/4;
				state  <= DONE;
				picoblaze_start_flag  <= 1'b0;
			end
		end
		
		pause_state: begin
			if(!pause)
				state<= DONE;
		end
		
		DONE: begin
			state <= IDLE; 
		end
		
		default:begin
			state <= IDLE;
			current_address <= start_address/4; 
			audio_out <= audio_out;	
		end
	endcase 
end
endmodule
