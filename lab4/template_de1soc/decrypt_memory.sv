`define START_ADDR 8'h00		//start and end addresses
`define END_K_ADDR 8'h20 			//32

module decrypt_memory(
	input logic clk,
	output logic [7:0] address,			//s_mem, d_mem, e_mem address
	output logic [7:0] s_data_in,		//data in s_mem data
	input logic [7:0] s_data_out,		//data out s_mem q
	output logic [7:0] d_data_in,		//data in decrypted RAM d_mem data
	input logic [7:0] e_data_out,		//data out encrypted ROM e_mem q
	output logic s_wren,
	output logic d_wren,				//write enable d
	input logic start_flag,
	output logic done_flag,
	input logic reset
);

	logic [9:0] state;
	logic [7:0] i_index, j_index, k_index, f_value;
	logic [7:0] i_data, j_data, encrypted_input;

	parameter IDLE = 11'b00000_000000;

	parameter SET_I_ADDR = 11'b00001_000000;		//set i (i=i+1)
	parameter WAIT_I_ADDR = 11'b00010_000000;
	parameter GET_I_DATA = 11'b00011_000000;		//get s[i]
	// parameter WAIT_I_DATA = 11'b00100_000000;	//wait for s[i] since it will be used next state

	parameter SET_J_ADDR = 11'b00101_000000;		//set j (j=j+s[i])
	parameter WAIT_J_ADDR = 11'b00110_000000;
	parameter GET_J_DATA = 11'b00111_000000;		//read data out to data j
	//parameter WAIT_J_DATA = 11'b10011_000000;	//wait for s[j] since it will be used next state

	parameter SWAP_DATA_I = 11'b01000_001100;	//write data j in addr i
	parameter SWAP_DATA_J = 11'b01001_001010;	//write data i in addr j

	parameter SET_F_ADDR = 11'b01011_000000;		//addr = s[i]+s[j]
	parameter WAIT_F_ADDR = 11'b01100_000000;
	parameter GET_F_VALUE = 11'b01101_010000;		//get f = s[s[i]+s[j]]
	
	parameter SET_K_ADDR = 11'b01110_010000;
	parameter WAIT_K_ADDR = 11'b01111_010000;	

	parameter DECRYPT = 11'b10000_010001;		//decrypted_output[k] = f^encrypted_input[k]

	parameter INCREMENT = 11'b10001_000000;
	parameter DONE = 11'b10010_100000;

	assign d_wren = state[0];			//state DECRYPT
	assign s_wren = state[3];			//state SWAP_DATA_I, SWAP_DATA_J
	assign done_flag = state[5];		//state DONE

	//assign get_data_i = state[1];		//state GET_I_DATA, //WAIT_I_DATA
	//assign get_data_j = state[2];		//state GET_J_DATA, //WAIT_J_DATA
	//assign get_value_f = state[4];	//state GET_F_VALUE

	assign f_value = state[4]? s_data_out : 8'bx;	//state GET_F_VALUE to DECRYPT f = s[s[i]+s[j]]

	assign s_data_in = state[2] ? j_data : (state[1] ? i_data : 8'bx);	//only matters s_wren, if SWAP_DATA_I, write j_data else write i_data

	assign d_data_in = d_wren ? (f_value ^ e_data_out) : 8'bx;	//only matters in state DECRYPT if d_wren, write to d_mem

	initial begin
		state = IDLE;
		k_index = `START_ADDR;
		i_index = `START_ADDR;
		j_index = `START_ADDR;

		i_data = 8'bx;
		j_data = 8'bx;
		
		address = 8'bx;
	end

	always_ff @(posedge clk, posedge reset)
	begin
		if (reset)
		begin
			state <= IDLE;

			k_index <= `START_ADDR;
			i_index <= `START_ADDR;
			j_index <= `START_ADDR;

			i_data <= i_data;
			j_data <= j_data;

			address <= 8'bx;
		end
		else
		begin
			case(state)
				IDLE: begin						//wait for start_flag
					k_index <= `START_ADDR;
					i_index <= `START_ADDR;
					j_index <= `START_ADDR;

					i_data <= i_data;
					j_data <= j_data;

					address <= address;

					if (start_flag)
						state <= SET_I_ADDR;
					else
						state <= IDLE;
				end
				SET_I_ADDR: begin			//address = i_index
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= j_data;

					address <= i_index;		//set address = i

					state <= WAIT_I_ADDR;
				end
				WAIT_I_ADDR: begin				//address = i_index
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= j_data;

					address <= i_index;			//set address = i

					state <= GET_I_DATA;
				end
				GET_I_DATA: begin				//i_data = s_data_out
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= s_data_out;
					j_data <= j_data;

					address <= i_index;

					state <= SET_J_ADDR;
				end
				SET_J_ADDR: begin				//address = j_index + i_data
					k_index <= k_index;
					i_index <= i_index;

					i_data <= i_data;
					j_data <= j_data;

					j_index <= j_index + i_data;	//j = j+s[i]
					address <= j_index;				//set address = j

					state <= WAIT_J_ADDR;
				end
				WAIT_J_ADDR: begin				//address = j_index + i_data
					k_index <= k_index;
					i_index <= i_index;

					i_data <= i_data;
					j_data <= j_data;
					
					j_index <= j_index + i_data;	//j = j+s[i]
					address <= j_index;				//set address = j

					state <= GET_J_DATA;
				end
				GET_J_DATA: begin			//j_data = s_data_out
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= s_data_out;

					address <= j_index;

					state <= SWAP_DATA_I;
				end
				SWAP_DATA_I: begin			//addr = i_index, write data_in = j_data
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= j_data;

					address <= i_index;

					if(s_data_out == j_data)		//ensure j_data stored in s_mem
						state <= SWAP_DATA_J;
					else
						state <= SWAP_DATA_I;
				end
				SWAP_DATA_J: begin			//addr = j_index, write data_in = i_data
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= j_data;

					address <= j_index;

					if(s_data_out == i_data)		//ensure i_data stored in s_mem
						state <= INCREMENT;
					else
						state <= SWAP_DATA_J;
				end
				SET_F_ADDR: begin			//set addr = i_data + j_data
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= j_data;

					address <= i_data + j_data;

					state <= WAIT_F_ADDR;
				end
				WAIT_F_ADDR: begin			//set addr = i_data + j_data
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= j_data;

					address <= i_data + j_data;

					state <= GET_F_VALUE;
				end
				GET_F_VALUE: begin			//get s[i_data + j_data]
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= j_data;

					address <= address;

					state <= SET_K_ADDR;
				end
				SET_K_ADDR: begin			//set addr = k_index
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= j_data;

					address <= k_index;

					state <= WAIT_K_ADDR;
				end
				WAIT_K_ADDR: begin			//set addr = k_index
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= j_data;

					address <= k_index;

					state <= DECRYPT;
				end
				DECRYPT: begin				//decypted_output[k] = f^encrypted_input[k]
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= j_data;

					address <= address;

					state <= INCREMENT;
				end
				INCREMENT: begin
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= j_data;

					address <= address;

					if (k_index == `END_K_ADDR)
					begin
						k_index <= k_index;
						state <= DONE;
					end
					else
					begin
						k_index <= k_index + 8'h01;		//incr addr by 1
						state <= SET_I_ADDR;
					end
				end
				DONE: begin
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= j_data;

					address <= address;

					//add start flag/return to IDLE?
					state <= DONE;
				end
				default: begin
					k_index <= k_index;
					i_index <= i_index;
					j_index <= j_index;

					i_data <= i_data;
					j_data <= j_data;

					address <= address;
					state <= IDLE;
				end
			endcase
		end
	end
endmodule