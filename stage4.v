
/* ************************** MEMORY STAGE ***********************
* forth stage in the system ( MEM )
* Writes to data memory takes place
*
* ***************************************************************/

`include "src4/dataMem.v"

module stage4 (
	// write address and data for data memory
	input [31:0] exmemMemWriteAddr, exmemMemWriteData,
	input [4:0] exmemRd, // writeback register to forward

	input clk,

	// CONTROL SIGNALS
	input [2:0] exmemMemCtrl,
	input [1:0] exmemWbCtrl,


	// zero bit from ALU in previous stage
	input exmemZero,

	output reg [31:0] memwbData, memwbAddr,

	// branch signal back to IF stage
	output reg branch,


	output reg [4:0] memwbRd,  // forward writeback register
	output reg [1:0] memwbWbCtrl  // forward control signals

);

	// destructure control signals for this stage
	// memory write, read for data memory and branch bit
	wire exmemMemWrite, exmemMemRead, exmemBranch;
	assign  exmemMemRead = exmemMemCtrl[2];
	assign exmemMemWrite = exmemMemCtrl[1];
	assign  exmemBranch = exmemMemCtrl[0];

	wire [31:0] memData;

	DATAMEMORY DataMem(exmemMemWriteAddr, exmemMemWriteData, exmemMemWrite, exmemMemRead,
		clk, memData);

	always@(posedge clk)
	begin
		memwbData <= memData;
		memwbAddr <= exmemMemWriteAddr;
		branch <= exmemBranch & exmemZero;

		memwbRd <= exmemRd;  // forward writeback register
		memwbWbCtrl <= exmemWbCtrl;  // forward control signals
	end

endmodule
