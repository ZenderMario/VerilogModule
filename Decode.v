`ifndef DECODE_V_ 
`define DECODE_V_ 

`include "time_control.v"
`include "register_file.v"

module Decode(
    input clk,
    input nop_D,
    input [23:0] instr_f,
    input [7:0] increPC_f,
    input [3:0] dst_w,
    input [7:0] regData_w,
    input       writeReg_w,
    
    input       writeReg_e,
    input [3:0] dst_e,

    input       writeReg_m,
    input [3:0] dst_m,

    output reg writeReg_d,
    output reg writeAluMem_d,
    output reg [7:0] increPC_d,
    output reg [3:0] insCode_d,
    output reg [3:0] funCode_d,
    output     [7:0] regA_d, 
    output     [7:0] regB_d,
    output reg [1:0] selA,
    output reg [1:0] selB,
    output reg [3:0] dst_d,
    output reg [7:0] valC_d,
    output reg error
);
    reg [7:0]  increPC_D;
    reg [23:0] instr_D;
    reg [3:0]  srcA;
    reg [3:0]  srcB;

    RegisterFile #( .REGSIZE(8), .SRCSIZE(4)) regFile( clk, writeReg_w, srcA, srcB, dst_w, regData_w, regA_d, regB_d);

    always @( posedge clk) begin 
        increPC_D = increPC_f;
        instr_D   = (nop_D === 1'b1 ? 24'b0 : instr_f);
    end
    
    always @( negedge clk) begin 
        increPC_d = increPC_D;
        insCode_d = instr_D[23:20];
        funCode_d = instr_D[19:16];
        srcA      = instr_D[15:12];
        srcB      = instr_D[11:8];
        
        if( insCode_d == 4'b0100) 
            valC_d = instr_D[15:8];
        else
            valC_d = instr_D[7:0];
        
        case( insCode_d)
            4'b0000 : writeReg_d = 1'b0;//*nop
            4'b0001 : //*ld 
                begin 
                    writeReg_d = 1'b1;
                    dst_d      = srcA;
                    case ( funCode_d) 
                        4'b0000 : srcA = srcB;                     //* r2 -> r1
                        4'b0001 : writeAluMem_d = 1'b1;//* imm ->r1
                        4'b0010 : writeAluMem_d = 1'b0;//* (imm) ->r1
                        default : error = 1'b1;
                    endcase
                end
            4'b0010 : writeReg_d = 1'b0;//*sd 
            4'b0011 : //*alu 
                begin 
                    writeReg_d    = 1'b1;
                    writeAluMem_d = 1'b1;
                    dst_d         = srcA;
                end
            4'b0100 : //*jmp 
                begin 
                    writeReg_d    = 1'b1;
                    writeAluMem_d = 1'b0;
                    dst_d         = 4'b0001;
                end
            4'b0101 : //*b
                begin 
                    writeReg_d    = 1'b1;
                    writeAluMem_d = 1'b0;
                    dst_d         = 4'b0001;
                end
            default : error = 1'b1;
        endcase
        if( insCode_d == 4'b0001 && funCode_d == 4'b0001)
            selA = 2'b11; //* aluA from valC
        else if( dst_e == srcA && writeReg_e)
            selA = 2'b01; //* aluA from Mem
        else if( dst_m == srcA && writeReg_m) 
            selA = 2'b10; //* aluA from Write 
        else
            selA = 2'b00; //* aluA from regA 

        if( (insCode_d == 4'b0001 && (funCode_d == 4'b0001 || funCode_d == 4'b0000)) || insCode_d == 4'b0010 ) 
            selB = 2'b11; //* aluB is 0
        else if( dst_e == srcB && writeReg_e)
            selB = 2'b01; //* aluB from Mem
        else if( dst_m == srcB && writeReg_m) 
            selB = 2'b10; //* aluB from Write
        else 
            selB = 2'b00; //* aluB from regB
    end

endmodule

`endif