`define START_ADDR 8'h00    //start and end addresses
`define END_K_ADDR 8'h20      //32

module decrypt_memory (
  input logic clk,
  output logic [7:0] address,     //s_mem, d_mem, e_mem address
  output logic [7:0] s_data_in,   //data in s_mem data
  input logic [7:0] s_data_out,   //data out s_mem q
  output logic [7:0] d_data_in,   //data in decrypted RAM d_mem data
  input logic [7:0] d_data_out,   //data out decrypted RAM d_mem data
  input logic [7:0] e_data_out,   //data out encrypted ROM e_mem q
  output logic s_wren,
  output logic d_wren,        //write enable d
  output logic key_found_flag,    //index k at 31 without invalid char, found a key
  input logic start_flag,
  output logic done_flag,
  input logic reset
);

    logic [10:0] state;
    logic [7:0] i_index, j_index, k_index, f_value;
    logic [7:0] i_data, j_data;


    parameter IDLE = 11'b000_0000_0000;  
    
    parameter SET_I_ADDR = 11'b000_0001_0000;   //set i (i=i+1)
    parameter WAIT_I_ADDR = 11'b000_0010_0000;
    parameter GET_I_DATA = 11'b000_0011_0000;    //get s[i]

    parameter SET_J_ADDR = 11'b000_0100_0000;    //set j (j=j+s[i])
    parameter WAIT_J_ADDR = 11'b000_0101_0000;
    parameter GET_J_DATA = 11'b000_0110_0000;   //read data out to data j
    
    parameter SWAP_DATA_I = 11'b000_0111_0010;   //write data j in addr i
    parameter WAIT_SWAP_I = 11'b000_1000_0010;
    parameter SWAP_DATA_J = 11'b000_1001_0000;   //write data i in addr j
    parameter WAIT_SWAP_J = 11'b000_1010_0010;

    parameter SET_F_ADDR = 11'b001_1011_0000;    //addr = s[i]+s[j]
    parameter WAIT_F_ADDR = 11'b000_1100_0000;
    parameter GET_F_VALUE = 11'b000_1101_0000;   //get f = s[s[i]+s[j]]

    parameter SET_K_ADDR = 11'b000_1110_0000;
    parameter WAIT_K_ADDR = 11'b000_1111_0000;

    parameter DECRYPT = 11'b001_0000_0100;			//decrypted_output[k] = f^encrypted_input[k]
    parameter WAIT_DECRYPT = 11'b0001_0001_0100;

    parameter VALIDATE = 11'b001_0010_0000;
    
    parameter INCREMENT = 11'b001_0011_0000;
    parameter DONE = 11'b001_0100_0001;

	// parameter TEST_SET_ADDR = 11'b11110_000000;
 	// parameter TEST_SET_DATA = 11'b11111_000001;  //d_wren

    assign d_wren = state[2];    	//state SWAP_DATA_I, SWAP_DATA_J
    assign s_wren = state[1];    //state DECRYPT
    assign done_flag = state[0];   //state DONE

    //assign f_value = state[4]? s_data_out : 8'bx; //state GET_F_VALUE to DECRYPT f = s[s[i]+s[j]]

 	//assign s_data_in = state[2] ? j_data : (state[1] ? i_data : 8'bx);  //only matters s_wren, if SWAP_DATA_I, write j_data else write i_data

 	//assign d_data_in = f_value ^ e_data_out;  //only matters in state DECRYPT if d_wren, write to d_mem

	initial begin
	   state = IDLE;
	   k_index = `START_ADDR;
	   i_index = `START_ADDR;
	   j_index = `START_ADDR;

	   i_data = 8'bx;
	   j_data = 8'bx;

	   f_value = 8'hx;
	   s_data_in = 8'hx;
	   d_data_in = 8'hx;

	   address = 8'bx;
	   key_found_flag = 1'b0;
	end
    
    always_ff @(posedge clk, posedge reset)
    begin
        if (reset) begin
        	state <= IDLE;

     		k_index <= `START_ADDR;
		    i_index <= `START_ADDR;
		    j_index <= `START_ADDR;

		    i_data <= 8'bx;
		    j_data <= 8'bx;

		    f_value <= 8'bx;
		    s_data_in <= 8'bx;
		    d_data_in <= 8'bx;

		    address <= 8'bx;
		    key_found_flag <= 1'b0;
		end
        else 
        begin
            case (state)
                IDLE: begin 
                    k_index <= `START_ADDR;
			         i_index <= `START_ADDR;
			         j_index <= `START_ADDR;

			         i_data <= 8'bx;
			         j_data <= 8'bx;

			         f_value <= 8'bx;
			         s_data_in <= 8'bx;
			         d_data_in <= 8'bx;

			         address <= 8'bx;

                    if (start_flag)
			           state <= SET_I_ADDR;
			        else
			           state <= IDLE;
                end
                SET_I_ADDR: begin
                	i_index <= i_index + 8'h01;////
                    address <= i_index + 8'h01;////     //set address = i

                    state <= WAIT_I_ADDR;
                end
                WAIT_I_ADDR: begin
                	state <= GET_I_DATA;
                end
                GET_I_DATA: begin
                	address <= i_index;
                    i_data <= s_data_out; 

                    state <= SET_J_ADDR;
                end
                SET_J_ADDR:  begin
                    j_index = j_index + i_data;
                    address = j_index;

                    state = WAIT_J_ADDR;
                end
                WAIT_J_ADDR: begin
                	state <= GET_J_DATA;
                end
                GET_J_DATA: begin
                    j_data <= s_data_out;

                    state <= SWAP_DATA_I;
                end
                SWAP_DATA_I: begin
                    address <= i_index;
                    s_data_in <= j_data;

                    state <= WAIT_SWAP_I;
                end
                WAIT_SWAP_I: begin
                	if (s_data_out == j_data)
                		state <= SWAP_DATA_J;
                	else
                		state <= SWAP_DATA_I;
                end   
                SWAP_DATA_J: begin
                    address <= j_index;
                    s_data_in <= i_data;

                    state <= WAIT_SWAP_J;
                end
                WAIT_SWAP_J: begin
                	if (s_data_out == i_data)
                		state <= SET_F_ADDR;
                	else
                		state <= SWAP_DATA_J;
                end
                SET_F_ADDR: begin
                    address = i_data + j_data;

                    state <= WAIT_F_ADDR;
                end
                WAIT_F_ADDR: begin
                	state <= GET_F_VALUE;
                end
                GET_F_VALUE: begin 
                    f_value <= s_data_out;

                    state <= SET_K_ADDR;
                end
                SET_K_ADDR: begin
                    address <= k_index;
                    state <= WAIT_K_ADDR;
                end
                WAIT_K_ADDR: begin 
                	state <= DECRYPT;
                end
                DECRYPT: begin
                    address <= k_index;
                    d_data_in <= f_value ^ e_data_out;

                    state <= WAIT_DECRYPT;
                end
                WAIT_DECRYPT: begin
                	if (d_data_out == d_data_in)
                		state <= VALIDATE;
                	else 
                		state <= DECRYPT;
                end
                VALIDATE: begin    
                    key_found_flag <= 1'b0;

                    if(((d_data_in >= 8'd97) && (d_data_in <= 8'd122)) || d_data_in == 8'd32)
                    	state <= INCREMENT;
                    else 
                    	state <= DONE;
                end
                INCREMENT: begin
                    k_index <= k_index + 1'b1;

                    if(k_index == (`END_K_ADDR - 1))
                    begin
                    	key_found_flag <= 1'b1;
                    	state <= DONE;
                    end
                    else
                    	state <= SET_I_ADDR;
                end
                DONE: begin
                	state <= IDLE;
                end
                default: begin
                	state <= IDLE;   
                end    
            endcase
        end
    end

endmodule


// ////////// TEST IF J_DATA SWAP to = A8
// 				TEST_SET_ADDR: begin	
// 					k_index <= k_index;
// 					i_index <= i_index;
// 					j_index <= j_index;

// 					i_data <= i_data;
// 					j_data <= j_data;

// 					f_value <= f_value;
// 					s_data_in <= s_data_in;
// 					d_data_in <= f_value;

// 					address <= k_index;//address;

// 					state <= TEST_SET_DATA;
// 				end
// 				TEST_SET_DATA: begin				//decypted_output[k] = f^encrypted_input[k]
// 					k_index <= k_index;
// 					i_index <= i_index;
// 					j_index <= j_index;

// 					i_data <= i_data;
// 					j_data <= j_data;

// 					f_value <= f_value;
// 					s_data_in <= s_data_in;
// 					d_data_in <= f_value;

// 					address <= k_index;//address;

// 					if(d_data_out == d_data_in)		//ensure d_data stored in d_mem
// 						state <= DONE;
// 					else
// 						state <= TEST_SET_DATA;
// 				end