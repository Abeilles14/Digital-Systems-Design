module DDS_tb();
  logic clk;
  logic reset;
  logic en;
  logic lfsr;
	logic [31:0] phase_inc;
  logic [11:0] sin_out;
  logic [11:0] cos_out;
  logic [11:0] squ_out;
  logic [11:0] saw_out;
  logic [11:0] ask_out;
  logic [11:0] bpsk_out;

  DDS DUT(
    .clk(clk),
    .reset(reset),
    .en(en),
    .lfsr(lfsr),
    .phase_inc(phase_inc),
    .sin_out(sin_out),
    .cos_out(cos_out),
    .squ_out(squ_out),
    .saw_out(saw_out),
    .ask_out(ask_out),
    .bpsk_out(bpsk_out));

  initial       //initial block
  begin
    reset = 1'b1;
    en = 1'b1;
    phase_inc = 32'd258;

    clk = 0;   //simulates clk every 5ps
    #5;
    forever
    begin
      clk = 1 ;      //simulate clk
      #5;
      clk = 0 ;
      #5;
    end
  end

  initial       //initial block
  begin
    lfsr = 0;
    #15;
    forever
    begin
      lfsr = 1 ;      //simulate lfsr
      #15;
      lfsr = 0 ;
      #15;
    end
  end
endmodule