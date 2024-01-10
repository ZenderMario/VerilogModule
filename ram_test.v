`include "ram.v"

module test();
    reg clk;
    reg wena;
    reg [4:0] addr;
    reg [7:0] data_in;
    wire [7:0] data_out; 

    RAM ram( clk, wena, addr, data_in, data_out);
    

    initial begin 
        $dumpfile("test.vcd");
        $dumpvars;
        clk = 0;
        addr = 5'b10010;
        data_in = 8'b1001_1111;
        wena = 1'b1;
        
        #100 clk = ~clk; #100 clk = ~clk;
        addr = 5'b00010;
        data_in = 8'b1111_1111;

        #100 clk = ~clk; #100 clk = ~clk;
        addr = 5'b10010;
        wena = 1'b0;
        data_in = 8'b0;

        #100 clk = ~clk; #100 clk = ~clk;
        addr = 5'b00010;

        #100 clk = ~clk; #100 clk = ~clk;
        addr = 1'b0;
        data_in = 8'b0;
        wena = 1'b0;
    end

endmodule