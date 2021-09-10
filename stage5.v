
/************************* WRITE-BACK STAGE *****************************
*
* Stage-5 of the pipeline
*
*************************************************************************/

module stage5(
    // Data from previous stage
    // ** memwbWb register address take from previous stage output
    input[31:0] memwbData, memwbAddr,
	input [4:0] memwbRd,  // writeback register

    // CONTROL SIGNALS
    input [1:0] memwbWbCtrl,


    output regwrite, // writeback??
    output[31:0] writebackData, // writeback data
    output [4:0] wbRd  // writeback register (forward)
);

    // memwbWbCtrl[1] -> signal to select data or address from previous stage
    // memwbWbCtrl[0] -> writeback signal to control writes to regfile(forward)
    assign regwrite = memwbWbCtrl[0];
    assign writebackData = memwbWbCtrl[1] ? memwbData : memwbAddr;
    assign wbRd = memwbRd;
    
endmodule