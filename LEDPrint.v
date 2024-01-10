`include "time_control.v"
`include "number.v"
`include "cpu.v"

module CPUPrint(
    input a,
    input b,
    input c,
    input d,
    input e, 
    input f, 
    input g,
    input h,
	input clk,
	input pause,
    output wire [7:0]led_id,
    output wire [7:0] out_led
    );
    
    wire [7:0] instr;
    wire [7:0] cpuR;
        
    assign instr = pause ? instr : { a, b, c, d, e, f, g, h};

    TinyCPU  cpu( instr, clk, cpuR, signal);
    Printer   num( cpuR, ~clk, led_id, out_led);

endmodule
