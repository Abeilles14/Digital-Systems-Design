module DDS_selector_tb();
  logic clk;
  logic reset;
  logic en;
  logic lfsr;
	logic [31:0] phase_inc;
  logic [31:0] fsk_phase_inc;
  logic [7:0] sig_sel;
  logic [3:0] mod_sel;
  logic [11:0] sig_out;
  logic [11:0] mod_out;

  DDS_selector DUT(
  .clk(clk),
  .reset(reset),
  .en(en),
  .lfsr(lfsr),   //use sync'd lfsr[0] and CLOCK_50 signal
  .phase_inc(phase_inc),
  .fsk_phase_inc(fsk_phase_inc),
  .sig_sel(sig_sel),
  .mod_sel(mod_sel),
  .sig_out(sig_out),
  .mod_out(mod_out));

  initial       //initial block
  begin
    reset = 1'b1;
    en = 1'b1;
    phase_inc = 32'd258;      //3hz
    fsk_phase_inc = 32'd86;   //1hz

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

  initial
  begin
    sig_out = 4'b0000;
    mod_out = 4'b0000; 
    #50;

    sig_out = 4'b0011;
    mod_out = 4'b0011;
    #1000;
  end
endmodule