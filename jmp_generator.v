`ifndef JMP_GENE_V_ 
`define JMP_GENE_V_ 

module JmpGenerator(
    input [3:0] insCode,
    input [3:0] funCode,
    input [7:0] aluE_e,
    input       zf, 

    output reg jmpFlag
);

    always @(*) begin 
        if( insCode == 4'b0101) begin 
            case( funCode) 
                4'b0000 : jmpFlag = !aluE_e[7];
                4'b0001 : jmpFlag = !aluE_e[7] | !zf;
                4'b0010 : jmpFlag = !zf;
                4'b0011 : jmpFlag = zf;
                4'b0100 : jmpFlag = aluE_e[7]; 
                4'b0101 : jmpFlag = aluE_e[7] | !zf;
                default : jmpFlag = 1'b0;
            endcase
        end
        else 
            jmpFlag = 1'b0;
    end

endmodule

`endif