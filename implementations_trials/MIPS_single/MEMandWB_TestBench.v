module tb_MEMandWB();

reg Clk,MemtoReg,MemRead,MemWrite;
reg [31:0] AluResult;
reg [31:0] ReadData2;
wire [31:0] WriteDataReg;

TopModule m1(AluResult,ReadData2,MemtoReg,WriteDataReg,MemRead,MemWrite,Clk);

always
	begin
	#5
	Clk = ~ Clk;
	end
initial 
	begin
	$monitor("ReadData=%d ",WriteDataReg);
	Clk<=0;
	AluResult<=32'b000000_00000_00000_00000_00000_000000;
	MemWrite<=0;
	MemRead<=0;
	ReadData2<=32;
	MemtoReg<=1;
	#15
	AluResult<=32'b000000_00000_00000_00000_00000_000000;
	MemRead<=1;
	MemWrite<=0;
	end

endmodule
