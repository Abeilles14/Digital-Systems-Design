//read addr from flash
`define IDLE 5'b00_000
`define READ_ADDR 5'b00_001
`define WAIT_DATA_READ 5'b10_000
`define WAIT_CLK_22K_EVEN 5'b01_000
`define READ_DATA_EVEN 5'b00_110
`define WAIT_CLK_22K_ODD 5'b11_000
`define READ_DATA_ODD 5'b00_010

module read_flash
    (input logic clk50M,
    input logic clk22K,
    input logic start_read_flag,
    input logic addr_retrieved_flag,
    input logic read_data_flag,
    output logic read_addr_flag,
    input logic [31:0] flash_data,
    output logic [15:0] audio_out,
    input logic reset);

    logic [4:0] state;
    logic [15:0] data_out;

    wire data_output_flag;
    wire data_even_flag;

    assign read_addr_flag = (state[0] && !addr_retrieved_flag);   //if READ_ADDR and addr NOT retrieved yet, get addr
    assign data_output_flag = state[1];     //trigger posedge for data out
    assign data_even_flag = state[2];
    assign data_out = data_even_flag ? flash_data[15:0] : flash_data [31:16];

    initial begin
        state = `IDLE;
    end

    always_ff @(posedge clk50M or posedge reset)
    begin
        if(reset)
        begin
            state <= `IDLE;
        end
        else
        begin
            case(state)
                `IDLE: begin                //wait for start reading flag from synchronizer
                    if (start_read_flag)
                        state <= `READ_ADDR;
                    else
                        state <= `IDLE;
                end
                `READ_ADDR: begin
                    if(addr_retrieved_flag)             //wait until address retrieved
                        state <= `WAIT_DATA_READ;
                    else
                        state <= `READ_ADDR;
                end
                `WAIT_DATA_READ: begin           //wait for datavalid
                    if(read_data_flag)
                        state <= `WAIT_CLK_22K_EVEN;
                    else
                        state <= `WAIT_DATA_READ;
                end
                `WAIT_CLK_22K_EVEN: begin                //wait until clk 22KHz posedge
                    if(clk22K)
                        state <= `READ_DATA_EVEN;
                    else
                        state <= `WAIT_CLK_22K_EVEN; 
                end
                `READ_DATA_EVEN: begin              //read even data, send to audio
                    state <= `WAIT_CLK_22K_ODD;
                end
                `WAIT_CLK_22K_ODD: begin                //wait until clk 22KHz posedge
                    if(clk22K)
                        state <= `READ_DATA_ODD;
                    else
                        state <= `WAIT_CLK_22K_ODD; 
                end
                `READ_DATA_ODD: begin               //read odd data, send to audio
                    state <= `IDLE;
                end
                default: begin
                    state <= `IDLE;
                end
            endcase
        end
    end

    always_ff @(posedge data_output_flag)       //output data when flag set on READ DATA EVEN and ODD
    begin
        audio_out = data_out;
    end
endmodule

