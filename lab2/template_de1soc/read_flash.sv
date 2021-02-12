//read flash
//countert
always_ff @( posedge enable, posedge reset) begin 
     case (direction) //different cases depending on the direction the song is playing
        forward:
        begin
            if (reset)
                count <= 23'h0;
            else if (count >= max)  // if counter reaches the division number we want then it inverts the out_clk signal and resets the counter
                count <= 23'h0;
            else count <= count + 1;
        end
        reverse:
        begin
            if (reset)
                count <= 23'h7FFFF;
            else if (count <= 0) 
                count <= 23'h7FFFF;
            else count <= count - 1;
        end
        default: count <= 23'h0 ; 
     endcase
end