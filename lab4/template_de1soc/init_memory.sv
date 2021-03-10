//start and end addresses
`define START_ADDR 8'h00
`define END_ADDR 8'hFF

module init_memory(
	input logic clk,
	output logic [7:0] address,
	output logic [7:0] data,
	output logic wren
);

	parameter IDLE = 2'b00;
	parameter START = 2'b10;
	parameter INCREMENT = 2'b01;
	parameter DONE = 2'b11;

	logic [1:0] state;

	initial begin
		state = IDLE;	
		wren = 1'b0;
		address = `START_ADDR;
	end

	always_ff @(posedge clk)
	begin
		case(state)
			IDLE: begin
				wren <= 1'b0;
				address <= address;
				data <= address;
				state <= START;
			end
			START: begin				//write to addr 0
				wren <= 1'b1;
				address <= `START_ADDR;
				data <= address;
				state <= INCREMENT;
			end
			INCREMENT: begin
				wren <= 1'b1;
				address <= address + 8'h01;		//incr addr by 1
				data <= address;

			if (address == `END_ADDR)
					state <= DONE;
			else
				state <= INCREMENT;
			end
			DONE: begin
				wren <= 1'b0;
				address <= address;	//reset address
				data <= address;
				state <= IDLE;
			end
			default: begin
				wren <= 1'b0;
				state <= IDLE;
				address <= address;
				data <= address;
			end
		endcase
	end
endmodule
