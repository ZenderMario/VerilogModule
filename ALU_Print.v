`timescale 1ns/1ps
`include "number.v"
`include "alu.v"


module Printer(
    input [7:0] in,
    input clk,
    input [3:0] aluc,
    output [7:0] led_id,
    output [7:0] out_led 
);
    reg [7:0] tmp;
    wire [3:0] res;
    wire cf, zf;

    alu    ALU( in[7:4], in[3:0], aluc, 1'b0, res, cf, zf);
    number Printer( res[7], res[6], res[5], res[4], res[3], res[2], res[1], res[0], clk, 1'b0, led_id, out_led);
    
    always @(res) begin 
        tmp = { res[3], res[3], res[3], res[3], res};
    end

endmodule