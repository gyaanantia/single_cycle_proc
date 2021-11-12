// 32 bit full subtractor
// Cam Brown
`timescale 1ns/10ps

module sub (A, B, b_in, diff, b_out, of);

    input [31:0] A, B;
    input b_in;
    output wire [31:0] diff;
    output wire b_out;
    output wire of;

    genvar  i;

    wire [30:0] between_subs; // wires to carry between subtractors in the RCA

    sub_1b sub_1b_(A[0], B[0], b_in, diff[0], between_subs[0]);

    generate
        for(i = 0; i < 30; i = i + 1) begin
            sub_1b sub_1b_1(A[i + 1], B[i + 1], between_subs[i], diff[i + 1], between_subs[i + 1]);
        end
    endgenerate
    
    sub_1b sub_1b_2(.A(A[31]), .B(B[31]), .b_in(between_subs[30]), .diff(diff[31]), .b_out(b_out));

    xor_gate xor_(.x(between_subs[30]), .y(b_out), .z(of)); 

endmodule