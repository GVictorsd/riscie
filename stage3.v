
/****************************** STAGE-3 *************************
*
* Execute stage of the pipeline
* Components: ALU and ALU Control
*
*****************************************************************/

`include "src3/alu.v"
`include "src3/aluControl.v"
`include "src3/forwardUnit.v"

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


