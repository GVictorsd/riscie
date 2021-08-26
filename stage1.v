
/*************************** STAGE-1 ***************************
*
* First stage of the pipeline
* fetch stage: features a program counter
* the stage is used to fetch next instruction by maintaining the
* program counter ...
*
* **************************************************************/

//TODO: `include instruction memory...
`include "src1/pc.v"

module stage1(
	// branch address if branch taken
	input [31:0] branchAddr,
	// clock, reset, control for next pc source(whether branch)
	input clk, reset, pcSrc,
	// pcWrite, ifidWrite for stalls
	input pcWrite, ifidWrite,

	// output (next instruction)
	output reg [31:0] ifidINST,ifidPc
);

	wire[31:0] nextAddr, data;

	PC pc(branchAddr, clk, pcSrc, pcWrite, reset, nextAddr);

//TODO:	INSTMEM instMem(nextAddr, data);

	always@(posedge clk)
	begin
		ifidPc <= nextAddr;
		if(ifidWrite)
			ifidINST <= ifidINST;
		else
			ifidINST <= data;
	end

endmodule

