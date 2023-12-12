`include "time_control.v"
`include "adder.v"
`include "slt.v"
`include "multiplier.v"

module ALU
#(parameter INPUTSIZE = 4)
(
	input  [INPUTSIZE - 1:0] a,
	input  [INPUTSIZE - 1:0] b,
	input  [3:0] 			 aluc,
	input       			 cin,

	output reg [INPUTSIZE - 1:0] r,
	output	    zf	 
);
	wire [INPUTSIZE - 1:0] addR, subR, sltR;
	wire [ 2 * INPUTSIZE - 1:0] mulTmp;

	wire overflow;
	
	reg  [INPUTSIZE  - 1:0] mulR;

	AddSub #(.INPUTSIZE(INPUTSIZE)) add( a, b, cin, 1'b0, addR, overflow);
	AddSub #(.INPUTSIZE(INPUTSIZE)) sub( a, b, cin, 1'b1, subR, overflow);
	Slt    #(.INPUTSIZE(INPUTSIZE)) slt( a, b, sltR);
	Multiplier #(.INPUTSIZE(INPUTSIZE)) multi(a, b,  mulTmp, overflow);
	
	always @(mulTmp) begin 
		mulR = mulTmp[INPUTSIZE - 1:0];
	end

	always @(a or b or aluc or cin or addR or subR or sltR or mulR) begin
		case(aluc) 
			4'b0000 : r = a & b;
			4'b0001 : r = a | b;
			4'b0010 : r = addR;
			4'b0110 : r = subR;
			4'b0111 : r = sltR;
			4'b1100 : r = ~(a|b);
			4'b1101 : r = ~(a&b);
			4'b1110 : r = mulR;
		endcase
	end
	assign zf = &(~r);

endmodule
