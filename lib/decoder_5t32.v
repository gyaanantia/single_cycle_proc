// This was done by just hard coding values into the dec_n.v provided in the ALU

module decoder_5t32 (src , z);
  input [4:0] src;
  output reg [31:0] z;
  integer i;
  
  always @(src)
      begin
        for (i = 0; i < 32; i = i+1) begin
            if (src == i) z[i] <= 1'b1;
            else z[i] <= 1'b0;
            $display ("src is %d z is %d and i is %d" ,src , z , i);
          end
      end
endmodule