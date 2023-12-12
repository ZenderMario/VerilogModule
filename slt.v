`ifndef SLT_V_
`define SLT_V_

`include "adder.v"
module Slt
#(parameter INPUTSIZE = 4)
(
	input [INPUTSIZE - 1:0] a,
	input [INPUTSIZE - 1:0] b,
	output [INPUTSIZE - 1:0] res
);
	wire [INPUTSIZE - 1:0] tmp;
	wire zf;
	AddSub #(.INPUTSIZE(INPUTSIZE)) addsub( a, b, 1'b0, 1'b1, tmp, zf);
		
	assign res = tmp[3] ? 1'b1 : 1'b0;

endmodule

`endif