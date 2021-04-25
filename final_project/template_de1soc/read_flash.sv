module read_flash(
	input logic clk,
	input logic start_read_flag,
	input logic read_data_valid,
	input logic read_data_flag,
	output logic done_read_flag); 

logic [2:0] state;  

parameter IDLE = 3'b00_0; 
parameter READ_DATA = 3'b01_0;
parameter WAIT_READ_DATA = 3'b10_0; 
parameter DONE = 3'b11_1; 

assign done_read_flag = state[0]; 

always_ff @(posedge clk)
	case(state)   
		
		IDLE: begin
			if(start_read_flag)
				state <= READ_DATA; 
			else
				state <= IDLE;
		end
			
		READ_DATA: begin
			if(read_data_flag)
				state <= WAIT_READ_DATA;
			else
				state <= READ_DATA;
		end
			
		WAIT_READ_DATA: begin
			if(read_data_valid)
				state <= WAIT_READ_DATA;
			else
				state <= DONE;
		end
			
		DONE: begin
			state <= IDLE;
		end

		default: begin
			state <= IDLE; 
		end
	endcase 
endmodule 
