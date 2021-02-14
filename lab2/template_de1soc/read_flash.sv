//read addr from flash
`define IDLE 5'b00_000
`define READ_ADDR 5'b00_001
`define READ_DATA 5'b00_011
`define WAIT_REQUEST 5'b01_001
`define DONE 5'b10_000

module read_flash
    (input logic clk50M,
    input logic start_read_flag,
    input logic read_data_flag,
    output logic read_addr_flag,
    input logic wait_request,
    input logic [31:0] flash_data_in,
    output logic [31:0] flash_data_out);

    logic [4:0] state;
    logic [15:0] data_out;
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
                    state <= `READ_ADDR;
                end
                `READ_ADDR: begin
                    state <= `WAIT_REQUEST;
                end
                `WAIT_REQUEST: begin
                    if(wait_request)
                        state <= `READ_DATA;
                    else
                        state <= `WAIT_REQUEST;
                end
                `READ_DATA: begin               //read odd data, send to audio
                    if (read_data_flag)
                        state <= `DONE;
                    else
                        state <= `READ_DATA;
                end
                `DONE: begin
                    if (start_read_flag)
                        state <= `IDLE;
                    else
                        state <= `DONE;
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

