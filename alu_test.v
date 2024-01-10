`timescale 1ns/1ps 

`include "alu.v"

module alu_test();
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] aluc;
    
    wire [3:0] res;
    wire zf;

    ALU alu( a, b, aluc, 1'b0, res, zf);
    
    initial begin 
        $dumpfile("alu_test.vcd");
        $dumpvars;
        a = 4'b1010;
        b = 4'b0110;
        aluc = 4'b0000;
        #100 
        aluc = 4'b0001;
        #100
        aluc = 4'b0010;
        #100
        aluc = 4'b0110;
        #100 
        aluc = 4'b0111;
        #100
        aluc = 4'b1100;
        #100
        aluc = 4'b1101;
        #100 
        a    = 4'b1111;
        b    = 4'b0010;
        aluc = 4'b1110;
        #100
        aluc = 4'b0000;
    end

endmodule