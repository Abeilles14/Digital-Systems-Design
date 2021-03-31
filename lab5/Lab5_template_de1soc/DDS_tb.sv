module DDS_tb();
  logic clk;
  logic reset;
  logic en;
	logic [31:0] phase_inc;
  logic [11:0] sin_out;
  logic [11:0] cos_out;
  logic [11:0] squ_out;
  logic [11:0] saw_out;

  DDS DUT(
    .clk(clk),
    .reset(reset),
    .en(en),
    .phase_inc(phase_inc),
    .sin_out(sin_out),
    .cos_out(cos_out),
    .squ_out(squ_out),
    .saw_out(saw_out));

	initial				//initial block
	begin
    reset = 1'b1;
    en = 1'b1;

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

  initial
  begin
  	#1000;
  end
endmodule