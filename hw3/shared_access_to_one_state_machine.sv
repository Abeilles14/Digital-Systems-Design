module shared_access_to_one_state_machine
	(output logic [31:0] output_arguments,
	output logic start_target_state_machine,
	input logic target_state_machine_finished,
	input logic sm_clk,
	input logic start_request_a,
	input logic start_request_b,
	output logic finish_a,
	output logic finish_b,
	output logic reset_start_request_a,
	output logic reset_start_request_b,
	input logic [31:0] input_arguments_a,
	input logic [31:0] input_arguments_b,
	output logic [7:0] received_data_a,
	output logic [7:0] received_data_b,
	input logic reset,
	input logic [7:0] in_received_data);

	logic register_data_a_enable, register_data_b_enable, select_b_output_parameters;
	
	reg [7:0] state;

	//FSM STATES
	//fsm_a
	parameter check_start_a = 8'b0000_0000;
	parameter give_start_a 	= 8'b0000_0110;
	parameter wait_for_finish_a	= 8'b0000_0010;
	parameter register_data_a = 8'b0100_0000;
	parameter give_finish_a	= 8'b0001_0000;

	//fsm_b
	parameter check_start_b	= 8'b0000_0001;
	parameter give_start_b = 8'b0000_1011;
	parameter wait_for_finish_b = 8'b0000_0011;
	parameter register_data_b = 8'b1000_0001;
	parameter give_finish_b	= 8'b0010_0001;

	assign select_b_output_parameters = state[0];
	assign start_target_state_machine = state[1];
	assign reset_start_request_a = state [2];
	assign reset_start_request_b = state [3];
	assign finish_a = state [4];
	assign finish_b = state [5];
	assign register_data_a_enable = state[6];
	assign register_data_b_enable = state[7];


	assign output_arguments = select_b_output_parameters ? input_arguments_b : input_arguments_a;

	always_ff @(posedge sm_clk)
	begin
		case(state)
			check_start_a: begin 
				if (start_request_a)
					state <= give_start_a;
				else
					state <= check_start_b;
			end						
			give_start_a: begin
				state <= wait_for_finish_a;
			end
			wait_for_finish_a: begin
				if (target_state_machine_finished)
					state <= register_data_a;
				else
					state <= wait_for_finish_a;
			end
			register_data_a: begin
				state <= give_finish_a;
			end
			give_finish_a: begin
				state <= check_start_b;
			end
			check_start_b: begin
				if(start_request_b)
					state <= give_start_b;
				else
					state <= check_start_a;
			end
			give_start_b: begin
				state <= wait_for_finish_b;
			end
			wait_for_finish_b: begin
				if (target_state_machine_finished)
					state <= register_data_b;
				else
					state <= wait_for_finish_b;
			end
			register_data_b: begin
				state <= give_finish_b;
			end
			give_finish_b: begin
				state <= check_start_a;
			end
			default: begin
				state <= check_start_a;
			end
		endcase
	end
			
	always @(posedge register_data_a_enable or posedge reset) begin
		if (reset)
			received_data_a <= 8'b0;
		else
			received_data_a <= in_received_data;
		end	

	always @(posedge register_data_b_enable or posedge reset) begin
		if (reset)
			received_data_b <= 8'b0;
		else
			received_data_b <= in_received_data;
	end
endmodule