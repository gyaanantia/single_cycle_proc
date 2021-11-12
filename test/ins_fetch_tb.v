`timescale 1ns/10ps
module ins_fetch_tb;
  
  reg [31:0] pc_in_tb;
  wire [31:0] ins_out_tb;
  
  ins_fetch #(.pc_start(32'h00400020)) test( // pass parameter we are given in spec.
      .pc_in(pc_in_tb),
      .ins_out(ins_out_tb)
  );
  
  initial
    begin
      pc_in_tb = 32'h00400020;
      #10
      #10
      #10
      $finish;
      
  end
  
endmodule





