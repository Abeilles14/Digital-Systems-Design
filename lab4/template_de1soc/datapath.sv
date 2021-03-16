module datapath(
	input logic clk,
	output logic [7:0] s_mem_addr,
	output logic [7:0] s_mem_data_in,
	input logic [7:0] s_mem_data_out,
	output logic s_mem_write,
	output logic [7:0] d_mem_addr,
	output logic [7:0] d_mem_data_in,
	output logic d_mem_write,
	output logic [7:0] e_mem_addr,
	input logic [7:0] e_mem_data_out,
	input logic [23:0] secret_key,
	input logic datapath_start_flag,
	input logic reset
);

	logic [5:0] state;
	logic [7:0] s_init_addr, s_init_data_in;
	logic [7:0] s_swap_addr, s_swap_data_in;
	logic [7:0] d_decrypt_addr, d_decrypt_data_in;
	logic [7:0] e_decrypt_addr;
	logic s_init_write, s_swap_write, d_decrypt_write;

	logic init_start_flag, swap_start_flag, decrypt_start_flag;
	logic init_done_flag, swap_done_flag, decrypt_done_flag;

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
    .address(d_decrypt_addr),
    .d_data_in(d_decrypt_data_in),
    .s_data_out(s_mem_data_out),
    .e_data_out(e_mem_data_out),
    .wren(d_decrypt_write),
    .start_flag(decrypt_start_flag),
    .done_flag(decrypt_done_flag),
    .reset(reset));

	parameter IDLE = 6'b000_000;
	parameter S_MEM_INIT = 6'b001_001;
	parameter S_MEM_SWAP = 6'b010_010;
	parameter S_MEM_DECRYPT = 6'b011_100;
	parameter DONE = 6'b100_000;

	assign init_start_flag = state[0];
	assign swap_start_flag = state[1];
	assign decrypte_start_flag = state[2];

	assign s_mem_addr = (state == S_MEM_INIT) ? s_init_addr : s_swap_addr;		//s mem address state dependent 
	assign s_mem_data_in = (state == S_MEM_INIT) ? s_init_data_in : s_swap_data_in;		//s mem data state dependent 
	assign s_mem_write = (state == S_MEM_INIT) ? s_init_write : s_swap_write;		//s mem write state dependent

	initial begin
		state = IDLE;	
	end

	always_ff @(posedge clk, posedge reset)
	begin
		if (reset)
			state = IDLE;
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
					if (decrypt_done_flag)
						state <= S_MEM_DONE;
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
