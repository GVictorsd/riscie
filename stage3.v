
/****************************** STAGE-3 *************************
*
* Execute stage of the pipeline
* Components: ALU and ALU Control
*
*****************************************************************/

module stage3(
	input [31:0] idexPc,
	input [31:0] idexData1, idexData2,
	input [4:0] idexRd,
	input [6:0] idexFunc7,
	input [2:0] idexFunc3,
	input [63:0] idexExpandInst,
	input clk,

	//TODO: control signals
	input AluSrc,
	input [1:0] AluOp,

	input memwbWb,
	input [4:0] memwbRd,
	input [31:0] wbData, // write back data from wb stage mux

	output reg [4:0] exmemRd,
	output reg [31:0] exmemAlu, exmemReg2,
	output reg exmemZero,

	output reg exmemWb //TODO: part of control line
);

	wire [1:0] forwardA, forwardB;
	FORWARDUNIT forwardUnit(idexExpandInst[19:15], idexExpandInst[24:20],
		exmemRd, memwbRd, exmemWb, memwbWb, forwardA, forwardB);

	wire[31:0] AluinA, AluinB;

	assign AluinA = (forwardA == 0) ? idexData1 :
		(forwardA == 2'b10) ? exmemAlu :
		(forwardA == 2'b01) ? wbData : 0;

	assign AluinB = (forwardB == 0) ? idexData2 :
		(forwardB == 2'b10) ? exmemAlu :
		(forwardB == 2'b01) ? wbData : 0;

	//TODO: AluSrc, AluOp controls
	
	wire [31:0] AluResult;
	wire zero;
	ALUCONTROL AluControl(AluinA, AluinB, idexExpandInst, AluSrc, idexFunc7, idexFunc3, AluOp, AluResult, zero);

	always@(posedge clk)
	begin
		exmemRd <= idexRd;
		exmemAlu <= AluResult;
		exmemReg2 <= AluinB;
		exmemZero <= zero;
	end

endmodule

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

//module test;
//
//	reg [4:0] idexRs1, idexRs2;
//	reg [4:0] exmemRegrd, memwbRegrd;
//	reg exmemWb, memwbWb;
//
//	wire [1:0] forwardA, forwardB;
//	forwardUnit DUT(idexRs1, idexRs2,exmemRegrd, memwbRegrd,exmemWb, memwbWb,forwardA, forwardB);
//
//	initial
//	begin
//	
//	initial
//	begin
//		$dumpfile("vars.vcd");
//		$dumpvars(0,DUT);
//	end
//	endmodule


module FORWARDUNIT(
	input [4:0] idexRs1, idexRs2,
	input [4:0] exmemRegrd, memwbRegrd,
	input exmemWb, memwbWb,

	output reg[1:0] forwardA, forwardB
);

	always@(*)
	begin
		forwardA = 2'b00;
		forwardB = 2'b00;

		if(exmemWb && exmemRegrd != 0 && exmemRegrd == idexRs1)
			forwardA = 2'b10;
		if(exmemWb && exmemRegrd != 0 && exmemRegrd == idexRs2)
			forwardB = 2'b10;


		if(memwbWb && memwbRegrd != 0 && memwbRegrd == idexRs1)
			forwardA = 2'b01;
		if(memwbWb && memwbRegrd != 0 && memwbRegrd == idexRs2)
			forwardB = 2'b01;


		if(memwbWb && memwbRegrd != 0 && 
			!(exmemWb && exmemRegrd != 0 && exmemRegrd == idexRs1) &&
			memwbRegrd == idexRs1)
			forwardA = 2'b01;

		if(memwbWb && memwbRegrd != 0 &&
			!(exmemWb && exmemRegrd != 0 && exmemRegrd == idexRs2) &&
			memwbRegrd == idexRs2)
			forwardB = 2'b01;
	end
	
	endmodule
