module divider(clock, speed_up, speed_down, reset, divider);
	//parameter base = 32'd1227;
	parameter base = 32'h0471;
	
	input speed_up, speed_down, reset;
	input clock;

	
	output logic [31:0] divider = base;
	
	always @(posedge clock)
	begin
			if (speed_up)			 	divider <= divider - 2'b11;
			else if(speed_down) 		divider <=divider + 2'b11;
			else if(reset)				divider <= base;
	end
		
endmodule	