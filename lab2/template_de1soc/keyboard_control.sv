`define B 8'h42
`define D 8'h44
`define E 8'h45
`define F 8'h46
`define R 8'h52

//TAKES THESE THE ASCI CODE AS INPUT, AND OUTPUTS STOP/START/RESTART TO THE DATA OUTPUT
module keyboard_control
	(input logic clk,
	 input logic read_keyboard_flag,
	 input logic [7:0] character,
	 output logic read_addr_start,
	 output logic direction,
	 output logic reset);

	logic reset_async; 
	
	initial begin
        reset = 1'b0;
		read_addr_start = 1'b0;
		direction = 1'b1;
    end

	always_ff @(posedge read_keyboard_flag)
	begin
		case(character)
			`B: begin
				direction <= 1'b0;
				{reset_async, read_addr_start} <= {reset_async, read_addr_start};
			end
			`D: begin
				read_addr_start <= 1'b10;
				{reset_async, direction} <= {reset_async, direction};
			end
			`E: begin
				read_addr_start <= 1'b1;
				{reset_async, direction} <= {reset_async, direction};
			end
			`F: begin
				direction <= 1'b1;
				{reset_async, read_addr_start} <= {reset_async, read_addr_start};
			end
			`R: begin
				reset_async <= !reset_async;
				{direction, read_addr_start} <= {direction, read_addr_start};
			end	
		endcase
	end
	

	wire restart_1, restart_2	;
	
	//PULSE FOR RESTART
	synchronizer sync_restart_sig(
		.async_sig(reset_async),
		.outclk(clk),
		.out_sync_sig(restart_1));	
	synchronizer sync_restart_sig1(
		.async_sig(!reset_async),
		.outclk(clk),
		.out_sync_sig(restart_2));
	
	always @(clk)
	begin
		reset = restart_1 | restart_2;	
	end

endmodule