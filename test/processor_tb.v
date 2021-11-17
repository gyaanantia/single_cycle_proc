`timescale 1ns/10ps

module processor_tb;

    reg clk_tb;
    reg reset_tb;
    reg [31:0] load_pc_tb;
    wire [31:0] z_tb;

    processor test(
        .clk(clk_tb),
        .reset(reset_tb),
        .load_pc(load_pc_tb),
        .z(z_tb)
    );

    initial begin
        clk_tb = 0;
        reset_tb = 1;
        #10
        load_pc_tb = 32'h00400020;
        reset_tb = 0;
        #10
        #10
        #10
        $finish;


    end

    always #5 clk_tb = ~clk_tb;
endmodule
