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

	logic [8:0] state;
	logic [7:0] counter;
	logic [2:0] keylength;

	logic [7:0] j_index, i_index;
	logic [7:0] i_data, j_data;

	parameter IDLE = 8'b000_00000;
	parameter GET_I_DATA = 8'b001_01010;	//read data out to data i
	parameter ADD_SUM_J = 8'b010_00000;
	parameter GET_J_DATA = 8'b011_01000;	//read data out to data j
	parameter SWAP_DATA_I = 8'b100_00110;	//write data j in addr i
	parameter SWAP_DATA_J = 8'b101_00101;	//write data i in addr j
	parameter INCREMENT = 8'b110_00000;
	parameter DONE = 8'b111_10000;

	assign keylength = 2'h03;

	assign write_addr_i = state[1];
	assign write_data_i = state[0];
	assign wren = state[2];
	//assign read_data = state[3];
	assign done_flag = state[4];

	assign address = write_addr_i ? i_index : j_index;
	assign data_in = write_data_i ? i_data : j_data;

	//assign i_data = (read_data && (address == i_index)) ? data_out : i_data;
	//assign j_data = (read_data && (address == j_index)) ? data_out : j_data;

	initial begin
		state = IDLE;	
		i_index = `START_ADDR;
		j_index = `START_ADDR;
		i_data = 8'bx;
		j_data = 8'bx;
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
		end
		else
		begin
			case(state)
				IDLE: begin
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					if (start_flag)
						state <= GET_I_DATA;
					else
						state <= IDLE;
				end
				GET_I_DATA: begin				//address = i_index
					i_index <= i_index;
					j_index <= j_index;
					j_data <= j_data;

					i_data <= data_out;

					state <= ADD_SUM_J;
				end
				ADD_SUM_J: begin
					i_index <= i_index;
					i_data <= i_data;
					j_data <= j_data;

					j_index <= (j_index + i_data + secret_key[i_index % keylength]) % 9'h100;
					state <= GET_J_DATA;
				end
				GET_J_DATA: begin			//address = j_index
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;

					j_data <= data_out;

					state <= SWAP_DATA_I;
				end
				SWAP_DATA_I: begin			//addr = i_index, write data_in = j_data
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					state <= SWAP_DATA_J;
				end
				SWAP_DATA_J: begin			//addr = j_index, write data_in = i_data
					i_index <= i_index;
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					state <= INCREMENT;
				end
				INCREMENT: begin
					j_index <= j_index;
					i_data <= i_data;
					j_data <= j_data;

					if (i_index == `END_ADDR)
					begin
						i_index <= i_index;
						state <= DONE;
					end
					else
					begin
						i_index <= i_index + 8'h01;		//incr addr by 1
						state <= GET_I_DATA;
					end
				end
				DONE: begin
					i_index <= i_index;
					j_index <= j_index;
					i_data = i_data;
					j_data = j_data;

					//add start flag/return to IDLE?
					state <= DONE;
				end
				default: begin
					i_index <= i_index;
					j_index <= j_index;
					i_data = i_data;
					j_data = j_data;

					state <= IDLE;
				end
			endcase
		end
	end
endmodule