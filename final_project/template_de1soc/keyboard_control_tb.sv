module keyboard_control_tb();
	logic clk;
	logic read_keyboard_flag;
	logic [7:0] character;
	logic read_addr_start;
	logic audio_done_flag;

	parameter character_0 =8'h30;
	parameter character_1 =8'h31;
	parameter character_2 =8'h32;
	parameter character_3 =8'h33;
	parameter character_4 =8'h34;
	parameter character_5 =8'h35;
	parameter character_6 =8'h36;
	parameter character_7 =8'h37;
	parameter character_8 =8'h38;
	parameter character_9 =8'h39;

keyboard_control DUT(
	.clk(clk),
	.read_keyboard_flag(read_keyboard_flag),
	.character(character),
	.read_addr_start(read_addr_start),
	.audio_done_flag(audio_done_flag));

	initial				//initial block
	begin
		audio_done_flag = 1'b1;

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

	initial begin
		#10;
		read_keyboard_flag = 1'b1;
		character = character_9;
		#20;
		read_keyboard_flag = 1'b0;
		audio_done_flag = 1'b1;
		#10;
		audio_done_flag = 1'b0;
		#10;
		read_keyboard_flag = 1'b1;
		character = character_4;
		#20
		audio_done_flag = 1'b1;
		#5000;
	end
endmodule
