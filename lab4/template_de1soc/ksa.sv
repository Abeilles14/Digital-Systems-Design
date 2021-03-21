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
// logic start_flag, done_flag;
// logic [3:0] key_found_flag;
// logic [23:0] secret_key;

// assign start_flag = 1'b1;

// multicore_controller quadcore_decryption (      //main 4 core controller
//     .clk(clk),
//     .secret_key(secret_key),
//     .key_found_flag(key_found_flag),
//     .multicore_start_flag(start_flag),
//     .multicore_done_flag(done_flag),
//     .reset(!reset_n));

// always_ff @(posedge clk)                                    //LED display which core found the key
// begin
//     if (done_flag && key_found_flag[0])
//         LED[1] = 1'b1;
//     else if (done_flag && key_found_flag[1])
//         LED[2] = 1'b1;
//     else if (done_flag && key_found_flag[2])
//         LED[3] = 1'b1;
//     else if (done_flag && key_found_flag[3])
//         LED[4] = 1'b1;
//     else if (done_flag && (key_found_flag == 4'b0))         //key not found, LED 7
//         LED[7] = 1'b1;
//     else
//         LED[7:1]= 8'b0;
// end

logic start_flag, done_flag, key_found_flag;
logic [23:0] secret_key;

assign start_flag = 1'b1;

multicore_controller quadcore_decryption (
    .clk(clk),
    .secret_key(secret_key),
    .key_found_flag(key_found_flag),
    .multicore_start_flag(start_flag),
    .multicore_done_flag(done_flag),
    .reset(!reset_n));

assign LED[1:0] = (done_flag && key_found_flag) ? 2'b11 : 2'b00;
assign LED[7:6] = (done_flag && !key_found_flag) ? 2'b11 : 2'b00;

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

