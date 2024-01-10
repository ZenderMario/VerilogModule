`ifndef REGISTERFILE_V_
`define REGISTERFILE_V_
`include "time_control.v"

module RegisterFile
#( parameter REGSIZE = 4,
   parameter SRCSIZE = 2
)
//the registers we use is defined to 4-bit if not set
//and we need SRCSSIZE bits to locate a register(2^SRCSIZE registers)
(
    input        clk,
    input        write,
    input  [ SRCSIZE - 1:0] src1,
    input  [ SRCSIZE - 1:0] src2,
    input  [ SRCSIZE - 1:0] dst,
    input  [7:0] data,

    output [7:0] regA, 
    output [7:0] regB 
);
    reg [7:0] register[ 2 ** SRCSIZE - 1:0];

    always @( posedge clk) begin 
        if( write) begin 
           register[ dst] = data; 
        end
    end
    
    assign regA = register[ src1];
    assign regB = register[ src2];
    
endmodule

`endif