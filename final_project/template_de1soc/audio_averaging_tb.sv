module audio_averaging_tb();
	logic clk;
	logic start_averaging_flag;
	logic [7:0] input_audio;
	logic [7:0] led_out;
	logic led0;

	audio_averaging DUT(
	  .clk(clk),
	  .start_averaging_flag(start_averaging_flag),
	  .input_audio(input_audio),
	  .led_out(led_out),
	  .led0(led0));

	initial				//initial block
	begin
		start_averaging_flag = 1'b1;
		input_audio = 8'b0000_1111;

    	clk = 0;		//simulates clk every 5ps
    	#5;

    	forever
    	begin
      		clk = 1;			//simulate clk
      		#5;
      		clk = 0;
      		#5;
    	end
  	end

	initial begin
		#5000;
	end
endmodule