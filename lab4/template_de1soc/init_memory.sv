`define START_ADDR 8'h00		//start and end addresses
`define END_ADDR 8'hFF

module init_memory(
	input logic clk,
	output logic [7:0] address,
	output logic [7:0] data,
	output logic wren,
	input logic start_flag,
	output logic done_flag,
	input logic reset
);

	logic [3:0] state;
	logic [7:0] counter;

	parameter IDLE = 4'b00_00;
	parameter START = 4'b01_01;
	parameter INCREMENT = 4'b10_01;
	parameter DONE = 4'b11_10;

	assign wren = state[0];
	assign address = counter;
    assign data = counter;
    assign done_flag = state[1]; 

	initial begin
		state = IDLE;	
		counter = `START_ADDR;
	end

	always_ff @(posedge clk, posedge reset)
	begin
		if (reset)
		begin
			state = IDLE;
			counter = `START_ADDR;
		end
		else
		begin
			case(state)
				IDLE: begin
					counter <= counter;
					if (start_flag)
						state <= START;
					else
						state <= IDLE;
				end
				START: begin				//write to addr 0
					counter <= `START_ADDR;
					state <= INCREMENT;
				end
				INCREMENT: begin
					if (counter == `END_ADDR)
						state <= DONE;
					else
					begin
						counter <= counter + 8'h01;		//incr addr by 1
						state <= INCREMENT;
					end
					end
				DONE: begin
					counter <= counter;

					//add start flag/return to IDLE?
					state <= DONE;
				end
				default: begin
					counter <= counter;
					state <= IDLE;
				end
			endcase
		end
	end
endmodule

// always_ff @(posedge clk)
// 	begin
// 		case(state)
// 			IDLE: begin
// 				counter <= counter;
// 				state <= WRITE;
// 			end
// 			WRITE: begin				//write to addr 0
// 				counter <= counter;
// 				if(counter == `END_ADDR)
// 					state <= INCREMENT;
// 				else
// 					state <= DONE;
// 			end
// 			INCREMENT: begin
// 				counter <= counter + 8'h01;		//incr addr by 1
// 				state <= WRITE;
// 			end
// 			DONE: begin
// 				counter <= counter;
// 				state <= IDLE;
// 			end
// 			default: begin
// 				state <= IDLE;
// 				counter <= counter;
// 			end
// 		endcase
// 	end
// endmodule