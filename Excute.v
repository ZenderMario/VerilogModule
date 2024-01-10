`ifndef EXCUTE_V_ 
`define EXCUTE_V_ 

`include "alu.v"
`include "jmp_generator.v"

module Excute(
    input clk,
    input nop_E,
    input writeReg_d,
    input writeAluMem_d,
    input [3:0] insCode_d,
    input [3:0] funCode_d,
    input [7:0] regA_d,
    input [7:0] regB_d,
    input [1:0] selA_d,
    input [1:0] selB_d,
    input [3:0] dst_d,
    input [7:0] valC_d,
    input [7:0] increPC_d,
    
    input [7:0] regData_m,
    input [3:0] dst_m,

    input [7:0] regData_w,
    input [3:0] dst_w,

    output           jmpFlag_e,
    output reg [7:0] increPC_e,
    output reg [3:0] insCode_e,
    output reg       writeReg_E,
    output reg       writeReg_e,
    output reg       writeAluMem_e,
    output     [7:0] aluE_e,
    output reg [7:0] valC_e,
    output reg [3:0] dst_E,
    output reg [3:0] dst_e,
    output reg       error
);

    reg [3:0] insCode_E;
    reg [3:0] funCode_E;
    reg [7:0] increPC_E;
    reg [7:0] aluA;
    reg [7:0] aluB;
    reg [3:0] aluc;
    reg [7:0] valC_E;
    reg [7:0] regA_E;
    reg [7:0] regB_E;
    reg       writeAluMem_E;
    reg [1:0] selA_E;
    reg [1:0] selB_E;

    always @( posedge clk) begin 
        insCode_E   = (nop_E === 1'b1 ? 4'b0 : insCode_d);
        funCode_E   = (nop_E === 1'b1 ? 4'b0 : funCode_d);
        increPC_E   = increPC_d;
        valC_E      = valC_d;
        regA_E      = regA_d;
        regB_E      = regB_d;
        dst_E       = dst_d;
        writeReg_E  = (nop_E === 1'b1 ? 1'b0 : writeReg_d);
        writeAluMem_E = writeAluMem_d;
        selA_E      = selA_d;
        selB_E      = selB_d;
    end

    always @( negedge clk) begin 
        case ( selA_E) 
            2'b00 : aluA = regA_E;
            2'b01 : aluA = regData_m;
            2'b10 : aluA = regData_w;
            2'b11 : aluA = valC_E;
        endcase
        case ( selB_E) 
            2'b00 : aluB = regB_E;
            2'b01 : aluB = regData_m;
            2'b10 : aluB = regData_w;
            2'b11 : aluB = 8'b0;
        endcase
        
        case( insCode_E)
            4'b0000 ,
            4'b0001 ,
            4'b0010 : aluc = 4'b0010;
            4'b0011 : aluc = funCode_E;
            4'b0100 : aluc = 4'b0010;
            4'b0101 : aluc = 4'b0110;
            default : error = 1'b1;
        endcase
    end
    
    ALU #(.INPUTSIZE(8)) alu( aluA, aluB, aluc, 1'b0, aluE_e, zf);
    
    always @( negedge clk) begin 
        insCode_e     = insCode_E;
        increPC_e     = increPC_E;
        writeReg_e    = writeReg_E;
        writeAluMem_e = writeAluMem_E;
        dst_e         = dst_E;
        valC_e        = valC_E;
    end
    
    JmpGenerator jmpGene( insCode_E, funCode_E, aluE_e, zf, jmpFlag_e);

endmodule

`endif