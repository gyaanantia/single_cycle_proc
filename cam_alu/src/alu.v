// ALU
// Cam Brown
// Nov 4, 2021
`timescale 1ns/10ps

module alu(
    A, B, select,
    carry_out_flag, overflow, zero_flag, result
);

input [31:0] A;
input [31:0] B;
input [3:0] select;

output carry_out_flag;
output overflow;
output zero_flag;
output [31:0] result;

wire [2:0] sel;
wire perf_sub;
wire [31:0] out;
wire [31:0] notB_res;
wire [31:0] add_res;
wire [31:0] sub_res;
wire [31:0] add_sub_mux;
wire [31:0] sll_res;
wire [31:0] srl_res;
wire [31:0] slt_res;
wire [31:0] sltu_res;
wire [31:0] and_res;
wire [31:0] or_res;
wire [31:0] xor_res;
wire [31:0] mux_res;

wire carry_out_res;
wire overflow_res;
wire zero_flag_res;

wire add_of;
wire sub_of;
wire slt_of;
wire sltu_of;

wire add_cout;
wire sub_cout;

// Perform AND on A and B
and_gate_32 and_(.x(A), .y(B), .z(and_res));

// Perform OR on A and B
or_gate_32 or_(.x(A), .y(B), .z(or_res));

// Perform XOR on A and B
xor_gate_32 xor_(.x(A), .y(B), .z(xor_res));

// Perform ADD on A and B
add add_(.x(A), .y(B), .c_in(1'b0), .sum(add_res), .c_out(add_cout), .of(add_of));

// Perform SUB on A and B
not_gate_32 not_(.x(B), .z(notB_res));
add add_0(.x(A), .y(notB_res), .c_in(1'b1), .sum(sub_res), .c_out(sub_cout), .of(sub_of));

// Perform SLL on A by amt B
sll sll_(.A(A), .amt(B[4:0]), .Q(sll_res));

// Perform SRL on A by amt B
srl srl_(.A(A), .amt(B[4:0]), .Q(srl_res));

// Perform SLT on A and B
slt slt_(.A(A), .B(B), .u(1'b0), .Q(slt_res), .of(slt_of));

// Perform SLTU on A and B
slt slt_u(.A(A), .B(B), .u(1'b1), .Q(sltu_res), .of(sltu_of));

// Selection code key:
// add:  0000   0x0
// sub:  0001   0x1
// and:  0010   0x2
// or:   0100   0x4
// xor:  0110   0x6
// sll:  1000   0x8
// srl:  1010   0xA
// slt:  1100   0xC
// sltu: 1110   0xE

// isolate top 3 bits of select
assign sel[2:0] = select[3:1];

// select addition or subtraction based on the last bit of select
assign perf_sub = select[0];
mux_32 mux_add_sub(.sel(perf_sub), .src0(add_res), .src1(sub_res), .z(add_sub_mux));


/////////////////////////////
//// CARRY OUT HANDLING /////
/////////////////////////////

// whether or not we write to the carry out bit depends on if we are doing add/sub or not
// this mux just gets the value from both operations
mux add_sub_carry(.sel(perf_sub), .src0(add_cout), .src1(sub_cout), .z(carry_out_res));

wire not_z;             // wire running out of not(sel[0])
wire nor_x_y;           // wire running out of sel[1] nor sel[2]
wire carry_out_we;      // sel[0] nor sel[1] nor sel[2] aka carry-out write-enable

not_gate not_z_(.x(sel[0]), .z(not_z));
nor_gate nor_x_y_(.x(sel[1]), .y(sel[2]), .z(nor_x_y));
and_gate and_notz_nor_xy_(.x(nor_x_y), .y(not_z), .z(carry_out_we));

wire carry_out_wire;

mux carry_out_enable(.sel(carry_out_we), .src0(1'b0), .src1(carry_out_res), .z(carry_out_wire));

assign carry_out_flag = carry_out_wire;


////////////////////////////
//// OVERFLOW HANDLING /////
////////////////////////////

// The operations where we have potential overflow are add, sub, slt, sltu
// We already have a wire that holds whether or not the op is add/sub
// Based on the status of sel[2] and sel[1], we can determine if its slt/sltu
// Finally, or'ing that result with our carry_out_we wire will give us overflow we

// First, gotta actually calculate the overflow first
wire of_add_sub;
wire of_slt_sltu;
wire of_val;

mux of_add_sub_(.sel(perf_sub), .src0(add_of), .src1(sub_of), .z(of_add_sub));
mux of_slt_sltu_(.sel(sel[0]), .src0(slt_of), .src1(sltu_of), .z(of_slt_sltu));
// We can use the carry-out write-enable status to tell us which overflow value we want
mux of_mux(.sel(carry_out_we), .src0(of_slt_sltu), .src1(of_add_sub), .z(of_val));

wire and_sel1_sel2_res;
wire overflow_we;

and_gate and_sel1_sel2(.x(sel[1]), .y(sel[2]), .z(and_sel1_sel2_res));
or_gate overflow_we_(.x(and_sel1_sel2_res), .y(carry_out_we), .z(overflow_we));

wire overflow_wire;

mux overflow_enable(.sel(overflow_we), .src0(1'b0), .src1(of_val), .z(overflow_wire));

assign overflow = overflow_wire;

// 8-to-1 32-bit mux based on the op-code
mux_8t1_32 sel_op(.x0(add_sub_mux), .x1(and_res), .x2(or_res), .x3(xor_res), .x4(sll_res), .x5(srl_res), .x6(slt_res), .x7(sltu_res), .sel(sel), .q(mux_res));


////////////////////////////
//// ZERO FLAG HANDLING ////
////////////////////////////

wire [30:0] or_bridge;
genvar i;

or_gate or_zf(.x(mux_res[0]), .y(mux_res[1]), .z(or_bridge[0]));
generate
    for(i = 1; i < 31; i = i + 1) begin
        or_gate or_zf_(.x(mux_res[i + 1]), .y(or_bridge[i-1]), .z(or_bridge[i]));
    end
endgenerate

// if the last wire after the cascade of or gates is 0, then zero flag is 1
not_gate not_zf(.x(or_bridge[30]), .z(zero_flag_res));

assign zero_flag = zero_flag_res;

// finally, pipe the mux result into result
assign result = mux_res;
    
endmodule