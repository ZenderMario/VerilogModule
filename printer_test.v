`timescale 1ns/1ps
`include "ALU_Print.v"

module Printer_test();
    reg [3:0] op1;
    reg [3:0] op2;
    reg [3:0] aluc;

    wire [3:0] res;
    
    reg clk = 0;
    
    Printer p1( {op1, op2}, clk, aluc, res);

    initial begin 
        $dumpfile("Printer.vcd");
        $dumpvars;

        op1 = 4'b1010;
        op2 = 4'b1011;
        aluc = 4'b0010;
        clk = ~clk;

        #100 
        clk = ~clk;
    end
endmodule