// AD first attempt at instruction fetch module.  P. 253 in text.

`timescale 1ns/10ps

module ins_fetch(pc_in, ins_out); //input: pc counter value; output: instruction

    parameter pc_start = 32'h00400020; //this is what we are given, make param for flexibility
    input [31:0] pc_in;
    output wire [31:0] ins_out;
    wire [31:0] pc_out; // need a wire for the pc result

    register pc( // add a register to be the pc.  Just hard-code most of these?
        .clk(1'b1), 
        .areset(1'b0), 
        .aload(1'b0), 
        .adata(32'h00000000), //no asynch. data in 
        .data_in(pc_in), 
        .write_enable(1'b1), // want to be able to write at end 
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
