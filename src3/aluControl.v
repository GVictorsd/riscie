

module ALUCONTROL(
	input[31:0] inReg1, inReg2, imm,
	input ALUSrc,
	input [6:0] func7,
	input [2:0] func3,
	input [1:0] AluOp,

	output [31:0] result,
	output zero
);

	wire [31:0] dataOut1, dataOut2;
	wire [3:0] controlOut;
	
	ALU Alu(dataOut1, dataOut2, controlOut, result, zero);

	assign dataOut1 = inReg1;
	assign dataOut2 = ALUSrc ? imm : inReg2;

	parameter loadStore = 2'b00,
		branch = 2'b01,
		AluInstruction = 2'b10;

	parameter AND = 4'h0,
		OR = 4'h1,
		ADD = 4'h2,
		SUB = 4'h6;

	assign controlOut = (AluOp == loadStore) ? ADD :
		(AluOp == branch) ? SUB :
		(AluOp == AluInstruction) ?
			(func7 == 7'b0000000 && func3 == 3'b000) ? ADD :
			(func7 == 7'b0100000 && func3 == 3'b000) ? SUB :
			(func7 == 7'b0000000 && func3 == 3'b111) ? AND :
			(func7 == 7'b0000000 && func3 == 3'b110) ? OR  :
			4'hz:
		4'hz;

endmodule

