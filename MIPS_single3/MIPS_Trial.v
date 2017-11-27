//Testbench
module MIPS(Clk,WriteData,WriteEnable,ReadData1,ReadData2,DataMEMtoReg,ALUresult,ControlLines);

	input wire Clk ;
	input wire [31:0]WriteData;
	input wire WriteEnable;
	wire [31:0]InputAddress;
	
	output wire [31:0]ReadData2;
	output wire [31:0]ReadData1;
	output wire [31:0]DataMEMtoReg;// form data mem to reg
	output wire [11:0]ControlLines;
	wire [31:0]ReadData;
	
	wire [4:0]shamt;
	wire [31:0]ImmediateField;
	output wire [31:0]ALUresult;
	wire zeroflag,overFlow;
	wire [31:0]BranchAddress;
	wire PCSrc;
	wire [31:0]OutputAddress;
	FetchStage Fetch(Clk,WriteData,ReadData,WriteEnable,InputAddress,OutputAddress,PCSrc);

	
	Decode Dec(Clk,ReadData,ControlLines,DataMEMtoReg,ReadData1,ReadData2,shamt,ImmediateField,PCSrc,InputAddress,OutputAddress);
	
	Execution Exexcution(ReadData1,ReadData2,ControlLines[8:5],shamt,ControlLines[10],ImmediateField,ALUresult,zeroflag,overFlow);
	
	MEMandWB MEM(ALUresult,ReadData2,ControlLines[4],DataMEMtoReg,ControlLines[3],ControlLines[9],Clk);
endmodule

module MIPS_TB;
	reg Clk;
	reg [31:0]WriteData;
	reg WriteEnable;
	wire [31:0]ReadData1;
	wire [31:0]ReadData2;	
	wire [31:0]DataMEMtoReg;
	wire [31:0]ALUresult;
	wire [11:0]ControlLines;
	wire [31:0]InputAddress;
	MIPS MIPS1(Clk,WriteData,WriteEnable,ReadData1,ReadData2,DataMEMtoReg,ALUresult,ControlLines);

	
always begin #10 Clk=~Clk; end
initial begin
	Clk<=0;
	WriteEnable<=0;
	$monitor($time,"Clk=%d ReadData1=%d ReadData2=%d DataMEMtoReg=%d ALU=%d  ControlLines=%b",Clk,ReadData1,ReadData2,DataMEMtoReg,ALUresult,ControlLines);
	end

endmodule



