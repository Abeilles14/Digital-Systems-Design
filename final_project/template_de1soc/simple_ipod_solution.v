`default_nettype none
module simple_ipod_solution(

    //////////// CLOCK //////////
    CLOCK_50,
    TD_CLK27,

    //////////// LED //////////
    LEDR,

    //////////// KEY //////////
    KEY,

    //////////// SW //////////
    SW,

    //////////// SEG7 //////////
    HEX0,
    HEX1,
    HEX2,
    HEX3,
    HEX4,
    HEX5,

    //////////// Audio //////////
    AUD_ADCDAT,
    AUD_ADCLRCK,
    AUD_BCLK,
    AUD_DACDAT,
    AUD_DACLRCK,
    AUD_XCK,

    //////////// I2C for Audio  //////////
    FPGA_I2C_SCLK,
    FPGA_I2C_SDAT,
    
    
    //////// PS2 //////////
    PS2_CLK,
    PS2_DAT,
    
    //////// SDRAM //////////
    DRAM_ADDR,
    DRAM_BA,
    DRAM_CAS_N,
    DRAM_CKE,
    DRAM_CLK,
    DRAM_CS_N,
    DRAM_DQ,
    DRAM_LDQM,
    DRAM_UDQM,
    DRAM_RAS_N,
    DRAM_WE_N,
    
    //////// GPIO //////////
    GPIO_0,
    GPIO_1
    
);
`define zero_pad(width,signal)  {{((width)-$size(signal)){1'b0}},(signal)}
//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input                       CLOCK_50;
input 						TD_CLK27;

//////////// LED //////////
output           [9:0]      LEDR;

//////////// KEY //////////
input            [3:0]      KEY;

//////////// SW //////////
input            [9:0]      SW;

//////////// SEG7 //////////
output           [6:0]      HEX0;
output           [6:0]      HEX1;
output           [6:0]      HEX2;
output           [6:0]      HEX3;
output           [6:0]      HEX4;
output           [6:0]      HEX5;



//////////// Audio //////////
input                       AUD_ADCDAT;
inout                       AUD_ADCLRCK;
inout                       AUD_BCLK;
output                      AUD_DACDAT;
inout                       AUD_DACLRCK;
output                      AUD_XCK;

//////////// I2C for Audio  //////////
output                      FPGA_I2C_SCLK;
inout                       FPGA_I2C_SDAT;

//////////// PS2 //////////
inout                       PS2_CLK;
inout                       PS2_DAT;

//////////// GPIO //////////
inout           [35:0]      GPIO_0;
inout           [35:0]      GPIO_1;
                
                
//////////// SDRAM //////////
output          [12:0]      DRAM_ADDR;
output        [1:0]         DRAM_BA;
output                      DRAM_CAS_N;
output                      DRAM_CKE;
output                      DRAM_CLK;
output                      DRAM_CS_N;
inout           [15:0]      DRAM_DQ;
output                      DRAM_LDQM;
output                      DRAM_UDQM;
output                      DRAM_RAS_N;
output                      DRAM_WE_N;


//=======================================================
//  REG/WIRE declarations
//=======================================================
// Input and output declarations
logic CLK_50M;
logic  [9:0] LED;
assign CLK_50M =  CLOCK_50;
assign LEDR[9:0] = LED[9:0];

//Character definitions

//numbers
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


//Uppercase Letters
parameter character_A =8'h41;
parameter character_B =8'h42;
parameter character_C =8'h43;
parameter character_D =8'h44;
parameter character_E =8'h45;
parameter character_F =8'h46;
parameter character_G =8'h47;
parameter character_H =8'h48;
parameter character_I =8'h49;
parameter character_J =8'h4A;
parameter character_K =8'h4B;
parameter character_L =8'h4C;
parameter character_M =8'h4D;
parameter character_N =8'h4E;
parameter character_O =8'h4F;
parameter character_P =8'h50;
parameter character_Q =8'h51;
parameter character_R =8'h52;
parameter character_S =8'h53;
parameter character_T =8'h54;
parameter character_U =8'h55;
parameter character_V =8'h56;
parameter character_W =8'h57;
parameter character_X =8'h58;
parameter character_Y =8'h59;
parameter character_Z =8'h5A;

//Lowercase Letters
parameter character_lowercase_a= 8'h61;
parameter character_lowercase_b= 8'h62;
parameter character_lowercase_c= 8'h63;
parameter character_lowercase_d= 8'h64;
parameter character_lowercase_e= 8'h65;
parameter character_lowercase_f= 8'h66;
parameter character_lowercase_g= 8'h67;
parameter character_lowercase_h= 8'h68;
parameter character_lowercase_i= 8'h69;
parameter character_lowercase_j= 8'h6A;
parameter character_lowercase_k= 8'h6B;
parameter character_lowercase_l= 8'h6C;
parameter character_lowercase_m= 8'h6D;
parameter character_lowercase_n= 8'h6E;
parameter character_lowercase_o= 8'h6F;
parameter character_lowercase_p= 8'h70;
parameter character_lowercase_q= 8'h71;
parameter character_lowercase_r= 8'h72;
parameter character_lowercase_s= 8'h73;
parameter character_lowercase_t= 8'h74;
parameter character_lowercase_u= 8'h75;
parameter character_lowercase_v= 8'h76;
parameter character_lowercase_w= 8'h77;
parameter character_lowercase_x= 8'h78;
parameter character_lowercase_y= 8'h79;
parameter character_lowercase_z= 8'h7A;

//Other Characters
parameter character_colon = 8'h3A;          //':'
parameter character_stop = 8'h2E;           //'.'
parameter character_semi_colon = 8'h3B;   //';'
parameter character_minus = 8'h2D;         //'-'
parameter character_divide = 8'h2F;         //'/'
parameter character_plus = 8'h2B;          //'+'
parameter character_comma = 8'h2C;          // ','
parameter character_less_than = 8'h3C;    //'<'
parameter character_greater_than = 8'h3E; //'>'
parameter character_equals = 8'h3D;         //'='
parameter character_question = 8'h3F;      //'?'
parameter character_dollar = 8'h24;         //'$'
parameter character_space=8'h20;           //' '     
parameter character_exclaim=8'h21;          //'!'


wire Clock_1KHz, Clock_1Hz;
wire Sample_Clk_Signal;

//=======================================================================================================================
//
// Insert your code for Lab2 here!
//
//

//flash mem vars
wire flash_mem_read;
wire flash_mem_waitrequest;
wire [22:0] flash_mem_address;
wire [31:0] flash_mem_readdata;
wire flash_mem_readdatavalid;
wire [3:0] flash_mem_byteenable;
wire [31:0] flash_mem_writedata;
wire flash_mem_write;

//clk crossing and sync
logic clk_7200hz, clk_7200hz_sync;
logic[31:0] div_clk_7200hz;
logic CLK_27M;

//flash fsm
logic [31:0] flash_data;
logic [7:0] audio_out;
logic start_read_flag, read_addr_start, addr_ready_flag, reset_flag, read_keyboard_flag;

logic [23:0] start_address, end_address;
logic [7:0] phoneme_sel;
logic silent_flag, picoblaze_start_flag, picoblaze_done_flag, visualizer_flag, done_flash_read;

//encoder decoder
logic enc_disparity, dec_disparity, disparity_err, K_char;
logic [9:0] enc_audio;

//keyboard
logic [7:0] valid_character;
logic invalid_char_flag, audio_done_flag, audio_start_flag;

//FLASH READ only
assign flash_mem_write = 1'b0;
assign flash_mem_writedata = 32'b0;
assign flash_mem_byteenable = 6'b000001;

assign CLK_27M = TD_CLK27;		//TD_CLK27 pin to use a CLK_27M clk

//control sampling speed with initial freq 22khz
speed_controller div_control_7200hz(
                  .clk50M(CLK_50M),
									.up(speed_up_event),
									.down(speed_down_event),
									.div(div_clk_7200hz), 		//outputs new clk division
									.rst(speed_reset_event));

//generate 22kHz clk
freq_divider generate_7200hz_clock(
                  .inclk(CLK_50M),		//can use CLK_50M
								  .outclk(clk_7200hz),
								  .div_clk_count(div_clk_7200hz),	//22khz init for 27M 32'h0265
								  .reset(1'b1));

//sync address incremented flag and addr ready to read flag
synchronizer sync_states(
             .vcc(1'b1),
						 .gnd(1'b0),
						 .async_sig(addr_ready_flag),		//done incrementing address
						 .outclk(CLK_50M),
						 .out_sync_sig(start_read_flag));	//ready to begin reading next address & start FSM

synchronizer sync_clocks_7200hz(
             .vcc(1'b1),
						 .gnd(1'b0),
						 .async_sig(clk_7200hz),
						 .outclk(CLK_50M),
						 .out_sync_sig(clk_7200hz_sync));	//syncs 22kHz clk to 50MHz clk

synchronizer sync_keyboard(
             .vcc(1'b1),
						 .gnd(1'b0),
						 .async_sig(kbd_data_ready),
						 .outclk(clk_7200hz_sync),
						 .out_sync_sig(read_keyboard_flag));	//ready to listen to keyboard input

address_counter count_addr(
.clk(CLK_50M),
.clk_22khz_sync(clk_7200hz_sync),
.current_address(flash_mem_address),
.flash_data(flash_mem_readdata),
.read_data_flag(flash_mem_read),      //addr ready flag
.led_start_flag(visualizer_flag),
.start_read(read_addr_start),                  //start reading address
.read_done_flag(done_flash_read),
.audio_out(audio_out),
.start_address(start_address),
.end_address(end_address),
.silent_flag(silent_flag),
.picoblaze_start_flag(picoblaze_start_flag),         //start flag
.picoblaze_done_flag(picoblaze_done_flag),         //done vlag
.reset(reset_flag)); 

read_flash read_FLASH(
.clk(CLK_50M),
.start_read_flag(flash_mem_read),
.wait_read_request(flash_mem_waitrequest), 
.read_data_valid(flash_mem_readdatavalid),
.read_data_flag(flash_mem_read),
.done_read_flag(done_flash_read)); 

audio_averaging visualizer(
  .clk(CLK_50M),
  .start_averaging_flag(visualizer_flag),
  .input_audio(audio_out),
  .silent_flag(silent_flag),
  .led_out(ledtemp));//LED[9:2]));

logic ledtemp;

encoder_8b10b encoder (
  .SBYTECLK(CLK_50M),
  .reset(1'b0),
  .K(K_char),
  .ebi(audio_out),     //to be encoded
  .tbi(enc_audio),          //encoded
  .disparity(enc_disparity));

decoder_8b10b decoder(
  .RBYTECLK(CLK_50M),
  .reset(1'b0),
  .tbi(enc_audio),        //to be decoded
  .K_out(K_char),
  .ebi(audio_data),       //decoded
  .disparity(dec_disparity),
  .disparity_err(disparity_err));

//phoneme addresses
narrator_ctrl narrator (
  .clk(CLK_50M),
  .phoneme_sel(phoneme_sel),      //phoneme address
  .start_address(start_address),
  .end_address(end_address),
  .silent(silent_flag));

//keyboard input
keyboard_control keyboard_input(
	.clk(clk_7200hz_sync),
	.read_keyboard_flag(read_keyboard_flag),
	.character(kbd_received_ascii_code),
  .valid_char(valid_character),
  .error_flag(invalid_char_flag),
	.read_addr_start(read_addr_start),
  .picoblaze_done_flag(picoblaze_done_flag),
  .audio_done_flag(audio_done_flag),
  .led0(LED[0]),
  .led1(led1));

logic led1;
assign LED[1] = audio_done_flag;
assign LED[2] = read_addr_start;  //
assign LED[3] = kbd_data_ready;
assign LED[4] = read_keyboard_flag;

flash flash_inst(
    .clk_clk                 (CLK_50M),
    .reset_reset_n           (1'b1),
    .flash_mem_write         (1'b0),
    .flash_mem_burstcount    (1'b1),
    .flash_mem_waitrequest   (flash_mem_waitrequest),	//output, not using
    .flash_mem_read          (flash_mem_read),			//input ready to read address
    .flash_mem_address       (flash_mem_address),		//input address to read
    .flash_mem_writedata     (),
    .flash_mem_readdata      (flash_mem_readdata),		//output data when readdatavalid
    .flash_mem_readdatavalid (flash_mem_readdatavalid),	//output ready to read data
    .flash_mem_byteenable    (flash_mem_byteenable)		//don't care
	);


//Audio Generation Signal
//Note that the audio needs signed data - so convert 1 bit to 8 bits signed
assign Sample_Clk_Signal = Clock_1KHz;
wire [7:0] audio_data;

//using picoblaze
picoblaze_template #(.clk_freq_in_hz(25000000)) picoblaze_template_inst(
  .clk(CLK_50M),
  .input_data(valid_character),
  .error_flag(invalid_char_flag),
  .interrupt_flag(start_read_flag),
  .phoneme_out(phoneme_sel),
  .start_phoneme_flag(picoblaze_start_flag),
  .start_word_flag(read_keyboard_flag),//read_addr_start),
  .done_phoneme_flag(picoblaze_done_flag),
  .done_word_flag(audio_done_flag)
  ); //interrupt routine flag

//======================================================================================
// 
// Keyboard Interface
//
//

wire ps2c, ps2d; //filtered kbd wires
wire kbd_data_ready, Kbd_to_LCD_finish;

doublesync ps2c_doublsync
(.indata(PS2_CLK),
.outdata(ps2c),
.clk(CLK_50M),
.reset(1'b1));

doublesync ps2d_doublsync
(.indata(PS2_DAT),
.outdata(ps2d),
.clk(CLK_50M),
.reset(1'b1));

wire reset_kbd_data;
(* KEEP = "TRUE" *) wire conv_now_ignore_timing;
 
wire [7:0] kbd_received_ascii_code, kbd_scan_code;
    
Kbd_ctrl Kbd_Controller(
.kbd_clk(ps2c), 
.kbd_data(ps2d),
 .clk(CLK_50M), 
.scan_code(kbd_scan_code), 
.reset_kbd_reg(~reset_kbd_data), 
.data_ready(kbd_data_ready)
);
                
key2ascii kbd2ascii(
.key_code(kbd_scan_code),
.ascii_code(kbd_received_ascii_code),
.clk(conv_now_ignore_timing)
); 
            
parameter scope_info_bytes = 16;
parameter scope_info_bits_per_byte = 8;

wire [15:0] write_kbd_debug;

wire  [scope_info_bits_per_byte-1:0] scope_info0, scope_info1, scope_info2,
     scope_info3, scope_info4, scope_info5, scope_info6, scope_info7, scope_info8, 
     scope_info9, scope_info10, scope_info11, scope_info12, scope_info13, 
     scope_info14, scope_info15;
                
Write_Kbd_To_Scope_LCD Write_Kbd_To_LCD1
(.kbd_ascii_data(kbd_received_ascii_code), 
              .kbd_ready(kbd_data_ready), .reset_kbd_data(reset_kbd_data), 
                     .sm_clk(CLK_50M), .reset(1'b1), 
                     .finish(Kbd_to_LCD_finish), 
                     .scope_info0(scope_info0), 
                     .scope_info1(scope_info1),
                     .scope_info2(scope_info2),
                     .scope_info3(scope_info3),
                     .scope_info4(scope_info4),
                     .scope_info5(scope_info5),
                     .scope_info6(scope_info6),
                     .scope_info7(scope_info7),
                     .scope_info8(scope_info8),
                     .scope_info9(scope_info9),
                     .scope_info10(scope_info10),
                     .scope_info11(scope_info11),
                     .scope_info12(scope_info12),
                     .scope_info13(scope_info13),
                     .scope_info14(scope_info14),
                     .scope_info15(scope_info15),
                     .debug(write_kbd_debug),
                     .convert_now(conv_now_ignore_timing)
    );
                
//=====================================================================================
//
// LCD Scope Acquisition Circuitry Wire Definitions                 
//
//=====================================================================================

wire allow_run_LCD_scope;
wire [15:0] scope_channelA, scope_channelB;
(* keep = 1, preserve = 1 *)wire scope_clk;
reg user_scope_enable_trigger;
wire user_scope_enable;
wire user_scope_enable_trigger_path0, user_scope_enable_trigger_path1;
wire scope_enable_source = SW[8];
wire choose_LCD_or_SCOPE = SW[9];


doublesync user_scope_enable_sync1(.indata(scope_enable_source),
                  .outdata(user_scope_enable),
                  .clk(CLK_50M),
                  .reset(1'b1)); 

//Generate the oscilloscope clock
Generate_Arbitrary_Divided_Clk32 
Generate_LCD_scope_Clk(
.inclk(CLK_50M),
.outclk(scope_clk),
.outclk_Not(),
.div_clk_count(scope_sampling_clock_count),
.Reset(1'h1));

//Scope capture channels
//Scope capture channels

(* keep = 1, preserve = 1 *) logic ScopeChannelASignal;
(* keep = 1, preserve = 1 *) logic ScopeChannelBSignal;

assign ScopeChannelASignal = Sample_Clk_Signal;
assign ScopeChannelBSignal = SW[1];
//Scope capture channels

scope_capture LCD_scope_channelA(
.clk(scope_clk),
.the_signal(ScopeChannelASignal),
.capture_enable(allow_run_LCD_scope & user_scope_enable), 
.captured_data(scope_channelA), //Insert your channel B signal here
.reset(1'b1));

scope_capture LCD_scope_channelB
(
.clk(scope_clk),
.the_signal(ScopeChannelBSignal),
.capture_enable(allow_run_LCD_scope & user_scope_enable), 
.captured_data(scope_channelB), //Insert your channel A signal here
.reset(1'b1));

//The LCD scope and display
LCD_Scope_Encapsulated_pacoblaze_wrapper LCD_LED_scope(
					    //LCD control signals
					    .lcd_d(GPIO_0[7:0]),
					    .lcd_rs(GPIO_0[8]),
					    .lcd_rw(GPIO_0[9]),
					    .lcd_e(GPIO_0[10]),
					    .clk(CLK_50M),
                
                        //LCD Display values
                      .InH(8'hAA),
                      .InG(8'hBB),
                      .InF(8'h01),
                       .InE(8'h23),
                      .InD(8'h45),
                      .InC(8'h67),
                      .InB(8'h89),
                     .InA(8'h00),
                          
                     //LCD display information signals
                         .InfoH({scope_info15,scope_info14}),
                          .InfoG({scope_info13,scope_info12}),
                          .InfoF({scope_info11,scope_info10}),
                          .InfoE({scope_info9,scope_info8}),
                          .InfoD({scope_info7,scope_info6}),
                          .InfoC({scope_info5,scope_info4}),
                          .InfoB({scope_info3,scope_info2}),
                          .InfoA({scope_info1,scope_info0}),
                          
                  //choose to display the values or the oscilloscope
                          .choose_scope_or_LCD(choose_LCD_or_SCOPE),
                          
                  //scope channel declarations
                          .scope_channelA(scope_channelA), //don't touch
                          .scope_channelB(scope_channelB), //don't touch
                          
                  //scope information generation
                          .ScopeInfoA(audio_data),
                          .ScopeInfoB(flash_mem_address),
                          
                 //enable_scope is used to freeze the scope just before capturing 
                 //the waveform for display (otherwise the sampling would be unreliable)
                          .enable_scope(allow_run_LCD_scope) //don't touch
                          
    );  
    

//=====================================================================================
//
//  Seven-Segment and speed control
//
//=====================================================================================

wire speed_up_event, speed_down_event;

//Generate 1 KHz Clock
Generate_Arbitrary_Divided_Clk32 
Gen_1KHz_clk
(
.inclk(CLK_50M),
.outclk(Clock_1KHz),
.outclk_Not(),
.div_clk_count(32'h61A6), //change this if necessary to suit your module
.Reset(1'h1)); 

wire speed_up_raw;
wire speed_down_raw;

doublesync 
key0_doublsync
(.indata(!KEY[0]),
.outdata(speed_up_raw),
.clk(Clock_1KHz),
.reset(1'b1));


doublesync 
key1_doublsync
(.indata(!KEY[1]),
.outdata(speed_down_raw),
.clk(Clock_1KHz),
.reset(1'b1));


parameter num_updown_events_per_sec = 10;
parameter num_1KHZ_clocks_between_updown_events = 1000/num_updown_events_per_sec;

reg [15:0] updown_counter = 0;
always @(posedge Clock_1KHz)
begin
      if (updown_counter >= num_1KHZ_clocks_between_updown_events)
      begin
            if (speed_up_raw)
            begin
                  speed_up_event_trigger <= 1;          
            end 
            
            if (speed_down_raw)
            begin
                  speed_down_event_trigger <= 1;            
            end 
            updown_counter <= 0;
      end
      else 
      begin
           updown_counter <= updown_counter + 1;
           speed_up_event_trigger <=0;
           speed_down_event_trigger <= 0;
      end     
end

wire speed_up_event_trigger;
wire speed_down_event_trigger;

async_trap_and_reset_gen_1_pulse 
make_speedup_pulse
(
 .async_sig(speed_up_event_trigger), 
 .outclk(CLK_50M), 
 .out_sync_sig(speed_up_event), 
 .auto_reset(1'b1), 
 .reset(1'b1)
 );
 
async_trap_and_reset_gen_1_pulse 
make_speedown_pulse
(
 .async_sig(speed_down_event_trigger), 
 .outclk(CLK_50M), 
 .out_sync_sig(speed_down_event), 
 .auto_reset(1'b1), 
 .reset(1'b1)
 );


wire speed_reset_event; 

doublesync 
key2_doublsync
(.indata(!KEY[2]),
.outdata(speed_reset_event),
.clk(CLK_50M),
.reset(1'b1));

parameter oscilloscope_speed_step = 100;

wire [15:0] speed_control_val;                      
speed_reg_control 
speed_reg_control_inst
(
.clk(CLK_50M),
.up_event(speed_up_event),
.down_event(speed_down_event),
.reset_event(speed_reset_event),
.speed_control_val(speed_control_val)
);

logic [15:0] scope_sampling_clock_count;
parameter [15:0] default_scope_sampling_clock_count = 3472; //7200Hz


always @ (posedge CLK_50M) 
begin
    scope_sampling_clock_count <= default_scope_sampling_clock_count+{{16{speed_control_val[15]}},speed_control_val};
end 

logic [7:0] Seven_Seg_Val[5:0];
logic [3:0] Seven_Seg_Data[5:0];
    
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst0(.ssOut(Seven_Seg_Val[0]), .nIn(Seven_Seg_Data[0]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst1(.ssOut(Seven_Seg_Val[1]), .nIn(Seven_Seg_Data[1]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst2(.ssOut(Seven_Seg_Val[2]), .nIn(Seven_Seg_Data[2]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst3(.ssOut(Seven_Seg_Val[3]), .nIn(Seven_Seg_Data[3]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst4(.ssOut(Seven_Seg_Val[4]), .nIn(Seven_Seg_Data[4]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst5(.ssOut(Seven_Seg_Val[5]), .nIn(Seven_Seg_Data[5]));

assign HEX0 = Seven_Seg_Val[0];
assign HEX1 = Seven_Seg_Val[1];
assign HEX2 = Seven_Seg_Val[2];
assign HEX3 = Seven_Seg_Val[3];
assign HEX4 = Seven_Seg_Val[4];
assign HEX5 = Seven_Seg_Val[5];
            
wire Clock_2Hz;
            
Generate_Arbitrary_Divided_Clk32 
Gen_2Hz_clk
(.inclk(CLK_50M),
.outclk(Clock_2Hz),
.outclk_Not(),
.div_clk_count(32'h17D7840 >> 1),
.Reset(1'h1)
); 
        
logic [23:0] actual_7seg_output;
reg [23:0] regd_actual_7seg_output;

always @(posedge Clock_2Hz)
begin
    regd_actual_7seg_output <= actual_7seg_output;
    Clock_1Hz <= ~Clock_1Hz;
end

//seven segment display sampling rate divisor
assign Seven_Seg_Data[0] = div_clk_7200hz[3:0];
assign Seven_Seg_Data[1] = div_clk_7200hz[7:4];
assign Seven_Seg_Data[2] = div_clk_7200hz[11:8];
assign Seven_Seg_Data[3] = div_clk_7200hz[15:12];
assign Seven_Seg_Data[4] = div_clk_7200hz[19:16];

assign actual_7seg_output =  scope_sampling_clock_count;




//=======================================================================================================================
//
//   Audio controller code - do not touch
//
//========================================================================================================================
wire [$size(audio_data)-1:0] actual_audio_data_left, actual_audio_data_right;
wire audio_left_clock, audio_right_clock;

to_slow_clk_interface 
interface_actual_audio_data_right
 (.indata(audio_data),
  .outdata(actual_audio_data_right),
  .inclk(CLK_50M),
  .outclk(audio_right_clock));
   
   
to_slow_clk_interface 
interface_actual_audio_data_left
 (.indata(audio_data),
  .outdata(actual_audio_data_left),
  .inclk(CLK_50M),
  .outclk(audio_left_clock));
   

audio_controller 
audio_control(
  // Clock Input (50 MHz)
  .iCLK_50(CLK_50M), // 50 MHz
  .iCLK_28(), // 27 MHz
  //  7-SEG Displays
  // I2C
  .I2C_SDAT(FPGA_I2C_SDAT), // I2C Data
  .oI2C_SCLK(FPGA_I2C_SCLK), // I2C Clock
  // Audio CODEC
  .AUD_ADCLRCK(AUD_ADCLRCK),                    //  Audio CODEC ADC LR Clock
  .iAUD_ADCDAT(AUD_ADCDAT),                 //  Audio CODEC ADC Data
  .AUD_DACLRCK(AUD_DACLRCK),                    //  Audio CODEC DAC LR Clock
  .oAUD_DACDAT(AUD_DACDAT),                 //  Audio CODEC DAC Data
  .AUD_BCLK(AUD_BCLK),                      //  Audio CODEC Bit-Stream Clock
  .oAUD_XCK(AUD_XCK),                       //  Audio CODEC Chip Clock
  .audio_outL({actual_audio_data_left,8'b1}), 
  .audio_outR({actual_audio_data_right,8'b1}),
  .audio_right_clock(audio_right_clock), 
  .audio_left_clock(audio_left_clock)
);


//=======================================================================================================================
//
//   End Audio controller code
//
//========================================================================================================================
                    
            
endmodule
