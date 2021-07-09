
/*************************** STAGE-1 ***************************
*
* First stage of the pipeline
* fetch stage: features a program counter
* the stage is used to fetch next instruction by maintaining the
* program counter ...
*
* **************************************************************/

//TODO: `include instruction memory...

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



module PC(
	input [31:0] branchAddr,
	input clk, pcSrc, pcwrite, reset,
	output [31:0] addrOut
);

	/*
	* INPUTS:
	* branch address from later stages to update the pc in case of branch
	* clock,
	* control signal to select either next location or branch (pcSrc)
	* reset,
	*
	* OUTPUT:
	* Address of the next instruction
	*/

	reg [31:0] store;
	parameter ofsetAddr = 4;    // memory offset for next word

	assign addrOut = store;

	always@(posedge clk)
	begin
		if(reset)
			store <= 32'b0;
		else if(pcwrite)
			store <= store;
		else if(pcSrc)
			store <= branchAddr;
		else if(!pcSrc)
			store <= store + ofsetAddr;
	end

	endmodule


