/******************** Program counter *******************
* module defining the program counter for the design
*
* ******************************************************/

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
