`timescale 10ns/1ns
`include "stage1.v"

module test;
	reg[31:0] branchAddr;
	reg clk=0, pcSrc, reset;
	wire[31:0] addrOut;

	pc DUT(branchAddr, clk, pcSrc, reset, addrOut);

	always #2 clk = ~clk;

	initial
	begin
		branchAddr<= 23;
		reset <= 1;
		pcSrc <= 0;
		#4 reset <= 0;
		#16 pcSrc <= 1;
		#4 branchAddr <= 44;
		#4 $finish;
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0, DUT);
	end

	endmodule
