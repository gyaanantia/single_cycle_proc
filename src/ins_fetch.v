`timescale 1ns/10ps

// AD first attempt at instruction fetch module.  P. 253 in text.

module ins_fetch(clk, reset, pc_in, ins_out); //input: pc counter value; output: instruction

    // define a clock here

    parameter pc_start = 32'h00400020; //this is what we are given, make param for flexibility
    input [31:0] pc_in;
    input clk, reset;
    output wire [31:0] ins_out;
    wire [31:0] pc_out; // need a wire for the pc result

    register pc( // add a register to be the pc.  Just hard-code most of these?
        .clk(clk), 
        .areset(1'b0), 
        .aload(reset), 
        .adata(pc_start), //reloads initial value when aload asserted
        .data_in(pc_in), 
        .write_enable(1'b1), // want to be able to write at end, always
        .data_out(pc_out) // wire in ins_fetch module
    );

    sram ins_mem( // the instruction mem will be sram, no clock.
            .cs(1'b1), 
            .oe(1'b1), 
            .we(1'b0), 
            .addr(pc_out), 
            .din(32'h00000000), 
            .dout(ins_out) 
    );

    adder_32 adder ( // this adder just increments the pc +4 every time
        .a(pc_out), 
        .b(32'h00000004), // constant
        .z(pc_in)
        );

endmodule //ins_fetch
