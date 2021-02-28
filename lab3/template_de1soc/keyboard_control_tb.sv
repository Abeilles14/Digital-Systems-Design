module keyboard_control_tb();
	logic clk;
	logic read_keyboard_flag;
	logic [7:0] character;
	logic read_addr_start;
	logic dir;
	logic reset;

	parameter character_B =8'h42;
	parameter character_D =8'h44;
	parameter character_E =8'h45;
	parameter character_F =8'h46;
	parameter character_R =8'h52;

	keyboard_control DUT(
		.clk(clk),
		.read_keyboard_flag(read_keyboard_flag),
		.character(character),
		.read_addr_start(read_addr_start),
		.dir(dir),
		.reset(reset));

	initial				//initial block
	begin
		reset = 1'b1;	//initially at reset state
		dir = 1'b1;

    	clk = 0;		//simulates clk every 5ps
    	#5;
    	forever
    	begin
      		clk = 1 ;			//simulate clk
      		#5;
      		clk = 0 ;
      		#5;
    	end
  	end

  	initial				//initial block
	begin
    	read_keyboard_flag = 0;		//simulates clk every 15ps
    	#15;
    	forever
    	begin
      		read_keyboard_flag = 1 ;			//simulate clk
      		#15;
      		read_keyboard_flag = 0 ;
      		#15;
    	end
  	end

	initial begin
		character = character_E;		//playing forward
		#30;

		character = character_D;		//pause forward
		#30;

		character = character_B;		//pause backward
		#30;

		character = character_E;		//playing backward
		#30;

		character = character_R;		//restart backward
		#30;

	end

endmodule
