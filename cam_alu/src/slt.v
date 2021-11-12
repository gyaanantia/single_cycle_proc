// set-less-than
// Cam Brown

module slt(A, B, u, Q, of);

    input [31:0] A, B;
    input u;
    output wire [31:0] Q;
    output wire of;
    
    wire not_u;
    wire [31:0] not_b;
    wire [31:0] sub_ab;
    wire of_wire;
    wire xor_a_b;
    wire msb_sub_res;
    wire msb_A;
    wire msb_B;
    wire and_notu_xor;
    wire slt_res;
    wire placeholder;

    assign msb_A = A[31];
    assign msb_B = B[31];

    // not the unsigned flag
    not_gate not_u_(.x(u), .z(not_u));

    // perform subtraction of A and B
    not_gate_32 not_(.x(B), .z(not_b));
    add add_(.x(A), .y(not_b), .c_in(1'b1), .sum(sub_ab), .c_out(placeholder), .of(of_wire));

    // xor A and B to determine if we should be looking at MSB(A) or MSB(sub_res)
    xor_gate xor_a_b_(.x(msb_A), .y(msb_B), .z(xor_a_b));

    // not_u AND A ^ B
    and_gate and_notu_xor_(.x(not_u), .y(xor_a_b), .z(and_notu_xor));

    assign msb_sub_res = sub_ab[31];

    // select result based on the outcome of this logic
    // unsigned:    A^B:    ret:
    //      0       0       msb_sub_res
    //      0       1       msb_A
    //      1       0       msb_sub_res
    //      1       1       msb_sub_res
    // logically equiv to (A^B) & ~unsigned

    mux mux_(.sel(and_notu_xor), .src0(msb_sub_res), .src1(msb_A), .z(slt_res));

    assign temp = 30'h0;
    assign Q[31:1] = temp;
    assign Q[0] = slt_res;
    
    assign of = of_wire;

endmodule