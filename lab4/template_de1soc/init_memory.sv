//start and end addresses
`define START_ADDR 8'h00
`define END_ADDR 8'hFF

module init_memory(
	input logic clk,
	output logic [7:0] address,
	output logic [7:0] data,
	output logic wren
);

	parameter IDLE = 3'b00_0;
	parameter START = 3'b01_1;
	parameter INCREMENT = 3'b10_1;
	parameter DONE = 3'b11_0;

	logic [2:0] state;
	logic [7:0] counter;

	assign wren = state[0];
	assign address = counter;
    assign data = counter;  

	initial begin
		state = IDLE;	
		wren = 1'b0;
		counter = `START_ADDR;
	end

	always_ff @(posedge clk)
	begin
		case(state)
			IDLE: begin
				counter <= counter;
				state <= START;
			end
			START: begin				//write to addr 0
				counter <= `START_ADDR;
				state <= INCREMENT;
			end
			INCREMENT: begin
				if (counter == `END_ADDR)
					state <= DONE;
				else
					counter <= counter + 8'h01;		//incr addr by 1
					state <= INCREMENT;
				end
			DONE: begin
				counter <= counter;
				state <= DONE;
			end
			default: begin
				counter <= counter;
				state <= IDLE;
			end
		endcase
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