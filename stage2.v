
/**************************** STAGE-2 ****************************
*
* Decode stage of the pipeline
* modules: register File(regFile)
* 	bitExpand...
*
******************************************************************/


module regFile(
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



module bitExpand(
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



