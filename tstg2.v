`timescale 10ns/1ns
`include "stage2.v"

module test;
	reg [4:0] readReg1, readReg2;
	reg [4:0] writeReg;
	reg clk = 0;
	reg writeEnable;
	reg [31:0] writeData;
	wire [31:0] data1, data2;
	regFile DUT(readReg1, readReg2, writeReg, clk, writeEnable, writeData, data1, data2);

	always #2 clk = ~clk;

	initial
	begin
		readReg1 = 0; readReg2 = 1;
		writeReg = 0; writeEnable = 1;
		writeData = 32;
		#4 writeReg = 31;
		#4 writeReg = 29;
		#4 writeEnable = 0;
		#4 readReg1 = 31; readReg2 = 29;
		#4 $finish;
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0, DUT);
	end

	endmodule



module test;
	reg [31:0] inData;
	wire [63:0] outData;

	bitExpand DUT(inData, outData);

	initial
	begin
		inData = 32'h47584236;
		#4 inData = 32'h53762368;
		#4 inData = 32'hf827f463;
		#4 inData = 32'hab47a7a9;
		#4 $finish;
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0, DUT);
	end
	endmodule
