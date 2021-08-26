
module hazardDetectionUnit(
	input [4:0] idexregrd, ifidRs1, ifidRs2,
	input idexMemRead,

	output reg ifidWrite, idexStall/*(to mux)*/, pcwrite
);

	always@(*)
	begin

		if(idexMemRead && (idexregrd == ifidRs1 || idexregrd == ifidRs2))
		begin
			//stall
			ifidWrite = 1;
			idexStall = 1;
			pcwrite = 1;
		end

		else
		begin
			//disassert the stall signals
			ifidWrite = 0;
			idexStall = 0;
			pcwrite = 0;
		end
	end

endmodule
