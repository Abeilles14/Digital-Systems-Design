module datapath(
	input logic clk,
	output logic [7:0] s_mem_addr,
	output logic [7:0] s_mem_data_in,
	input logic [7:0] s_mem_data_out,
	output logic s_mem_write,
	output logic [7:0] d_mem_addr,
	output logic [7:0] d_mem_data_in,
	input logic [7:0] d_mem_data_out,
	output logic d_mem_write,
	output logic [7:0] e_mem_addr,
	input logic [7:0] e_mem_data_out,
	output logic [23:0] secret_key,
	output logic key_found_flag,
	input logic datapath_start_flag,
	output logic datapath_done_flag,
	input logic reset,
	output logic test3,
	output logic test4,
	output logic test5
	);

	logic [6:0] state;
	logic [7:0] s_init_addr, s_init_data_in;
	logic [7:0] s_swap_addr, s_swap_data_in, s_decrypt_data_in;
	logic [7:0] decrypt_addr;		//can be s_addr, d_addr, or e_addr
	logic [7:0] e_decrypt_addr;
	logic s_init_write, s_swap_write, s_decrypt_write;
	logic d_decrypt_write;

	logic init_start_flag, swap_start_flag, decrypt_start_flag;
	logic init_done_flag, swap_done_flag, decrypt_done_flag;
	logic invalid_key_flag;

//initialize s_memory
init_memory init_s_mem (
    .clk(clk),
    .address(s_init_addr),
    .data(s_init_data_in),
    .wren(s_init_write),
    .start_flag(init_start_flag),
    .done_flag(init_done_flag),
    .reset(reset));

//s_memory swap
swap_memory swap_s_mem (
    .clk(clk),
    .address(s_swap_addr),
    .data_in(s_swap_data_in),
    .data_out(s_mem_data_out),
    .wren(s_swap_write),
    .secret_key(secret_key),
    .start_flag(swap_start_flag),
    .done_flag(swap_done_flag),
    .reset(reset));

//d_memory swap
decrypt_memory decrypt_d_mem (
    .clk(clk),
    .address(decrypt_addr),				//s_mem, d_mem, e_mem address
    .s_data_in(s_decrypt_data_in),		//data in s_mem data
    .s_data_out(s_mem_data_out),		//data out s_mem q
    .d_data_in(d_mem_data_in),			//data in decrypted RAM d_mem data
    .d_data_out(d_mem_data_out),
    .e_data_out(e_mem_data_out),		//data out encrypted ROM e_mem q
    .s_wren(s_decrypt_write),			//write enable s
    .d_wren(d_mem_write),				//write enable d
    .key_found_flag(key_found_flag),		//index k at 31 without invalid char, found a key
    .start_flag(decrypt_start_flag),
    .done_flag(decrypt_done_flag),
    .reset(reset));

	parameter IDLE = 7'b000_0000;
	parameter S_MEM_INIT = 7'b001_0001;
	parameter S_MEM_SWAP = 7'b010_0010;
	parameter S_MEM_DECRYPT = 7'b011_0100;
	parameter DONE = 7'b100_1000;

	assign init_start_flag = state[0];
	assign swap_start_flag = state[1];
	assign decrypt_start_flag = state[2];
	assign datapath_done_flag = state[3];

	assign s_mem_addr = (state == S_MEM_INIT) ? s_init_addr : ((state == S_MEM_SWAP) ? s_swap_addr : decrypt_addr);		//s mem address state dependent 
	assign s_mem_data_in = (state == S_MEM_INIT) ? s_init_data_in : ((state == S_MEM_SWAP) ? s_swap_data_in : s_decrypt_data_in);		//s mem data state dependent 
	assign s_mem_write = (state == S_MEM_INIT) ? s_init_write : ((state == S_MEM_SWAP) ? s_swap_write : s_decrypt_write);		//s mem write state dependent

	assign d_mem_addr = decrypt_addr;	//will only be written to when d_mem_write
	assign e_mem_addr = decrypt_addr;	//will only be used when writing to d_mem with d_mem_write

	//assign secret_key = 24'h000249;     //temp hardcoded secret key

	initial begin
		secret_key = 24'h000000;
		state = IDLE;
		test3 = 1'b0;
	end

	always_ff @(posedge clk, posedge reset)
	begin
		if (reset)
		begin
			secret_key <= 24'h000000;
			state <= IDLE;
			test3 <= 1'b0;
		end
		else
		begin
			case(state)
				IDLE: begin
					if (datapath_start_flag)
						state <= S_MEM_INIT;
					else
						state <= IDLE;
				end
				S_MEM_INIT: begin
					if (init_done_flag)
						state <= S_MEM_SWAP;
					else
						state <= S_MEM_INIT;
				end
				S_MEM_SWAP: begin
					if (swap_done_flag)
						state <= S_MEM_DECRYPT;
					else
						state <= S_MEM_SWAP;
				end
				S_MEM_DECRYPT: begin
					if (decrypt_done_flag && key_found_flag)
						state <= DONE;
					else if (decrypt_done_flag && !key_found_flag)
					begin
						if(secret_key == 24'h3FFFFF)
							state <= DONE;
						else
						begin
							secret_key <= secret_key + 1'b1;
							state <= S_MEM_INIT;
						end
					end
					else
						state <= S_MEM_DECRYPT;
				end
				DONE: begin
					state <= DONE;
				end
				default: begin
					state <= IDLE;
				end
			endcase
		end
	end
endmodule
