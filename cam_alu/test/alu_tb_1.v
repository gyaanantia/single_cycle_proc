`timescale 1ns/10ps

module alu_tb_1;

    reg [31:0] t_A;
    reg [31:0] t_B;
    reg [3:0] t_sel;

    wire t_carryOut;
    wire t_overflow;
    wire t_zero;
    wire [31:0] t_result;

    alu alu_(t_A, t_B, t_sel, 
             t_carryOut, t_overflow, t_zero, t_result);

    initial 
        begin
        
        // test ADD capabilities //
        #10
        t_sel = 4'h0;
        t_A = 32'h2;
        t_B = 32'h3;

        // test SUB capabilities //
        #10
        t_sel = 4'h1;
        t_A = 32'h2;
        t_B = 32'h3;

        // test AND capabilities //
        #10
        t_sel = 4'h2;
        t_A = 32'h2;
        t_B = 32'h3;

        // test OR capabilities //
        #10
        t_sel = 4'h4;
        t_A = 32'h2;
        t_B = 32'h3;

        // test XOR capabilities //
        #10
        t_sel = 4'h6;
        t_A = 32'h2;
        t_B = 32'h3;

        // test SLL capabilities //
        #10
        t_sel = 4'h8;
        t_A = 32'h2;
        t_B = 32'h3;

        // test SRL capabilities //
        #10
        t_sel = 4'hA;
        t_A = 32'h2;
        t_B = 32'h3;

        // test SLT capabilities //
        #10
        t_sel = 4'hC;
        t_A = 32'h2;
        t_B = 32'h3;

        // test SLTU capabilities //
        #10
        t_sel = 4'hE;
        t_A = 32'h2;
        t_B = 32'h3;

        #10
        t_sel = 0;
        t_A = 0;
        t_B = 0;


    end

endmodule