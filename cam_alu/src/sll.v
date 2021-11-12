// 32 bit left shifter
// Cam Brown
`timescale 1ns/10ps

module sll (A, amt, Q);

input [31:0] A;
input [4:0] amt;

output wire [31:0] Q;

wire [31:0] layer_1_carry;
wire [31:0] layer_2_carry;
wire [31:0] layer_3_carry;
wire [31:0] layer_4_carry;

genvar i;

// layer 1
generate
    for (i = 0; i < 32; i = i + 1) begin
        if (i < 1) begin
            mux mux_layer_1_zext(.sel(amt[0]), .src0(A[i]), .src1(1'b0), .z(layer_1_carry[i]));
        end
        else begin
            mux mux_layer_1_shift(.sel(amt[0]), .src0(A[i]), .src1(A[i - 1]), .z(layer_1_carry[i]));
        end
    end
endgenerate

// layer 2
generate
    for (i = 0; i < 32; i = i + 1) begin
        if (i < 2) begin
            mux mux_layer_2_zext(.sel(amt[1]), .src0(layer_1_carry[i]), .src1(1'b0), .z(layer_2_carry[i]));
        end
        else begin
            mux mux_layer_2_shift(.sel(amt[1]), .src0(layer_1_carry[i]), .src1(layer_1_carry[i - 2]), .z(layer_2_carry[i]));
        end
    end
endgenerate

// layer 3
generate
    for (i = 0; i < 32; i = i + 1) begin
        if (i < 4) begin
            mux mux_layer_3_zext(.sel(amt[2]), .src0(layer_2_carry[i]), .src1(1'b0), .z(layer_3_carry[i]));
        end
        else begin
            mux mux_layer_3_shift(.sel(amt[2]), .src0(layer_2_carry[i]), .src1(layer_2_carry[i - 4]), .z(layer_3_carry[i]));
        end
    end
endgenerate

// layer 4
generate
    for (i = 0; i < 32; i = i + 1) begin
        if (i < 8) begin
            mux mux_layer_4_zext(.sel(amt[3]), .src0(layer_3_carry[i]), .src1(1'b0), .z(layer_4_carry[i]));
        end
        else begin
            mux mux_layer_4_shift(.sel(amt[3]), .src0(layer_3_carry[i]), .src1(layer_3_carry[i - 8]), .z(layer_4_carry[i]));
        end
    end
endgenerate

// layer 5
generate
    for (i = 0; i < 32; i = i + 1) begin
        if (i < 16) begin
            mux mux_layer_5_zext(.sel(amt[4]), .src0(layer_4_carry[i]), .src1(1'b0), .z(Q[i]));
        end
        else begin
            mux mux_layer_5_shift(.sel(amt[4]), .src0(layer_4_carry[i]), .src1(layer_4_carry[i - 16]), .z(Q[i]));
        end
    end
endgenerate

endmodule