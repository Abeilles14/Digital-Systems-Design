module datapath(
	input logic clk,
	output logic [7:0] s_mem_addr,
	output logic [7:0] s_mem_data_in,
	input logic [7:0] s_mem_data_out,
	output logic s_mem_write,
	input logic [23:0] secret_key,
	input logic datapath_start_flag,
	input logic reset
);

	logic [5:0] state;
	logic [7:0] s_init_addr, s_init_data_in;
	logic [7:0] s_swap_addr, s_swap_data_in;
	logic s_init_write, s_swap_write;

	logic init_start_flag, swap_start_flag;
	logic init_done_flag, swap_done_flag;

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

	parameter IDLE = 6'b000_000;
	parameter S_MEM_INIT = 6'b001_001;
	parameter S_MEM_SWAP = 6'b010_010;
	parameter DONE = 6'b011_000;

	assign init_start_flag = state[0];
	assign swap_start_flag = state[1];

	assign s_mem_addr = (state == S_MEM_INIT) ? s_init_addr : s_swap_addr;
	assign s_mem_data_in = (state == S_MEM_INIT) ? s_init_data_in : s_swap_data_in;
	assign s_mem_write = (state == S_MEM_INIT) ? s_init_write : s_swap_write;

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
						state <= DONE;
					else
						state <= S_MEM_SWAP;
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
