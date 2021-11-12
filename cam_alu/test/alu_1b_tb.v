// 1-bit ALU test bench
`timescale 1ns/10ps

module alu_1b_tb;

    reg A;
    reg B;
    reg [2:0] SELECT;

    wire CARRY_OUT;
    wire ZERO_FLAG;
    wire RESULT;

    alu_1b ALU_1(A, B, SELECT, CARRY_OUT, ZERO_FLAG, RESULT);

    initial 
        begin
        
            // initialize with dummy values
            A = 1'b0;
            B = 1'b0;

            /////////////////
            ////// ADD //////
            /////////////////
            SELECT = 3'b000;

            #1
            A = 1'b0;
            B = 1'b0;

            #5
            A = 1'b0;
            B = 1'b1;

            #5
            A = 1'b1;
            B = 1'b0;

            #5
            A = 1'b1;
            B = 1'b1;

            // begin buffer
            #5
            A = 1'b0;
            B = 1'b0;
            // end buffer

            /////////////////
            ////// SUB //////
            /////////////////
            SELECT = 3'b001;

            #1
            A = 1'b0;
            B = 1'b0;

            #5
            A = 1'b0;
            B = 1'b1;

            #5
            A = 1'b1;
            B = 1'b0;

            #5
            A = 1'b1;
            B = 1'b1;

            // begin buffer
            #5
            A = 1'b0;
            B = 1'b0;
            // end buffer

            /////////////////
            ////// AND //////
            /////////////////
            SELECT = 3'b010;

            #1
            A = 1'b0;
            B = 1'b0;

            #5
            A = 1'b0;
            B = 1'b1;

            #5
            A = 1'b1;
            B = 1'b0;

            #5
            A = 1'b1;
            B = 1'b1;

            // begin buffer
            #5
            A = 1'b0;
            B = 1'b0;
            // end buffer
            
            /////////////////
            ////// OR //////
            /////////////////
            SELECT = 3'b100;

            #1
            A = 1'b0;
            B = 1'b0;

            #5
            A = 1'b0;
            B = 1'b1;

            #5
            A = 1'b1;
            B = 1'b0;

            #5
            A = 1'b1;
            B = 1'b1;

            // begin buffer
            #5
            A = 1'b0;
            B = 1'b0;
            // end buffer

            /////////////////
            ////// XOR //////
            /////////////////
            SELECT = 3'b110;

            #1
            A = 1'b0;
            B = 1'b0;

            #5
            A = 1'b0;
            B = 1'b1;

            #5
            A = 1'b1;
            B = 1'b0;

            #5
            A = 1'b1;
            B = 1'b1;

            // begin buffer
            #5
            A = 1'b0;
            B = 1'b0;
            // end buffer
        
        

    end

endmodule