
module controlUnit(
    // current instruction
    input [31:0] inst,

    // CONTROL SIGNALS:
    // control signals for execute stage {AluSrc, AluOp[1:0]}
    output [2:0] exCtrl,

    // for memory stage {dataMemRead, dataMemWrite, Branch}
    output[2:0] memCtrl,

    // for WriteBack Stage {MemtoReg(for Mux select), regwrite(writeback enable)}
    output[1:0] wbCtrl;
);
    // EX stage(stage-3)
    reg AluSrc;
    reg [1:0] AluOp;
    assign exCtrl = {AluSrc, AluOp};

    // MEM stage(stage-4)
    reg dataMemRead, dataMemWrite, Branch;
    assign memCtrl = {dataMemRead, dataMemWrite, Branch};
    
    // WB stage(stage-5)
    reg MemtoReg; // mux select signal at writeback stage
    reg regwrite; // write back signal for register file
    assign wbCtrl = {MemtoReg, regwrite};


    // TODO : set control lines based on the instruction!!

endmodule