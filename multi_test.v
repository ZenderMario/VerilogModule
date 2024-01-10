`timescale 1ns/1ps

`include "multiplier_pipline.v"

module multi_test(); 
    reg [3:0] tmpA;
    reg [3:0] tmpB;
    wire [7:0] res;
    reg clk;

    MultiplierClkIm multi( tmpA, tmpB, clk, res);
    
    initial begin 
        $dumpfile("multi_test.vcd");
        $dumpvars;
        tmpA = 3;
        tmpB = 4;
        clk  = 0;
        
        #100 clk = ~clk; #100 clk = ~clk;

       tmpA = -1;
       tmpB = -1;
       #100 clk = ~clk; #100 clk = ~clk;
       
       tmpA = -1;
       tmpB =  1;

       #100 clk = ~clk; #100 clk = ~clk;
       
       tmpA = -2;
       tmpB = -2;
        
       #100 clk = ~clk; #100 clk = ~clk;
       #100 clk = ~clk; #100 clk = ~clk;
       #100 clk = ~clk; #100 clk = ~clk;
       #100 clk = ~clk; #100 clk = ~clk;
       #100 clk = ~clk; #100 clk = ~clk;
       #100 clk = ~clk; #100 clk = ~clk;
       tmpA = 0;
       tmpB = 0;

    end
    
endmodule