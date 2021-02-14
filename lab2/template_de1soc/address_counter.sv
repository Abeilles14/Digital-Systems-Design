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
	//output logic addr_retrieved_flag,	//address has been read
	input logic [31:0] flash_data,
	output logic [15:0] audio_out,
	input logic reset);

	logic data_even_flag;

	initial begin
		current_address = `START;
		addr_ready_flag = 1'b0;
	end

	always_ff @(posedge clk22K or posedge reset)
	begin
		if(reset)	//start from address 0
		begin
			current_address <= `START;
		end
		else
		if(!read_addr_start)
		begin
			audio_out <= 16'b0;
			current_address <= current_address;
		end
		else
		begin
			case(dir)
				`UP: begin
					addr_ready_flag <= 0;
					data_even_flag <= !data_even_flag;
					audio_out = data_even_flag ? flash_data[15:0] : flash_data[31:16];

					if(data_even_flag)
					begin
						if (current_address == `END)		//if at last address, go to first
							current_address <= `START;
						else
							current_address <= current_address + 23'h01;		//incr addr by 1
							addr_ready_flag <= 1'b1;
					end
				end
				`DOWN: begin
					addr_ready_flag <= 0;
					data_even_flag <= !data_even_flag;
					audio_out = data_even_flag ? flash_data[31:16] : flash_data[15:0];

					if(data_even_flag)
					begin
						if (current_address == `START)		//if at last address, go to first
							current_address <= `END;
						else
							current_address <= current_address - 23'h01;		//incr addr by 1
							addr_ready_flag <= 1'b1;
					end
				end
				default: begin
					data_even_flag <= !data_even_flag;
					current_address <= `START;
					addr_ready_flag <= 1'b1;
				end
			endcase
		end
	end
endmodule