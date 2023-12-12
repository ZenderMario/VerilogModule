`include "adder.v"

module AddInverse
#(parameter INPUTSIZE = 4)
(
    input  [INPUTSIZE - 1:0] in,
    output [INPUTSIZE - 1:0] inverse
);
    AddSub addsub( {INPUTSIZE{1'b0}}, in, 1'b0, 1'b1, inverse, overflow);
endmodule