module multiple_fsm_shared_access_to_one_state_machine
	#(parameter N = 2)
	(output logic [31:0] output_arguments [N],
	output logic start_target_state_machine [N],
	input logic target_state_machine_finished [N],
	input logic sm_clk,
	input logic start_request [N],
	output logic finish [N],
	output logic reset_start_request [N],
	input logic [31:0] input_arguments [N],
	output logic [7:0] received_data [N],
	input logic reset,
	input logic [7:0] in_received_data [N]);

	genvar i;
	generate
		for(i = 0; i < N-1; i++)
		begin : generate_fsm
			state_machine fsm (
				.output_arguments(output_arguments[i]),
				.start_target_state_machine(start_target_state_machine[i]),
				.target_state_machine_finished(target_state_machine_finished[i]),
				.sm_clk(sm_clk),
				.start_request(start_request[i]),
				.finish(finish[i]),
				.reset_start_request(reset_start_request[i]),
				.input_arguments(input_arguments[i]),
				.received_data(received_data[i]),
				.reset(reset),
				.in_received_data(in_received_data[i]));
		end
	endgenerate
endmodule

module state_machine
	(output logic [31:0] output_arguments,
	output logic start_target_state_machine,
	input logic target_state_machine_finished,
	input logic sm_clk,
	input logic start_request,
	output logic finish,
	output logic reset_start_request,
	input logic [31:0] input_arguments,
	output logic [7:0] received_data,
	input logic reset,
	input logic [7:0] in_received_data);

	logic register_data_enable;
	
	reg [7:0] state;

	//FSM STATES
	//fsm_a
	parameter check_start = 8'b0000_0000;
	parameter give_start = 8'b0000_0110;
	parameter wait_for_finish = 8'b0000_0010;
	parameter register_data	= 8'b0100_0000;
	parameter give_finish = 8'b0001_0000;

	assign start_target_state_machine = state[1];
	assign reset_start_request = state[2];
	assign finish = state[4];
	assign register_data_enable = state[6];

	assign output_arguments = input_arguments;


	always_ff @(posedge sm_clk)
	begin
		case(state)
			check_start: begin 
				if (start_request)
					state <= give_start;
				end						
			give_start: begin
				state <= wait_for_finish;
			end
			wait_for_finish: begin
				if (target_state_machine_finished)
					state <= register_data;
				else
					state <= wait_for_finish;
			end
			register_data: begin
				state <= give_finish;
			end
			give_finish: begin
					state <= check_start;
			end
			default: begin
				state <= check_start;
			end
		endcase
	end
					
	always @(posedge register_data_enable or posedge reset)
	begin
		if (reset)
			received_data <= 8'b0;
		else
			received_data <= in_received_data;
	end
endmodule

