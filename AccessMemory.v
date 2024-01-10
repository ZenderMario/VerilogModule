`ifndef RAM_V_
`define RAM_V_

`include "time_control.v"

module Memory 
(
    input clk,
    input [3:0] insCode_e,
    input [7:0] addrI,
    input [7:0] aluE_e,
    input [7:0] valC_e,
    input [3:0] dst_e,
    input       jmpFlag_e,
    input [7:0] increPC_e,
    input       writeReg_e,
    input       writeAluMem_e,

    output reg        jmpFlag_m,
    output reg [7:0]  increPC_m,
    output     [23:0] instr,
    output reg        writeReg_M,
    output reg        writeReg_m,
    output reg [3:0]  dst_M,
    output reg [3:0]  dst_m,
    output reg [7:0]  regData_M,
    output reg [7:0]  regData_m
);

    reg [7:0] ram [255:0];
    
    initial begin
        ram[0] = 8'b0001_0001;
        ram[1] = 8'b0000_0000;
        ram[2] = 8'b0000_0010;
        ram[3] = 8'b0001_0001;
        ram[4] = 8'b0010_0000;
        ram[5] = 8'b0000_0100;
        ram[6] = 8'b0101_0010;
        ram[7] = 8'b0000_0010;
        ram[8] = 8'b0111_1111;
        ram[9] = 8'b0001_0000;
        ram[10] = 8'b0110_0000;
        ram[127] = 8'b0001_0000;
        ram[128] = 8'b0100_0000;
    end
    
    reg [7:0] addrW_M;
    reg [7:0] aluE_M;
    reg [7:0] valM_M;
    reg [3:0] insCode_M;
    reg       writeAluMem_M;
    reg       writeMem;
    reg [7:0] valC_M;
    

    always @(posedge clk) begin 
        dst_M      = dst_e;
        jmpFlag_m  = jmpFlag_e;
        writeReg_M = jmpFlag_m === 1'b1 ? 1'b0 : writeReg_e;
        writeAluMem_M = writeAluMem_e;
        insCode_M  = insCode_e;
        aluE_M     = aluE_e;
        jmpFlag_m  = jmpFlag_e;
        increPC_m  = increPC_e;
        valM_M     = ram[valC_M];
        valC_M     = valC_e;
        regData_M  = writeAluMem_M ? aluE_M : valM_M;

        if( insCode_M == 4'b0010) 
            writeMem = 1'b1;
        else 
            writeMem = 1'b0;

        if( writeMem) 
            ram[ valC_M] = aluE_M;    
        //write when posedge clk
    end

    always @(negedge clk) begin 
        dst_m = dst_M;
        writeReg_m = writeReg_M;
        regData_m  = regData_M;
    end
    
    assign instr = {ram[addrI], ram[addrI + 1], ram[addrI + 2]};

endmodule

`endif