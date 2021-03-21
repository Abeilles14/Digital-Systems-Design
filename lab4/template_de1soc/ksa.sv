`default_nettype none
module ksa(
    //////////// CLOCK //////////
    CLOCK_50,

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
);

//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input                       CLOCK_50;

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

//=======================================================
//  REG/WIRE declarations
//=======================================================
// Input and output declarations
logic CLK_50M;
logic  [7:0] LED;
assign CLK_50M =  CLOCK_50;
assign LEDR[7:0] = LED[7:0];

logic clk, reset_n;						

assign clk = CLK_50M;
assign reset_n = KEY[3];

//====================================================================================
//
// Lab 4 code
//
//====================================================================================

logic s_mem_write, d_mem_write, datapath_start_flag, datapath_done_flag, key_found_flag;
logic [7:0] s_mem_addr, s_mem_data_in, s_mem_data_out;
logic [7:0] d_mem_addr, d_mem_data_in, d_mem_data_out;
logic [7:0] e_mem_addr, e_mem_data_out;
logic [23:0] secret_key;
logic test_LED3, test_LED4, test_LED5;

assign datapath_start_flag = 1'b1;

s_memory s_mem (
    .address(s_mem_addr),
    .clock(clk),
    .data(s_mem_data_in),
    .wren(s_mem_write),
    .q(s_mem_data_out));

d_memory d_mem (
    .address(d_mem_addr),
    .clock(clk),
    .data(d_mem_data_in),
    .wren(d_mem_write),
    .q(d_mem_data_out));

e_memory e_mem (
    .address(e_mem_addr),
    .clock(clk),
    .q(e_mem_data_out));

datapath controller (
    .clk(clk),
    .s_mem_addr(s_mem_addr),
    .s_mem_data_in(s_mem_data_in),
    .s_mem_data_out(s_mem_data_out),
    .s_mem_write(s_mem_write),
    .d_mem_addr(d_mem_addr),
    .d_mem_data_in(d_mem_data_in),
    .d_mem_data_out(d_mem_data_out),
    .d_mem_write(d_mem_write),
    .e_mem_addr(e_mem_addr),
    .e_mem_data_out(e_mem_data_out),
    .secret_key(secret_key),
    .key_found_flag(key_found_flag),
    .datapath_start_flag(datapath_start_flag),
    .datapath_done_flag(datapath_done_flag),
    .reset(!reset_n),
    .test3(test_LED3),
    .test4(test_LED4),
    .test5(test_LED5));

assign LED[1:0] = (datapath_done_flag && key_found_flag) ? 2'b11 : 2'b00;
assign LED[7:6] = (datapath_done_flag && !key_found_flag) ? 2'b11 : 2'b00;

assign LED[3] = test_LED3;
assign LED[4] = test_LED4;
 assign LED[5] = test_LED5;

//=====================================================================================
//
//  Seven-Segment
//
//=====================================================================================

logic [7:0] Seven_Seg_Val[5:0];
    
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst0(.ssOut(Seven_Seg_Val[0]), .nIn(secret_key[3:0]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst1(.ssOut(Seven_Seg_Val[1]), .nIn(secret_key[7:4]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst2(.ssOut(Seven_Seg_Val[2]), .nIn(secret_key[11:8]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst3(.ssOut(Seven_Seg_Val[3]), .nIn(secret_key[15:12]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst4(.ssOut(Seven_Seg_Val[4]), .nIn(secret_key[19:16]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst5(.ssOut(Seven_Seg_Val[5]), .nIn(secret_key[23:20]));

assign HEX0 = Seven_Seg_Val[0];
assign HEX1 = Seven_Seg_Val[1];
assign HEX2 = Seven_Seg_Val[2];
assign HEX3 = Seven_Seg_Val[3];
assign HEX4 = Seven_Seg_Val[4];
assign HEX5 = Seven_Seg_Val[5];

endmodule

