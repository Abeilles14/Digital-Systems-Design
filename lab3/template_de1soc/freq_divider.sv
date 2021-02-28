module freq_divider #(parameter N = 32)
	(input logic inclk,
	output logic outclk,
	input logic [N-1:0] div_clk_count,
	input reset);

	logic [N-1:0] clk_count;

	initial begin
		outclk = 1'b0;
		clk_count = 1'b0;
	end

	always_ff @(posedge inclk)
	begin
		//if rest clock, counter and outclk freq = 0
		if(~reset)
		begin
			clk_count <= 1'b0;
			outclk <= 1'b0;
		end
		begin
			//if counter < division clk, keep counting
			if (clk_count < div_clk_count)
			begin
				clk_count <= clk_count + 1'b1;		//next state logic
			end

			//if counter >= division clk, reverse clk count down
			else
			begin
				outclk <= ~outclk;
				clk_count <= 1'b0;
			end
		end
	end
endmodule
