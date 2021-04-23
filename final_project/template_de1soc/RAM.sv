module FLASH(
    input logic clk,
    input logic [22:0] address,
    output logic [31:0] q);

    always_ff @(posedge clk) begin                     //test byte addr 27-35
        case (address)                              //output 4-12
            23'd6: q = {8'd4, 8'd3, 8'd2, 8'd1};
            23'd7: q = {8'd8, 8'd7, 8'd6, 8'd5};
            23'd8: q = {8'd12, 8'd11, 8'd10, 8'd9};
            default: q = 32'hAABBCCDD;
        endcase
    end 
    
endmodule