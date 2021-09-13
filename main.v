
/**************************** MAIN MODULE *************************
*
* Module to bring all the pieces together
*
*******************************************************************/

`include "stage1.v"
`include "stage2.v"
`include "stage3.v"
`include "stage4.v"
`include "stage5.v"

module main;

reg clk = 0;
wire nclk;
reg reset = 0;

always #2 clk = ~clk;
assign nclk = ~clk;

// branch??, 
wire branch;
wire [31:0] ifidINST, ifidPc;

// TODO: pcWrite, branchAddr, ifidWrite,
wire [31:0] branchAddr;
wire pcWrite, ifidWrite;

stage1 s1(branchAddr, clk, reset, branch, pcWrite, ifidWrite,
    ifidINST, ifidPc);

wire regWriteEnable;
wire [4:0] writeReg;
wire [31:0] writeData;

wire [31:0] idexPc, idexData1, idexData2;
wire [4:0] idexRd;
wire [6:0] idexFunc7;
wire [2:0] idexFunc3;
wire [63:0] idexExpandInst;
wire [2:0] idexExCtrl, idexMemCtrl;
wire [1:0] idexWbCtrl;
stage2 s2(ifidINST, ifidPc, nclk, regWriteEnable, writeReg, writeData,
    idexPc, idexData1, idexData2, idexRd, idexFunc7, idexFunc3,idexExpandInst,
    idexExCtrl, idexMemCtrl, idexWbCtrl);


wire [4:0] exmemRd;
wire [31:0] exmemAlu, exmemReg2;
wire exmemZero;
wire [2:0] exmemMemCtrl;
wire [1:0] exmemWbCtrl;
stage3 s3(idexPc, idexData1, idexData2, idexRd, idexFunc7, idexFunc3, idexExpandInst,
    idexExCtrl, idexMemCtrl, idexWbCtrl, clk, regWriteEnable, writeReg, writeData,
    exmemRd, exmemAlu, exmemReg2, exmemZero, exmemMemCtrl, exmemWbCtrl);


wire [31:0] memwbData, memwbAddr;
wire [4:0] memwbRd;
wire [1:0] memwbWbCtrl;
stage4 s4(exmemReg2, exmemAlu, exmemRd, clk, exmemMemCtrl, exmemWbCtrl, exmemZero,
    memwbData, memwbAddr, branch, memwbRd, memwbWbCtrl);


stage5 s5(memwbData, memwbAddr, memwbRd, memwbWbCtrl, regWriteEnable, writeData, writeReg);
    
endmodule
