module InstructionFetch_TestBench;

reg Clk,WritEnable;
reg [31:0]WriteData;
wire [31:0]ReadData;

always
	begin
	#5
	Clk = ~ Clk;
	end
initial 
begin
Clk<=0;
WritEnable<=0;
$monitor("ReadData=%d",ReadData);

end

FetchStage TestFetch(Clk,WriteData,ReadData,WritEnable);

endmodule
