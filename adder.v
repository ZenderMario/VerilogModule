`ifndef ADDER_V_ 
`define ADDER_V_ 

module FullAdder(
    input a,  
    input b, 
    input cin, 
    output cout, 
    output sum 
);
    
    assign cout = (a&b) | (a&cin) | (b&cin);  
    assign sum = a^b^cin; 
    
endmodule

module Adder
#(parameter INPUTSIZE = 4)
(
    input [INPUTSIZE - 1:0] a,
    input [INPUTSIZE - 1:0] b,
    input cin, 
    output [INPUTSIZE - 1:0] s,
    output carryFlag
);
    wire [ INPUTSIZE - 1: 0] carry;
    genvar i;
    
    FullAdder adder( a[0], b[0], 1'b0, carry[0], s[0]);

    generate
        for( i = 1; i < INPUTSIZE; i = i + 1) begin 
            FullAdder add( a[i], b[i], carry[ i - 1], carry[ i], s[i]);
        end

    endgenerate
    assign carryFlag = carry[INPUTSIZE - 1]; 

endmodule

module AdderSigned
#(parameter INPUTSIZE = 4)
(
    input [INPUTSIZE - 1:0] a,  
    input [INPUTSIZE - 1:0] b, 
    input cin, 
    output [INPUTSIZE - 1:0] s, 
    output overflow 
);
    wire cf;

    Adder #(.INPUTSIZE(INPUTSIZE)) add ( a, b, cin, s, cf);
    assign overflow = (a[INPUTSIZE - 1] && b[INPUTSIZE - 1] && !s[INPUTSIZE - 1] )|| (!a[INPUTSIZE - 1] && !b[INPUTSIZE - 1] && s[INPUTSIZE - 1] )? 1 : 0;
	
endmodule

module AddSub
#(parameter INPUTSIZE = 4)
(
    input [INPUTSIZE - 1:0] a, 
    input [INPUTSIZE - 1:0] b, 
    input cin, 
    input operator, 
    output [INPUTSIZE - 1:0] result, 
    output overflow 
); 

    wire [ INPUTSIZE - 1: 0] cb;
    assign cb = operator ? ~b + 'b1 : b;
    AdderSigned #(.INPUTSIZE(INPUTSIZE)) add( a, cb, cin, result, overflow);

endmodule

`endif