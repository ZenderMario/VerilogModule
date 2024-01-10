`ifndef PC_V_ 
`define PC_V_ 

`include "time_control.v"
`include "adder.v"
`include "AccessMemory.v"

module PC
(
    input clk,
    input [23:0] instr,
    input        jmpFlag_m,
    input [7:0]  increPC_m,

    output [7:0]  addrI,
    output reg [23:0] instr_f,
    output reg [7:0]  increPC_f,
    output reg error
);

    reg  [7:0] predPC_F;
    reg  [7:0] addrNext;
    reg  [7:0] predPC_f;
    
    reg needReg;
    reg needCon;
    
    initial 
        predPC_f = 8'b0;
    
    always @(posedge clk) begin 
        error    = 1'b0;
        predPC_F = predPC_f;
        
        addrNext = ( jmpFlag_m === 1'b1 ? increPC_m : predPC_F);
        
        case(instr[23:20])
            4'b0000 : 
                begin 
                    needReg = 1'b0;
                    needCon = 1'b0;
                end
            4'b0001 : 
                begin 
                    needReg = 1'b1;
                    case( instr[19:16]) 
                        4'b0000 : needCon = 1'b0;
                        4'b0001 , 
                        4'b0010 : needCon = 1'b1;
                        default : error   = 1'b1;
                    endcase
                end
            4'b0010 : 
                begin 
                    needReg = 1'b1;
                    needCon = 1'b1;
                end
            4'b0011 : 
                begin 
                    needReg = 1'b1;
                    needCon = 1'b0;
                end
            4'b0100 : 
                begin 
                    needReg = 1'b0;
                    needCon = 1'b1;
                end
            4'b0101 : 
                begin 
                    needReg = 1'b1;
                    needCon = 1'b1;
                end
        endcase
    end
    
    wire [1:0] increB;
    wire [7:0] increPC;
    
    Adder #(.INPUTSIZE(2)) IncreBytes( {1'b0, needReg}, {1'b0, needCon}, 1'b1, increB, c);
    
    Adder #(.INPUTSIZE(8)) PCIncrementer( predPC_F, {6'b0, increB}, 1'b0, increPC, carryFlag); 

    always @( negedge clk) begin 
        increPC_f = increPC;
        instr_f = instr;
        case( instr[23:20]) 
            4'b0000 ,
            4'b0001 ,
            4'b0010 ,
            4'b0011 : predPC_f = increPC_f; 
            4'b0100 : predPC_f = instr[15:8];
            4'b0101 : predPC_f = instr[7:0];
            default : error  = 1'b1;
        endcase
        if( jmpFlag_m) 
            predPC_f = increPC_m;
    end 
    
    assign addrI = addrNext;
endmodule
`endif