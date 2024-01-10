`include "time_control.v"
`include "pc.v"
`include "register_file.v"
`include "Excute.v"
`include "AccessMemory.v"
`include "WriteBack.v"
`include "Decode.v"

module PipeCPU(
    input clk,
    output [7:0] res
);

    wire [4:0] error;

    //*Fetch code;
    wire [23:0] instr;
    wire [7:0]  addrI;
    wire [23:0] instr_f;
    wire [7:0]  increPC_f;
    wire        jmpFlag_f;
    
    PC pc( clk, instr, jmpFlag_m, increPC_m, addrI, instr_f, increPC_f, error[4]);

    //*Decode
    wire [7:0] addrR_d;
    wire [7:0] addrW_d;
    wire [7:0] increPC_d;
    wire [7:0] instr_d;
    wire [3:0] srcA_d;
    wire [3:0] srcB_d;
    wire [3:0] dst_d;
    wire [7:0] valC_d;
    wire [7:0] regA_d;
    wire [7:0] regB_d;
    wire [3:0] insCode_d;
    wire [3:0] funCode_d;
    wire [1:0] selA_d;
    wire [1:0] selB_d;
    wire       writeReg_d;
    wire       writeAluMem_d;
    wire       nop_D;

    Decode decode( clk, nop_D, instr_f, increPC_f, dst_w, regData_w, writeReg_w, writeReg_E, dst_E, writeReg_M, dst_M, writeReg_d, writeAluMem_d, increPC_d, insCode_d, funCode_d, regA_d, regB_d, selA_d, selB_d, dst_d, valC_d, error[3]);

    //*Excute 
    wire [7:0] addrW_e;
    wire       writeMem_e;
    wire       writeReg_E;
    wire       writeReg_e;
    wire [3:0] dst_E;
    wire [3:0] dst_e;
    wire [7:0] aluE_e;
    wire [7:0] valC_e;
    wire [7:0] increPC_e;
    wire [3:0] insCode_e;
    wire       jmpFlag_e;
    wire       nop_E;
    
    Excute excute( clk, nop_E,  writeReg_d, writeAluMem_d, insCode_d, funCode_d, regA_d, regB_d, selA_d, selB_d, dst_d, valC_d, increPC_d, regData_M, dst_m, regData_w, dst_w, jmpFlag_e, increPC_e, insCode_e, writeReg_E, writeReg_e, writeAluMem_e, aluE_e, valC_e, dst_E, dst_e, error[2]);

    //*Ram
    wire [7:0] valM_m;
    
    wire [7:0] regData_m;
    wire [7:0] regData_M;
    wire [7:0] instr_m;
    wire [3:0] dst_M;
    wire [3:0] dst_m;
    wire       jmpFlag_m;
    wire [7:0] increPC_m;
    wire       writeReg_M;
    wire       writeReg_m;
    
    Memory memory( clk, insCode_e, addrI, aluE_e, valC_e, dst_e, jmpFlag_e, increPC_e, writeReg_e, writeAluMem_e, jmpFlag_m, increPC_m, instr, writeReg_M, writeReg_m, dst_M, dst_m, regData_M, regData_m);

    //*WriteBack
    wire [3:0] dst_w;
    wire       writeReg_w;
    wire [7:0] regData_w;
    
    WriteBack write( clk, writeReg_m, dst_m, regData_m, writeReg_w, dst_w, regData_w);

endmodule