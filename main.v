
/**************************** MAIN MODULE *************************
*
* Module to bring all the pieces together
*
*******************************************************************/

`include "stage1.v"
`include "stage2.v"
`include "stage3.v"
`include "stage4.v"

module main;

stage1 s1(branchAddr, clk, reset, pcSrc, pcWrite, ifidWrite,
    ifidINST, ifidWrite);
    
endmodule