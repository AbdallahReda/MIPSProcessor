module DecodeExecutionTB;
	reg Clk;
	reg [31:0]Instruction;


	wire [31:0]MemtoReg_Data;
	wire [11:0]ControlLines;
	wire [31:0]ReadData1;
	wire [31:0]ReadData2;
	wire [4:0]shamt;
	wire [31:0]ImmediateField;
 
	wire [31:0]ALUresult;
	wire zeroflag,overFlow;
	

Decode Dec(Clk,Instruction,ControlLines,MemtoReg_Data,ReadData1,ReadData2,shamt,ImmediateField);
Execution Exec(ReadData1,ReadData2,ControlLines[8:5],shamt,ControlLines[10],ImmediateField,ALUresult,zeroflag,overFlow);

always begin #20 Clk=~Clk; end
initial 
begin
Clk<=0;
Instruction<=32'b100011_10001_01000_0000000000011100;
$monitor("ReadData1=%d ReadData2=%d ControlLines=%b ALUresult=%d ImmediateField=%b ControlLines[8:5]=%b",ReadData1,ReadData2,ControlLines,ALUresult,ImmediateField,ControlLines[8:5]);

end
endmodule

