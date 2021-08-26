
/* ************************** MEMORY STAGE ***********************
* forth stage in the system ( MEM )
* Writes to data memory takes place
*
* ***************************************************************/

`include "src4/dataMem.v"

module stage4 (
	// write address and data, control signals
	input [31:0] exmemMemWriteAddr, exmemMemWriteData,
	input exmemMemWrite, exmemMemRead,
	// branch bit, zero bit from ExMem
	input exmemBranch, exmemZero,
	input clk,

	output reg [31:0] memwbData, memwbAddr,
	// branch signal back to IF stage
	output reg branch
);
	wire [31:0] memData;

	DATAMEMORY DataMem(exmemMemWriteAddr, exmemMemWriteData, exmemMemWrite, exmemMemRead,
		clk, memData);

	always@(posedge clk)
	begin
		memwbData <= memData;
		memwbAddr <= exmemMemWriteAddr;
		branch <= exmemBranch & exmemZero;
	end

endmodule
