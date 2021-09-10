
/*********************** INSTRUCTION MEMORY ******************
* memory block to store instructions
* 32 bit addresses of 32 bit word length
* ** only lower 16 bits address space implemented due to verilog
* constrains...
* ***************************************************************/

module instMemory (
    input [31:0] address,
    output [31:0] data
);

reg [31:0] store [16'hffff:0];

assign data = store[address];
endmodule


/*** testModule ***
`timescale 10ns/1ns
module test;

reg [31:0] addr;
wire [31:0] dat;
instMemory DUT (addr, dat);

initial begin
    DUT.store[32'h0] = 32'ha;
    DUT.store[32'haa] = 32'haa;
    #2 addr <= 32'ha;
    #2 addr <= 32'h0;
    #2 addr <= 32'haa;
    #4 $finish;
end

initial begin
    $dumpfile("vars.vcd");
    $dumpvars(0, DUT);
end
    
endmodule

***/