`ifndef MULTIPLIER_PIP_H
`define MULTIPLIER_PIP_H
`timescale 1ns/1ps 

`include "adder.v"

module MultiplierReg
#(parameter INPUTSIZE = 4)
(
    input [ INPUTSIZE - 1:0]     a,
    input [ 2 * INPUTSIZE - 1:0] b,
    input [ 2 * INPUTSIZE - 1:0] preRes,
    input presFlag,
    input clk,
    
    output reg [ INPUTSIZE - 1:0] shiftA,
    output reg [ 2 * INPUTSIZE - 1:0] shiftB,
    output reg [ 2 * INPUTSIZE - 1:0] tmpRes,
    output reg sFlag
);
    always @(posedge clk) begin 
       if( a[0])  
            tmpRes <= preRes + b;
       else 
            tmpRes <= preRes + 1'b0;

        shiftA <= (a >> 1);
        shiftB <= (b << 1);
        sFlag   = presFlag;
    end
endmodule

module MultiplierClk
#(parameter INPUTSIZE = 4)
(
    input [ INPUTSIZE - 1:0] a,
    input [ INPUTSIZE - 1:0] b,
    input clk,
    output [ 2 * INPUTSIZE - 1:0] res
);

    genvar i;

    reg [ INPUTSIZE - 1:0]     tmpA;
    reg [ INPUTSIZE - 1:0]     tmp;
    reg [ 2 * INPUTSIZE - 1:0] tmpB;

    wire [ INPUTSIZE - 1:0]     outA [ INPUTSIZE - 1:0];
    wire [ 2 * INPUTSIZE - 1:0] outB [ INPUTSIZE - 1:0];
    wire [ 2 * INPUTSIZE - 1:0] outRes [ INPUTSIZE - 1:0];
    wire [ INPUTSIZE - 1:0] sFlag;
    reg [ 2 * INPUTSIZE - 1:0] out;

    wire [ INPUTSIZE - 1:0] data;
    assign data= 4'b0;
    
    always @(a or b) begin 
        tmpA = a[ INPUTSIZE - 1] ? ~a + 1 : a;
        tmp  = b[ INPUTSIZE - 1] ? ~b + 1 : b;
		tmpB = { {INPUTSIZE{1'b0}}, tmp};
    end

    MultiplierReg mul1( tmpA, tmpB, 8'b0, (a[3] ^ b[3]),       clk, outA[0], outB[0], outRes[0], sFlag[0]);
    generate 
        for( i = 1; i < INPUTSIZE; i = i + 1) begin 
            MultiplierReg mul( outA[ i - 1], outB[ i - 1], outRes[ i - 1], sFlag[ i - 1], clk, outA[ i], outB[ i], outRes[ i], sFlag[ i]);
        end
    endgenerate
   
    assign res = sFlag[3] ? ~outRes[3] + 1 :outRes[3]; 
    
endmodule

module MultiplierHash(
    input [3:0] addr,
    output reg [3:0] res
);

    always @(*) begin 
        case( addr)
            4'b0000 : res = 4'b0000;
            4'b0001 : res = 4'b0000;
            4'b0010 : res = 4'b0000;
            4'b0011 : res = 4'b0000;
            4'b0100 : res = 4'b0000;
            4'b0101 : res = 4'b0001;
            4'b0110 : res = 4'b0010;
            4'b0111 : res = 4'b0011;
            4'b1000 : res = 4'b0000;
            4'b1001 : res = 4'b0010;
            4'b1010 : res = 4'b0100;
            4'b1011 : res = 4'b0110;
            4'b1100 : res = 4'b0000;
            4'b1101 : res = 4'b0011;
            4'b1110 : res = 4'b0110;
            4'b1111 : res = 4'b1001;
            default : res = 4'b0000;
        endcase
    end

endmodule

module MultiplierRegIm(
    input [1:0] a,
    input [1:0] b,
    input [1:0] power,
    output reg [7:0] res
);

    wire [3:0] tmp;
    MultiplierHash hash( {a, b}, tmp);
    always @(*) begin 
        case( power) 
            2'b00 : res = { 4'b0, tmp[3:0]};
            2'b01 : res = { 2'b0, tmp[3:0] , 2'b0};
            2'b10 : res = { tmp[3:0] , 4'b0};
            default : res = {4'b0, tmp[3:0]};
        endcase
    end
endmodule

module MultiplierClkIm(
    input [3:0] a,
    input [3:0] b,
    input clk,
    output reg [7:0] res
);

    reg [3:0] tmpA;
    reg [3:0] tmpB;
    reg [7:0] tmpR;
    reg [7:0] tmpPar[3:0];
    reg [7:0] tmpAdd[3:0];
    reg [1:0] sFlag;

    wire [7:0] par[3:0];
    
    always @(a or b) begin 
        tmpA = a[3] ? ~a + 1 : a;
        tmpB  = b[3] ? ~b + 1 : b;
    end

    MultiplierRegIm reg1(tmpA[1:0], tmpB[1:0], 2'b0, par[0]);
    MultiplierRegIm reg2(tmpA[3:2], tmpB[1:0], 2'b1, par[1]);
    MultiplierRegIm reg3(tmpA[1:0], tmpB[3:2], 2'b1, par[2]);
    MultiplierRegIm reg4(tmpA[3:2], tmpB[3:2], 2'b10, par[3]);
    

    always @(posedge clk) begin
        sFlag[0]  <= (a[3] ^ b[3]) ? 1'b1 : 1'b0;
        sFlag[1]  <= sFlag[0];
        
        tmpPar[0] <= par[0];
        tmpPar[1] <= par[1];
        tmpPar[2] <= par[2];
        tmpPar[3] <= par[3];

        tmpAdd[0] <= tmpPar[0] + tmpPar[1];
        tmpAdd[1] <= tmpPar[2] + tmpPar[3];
        tmpAdd[2]  = tmpAdd[0] + tmpAdd[1];

        res        = sFlag[1] ? ~tmpAdd[2] + 1: tmpAdd[2];
    end
    
endmodule

`endif