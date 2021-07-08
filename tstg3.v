`timescale 10ns/1ns
`include "stage3.v"

module test;

	
	reg [31:0] inReg1, inReg2, imm;
	reg ALUSrc;
	reg [6:0] func7;
	reg [2:0] func3;
	reg [1:0] AluOp;

	wire [31:0] result;
	wire zero;

	ALUControl DUT(inReg1, inReg2, imm, ALUSrc, func7, func3, AluOp,result,zero);

	initial
	begin
		inReg1 = 11; inReg2 = 22; imm = 33;
		ALUSrc = 0; AluOp = 0;
		#4 AluOp = 1;
		#4 AluOp = 2; func7 = 0; func3 = 0;
		#4 AluOp = 2; func7 = {4'h4,3'b000}; func3 = 0;
		#4 AluOp = 2; func7 = 0; func3 = 7;
		#4 func7 = 0; func3 = 6;
		#4 inReg2 = 11; AluOp = 2;
		#4 $finish;
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0, DUT);
	end

	endmodule
