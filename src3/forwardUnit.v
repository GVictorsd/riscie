
module FORWARDUNIT(
	input [4:0] idexRs1, idexRs2,
	input [4:0] exmemRegrd, memwbRegrd,
	input exmemWb, memwbWb,

	output reg[1:0] forwardA, forwardB
);

	always@(*)
	begin
		forwardA = 2'b00;
		forwardB = 2'b00;

		if(exmemWb && exmemRegrd != 0 && exmemRegrd == idexRs1)
			forwardA = 2'b10;
		if(exmemWb && exmemRegrd != 0 && exmemRegrd == idexRs2)
			forwardB = 2'b10;


		if(memwbWb && memwbRegrd != 0 && memwbRegrd == idexRs1)
			forwardA = 2'b01;
		if(memwbWb && memwbRegrd != 0 && memwbRegrd == idexRs2)
			forwardB = 2'b01;


		if(memwbWb && memwbRegrd != 0 && 
			!(exmemWb && exmemRegrd != 0 && exmemRegrd == idexRs1) &&
			memwbRegrd == idexRs1)
			forwardA = 2'b01;

		if(memwbWb && memwbRegrd != 0 &&
			!(exmemWb && exmemRegrd != 0 && exmemRegrd == idexRs2) &&
			memwbRegrd == idexRs2)
			forwardB = 2'b01;
	end
	
	endmodule
