`ifndef MULTIPLIER_H_
`define MULTIPLIER_H_

module Multiplier
#(parameter INPUTSIZE = 4)
(
	input      [INPUTSIZE - 1:0] a,
	input  	   [INPUTSIZE - 1:0] b,
	output reg [2 * INPUTSIZE - 1:0] z,
	output ZF
);
	reg [INPUTSIZE - 1:0] tmpA;
	reg [INPUTSIZE - 1:0] tmp;
	reg [2 * INPUTSIZE - 1:0] tmpB;
	reg [2 * INPUTSIZE - 1:0] res;

	reg [2 * INPUTSIZE - 1:0] sum;
	integer i = 0;

	always @(*) begin
		sum = 1'b0;
		tmpA = a[INPUTSIZE - 1] ? ~a + 1 : a;
		tmp  = b[INPUTSIZE - 1] ? ~b + 1 : b;
		tmpB = { {INPUTSIZE{1'b0}}, tmp};
		
		for( i = 0; i < INPUTSIZE; i = i + 1) begin 
			if( tmpA[0]) begin 
				sum = sum + tmpB;
			end
			tmpA  = tmpA >> 1;
			tmpB  = tmpB << 1;
		end
		z = ( a[ INPUTSIZE - 1] ^ b[ INPUTSIZE - 1]) ? ~sum + 1 : sum;
	end
	
endmodule

`endif