module tb_dec;
reg Clk;
reg[31:0]Instruction;
wire [11:0]ControlLines;
wire [31:0]MemtoReg_Data;
wire [31:0]ReadData1;
wire [31:0]ReadData2;
wire [4:0]shamt;
wire [31:0]ImmediateField;
	always
	begin
	#5
	Clk = ~ Clk;
	end
initial 
	begin
	Clk<=0;
	Instruction<=32'b000000_10001_10010_01000_00000_100000;
	$monitor("Read1=%d Read2=%d,ControlLines=%b shamt=%b",ReadData1,ReadData2,ControlLines,shamt);
	end

Decode dec(Clk,Instruction,ControlLines,MemtoReg_Data,ReadData1,ReadData2,shamt,ImmediateField);

endmodule
