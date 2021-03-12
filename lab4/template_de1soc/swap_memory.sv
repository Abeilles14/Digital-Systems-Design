

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
	parameter GET_I_DATA = 10'b00010_01010;	//read data out to data i
	parameter ADD_SUM_J = 10'b00011_00000;
	parameter SET_J_ADDR = 10'b00100_00000;
	parameter GET_J_DATA = 10'b00101_01000;	//read data out to data j
	parameter SET_I_ADDR_SWAP = 10'b00110_00000;
	parameter SWAP_DATA_I = 10'b00111_00110;	//write data j in addr i
	parameter SET_J_ADDR_SWAP = 10'b01000_00110;
	parameter SWAP_DATA_J = 10'b01001_00101;	//write data i in addr j
	parameter INCREMENT = 10'b01010_00000;
	parameter DONE = 10'b01011_10000;
	parameter TEMP = 10'b10000_00000;
	// parameter CONF1 = 10'b11000_0000;
	// parameter CONF2 = 10'b11100_0000;

	assign keylength = 8'd3;

	//assign write_addr_i = state[1];
	//assign write_data_i = state[0];
	//assign wren = state[2];
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
		wren = 1'b0;//
	end

	always_ff @(posedge clk, posedge reset)
	begin
		if (reset)
		begin
			state = IDLE;
			i_index = `START_ADDR;
			j_index = `START_ADDR;
			i_data = 8'bx;
			j_data = 8'bx;

			address = 8'bx;
			data_in = 8'bx;
			wren = 1'b0;
		end
		else
		begin
			case(state)
				IDLE: begin					//wait for start_flag
					i_index <= `START_ADDR;
					j_index <= `START_ADDR;
					i_data <= i_data;
					j_data <= j_data;

					address <= address;
					data_in <= data_in;
					wren <= 1'b0;

					if (start_flag)
						state <= SET_I_ADDR;
					else
						state <= IDLE;
				end
				SET_I_ADDR: begin				//address = i_index
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;//i_data <= i_data;
					j_data <= j_data;

					address <= i_index;		//set address = i
					data_in <= data_in;
					wren <= 1'b0;

					state <= TEMP;//GET_I_DATA;
				end
				TEMP: begin
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;//i_data <= i_data;
					j_data <= j_data;

					address <= i_index;		//set address = i
					data_in <= data_in;
					wren <= 1'b0;

					state <= GET_I_DATA;
				end
				GET_I_DATA: begin				//i_data = data_out
					i_index <= i_index;
					j_index <= j_index;
					j_data <= j_data;

					address <= i_index;
					data_in <= data_in;
					wren <= 1'b0;

					i_data <= data_out;

					// if(i_data == data_out)		//ensure s_mem data stored in i_data
					// 	state <= ADD_SUM_J;
					// else
					// 	state <= GET_I_DATA;
					state <= ADD_SUM_J;//
				end
				ADD_SUM_J: begin
					i_index <= i_index;
					i_data <= i_data;
					j_data <= j_data;

					//j_index <= j_index;//
					//j_index <= `END_ADDR - i_index;//

					//address <= address;
					data_in <= data_in;
					wren <= 1'b0;

					case(i_index % 8'h03)
						8'h00: begin
							j_index <= j_index + i_data + secret_key[23:16];
						end
						8'h01: begin
							j_index <= j_index + i_data + secret_key[15:8];
						end
						8'h10: begin
							j_index <= j_index + i_data + secret_key[7:0];
						end
						default: begin
							j_index <= j_index + i_data + 8'h00;
						end
					endcase

					address <= j_index;		//set address = i

					state <= SET_J_ADDR;
				end
				SET_J_ADDR: begin		//address = j_index
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;//j_data <= j_data;

					address <= j_index;		//set address = i
					data_in <= data_in;
					wren <= 1'b0;

					state <= GET_J_DATA;
				end
				GET_J_DATA: begin			//j_data = data_out
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;

					address <= j_index;
					data_in <= data_in;
					wren <= 1'b0;

					j_data <= data_out;

					// if(j_data == data_out)		//ensure s_mem data stored in j_data
					// 	state <= SET_I_ADDR_SWAP;
					// else
					// 	state <= GET_J_DATA;
					state <= SET_I_ADDR_SWAP;//
				end
				SET_I_ADDR_SWAP: begin
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= i_index;
					data_in <= j_data;
					wren <= 1'b1;

					state <= SWAP_DATA_I;
				end

				SWAP_DATA_I: begin			//addr = i_index, write data_in = j_data
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= i_index;
					data_in <= j_data;
					wren <= 1'b1;

					if(data_out == j_data)		//ensure j_data stored in s_mem
						state <= SET_J_ADDR_SWAP;
					else
						state <= SET_I_ADDR_SWAP;
					//state <= SET_J_ADDR_SWAP;//
				end
				SET_J_ADDR_SWAP: begin
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= j_index;
					data_in <= i_data;
					wren <= 1'b1;

					state <= SWAP_DATA_J;
				end
				SWAP_DATA_J: begin			//addr = j_index, write data_in = i_data
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= j_index;
					data_in <= i_data;
					wren <= 1'b1;

					if(data_out == i_data)		//ensure i_data stored in s_mem
						state <= INCREMENT;
					else
						state <= SET_J_ADDR_SWAP;
					//state <= INCREMENT;//
				end
				INCREMENT: begin
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= address;
					data_in <= data_in;
					wren <= 1'b0;

					if (i_index == `END_ADDR)//8'h7F)//`END_ADDR)
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
					wren <= 1'b0;

					//add start flag/return to IDLE?
					state <= DONE;
				end
				default: begin
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					address <= address;
					data_in <= data_in;
					wren <= 1'b0;

					state <= IDLE;
				end
			endcase
		end
	end
endmodule