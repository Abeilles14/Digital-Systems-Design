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

logic s_mem_write, d_mem_write, datapath_start_flag;
logic [7:0] s_mem_addr, s_mem_data_in, s_mem_data_out;
logic [7:0] d_mem_addr, d_mem_data_in, d_mem_data_out;
logic [7:0] e_mem_addr, e_mem_data_out;
logic [23:0] secret_key;

//assign secret_key = {14'b0, SW[9:0]};
assign secret_key = 24'h000249;     //temp hardcoded secret key
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
    .d_mem_write(d_mem_write),
    .e_mem_addr(e_mem_addr),
    .e_mem_data_out(e_mem_data_out),
    .secret_key(secret_key),
    .datapath_start_flag(datapath_start_flag),
    .reset(!reset_n));

//=====================================================================================
//
//  Seven-Segment
//
//=====================================================================================

// logic [7:0] Seven_Seg_Val[5:0];
// logic [3:0] Seven_Seg_Data[5:0];
    
// SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst0(.ssOut(Seven_Seg_Val[0]), .nIn(Seven_Seg_Data[0]));
// SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst1(.ssOut(Seven_Seg_Val[1]), .nIn(Seven_Seg_Data[1]));
// SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst2(.ssOut(Seven_Seg_Val[2]), .nIn(Seven_Seg_Data[2]));
// SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst3(.ssOut(Seven_Seg_Val[3]), .nIn(Seven_Seg_Data[3]));
// SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst4(.ssOut(Seven_Seg_Val[4]), .nIn(Seven_Seg_Data[4]));
// SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst5(.ssOut(Seven_Seg_Val[5]), .nIn(Seven_Seg_Data[5]));

// assign HEX0 = Seven_Seg_Val[0];
// assign HEX1 = Seven_Seg_Val[1];
// assign HEX2 = Seven_Seg_Val[2];
// assign HEX3 = Seven_Seg_Val[3];
// assign HEX4 = Seven_Seg_Val[4];
// assign HEX5 = Seven_Seg_Val[5];

endmodule

