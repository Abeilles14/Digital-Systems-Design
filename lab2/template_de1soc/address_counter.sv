//direction encodings
`define UP 1'b1
`define DOWN 1'b0

//start and end addresses
`define START 32'h00000
`define END 32'h7FFFF

module address_counter
	(input logic clk,				//50 MHz
	input logic dir,				//going fwd or bck
	input logic read_next_addr,		//flag to check if ready to read next addr
	output logic [31:0] current_address,		//address to read data from
	output logic read_data_flag,
	input reset);

	always_ff @(posedge clk or posedge reset)
	begin
		if(reset)	//start from address 0
		begin
			current_address <= `START;
		end
		case(dir)
			`UP: begin
				if (read_next_addr)
				begin
					if (current_address == `END)		//if at last address, go to first
						current_address <= `START;
					else
						current_address = current_address + 32'h01;		//incr addr by 1
						read_data_flag <= 1'b1;
				end
			end
			`DOWN: begin
				if (read_next_addr)
				begin
					if (current_address == `START)		//if at first address, go to last
						current_address <= `END;
					else
						current_address <= current_address - 32'h01;		//decr addr by 1
						read_data_flag <= 1'b1;
				end
			end
			default: begin
				current_address <= `START;
				read_data_flag <= 1'b0;
			end
		endcase
	end
endmodule