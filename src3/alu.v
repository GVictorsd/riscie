
module ALU(
	input [31:0] a, b,
	input [3:0] control,
	output [31:0] c,
	output zero
);

	parameter AND = 4'h0,
		OR = 4'h1,
		ADD = 4'h2,
		SUB = 4'h6;

	assign c = (control == AND) ? a&b :
		(control == OR) ? a | b :
		(control == ADD) ? a + b:
		(control == SUB) ? a-b:
		32'hx;

	assign zero = (c == 0) ? 1'b1 : 1'b0;

endmodule
