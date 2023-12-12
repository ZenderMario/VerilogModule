`include "time_control.v"
`include "BitsGenerator.v"

module Printer(
    input [7:0]      number,   
	input            clk,
    output reg [7:0] led_id,
    output reg [7:0] out_led 
    );
    reg [1:0]   id = 2'b0;
    reg         lc_clk = 0;
    reg [3:0]   print;
    
    wire [15:0] num;

    integer count = 0;

    BitsGenerator bg( number, 1'b1, num);
        
    /*always @(posedge clk) begin
        count = count + 1;
        if( count == 50000) begin
            lc_clk = ~lc_clk;
            count = 0;
        end
    end*/
        
    always @(posedge clk) begin
        id = id + 1;
        case ( id) 
            2'b00 : led_id <= 8'b1111_1110;
            2'b01 : led_id <= 8'b1111_1101;
            2'b10 : led_id <= 8'b1111_1011;
            2'b11 : led_id <= 8'b1111_0111;
            default : led_id <= 8'b1111_1110;
        endcase
        
        
        case( id)
            2'b00 : print = num[ 3:0];
            2'b01 : print = num[ 7:4];
            2'b10 : print = num[ 11:8];
            2'b11 : print = num[ 15:12];
            default : print = num[3:0];
        endcase

         case(print)  
                4'b0000: out_led <= 8'b0000_0011;    //0
                4'b0001: out_led <= 8'b1001_1111;    //1
                4'b0010: out_led <= 8'b0010_0101;    //2
                4'b0011: out_led <= 8'b0000_1101;    //3
                4'b0100: out_led <= 8'b1001_1001;    //4
                4'b0101: out_led <= 8'b0100_1001;    //5
                4'b0110: out_led <= 8'b0100_0001;    //6
                4'b0111: out_led <= 8'b0001_1111;    //7
                4'b1000: out_led <= 8'b0000_0001;    //8
                4'b1001: out_led <= 8'b0000_1001;    //9
                4'b1010: out_led <= 8'b1111_1101;
                default:
                   out_led = 8'b1111_1111;
           endcase
       end
endmodule
