// AD first attempt at sign extender.  Needs to take the sign of the msb and extend to 32 bits from 16.

module sgn_ext(a);
   input [15:0] a;
   output wire [31:0] a_ext; // need wire?
   wire [0:0];

   assign a_ext[15:0] = a[15:0];
   assign a_ext[31:16] = a[15]; // I think this is it...too simple?  Clocking?

endmodule // sgn_ext

   
   

   
