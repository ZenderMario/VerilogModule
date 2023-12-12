`ifndef PC_V_ 
`define PC_V_ 

`include "time_control.v"
`include "adder.v"

module PC
#(parameter ADDRLEN = 8)
(
    input                   clk,
    input                   jumpFlag,
    input  [ ADDRLEN - 1:0] nextJump,

    output reg [ ADDRLEN - 1:0] nextAddr
);

    reg [ ADDRLEN - 1:0] insAddr;
    //stroe current address

    wire[ ADDRLEN - 1:0] insIncre;
    //store pc + 2

    Adder #(.INPUTSIZE( ADDRLEN)) PCIncrementer( insAddr, 8'b10, 1'b0, insIncre, carryFlag);
    
    always @(posedge clk) begin 
        insAddr      = nextAddr;
    end

    always @(negedge clk) begin 
        nextAddr = jumpFlag ? nextJump: insIncre;
        //to calculate next address correctly 
    end 
endmodule

`endif