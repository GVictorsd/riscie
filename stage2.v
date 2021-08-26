
/**************************** STAGE-2 ****************************
*
* Decode stage of the pipeline
* modules: register File(regFile)
* 	bitExpand...
*
******************************************************************/

`include "src2/regfile.v"
`include "src2/bitexpand.v"
//`include "src2/hazardDetection.v"
//TODO: `include controlUnit.v

module stage2(
	// instruction and pc from prev stage
	input[31:0] ifidInst, ifidPc,
	// clk, regwrite from WB stages
	input clk, regWriteEnable,
	// register to write from WB
	input [4:0] writeReg,
	// register write value from WB stage
	input [31:0] writeData,

	// PIPELINE REGISTERS
	//
	// pc forwarding
	output reg [31:0] idexPc,
	// register read values
	output reg [31:0] idexData1, idexData2,
	output reg [4:0] idexRd,
	output reg [6:0] idexFunc7,
	output reg [2:0] idexFunc3,
	output reg [63:0] idexExpandInst
);
	wire [31:0] d1, d2;
	wire [63:0] expandInst;


	REGFILE regFile(ifidInst[24:20], ifidInst[19:15], writeReg, /*ifidInst[11:7],*/
		clk, regWriteEnable, writeData, d1, d2);

	BITEXPAND bitExpand(ifidInst, expandInst);

	//TODO: Control Unit...

	always@(posedge clk)
	begin
		idexData1 <= d1;
		idexData2 <= d2;
		idexPc <= ifidPc;
		idexRd <= ifidInst[11:7];
		idexFunc7 <= ifidInst[31:25];
		idexFunc3 <= ifidInst[14:12];
		idexExpandInst <= expandInst;
	end

endmodule
