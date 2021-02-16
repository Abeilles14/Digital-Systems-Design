//read addr from flash
`define IDLE 3'b000
`define READ_ADDR 3'b001
`define READ_DATA 3'b011

module read_flash
    (input logic clk50M,
    input logic start_read_flag,
    input logic read_data_flag,
    output logic read_addr_flag,
    input logic [31:0] flash_data_in,
    output logic [31:0] flash_data_out);

    logic [2:0] state;
    logic data_output_flag;

    assign read_addr_flag = state[0];   //if READ_ADDR get addr
    assign data_output_flag = state[1];     //trigger posedge for data out

    initial begin
        state = `IDLE;
    end

    always_ff @(posedge clk50M)
    begin
        begin
            case(state)
                `IDLE: begin                //wait for start reading flag from synchronizer
                    if (start_read_flag)
                        state <= `READ_ADDR;
                    else
                        state <= `IDLE;
                end
                `READ_ADDR: begin
                    state <= `READ_DATA;
                end
                `READ_DATA: begin               //read odd data, send to audio
                    if (read_data_flag)
                        state <= `IDLE;
                    else
                        state <= `READ_DATA;
                end
                default: begin
                    state <= `IDLE;
                end
            endcase
        end
    end

    always_ff @(posedge data_output_flag)       //output data when flag set on READ DATA EVEN and ODD
    begin
        flash_data_out <= flash_data_in;
    end
endmodule

