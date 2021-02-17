module led_control_tb ();
	logic clk;
	logic [7:0] led_pos;


	led_control DUT(
		.clk(clk),
		.led_pos(led_pos));

	initial				//initial block
	begin
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

	initial
	begin
		//initializing inputs
		$display("Output is %b, expected %b", led_pos, 8'b00000001);	//LED0

		#10;
		$display("Output is %b, expected %b", led_pos, 8'b00000010);	//LED1
		
		#10;
		$display("Output is %b, expected %b", led_pos, 8'b00000100); 	//LED2
		
		#10;
		$display("Output is %b, expected %b", led_pos, 8'b00001000); 	//LED3

		#10;
		$display("Output is %b, expected %b", led_pos, 8'b00010000);	//LED4
		
		#10;
		$display("Output is %b, expected %b", led_pos, 8'b00100000); 	//LED5
		
		#10;
		$display("Output is %b, expected %b", led_pos, 8'b01000000); 	//LED6

		#10;
		$display("Output is %b, expected %b", led_pos, 8'b10000000); 	//LED7

		//led changing directions
		#10;
		$display("Output is %b, expected %b", led_pos, 8'b01000000); 	//LED6
	end
	$stop;
endmodule