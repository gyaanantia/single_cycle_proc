`timescale 1ns/10ps
module ALU_tb;
    reg [2:0] ctrl;
    reg [31:0] A, B;
    reg [4:0] shamt;
    wire cout, ovf, ze;
    wire [31:0] R;

    ALU tester(
        ctrl,
        A,
        B,
        shamt,
        cout,
        ovf,
        ze,
        R
    );

    initial begin
        // based on a couple slides I found online, this should be AND
        ctrl = 0;
        A = 32'hAAAAAAAA;
        B = 32'hFFFFFFFF;
        shamt = 0;
        #5
        // this should be OR
        ctrl = 1;
        #5
        // ADD
        A = -1;
        B = 1;
        ctrl = 2;
        #5
        // not sure
        ctrl = 3;
        A = 1;
        A = 32'h00010000;
        shamt = 5;
        #5
        // or?
        ctrl = 4;
        #5
        // left shift
        ctrl = 5;
        #5
        // SUB
        ctrl = 6;
        #5
        // SLT
        ctrl = 7;
        #5
        $finish;
    end

endmodule