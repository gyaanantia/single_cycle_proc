// single bit full adder
// Cam Brown
`timescale 1ns/10ps

module add_1b (A, B, c_in, sum, c_out);

    input A, B, c_in;
    output wire sum, c_out;

    wire a_xor_b;
    wire and_res_1;
    wire and_res_2;

    // assign a_xor_b = (A ^ B);
    xor_gate xor_1(.x(A), .y(B), .z(a_xor_b));
    // assign sum = (a_xor_b ^ c_in);
    xor_gate xor_2(.x(a_xor_b), .y(c_in), .z(sum));

    and_gate and_0(.x(a_xor_b), .y(c_in), .z(and_res_1));
    and_gate and_1(.x(A), .y(B), .z(and_res_2));
    or_gate or_1(.x(and_res_1), .y(and_res_2), .z(c_out));

endmodule