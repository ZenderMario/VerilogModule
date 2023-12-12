`include "time_control.v"
`include "adder.v"
`include "slt.v"
`include "alu.v"
`include "multiplier.v"
`include "ram.v"
`include "register_file.v"

//some components for each phase
module ControlUnit(
    input [7:0] instr,

    output reg [2:0] insType,
    output reg [1:0] dst,
    output reg [3:0] aluc,
    output reg       writeControl
);

    always @(instr) begin 
        if( instr[7:6] == 2'b10) begin
            //wirte to register
            insType      = 3'b00;
            dst          = instr[5:4];
            aluc         = 4'b0010;
            writeControl = 1'b1;
        end
        else if( instr[7:2] == 6'b1111_00) begin
            //read from register
            insType      = 3'b001;
            dst          = 2'b10;
            aluc         = 4'b0010;
            writeControl = 1'b0;
        end
        else if( instr[7:2] == 6'b1111_01) begin 
            //jump
            
        end
        else if( instr[7:2] == 6'b1111_10) begin 
            //
        end
        else if( instr[7:2] == 6'b1111_11) begin 
            //read instructions from memory instead of input
        end
        else begin 
            insType      = 3'b010;
            dst          = 2'b10;
            aluc         = instr[7:4];
            writeControl = 1'b1;
        end
    end

endmodule


module Complement4To8(
    input  [3:0] in,
    output [7:0] out
);

    assign out = { in[3], in[3], in[3], in[3], in[3:0]};

endmodule



//cpu excution
module Decode
#(parameter WORDSIZE = 8)
(
    input  [7:0] instr,

    output [2:0] insType,
    output reg [1:0] src1,
    output reg [1:0] src2,
    output [1:0] dst,
    output [3:0] aluc,
    output       write
);
    ControlUnit control(instr, insType, dst, aluc, write);    

    
    always @(insType) begin 

        case( insType) 
            3'b000 : //store immediate to registers
                begin 
                    src1 = 2'b11;
                    src2 = 2'b11;
                end
            3'b001 : //load  register and print it to screen
                begin 
                    src1 = instr[1:0];
                    src2 = 2'b11;
                end
            3'b010 : //r instruction
                begin 
                    src1 = instr[3:2];
                    src2 = instr[1:0];
                end
        endcase
    end


endmodule 

module Excute
#(parameter WORDSIZE = 8)
(
    input [ WORDSIZE - 1:0] reg1,
    input [ WORDSIZE - 1:0] reg2,
    input [3:0] aluc, 

    output [ WORDSIZE - 1:0] res,
    output                  zf
);

    ALU #(.INPUTSIZE(WORDSIZE)) alu( reg1, reg2, aluc, 1'b0, res, zf);

endmodule

module TinyCPU
#(parameter WORDSIZE = 8)
(
    input [7:0] instr,
    input clk,
    output [7:0] res,
    output singal
);
    //two resoureces for regFile
    wire [1:0] src1;
    wire [1:0] src2; 
    
    //destination for data to write to regFile
    wire [1:0] dst;
    wire       writeControl;
    wire [2:0] insType;

    wire [3:0] aluc;
    
    //two registers from regFile
    wire [WORDSIZE - 1:0] reg1;
    wire [WORDSIZE - 1:0] reg2; 

    //two operands for alu
    reg  [WORDSIZE - 1:0] valA;
    reg  [WORDSIZE - 1:0] valB;
    
    //final result
    reg  [WORDSIZE - 1:0] valR;
    
    //result from alu
    wire [WORDSIZE - 1:0] valE;
    
    //convert 4-bit complement to 8-bit's
    wire [WORDSIZE - 1:0] outComplement;
    wire zf;
    
    //We just abondon FETCH, cause we can just use inputs rather than instruction memory
    
    /****************************************************/

    RegisterFile regFile( src1, src2, dst, valE, writeControl, clk, reg1, reg2);
    
    /****************************************************/

    Decode #(.WORDSIZE(WORDSIZE)) decode( instr, insType, src1, src2, dst, aluc, writeControl);

    
    Complement4To8 complement( instr[3:0], outComplement);
    
    always @( insType or reg1 or outComplement) begin 
        case(insType) 
            3'b000 : valA = outComplement;
            default : valA = reg1;
        endcase
    end

    always @( insType or reg2) begin 
        case(insType) 
            3'b000 : valB = 8'b0;
            3'b001 : valB = 8'b0;
            default : valB = reg2;
        endcase
    end

    /****************************************************/

    Excute #(.WORDSIZE(WORDSIZE)) excute( valA, valB, aluc, valE, zf);

    /****************************************************/

    assign res = valE;

endmodule
