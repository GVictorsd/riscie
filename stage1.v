
/*************************** STAGE-1 ***************************
*
* First stage of the pipeline
* fetch stage: features a program counter
* the stage is used to fetch next instruction by maintaining the
* program counter ...
*
* **************************************************************/

`include "src1/instMem.v"
`include "src1/pc.v"

module stage1(
	input [31:0] branchAddr,  // branch address if branch taken
	input clk, reset, pcSrc,  // clock, reset, control for next pc source(whether branch)
	input pcWrite, ifidWrite,  // pcWrite, ifidWrite for stalls

	output reg [31:0] ifidINST, ifidPc  // next instruction, next pc value
);

	wire[31:0] nextAddr, data;

	PC pc(branchAddr, clk, pcSrc, pcWrite, reset, nextAddr);

	instMemory instmem (nextAddr, data);

	always@(posedge clk)
	begin
		ifidPc <= nextAddr;
		if(ifidWrite)
			ifidINST <= ifidINST;
		else
			ifidINST <= data;
	end

endmodule