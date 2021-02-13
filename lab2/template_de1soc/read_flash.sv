//read addr from flash
`define WAIT_ADDR_READ 3'b000
`define READ_ADDR 3'b001
`define WAIT_DATA_READ 3'b010
`define READ_DATA_EVEN 3'b011
`define READ_DATA_ODD 3'b100
`define WAIT_SYNC 3'b101
`define IDLE 3'b110

module read_flash
    (input logic clk50M,               //50 MHz
    input logic clk22K,
    input logic start_read_flag,
    input logic addr_retrieved_flag,
    input logic read_data_flag,
    output logic read_addr_flag,
    input logic [31:0] flash_data,
    output logic [15:0] audio_out,
    input logic reset);

    logic [2:0] state;
    logic [15:0] data_out;

    wire data_output_flag;

    always_ff @(posedge clk50M or posedge reset)
    begin
        if(reset)
        begin
            state <= `WAIT_ADDR_READ;
        end
        else
            case(state)
                `IDLE: begin                //wait for start reading flag from synchronizer
                    if (start_read_flag)
                        state <= `READ_ADDR;
                    else
                    begin
                        state <= `WAIT_ADDR_READ;
                        flash_mem_read <= 1'b1;
                    end
                end
                `READ_ADDR: begin                   //wait until readdatavalid before retrieving data
                    if(read_data_flag)
                        state <= `READ_DATA_EVEN;
                    else
                        state <= `READ_ADDR;
                end
                `READ_DATA_EVEN: begin              //read even data
                    if (read_data_flag)
                    begin
                        state <= `READ_DATA_ODD;
                        data_output_flag = 1'b1;
                        data_out = flash_data[15:0];
                    end
                    else
                        state <= `READ_DATA_EVEN;
                end
                `READ_DATA_ODD: begin               //read odd data
                    if (read_data_flag)
                    begin
                        state <= `IDLE;
                        data_output_flag = 1'b1;
                        data_out = flash_data[31:16];
                    end
                    else
                        state <= `READ_DATA_ODD;
                end
                `OUTPUT_DATA: begin              //write even and odd data to audio
                    data_output_flag <= 1'b1;
                end
                default: begin
                    state <= `IDLE;
                end
            endcase
        end
    end

    always_ff @(posedge data_output_flag)
    begin
        audio_out = data_out;
    end
endmodule

