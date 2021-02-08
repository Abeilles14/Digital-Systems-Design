`define LED0 8'b00000001
// `define LED1 8'b00000010
// `define LED2 8'b00000100
// `define LED3 8'b00001000
// `define LED4 8'b00010000
// `define LED5 8'b00100000
// `define LED6 8'b01000000
`define LED7 8'b10000000
`define LEDX 8'bx

//direction encodings
`define LEFT 1'b1
`define RIGHT 1'b0
`define NONE 1'bx

module led_control
	(input logic clk,
	 output logic [7:0] led_pos);

	logic dir;

	initial begin
		dir = `LEFT;
		led_pos = `LED0;
	end
	
	always_ff @(posedge clk)
	begin 					
		case(dir)
			`LEFT: begin
				led_pos = led_pos << 1;		//shift LEDs left
				if (led_pos == `LED7)		//if position at LED7, go right
				begin
					dir = ~dir;
				end
			end
			`RIGHT: begin
				led_pos = led_pos >> 1;		//shift LEDs right
				if (led_pos == `LED0)		//if position at LED0, go left
				begin
					dir = ~dir;
				end
			end
			default: begin
				led_pos = `LEDX;
				dir = `NONE;
			end
		endcase
	end
endmodule


////////////////////////////////

//Alternate functional LED FSM using LED States and register (less efficient)

//state encodings
// `define S0 3'b000
// `define S1 3'b001
// `define S2 3'b010
// `define S3 3'b011
// `define S4 3'b100
// `define S5 3'b101
// `define S6 3'b110
// `define S7 3'b111
// `define SX 3'bx

// module led_control
// 	(input logic clk,
// 	 output logic [7:0] led_pos);

// 	logic [2:0] state, next_state;
// 	logic dir, next_dir;

// 	//state register
// 	state_register #(3) STATE(
// 		.clk(clk),
// 		.d(next_state),
// 		.q(state));

// 	//direction register
// 	state_register #(1) DIR(
// 		.clk(clk),
// 		.d(next_dir),
// 		.q(dir));

// 	//if dir=1, LED move up, if dir=0, LED move down
// 	initial begin
// 		dir = `LEFT;
// 		state = `S0;
// 	end

// //LED FSM
// always_comb
// begin
// 	case(state)
// 		`S0: begin
// 			next_state = `S1;
// 			led_pos = `LED0;
// 			next_dir = `LEFT;
// 		end
// 		`S1: begin
// 			next_state = dir ? `S2 : `S0;		//check led direction for next state
// 			next_dir = dir;
// 			led_pos = `LED1;
// 		end
// 		`S2: begin
// 			next_state = dir ? `S3 : `S1;
// 			next_dir = dir;
// 			led_pos = `LED2;
// 		end
// 		`S3: begin
// 			next_state = dir ? `S4 : `S2;
// 			next_dir = dir;
// 			led_pos = `LED3;
// 		end
// 		`S4: begin
// 			next_state = dir ? `S5 : `S3;
// 			next_dir = dir;
// 			led_pos = `LED4;
// 		end
// 		`S5: begin
// 			next_state = dir ? `S6 : `S4;
// 			next_dir = dir;
// 			led_pos = `LED5;
// 		end
// 		`S6: begin
// 			next_state = dir ? `S7 : `S5;
// 			next_dir = dir;
// 			led_pos = `LED6;
// 		end
// 		`S7: begin
// 			next_state = `S6;
// 			led_pos = `LED7;
// 			next_dir = `RIGHT;
// 		end
// 		default: begin
// 			next_state = `SX;
// 			led_pos = `LEDX;
// 			next_dir = `NONE;
// 		end
// 	endcase
// end
// endmodule

// module state_register #(parameter N = 3)
//     (input logic clk,
//     input logic [N-1:0] d,
//     output logic [N-1:0] q);

//     always @(posedge clk)
//     begin
//         q <= d;
//     end
// endmodule