`include "LEDPrint.v"

module test();
    reg [7:0] instr;
    reg clk;
    reg  pause;
    wire [7:0] out_led;
    wire [7:0] led_id;
    
    CPUPrint led(instr[7], instr[6], instr[5], instr[4], instr[3], instr[2], instr[1], instr[0], clk, pause, led_id, out_led);

    initial begin 
        $dumpfile("num_test.vcd");
        $dumpvars;
        instr = 8'b1000_1111;
        clk = 0;
        pause = 0;

        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        
        
        instr = 8'b1001_0111;
        pause = 1;
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        pause = 0;
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        
        instr = 8'b1110_0001;
        
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        #100 clk = ~clk; #100 clk = ~clk;
        
        clk = 0;
        instr = 8'b0;

    end

endmodule