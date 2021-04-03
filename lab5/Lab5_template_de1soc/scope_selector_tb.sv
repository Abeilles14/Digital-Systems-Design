module scope_selector_tb();
	logic clk;
	logic [3:0] sig_sel;
  logic [3:0] mod_sel;
  logic [11:0] sin_sig;
  logic [11:0] cos_sig;
  logic [11:0] saw_sig;
  logic [11:0] squ_sig;
  logic [11:0] ask_mod;
  //logic [11:0] fsk_mod;
  logic [11:0] bpsk_mod;
  logic lfsr_mod;
  logic [11:0] sig_out;
  logic [11:0] mod_out;

	scope_selector DUT(
		.clk(clk),
    .sig_sel(sig_sel),
    .mod_sel(mod_sel),
    .sin_sig(sin_sig),
    .cos_sig(cos_sig),
    .saw_sig(saw_sig),
    .squ_sig(squ_sig),
    .ask_mod(ask_mod),
    //.fsk_mod(fsk_out),
    .bpsk_mod(bpsk_mod),
    .lfsr_mod(lfsr_mod),
    .sig_out(sig_out),
    .mod_out(mod_out));

	initial				//initial block
	begin
    sin_sig = 12'h001;
    cos_sig = 12'h002;
    saw_sig = 12'h003;
    squ_sig = 12'h004;

    ask_mod = 12'h010;
    bpsk_mod = 12'h020;

    sig_sel = 4'b0;       //start at sin and ask
    mod_sel = 4'b0;

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

  initial       //initial block
  begin
    lfsr_mod = 0;
    #15;
    forever
    begin
      lfsr_mod = 1 ;      //simulate lfsr
      #15;
      lfsr_mod = 0 ;
      #15;
    end
  end

  initial				//initial block
	begin
    #10;
    sig_sel = 4'b0001;    //cos and sin
    mod_sel = 4'b0001;
    #10;
    sig_sel = 4'b0010;    //saw and bpsk
    mod_sel = 4'b0010;
    #10;
    sig_sel = 4'b0011;    //squ and lfsr
    mod_sel = 4'b0011;
    #10;
  end
endmodule
