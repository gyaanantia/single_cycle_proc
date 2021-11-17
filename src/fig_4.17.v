`timescale 1ns/10ps

// AD first attempt at processor.  P. 255 in text.

module ins_fetch(clk, reset, load_pc, z); //input: pc counter value; output: instruction

    //signals
    parameter pc_start = 32'h00400020; //this is what we are given for init
    input clk, reset, load_pc;
    output wire [31:0] z;
    // data wires:
    wire [31:0] pc_out, add_1_out, add_2_out, branch_mux_out, ins_mem_out,
    ins_31_26, ins_25_21, ins_20_16, ins_15_11, ins_15_0, ins_5_0, ext_out,
    read_data_1, read_data_2, shift_left_2;
    // control wires:
    wire [2:1] alu_op, alu_op_in; // check bit numbers
    wire reg_dst, branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write; // single bit

    //program counter
    register pc( // add a register to be the pc.
        .clk(clk), 
        .areset(reset), 
        .aload(load_pc), 
        .adata(pc_start), //reloads initial value when aload asserted
        .data_in(pc_in), // debug; final output is pc_in
        .write_enable(1'b1), // want to be able to write at end, always
        .data_out(pc_out) // debug; final value is pc_out
    );

    //instruction memory
    gac_sram #(.mem_file("data/bills_branch.dat")) ins_mem( // the instruction mem will be sram, no clock.
            .cs(1'b1), // always enable ops
            .oe(1'b1), // always read the ins mem
            .we(1'b0), // never write the ins mem 
            .addr(pc_out), // the address comes from pc
            .din(32'h00000000), // never write the ins mem
            .dout(z) // read out the instruction
    );

    //data memory
    gac_syncram #(.mem_file("data/bills_branch.dat")) data_mem (
        .clk(clk),
        .cs(1'b1), //always on
        .oe(),
        .we(),
        .addr(alu_result),
        .din(read_data_2),
        .dout()
        );

    //first adder (+4)
    adder_32 adder_1 ( // this adder just increments the pc +4 every time
        .a(pc_out), 
        .b(32'h00000004), // constant 4 for incrementing
        .z(add_1_out) // debug - final is pc_in
        );

    //second adder (for branch)
    adder_32 adder_2 ( // this adder just increments the pc +4 every time
        .a(add_1_out), 
        .b(shift_left_2), // constant 4 for incrementing
        .z(add_2_out) // debug - final is pc_in
        );
    
    // register file
    register_file(
        .clk(.clk), 
        .read_reg1(ins_25_21), 
        .read_reg2(ins_20_16), 
        .write_reg(), //mux output
        .write_data(z), //check this 
        .write_enable(reg_write), // from control 
        .read_data1(read_data1), 
        .read_data2(read_data_2)
        );
    
    // mux for branch logic
    gac_mux_32 branch_mux ( // the top one in the schematic
        .sel(), 
        .src0(), 
        .src1(alu), 
        .z(branch_mux_out)
    )

    //control will go here - placeholder
    // gac_control control (
    // .in(ins_31_26),
    // .RegDst(reg_dst),
    // .Branch(branch),
    // .MemRead(mem_read),
    // .ALUOp(alu_op),
    // .MemWrite(mem_write),
    // .ALUSrc(alu_src),
    // .RegWrite(reg_write)
    //  );




endmodule

