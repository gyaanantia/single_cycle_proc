// single bit full subtractor
// Cam Brown
`timescale 1ns/10ps

module sub_1b (A, B, b_in, diff, b_out);

    input A, B, b_in;
    output wire diff, b_out;

    wire a_xor_b;
    wire not_A;
    wire not_axb;
    wire and_axb_bin;
    wire and_notA_B;

    xor_gate xor_(.x(A), .y(B), .z(a_xor_b));
    xor_gate xor_diff(.x(a_xor_b), .y(b_in), .z(diff));

    not_gate not_(.x(A), .z(not_A));
    not_gate not_1(.x(a_xor_b), .z(not_axb));

    and_gate and_(.x(not_axb), .y(b_in), .z(and_axb_bin));
    and_gate and_1(.x(not_A), .y(B), .z(and_notA_B));

    or_gate or_(.x(and_axb_bin), .y(and_notA_B), .z(b_out));
    
endmodule