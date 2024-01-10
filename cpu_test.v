`include "cpu.v"

module test();
    reg clk;
    reg  [7:0] instr;
    wire [7:0] res;
    TinyCPU CPU( instr, clk, res, singal);

    initial begin 
        $dumpfile("cpu.vcd");
        $dumpvars;

        clk = 1;

        #100 clk = ~clk; #100 clk = ~clk;
        instr = 8'b1001_1110;
        #100 clk = ~clk; #100 clk = ~clk;
        instr = 8'b1000_1110;
        #100 clk = ~clk; #100 clk = ~clk;
        instr = 8'b1110_0100;
        #100 clk = ~clk; #100 clk = ~clk;
        instr = 8'b1111_0000;
        #100 clk = ~clk; #100 clk = ~clk;
        instr = 8'b1111_0001;
        #100 clk = ~clk; #100 clk = ~clk;
        instr = 8'b1111_0010;
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
    end

endmodule