module multicore_controller(
	input logic clk,
	output logic [23:0] secret_key,
	output logic [3:0] key_found_flag,
	input logic multicore_start_flag,
	output logic multicore_done_flag,
	input logic reset
	);

logic stop_flag;
logic [23:0] key_range_1, key_range_2, key_range_3, key_range_4;
logic key_found_1, key_found_2, key_found_3, key_found_4;
logic [23:0] current_key_1, current_key_2, current_key_3, current_key_4;
logic datapath_done_1, datapath_done_2, datapath_done_3, datapath_done_4;

assign key_range_1 = 24'h000000;		//start value key for each core
assign key_range_2 = 24'h100000;
assign key_range_3 = 24'h200000;
assign key_range_4 = 24'h300000;

datapath decryption_core_1 (
    .clk(clk),
    .secret_key(current_key_1),
    .key_start_value(key_range_1),
    .key_found_flag(key_found_1),
    .datapath_start_flag(multicore_start_flag),
    .datapath_done_flag(datapath_done_1),
    .stop(stop_flag),
    .reset(reset));

datapath decryption_core_2 (
    .clk(clk),
    .secret_key(current_key_2),
    .key_start_value(key_range_2),
    .key_found_flag(key_found_2),
    .datapath_start_flag(multicore_start_flag),
    .datapath_done_flag(datapath_done_2),
    .stop(stop_flag),
    .reset(reset));

datapath decryption_core_3 (
    .clk(clk),
    .secret_key(current_key_3),
    .key_start_value(key_range_3),
    .key_found_flag(key_found_3),
    .datapath_start_flag(multicore_start_flag),
    .datapath_done_flag(datapath_done_3),
    .stop(stop_flag),
    .reset(reset));

datapath decryption_core_4 (
    .clk(clk),
    .secret_key(current_key_4),
    .key_start_value(key_range_4),
    .key_found_flag(key_found_4),
    .datapath_start_flag(multicore_start_flag),
    .datapath_done_flag(datapath_done_4),
    .stop(stop_flag),
    .reset(reset));

	assign multicore_done_flag = stop_flag;
	//assign secret_key = current_key_4;

	initial begin
		secret_key = current_key_1;			//display core 1 secret key incrementing initially
		stop_flag = 1'b0;
		key_found_flag = 4'b0000;
	end

	always_ff @(posedge clk)
	begin
		if (key_found_1)					//core 1 found key
		begin
			key_found_flag = 4'b0001;
			secret_key = current_key_1;
			stop_flag = 1'b1;
		end
		else if (key_found_2)				//core 2 found key
		begin
			key_found_flag = 4'b0010;
			secret_key = current_key_2;
			stop_flag = 1'b1;
		end
		else if (key_found_3)				//core 3 found key
		begin
			key_found_flag = 4'b0100;
			secret_key = current_key_3;
			stop_flag = 1'b1;
		end
		else if (key_found_4)				//core 4 found key
		begin
			key_found_flag = 4'b1000;
			secret_key = current_key_4;
			stop_flag = 1'b1;
		end
		else
		begin
			key_found_flag = 4'b0000;
			secret_key = current_key_1;
			stop_flag = 1'b0;
		end
	end
endmodule