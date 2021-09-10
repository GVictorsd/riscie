
/**************************** STAGE-2 ****************************
*
* Decode stage of the pipeline
* modules: register File(regFile)
* 	bitExpand...
*
******************************************************************/

`include "src2/regfile.v"
`include "src2/bitexpand.v"
`include "src2/controlUnit.v"
//`include "src2/hazardDetection.v"

module stage2(
	input[31:0] ifidInst, ifidPc,  // instruction and pc from prev stage
	input clk,
	input regWriteEnable,  // regwrite from WB stages
	input [4:0] writeReg,  // register to write from WB
	input [31:0] writeData,  // register write value from WB stage

	// PIPELINE REGISTERS
	//
	// pc forwarding
	output reg [31:0] idexPc,
	// register read values
	output reg [31:0] idexData1, idexData2,

	output reg [4:0] idexRd,
	output reg [6:0] idexFunc7,
	output reg [2:0] idexFunc3,
	output reg [63:0] idexExpandInst,

	// CONTROL SIGNALS TO ID/EX PIPELINE REGISTER
	reg [2:0] idexExCtrl,   // EX stage signals...(stage-3)
	reg [2:0] idexMemCtrl,  // MEM signals
	reg [1:0] idexWbCtrl,   // WB signals
);


	wire [31:0] d1, d2;
	wire [63:0] expandInst;


	REGFILE regFile(ifidInst[24:20], ifidInst[19:15], writeReg, /*ifidInst[11:7],*/
		clk, regWriteEnable, writeData, d1, d2);

	BITEXPAND bitExpand(ifidInst, expandInst);

	//TODO: Control Unit...
	wire [2:0] wire_exCtrl, wire_memCtrl;
	wire [1:0] wire_wbCtrl;
	controlUnit ctrlUnit(ifidInst, wire_exCtrl, wire_memCtrl, wire_wbCtrl);

	always@(posedge clk) begin
		idexData1 <= d1;
		idexData2 <= d2;
		idexPc <= ifidPc;
		idexRd <= ifidInst[11:7];
		idexFunc7 <= ifidInst[31:25];
		idexFunc3 <= ifidInst[14:12];
		idexExpandInst <= expandInst;

		// forward control signals
		idexExCtrl <= wire_exCtrl;
		idexMemCtrl <= wire_memCtrl;
		idexWbCtrl <= wire_wbCtrl;
	end

endmodule
