`ifndef RAM_V_
`define RAM_V_

`include "time_control.v"

module RAM(
    input clk,
    input wena,
    input [4:0] addr,
    input [7:0] data_in,
    output [7:0] data_out
);

    reg [7:0] ram [31:0];
    reg [7:0] out;
    
    initial 
        out = 0;
    
    always @(addr) begin 
        if( !wena)
            out = ram[ addr];
        //read at any time 
    end

    always @(posedge clk) begin 
        if( wena) 
            ram[ addr] = data_in;    
        //write when posedge clk
    end
    
    assign data_out = out;

endmodule

`endif