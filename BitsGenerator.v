`timescale 1ns/1ps

module Unsigned( 
input   [7:0] in,
output  reg [7:0] res);
    always @(*) 
       res = in[ 7] ? ~in + 1 : in;

endmodule

module BCD( input [7:0] in, input uFlag, output [15:0] out);
    integer sum = 0;
    integer i   = 0;
    integer j   = 0;
    integer k   = 0;
    
    wire [7:0] No;
    reg [15:0] res;
    
    Unsigned N( in, No);
    
    always @(*) begin
        if( uFlag)
            res = No;
        else 
            res = in;
           
        sum = 0;
        for( i = 0; i < 8; i = i + 1) begin
            sum = sum + (res[i] << i);
        end
        
        for( i = 0; i < 4; i = i + 1) begin
            k = sum % 10;
            sum = sum / 10;
            for( j = 0; j < 4; j = j + 1) begin
                res[ i * 4 + j] = k % 2;
                k = k / 2;
            end
        end
        if( in[ 7]) 
            res[15:12] = 4'b1010;
        else
            res[15:12] = 4'b1111;
    end
    
    assign out = res;
    
endmodule




module BitsGenerator( 
input  [7:0] number,
input  signedFlg,
output [15:0] bits
);

BCD bcd( number, signedFlg, bits);

endmodule
