`timescale 1ns/10ps

module full_sub_1b_tb;
  
  reg t_A;
  reg t_B;
  reg t_b_in;
  wire t_z;
  wire t_b_out;
    
  sub_1b full_adder_ut(t_A,
                           t_B, 
                           t_b_in,
                           t_z,
                           t_b_out);
  
  initial
    begin      
      #10;
      t_b_in = 1'b0;
      t_A = 1'b0;
      t_B = 1'b1;
      
      #10;
      t_b_in = 1'b0;
      t_A = 1'b1;
      t_B = 1'b0;
      
      #10;
      t_b_in = 1'b1;
      t_A = 1'b0;
      t_B = 1'b1;
      
      #10;
      t_b_in = 1'b1;
      t_A = 1'b1;
      t_B = 1'b0;

      #10;
      t_b_in = 1'b0;
      t_A = 1'b1;
      t_B = 1'b1;
      
      #10;
      t_b_in = 1'b1;
      t_A = 1'b1;
      t_B = 1'b1;
      #10;
      // $finish;
  end
  
endmodule
