
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
