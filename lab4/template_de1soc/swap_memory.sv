`define START_ADDR 8'h00		//start and end addresses
`define END_ADDR 8'hFF

module swap_memory(
	input logic clk,
	output logic [7:0] address,		//s_mem address
	output logic [7:0] data_in,		//data in s_mem data
	input logic [7:0] data_out,		//data out s_mem q
	output logic wren,				//write enable
	input logic [23:0] secret_key,
	input logic start_flag,
	output logic done_flag,
	input logic reset
);

	logic [9:0] state;
	logic [7:0] keylength;

	logic [7:0] i_index, j_index;
	logic [7:0] i_data, j_data;

	parameter IDLE = 10'b00000_00000;

	parameter SET_I_ADDR = 10'b00001_00000;
	parameter WAIT_I_ADDR = 10'b10000_00000;
	parameter GET_I_DATA = 10'b00010_01010;	//read data out to data i

	parameter ADD_SUM_J = 10'b00011_00000;

	parameter SET_J_ADDR = 10'b00100_00000;
	parameter WAIT_J_ADDR = 10'b11000_00000;
	parameter GET_J_DATA = 10'b00101_01000;	//read data out to data j

	parameter SWAP_DATA_I = 10'b00111_00110;	//write data j in addr i
	parameter SWAP_DATA_J = 10'b01001_00101;	//write data i in addr j

	parameter INCREMENT = 10'b01010_00000;
	parameter DONE = 10'b01011_10000;

	assign keylength = 8'h03;

	//assign write_addr_i = state[1];
	//assign write_data_i = state[0];
	assign wren = state[2];
	assign done_flag = state[4];

	//assign address = write_addr_i ? i_index : j_index;		//use i or j
	//assign data_in = write_data_i ? i_data : j_data;	//write to s[i] or s[j]

	initial begin
		state = IDLE;	
		i_index = `START_ADDR;
		j_index = `START_ADDR;
		i_data = 8'bx;
		j_data = 8'bx;

		address = 8'bx;//
		data_in = 8'bx;//
	end

	always_ff @(posedge clk, posedge reset)
	begin
		if (reset)
		begin
			state <= IDLE;
			i_index <= `START_ADDR;
			j_index <= `START_ADDR;
			i_data <= 8'bx;
			j_data <= 8'bx;

			address <= 8'bx;
			data_in <= 8'bx;
		end
		else
		begin
			case(state)
				IDLE: begin					//wait for start_flag
					i_index <= `START_ADDR;
					j_index <= `START_ADDR;
					i_data <= 8'bx;
					j_data <= 8'bx;

					address <= 8'bx;
					data_in <= 8'bx;

					if (start_flag)
						state <= SET_I_ADDR;
					else
						state <= IDLE;
				end
				SET_I_ADDR: begin				//address = i_index
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= i_index;		//set address = i
					data_in <= data_in;

					state <= WAIT_I_ADDR;
				end
				WAIT_I_ADDR: begin				//address = i_index
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= i_index;		//set address = i
					data_in <= data_in;

					state <= GET_I_DATA;
				end
				GET_I_DATA: begin				//i_data = data_out
					i_index <= i_index;
					j_index <= j_index;
					j_data <= j_data;

					address <= i_index;
					data_in <= data_in;

					i_data <= data_out;

					state <= ADD_SUM_J;
				end
				ADD_SUM_J: begin
					i_index <= i_index;
					i_data <= i_data;
					j_data <= j_data;

					data_in <= data_in;

					case(i_index % keylength)
						8'h00: begin
							j_index <= j_index + i_data + secret_key[23:16];
						end
						8'h01: begin
							j_index <= j_index + i_data + secret_key[15:8];
						end
						8'h02: begin
							j_index <= j_index + i_data + secret_key[7:0];
						end
						default: begin
							j_index <= j_index + i_data + 8'h00;
						end
					endcase

					address <= j_index;		//set address = j

					state <= SET_J_ADDR;
				end
				SET_J_ADDR: begin		//address = j_index
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= j_index;		//set address = i
					data_in <= data_in;

					state <= WAIT_J_ADDR;
				end
				WAIT_J_ADDR: begin				//address = j_index
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= j_index;		//set address = i
					data_in <= data_in;

					state <= GET_J_DATA;
				end
				GET_J_DATA: begin			//j_data = data_out
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;

					//need to prepare for next state to swap at i_index??
					address <= j_index;
					data_in <= data_in;

					j_data <= data_out;

					state <= SWAP_DATA_I;
				end
				SWAP_DATA_I: begin			//addr = i_index, write data_in = j_data
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					//prepare for next state to swap at j_index
					address <= i_index;
					data_in <= j_data;

					if(data_out == j_data)		//ensure j_data stored in s_mem
						state <= SWAP_DATA_J;
					else
						state <= SWAP_DATA_I;
				end
				SWAP_DATA_J: begin			//addr = j_index, write data_in = i_data
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= j_index;
					data_in <= i_data;

					if(data_out == i_data)		//ensure i_data stored in s_mem
						state <= INCREMENT;
					else
						state <= SWAP_DATA_J;
				end
				INCREMENT: begin
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= address;
					data_in <= data_in;

					if (i_index == `END_ADDR)
					begin
						i_index <= i_index;
						state <= DONE;
					end
					else
					begin
						i_index <= i_index + 8'h01;		//incr addr by 1
						state <= SET_I_ADDR;
					end
				end
				DONE: begin
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= address;
					data_in <= data_in;

					//add start flag/return to IDLE?
					state <= IDLE;
				end
				default: begin
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= address;
					data_in <= data_in;
					state <= IDLE;
				end
			endcase
		end
	end
endmodule