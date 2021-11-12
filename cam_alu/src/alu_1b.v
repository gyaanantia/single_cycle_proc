// ALU 1-bit
// Cam Brown
`timescale 1ns/10ps

module alu_1b(A, B, select, carry_out, zero_flag, result);

input A, B;
input [2:0] select;

output carry_out;
output zero_flag;
output result;

wire add_res;
wire sub_res;
wire and_res;
wire or_res;
wire xor_res;
wire carry_out;
wire res;
wire add_sub_mux;
wire sub_cout;
wire add_cout;


// selection encoding
// add: 000
// sub: 001
// and: 010
// or:  100
// xor: 110

// XOR result
xor_gate xor_(.x(A), .y(B), .z(xor_res));

// ADD result
add_1b add_(.A(A), .B(B), .c_in(1'b0), .sum(add_res), .c_out(add_cout));

// SUB result
wire not_B;
not_gate not_(.x(B), .z(not_B));
add_1b add_s(.A(A), .B(not_B), .c_in(1'b1), .sum(sub_res), .c_out(sub_cout));

// AND result
and_gate and_(.x(A), .y(B), .z(and_res));

// OR result
or_gate or_(.x(A), .y(B), .z(or_res));

// NAND sel1, sel2
wire add_sub_sel;
nand_gate nand_(.x(select[1]), .y(select[2]), .z(add_sub_sel));

// select the result based on the select bits
mux mux_add_sub_(.sel(select[0]), .src0(add_res), .src1(sub_res), .z(add_sub_mux));

wire [1:0] sel;

// pick between or and xor
wire or_xor_mux;
assign sel = select[2:1];
mux mux_xor_or_(.sel(sel[0]), .src0(or_res), .src1(xor_res), .z(or_xor_mux));

// pick between the result of those two and and
wire xOR_and_mux;
mux mux_xOR_and_(.sel(sel[1]), .src0(and_res), .src1(or_xor_mux), .z(xOR_and_mux));

// pick between add/sub and the other 3
mux last_mux_(.sel(add_sub_sel), .src0(xOR_and_mux), .src1(add_sub_mux), .z(res));

assign result = res;

/// ZERO FLAG ///

wire not_res;
not_gate not_res_(.x(res), .z(not_res));
assign zero_flag = not_res;

/// CARRY OUT ///

// we need to pick which cout value to send to carry_out_flag
wire add_sub_cout;
mux add_sub_cout_mux_(.sel(select[0]), .src0(add_cout), .src1(sub_cout), .z(add_sub_cout));

wire cout_res;
mux cout_mux_(.sel(add_sub_sel), .src0(1'b0), .src1(add_sub_cout), .z(cout_res));
assign carry_out = cout_res;

endmodule


