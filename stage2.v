
/**************************** STAGE-2 ****************************
*
* Decode stage of the pipeline
* modules: register File(regFile)
* 	bitExpand...
*
******************************************************************/

module stage2(
	input[31:0] ifidInst, ifidPc,
	input clk, regWrite,
	input [31:0] writeData,

	output reg [31:0] idexPc,
	output reg [31:0] idexData1, idexData2,
	output reg [4:0] idexRd,
	output reg [6:0] idexFunc7,
	output reg [2:0] idexFunc3,
	output reg [63:0] idexExpandInst
);
	wire [31:0] d1, d2;
	wire [63:0] expandInst;


	REGFILE regFile(ifidInst[24:20], ifidInst[19:15], ifidInst[11:7],
		clk, regWrite, writeData, d1, d2);

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



module REGFILE(
	input [4:0] readReg1, readReg2,
	input [4:0] writeReg,
	input clk,
	input writeEnable,
	input [31:0] writeData,
	output [31:0] data1, data2
);

	/*
	* Register file with two read ports and a write Port
	* INPUT:
		* read registers - readReg1, readReg2,
		* write register - writeReg,
		* clock - clk,
		* writeEnable,
		* writeData - data to write
	* OUTPUT:
		* two ports giving out data in read registers
	*/

	reg [31:0] store [31:0];

	assign data1 = store[readReg1];
	assign data2 = store[readReg2];

	always@(posedge clk)
	begin
		if(writeEnable)
			store[writeReg] <= writeData;
	end

endmodule



module BITEXPAND(
	input [31:0] inData,
	output [63:0] outData
);

	/*
	* module to expand a 2's complement data from 32bits to 64bits
	* input:
		* 32 bit data input
	* output:
		* 64 bit sign preserved data
	*/

	assign outData[31:0] = inData[31:0];
	assign outData[63:32] = inData[31] ? 32'hFFFFFFFF : 32'h00000000;

endmodule


module hazardDetectionUnit(
	input [4:0] idexregrd, ifidRs1, ifidRs2,
	input idexMemRead,

	output reg ifidWrite, idexStall/*(to mux)*/, pcwrite
);

	always@(*)
	begin

		if(idexMemRead && (idexregrd == ifidRs1 || idexregrd == ifidRs2))
		begin
			//stall
			ifidWrite = 1;
			idexStall = 1;
			pcwrite = 1;
		end

		else
		begin
			//disassert the stall signals
			ifidWrite = 0;
			idexStall = 0;
			pcwrite = 0;
		end
	end

endmodule

