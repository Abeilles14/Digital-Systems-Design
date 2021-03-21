// Pretty much the same as the DE1 except writes are instantaneous instead of delayed
module RAM(address, clock, data, wren, q);
    parameter ADDR_WIDTH = 8;
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 256;

    input [ADDR_WIDTH - 1:0] address;
    input clock;
    input [DATA_WIDTH - 1:0] data;
    input wren;
    output reg [DATA_WIDTH - 1:0] q;

    reg [DATA_WIDTH - 1:0] temp_data;
    reg [DATA_WIDTH - 1:0] mem [0:DEPTH-1];

    always @(posedge clock) begin
       if (wren) mem[address] <= data;
       
       q <= mem[address];
    end

endmodule

module ROM(address, clock, q);
    parameter ADDR_WIDTH = 5;
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 32;

    input [ADDR_WIDTH - 1:0] address;
    input clock;
    output reg [DATA_WIDTH - 1:0] q;

    wire [DATA_WIDTH - 1:0] mem [0:DEPTH-1];

    assign mem[0] = 8'hC1;
    assign mem[1] = 8'h0C;
    assign mem[2] = 8'h35;
    assign mem[3] = 8'hD0;
    assign mem[4] = 8'h8D;
    assign mem[5] = 8'h27;
    assign mem[6] = 8'h66;
    assign mem[7] = 8'h4B;
    assign mem[8] = 8'h0D;
    assign mem[9] = 8'hAD;
    assign mem[10] = 8'h4B;
    assign mem[11] = 8'hB6;
    assign mem[12] = 8'h31;
    assign mem[13] = 8'h29;
    assign mem[14] = 8'h32;
    assign mem[15] = 8'hC2;
    assign mem[16] = 8'h90;
    assign mem[17] = 8'h0D;
    assign mem[18] = 8'h68;
    assign mem[19] = 8'h1E;
    assign mem[20] = 8'h76;
    assign mem[21] = 8'h5E;
    assign mem[22] = 8'h02;
    assign mem[23] = 8'h62;
    assign mem[24] = 8'hDA;
    assign mem[25] = 8'h45;
    assign mem[26] = 8'h70;
    assign mem[27] = 8'hC3;
    assign mem[28] = 8'hA5;
    assign mem[29] = 8'h92;
    assign mem[30] = 8'h74;
    assign mem[31] = 8'hBE;

    always @(posedge clock) begin
        q <= mem[address];
    end
    
endmodule

// msg 7
    // assign mem[0] = 8'hC1;
    // assign mem[1] = 8'h0C;
    // assign mem[2] = 8'h35;
    // assign mem[3] = 8'hD0;
    // assign mem[4] = 8'h8D;
    // assign mem[5] = 8'h27;
    // assign mem[6] = 8'h66;
    // assign mem[7] = 8'h4B;
    // assign mem[8] = 8'h0D;
    // assign mem[9] = 8'hAD;
    // assign mem[10] = 8'h4B;
    // assign mem[11] = 8'hB6;
    // assign mem[12] = 8'h31;
    // assign mem[13] = 8'h29;
    // assign mem[14] = 8'h32;
    // assign mem[15] = 8'hC2;
    // assign mem[16] = 8'h90;
    // assign mem[17] = 8'h0D;
    // assign mem[18] = 8'h68;
    // assign mem[19] = 8'h1E;
    // assign mem[20] = 8'h76;
    // assign mem[21] = 8'h5E;
    // assign mem[22] = 8'h02;
    // assign mem[23] = 8'h62;
    // assign mem[24] = 8'hDA;
    // assign mem[25] = 8'h45;
    // assign mem[26] = 8'h70;
    // assign mem[27] = 8'hC3;
    // assign mem[28] = 8'hA5;
    // assign mem[29] = 8'h92;
    // assign mem[30] = 8'h74;
    // assign mem[31] = 8'hBE;
    
// msg 1
    // assign mem[0] = 8'd45;
    // assign mem[1] = 8'd143;
    // assign mem[2] = 8'd122;
    // assign mem[3] = 8'd169;
    // assign mem[4] = 8'd56;
    // assign mem[5] = 8'd115;
    // assign mem[6] = 8'd95;
    // assign mem[7] = 8'd135;
    // assign mem[8] = 8'd69;
    // assign mem[9] = 8'd27;
    // assign mem[10] = 8'd130;
    // assign mem[11] = 8'd134;
    // assign mem[12] = 8'd75;
    // assign mem[13] = 8'd155;
    // assign mem[14] = 8'd127;
    // assign mem[15] = 8'd157;
    // assign mem[16] = 8'd239;
    // assign mem[17] = 8'd13;
    // assign mem[18] = 8'd196;
    // assign mem[19] = 8'd187;
    // assign mem[20] = 8'd249;
    // assign mem[21] = 8'd119;
    // assign mem[22] = 8'd153;
    // assign mem[23] = 8'd117;
    // assign mem[24] = 8'd255;
    // assign mem[25] = 8'd213;
    // assign mem[26] = 8'd96;
    // assign mem[27] = 8'd115;
    // assign mem[28] = 8'd1;
    // assign mem[29] = 8'd248;
    // assign mem[30] = 8'd22;
    // assign mem[31] = 8'd37;