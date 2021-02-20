module viterbi_ctrl (
clk,
reset_all,
in_addr,
in_data,
is_write,
start,
vit_num,
vit1_cs,
vit2_cs,
out_addr,
vit_data,
out_RD,
out_WR,
return_data,
finish
);

input clk, reset_all;
input[7:0] in_data;
input[2:0] in_addr;
input is_write;
input start;
input vit_num;

inout[7:0] vit_data;

output vit1_cs;
output vit2_cs;
output[2:0] out_addr;
output out_RD,out_WR,finish;
output[7:0] return_data;

reg[10:0] state;
reg[7:0] read_reg;

wire[7:0] return_data;
wire vit_cs_allow;
wire strobe_read_reg;
wire allow_data_output;

parameter vit1_code = 1'b0;
parameter vit2_code = 1'b1;

// 0987_6543210
parameter idle = 11'b0000_0000000;
parameter check_oper = 11'b0010_0101000;
parameter handle_write_op = 11'b0011_0101000;
parameter strobe_write = 11'b0100_0101010;
parameter handle_read_op = 11'b0101_0101001;
parameter wait_read = 11'b0110_0101001;
parameter strobe_read = 11'b0111_0111001;
parameter finished = 11'b1000_0101100;

assign out_RD = ~state[0];
assign out_WR = ~state[1];
assign finish = state[2];
assign vit_cs_allow = state[3];
assign strobe_read_reg = state[4];
assign allow_data_output = state[5];

assign vit1_cs = !((vit_num == vit1_code) && (vit_cs_allow));
assign vit2_cs = !((vit_num == vit2_code) && (vit_cs_allow));

assign out_addr = in_addr;
assign vit_data = (allow_data_output && is_write) ? in_data[7:0] : 8'bz;
assign return_data = read_reg;

always_ff @(posedge clk or negedge reset_all)
begin
	if (~reset_all)
		state <= idle;
	else
		case(state) /* synthesis full_case */
			idle :begin
				if (start) state <= check_oper;
			end
			check_oper : begin
				if (is_write)
					state <= handle_write_op;
				else
					state <= handle_read_op;
			end
			handle_write_op: state <= strobe_write;
			strobe_write: state <= finished;
			handle_read_op: state <= wait_read;
			wait_read : state <= strobe_read;
			strobe_read: state <= finished;
			finished : state <= idle;
		endcase
end

always_ff @(posedge strobe_read_reg or negedge reset_all)
begin
	if (~reset_all)
		read_reg <= 7'b0;
	else
		read_reg <= vit_data[7:0];
end
endmodule