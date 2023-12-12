`ifndef SHIFT_V_ 
`define SHIFT_V_ 

module ShiftL(
	input [3:0] a,
	input [1:0] b,
	output[3:0]  res
);
	reg [3:0] tmp;

	always @(*) begin 
		case (b) 
			2'b00 : tmp = a;
			2'b01 : tmp = a << 1;
			2'b10 : tmp = a << 2;
			2'b11 : tmp = a << 3;
		endcase
	end

	assign res = tmp;
endmodule

module ShiftHR(
	input [3:0] a,
	input [1:0] b,
	output[3:0]  res
);
	reg [3:0] tmp;

	always @(*) begin 
		case (b) 
			2'b00 : tmp = a;
			2'b01 : tmp = a >> 1;
			2'b10 : tmp = a >> 2;
			2'b11 : tmp = a >> 3;
		endcase
	end

	assign res = tmp;
endmodule

module ShiftAR(
	input [3:0] a,
	input [1:0] b,
	output[3:0]  res
);
	reg [3:0] tmp;

	always @(*) begin 
		case (b) 
			2'b00 : tmp = a;
			2'b01 : tmp = $signed(a) >>> 1;
			2'b10 : tmp = $signed(a) >>> 2;
			2'b11 : tmp = $signed(a) >>> 3;
		endcase
	end

	assign res = tmp;
endmodule

`endif