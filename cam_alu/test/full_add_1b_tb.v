module full_add_1b_tb;
  
  reg t_src0;
  reg t_src1;
  reg t_c_in;
  wire t_z;
  wire t_c_out;
    
  add_1b full_adder_ut(t_src0,
                           t_src1, 
                           t_c_in,
                           t_z,
                           t_c_out);
  
  initial
    begin      
      #10;
      t_c_in = 1'b0;
      t_src0 = 1'b0;
      t_src1 = 1'b1;
      
      #10;
      t_c_in = 1'b0;
      t_src0 = 1'b1;
      t_src1 = 1'b0;
      
      #10;
      t_c_in = 1'b1;
      t_src0 = 1'b0;
      t_src1 = 1'b1;
      
      #10;
      t_c_in = 1'b1;
      t_src0 = 1'b1;
      t_src1 = 1'b0;

      #10;
      t_c_in = 1'b0;
      t_src0 = 1'b1;
      t_src1 = 1'b1;
      
      #10;
      t_c_in = 1'b1;
      t_src0 = 1'b1;
      t_src1 = 1'b1;
      #10;
      // $finish;
  end
  
endmodule
