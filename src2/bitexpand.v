
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
