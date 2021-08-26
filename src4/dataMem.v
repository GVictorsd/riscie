
/********************* DATA MEMORY ****************************
* module defining the data memory for the design
* address => 32 bit
* wordSize => 32 bit
*
* *************************************************************/

module DATAMEMORY(
	// address, write data, control signals and clock...
	input [31:0] address,
	input [31:0] writeData,
	input memWrite, memRead,
	input clk,

	// data out
	output [31:0] data
);

parameter addrSize = 32;
reg [31:0] store [(1<<addrSize)-1:0];

assign data = memRead ? store[address] : 32'hz;

always@(posedge clk)
begin
	if(memWrite)
	begin
		store[address] <= writeData;
	end
end

endmodule
