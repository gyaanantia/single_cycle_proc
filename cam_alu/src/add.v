// 32 bit full adder
// Cam Brown
`timescale 1ns/10ps

module add (x, y, c_in, sum, c_out, of);

    input [31:0] x, y;
    input c_in;
    output wire [31:0] sum;
    output wire c_out;
    output wire of;

    genvar  i;

    wire [30:0] btw_add; // wires to carry between adders in the RCA
    wire end_carry;

    add_1b adder_0(.A(x[0]), .B(y[0]), .c_in(c_in), .sum(sum[0]), .c_out(btw_add[0]));
    
    generate
        for(i = 0; i < 30; i = i + 1) begin 
            add_1b adder(.A(x[i + 1]), .B(y[i + 1]), .c_in(btw_add[i]), .sum(sum[i + 1]), .c_out(btw_add[i + 1]));
        end
    endgenerate
    
    add_1b adder_32(.A(x[31]), .B(y[31]), .c_in(btw_add[30]), .sum(sum[31]), .c_out(end_carry));

    assign c_out = end_carry;

    wire sum_msb;
    wire a_msb;
    wire b_msb;
    wire xor_msb_ab;
    wire xor_res_msb;

    assign a_msb = x[31];
    assign b_msb = y[31];
    assign sum_msb = sum[31];
    xor_gate xor_ab_(.x(a_msb), .y(b_msb), .z(xor_msb_ab));
    xor_gate xor_res_msb_(.x(xor_msb_ab), .y(sum_msb), .z(xor_res_msb));
    assign of = xor_msb_ab;


    
    // Need to make sure we set our overflow flag based on the end carry and the last bit of the adder
    xor_gate xor_0(.x(btw_add[30]), .y(end_carry), .z(of)); 

endmodule