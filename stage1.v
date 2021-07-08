
/*************************** STAGE-1 ***************************
*
* First stage of the pipeline
* fetch stage: features a program counter
* the stage is used to fetch next instruction by maintaining the
* program counter ...
*
* **************************************************************/

module pc(
	input [31:0] branchAddr,
	input clk, pcSrc, reset,
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
		else if(pcSrc)
			store <= branchAddr;
		else if(!pcSrc)
			store <= store + ofsetAddr;
	end

	endmodule


