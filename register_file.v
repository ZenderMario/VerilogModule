`include "time_control.v"

module RegisterFile
#( parameter REGSIZE = 4,
   parameter SRCSIZE = 2)
//the registers we use is defined to 4-bit if not set
//and we need SRCSSIZE bits to locate a register(2^SRCSIZE registers)
(
    input  [ SRCSIZE - 1:0] src1,
    input  [ SRCSIZE - 1:0] src2,
    input  [ SRCSIZE - 1:0]     dst,
    input  [7:0] data,
    input        write,
    input        clk,

    output [7:0] regA, 
    output [7:0] regB 
);
    reg [7:0] register[ REGSIZE - 1:0];
    //four registers
    //label 3 -- x3 always restore 0 
    
    assign regA = register[ src1];
    assign regB = register[ src2];

    always @( posedge clk) begin 
        if( write) begin 
           register[ dst] = data; 
        end
    end
endmodule