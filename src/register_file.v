// 32 of the 32-bit registers

module register_file(clk, read_reg1, read_reg2, write_reg, write_data, write_enable, read_data1, read_data2);

input [4:0] read_reg1, read_reg2, write_reg;
input [31:0] write_data;
input clk, write_enable;
output wire [31:0] read_data1, read_data2;

// Wires coming out of each register, to be passed to the mux
// wire [31:0] $zero, $v0, $v1, $a0, $a1, $a2, $a3, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $t8, $t9, $gp, $sp, $fp, $ra;

// Actually just make wire arrays for input and output into the registers
wire [31:0] input_wires[31:0];
wire [31:0] output_wires[31:0];

// Note: registers 1, 26 and 27 are reserved for assembler/operating system, but I don't think that means we don't access them in hardware

// generate the bank of registers
// setting async reset, load and data to GND/0 until we want to implement that functionality
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin
        register reg_(.clk(clk), .areset(1'b0), .aload(1'b0), .adata(1'b0), .data_in(input_wires[i]), .write_enable(write_enable), .data_out(output_wires[i]));
    end
endgenerate

// These two muxes handle selecting which registers we are reading from

mux_32t1_32_arr read_sel_mux_1_(.sel(read_reg1), .in_arr(output_wires), .out(read_data1));
mux_32t1_32_arr read_sel_mux_2_(.sel(read_reg2), .in_arr(output_wires), .out(read_data2));

// In order to make sure writing is valid, just mux_32 with write_enable as the selector

mux_32t1_32_arr write_sel_mux_(.sel(write_reg), .in_arr(write_data), .)

assign output_wires[0] = 32'h0;     // this is the zero register, so just putting this at the end to ensure 0s are written to it.



