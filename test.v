`timescale 1ns/1ps 


module test();

    reg a;
    wire res;
    assign res = ( a == 1'b1) ? 1'b1 : 1'b0;

    initial begin 
        $dumpfile("test.vcd");
        $dumpvars;
        #100 a = 1'b0;
        #100 a = 1'b1;
        #100 a = 1'b0;
    end

endmodule