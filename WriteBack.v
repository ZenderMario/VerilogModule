`ifndef WRITEBACK_V
`define WRITEBACK_V 

module WriteBack(
    input clk,
    input       writeReg_m,
    input [3:0] dst_m,
    input [7:0] regData_m,
    
    output reg       writeReg_w,
    output reg [3:0] dst_w,
    output reg [7:0] regData_w
);
    always @(posedge clk) begin 
        dst_w     = dst_m;
        writeReg_w = writeReg_m;
        regData_w  = regData_m;
    end

endmodule
`endif