`include "time_control.v"

module Selector(
    input [1:0] sel,
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    
    output reg [3:0] res
);
    always @( sel or a or b or c or d) begin 
        case( sel) 
            2'b00 : res = a;
            2'b01 : res = b;
            2'b10 : res = c;
            2'b11 : res = d;
        endcase
    end

endmodule