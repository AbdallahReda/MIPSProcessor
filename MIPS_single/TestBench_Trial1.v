//Testbench
module tb();
	reg  Clk ;
	
	//RegFile
	reg  WriteEnb ;
	reg  [4:0] ReadReg1 = 0;
	reg  [4:0] ReadReg2 = 1;
	reg  [4:0] WriteReg = 2;
	wire [31:0] ReadData1,ReadData2;
	wire [31:0] WriteData;

	RegFile file(Clk, WriteEnb, ReadReg1, ReadReg2, WriteReg, ReadData1, ReadData2, WriteData);

	//ALU
	reg [3:0] op;
	reg [4:0] shamt;
	wire [31:0] Result;
	wire overFlow;

	ALU myALU(Result, overFlow, ReadData1,ReadData2,op, shamt);

	//MUX
	reg MUXCtrl;
	reg[31:0] wd = 32'h12345678;
	MUX myMUX(Result,wd,MUXCtrl,WriteData);

	//Clock
	always #10 Clk = ~ Clk;

	
	initial begin
		Clk <= 0;
		MUXCtrl <= 1;
		shamt <= 1;

		#50
		WriteEnb <= 0;
		$monitor("ReadReg1 reads from address  %h of value %h", ReadReg1, ReadData1);
		#50
		$monitor("ReadReg2 reads from address  %h of value %h", ReadReg2, ReadData2);	

		#50
		op = 0;
		$monitor("%d ADD %d is %d OVERFLOW = %1d", $signed(ReadData1), $signed(ReadData2), $signed(Result), overFlow);
		
		#50
		WriteEnb <= 1;
		#10
		WriteEnb <= 0;
		#10
		WriteReg = WriteReg +1;


		#50
		op = 1;
		$monitor("%d SUB %d is %d OVERFLOW = %1d", $signed(ReadData1), $signed(ReadData2), $signed(Result), overFlow);

		#50
		WriteEnb <= 1;
		#10
		WriteEnb <= 0;
		#10
		WriteReg = WriteReg +1;

		#50
		op = 2;
		$monitor("%b AND %b is %b", ReadData1, ReadData2, Result);

		#50
		WriteEnb <= 1;
		#10
		WriteEnb <= 0;
		#10
		WriteReg = WriteReg +1;

		#50
		op = 3;
		$monitor("%b OR  %b is %b", ReadData1, ReadData2, Result);

		#50
		WriteEnb <= 1;
		#10
		WriteEnb <= 0;
		#10
		WriteReg = WriteReg +1;

		#10
		op = 4;
		$monitor("SLL	%b by %d bits is %b", ReadData1, shamt, Result);

		#50
		WriteEnb <= 1;
		#10
		WriteEnb <= 0;
		#10
		WriteReg = WriteReg +1;

		#50
		op = 5;
		$monitor("SRL	%b by %d bits is %b", ReadData1, shamt, Result);

		#50
		WriteEnb <= 1;
		#10
		WriteEnb <= 0;
		#10
		WriteReg = WriteReg +1;
		#50

		op = 6;
		$monitor("SRA	%b by %d bits is %b", ReadData1, shamt, Result);

		#50
		WriteEnb <= 1;
		#10
		WriteEnb <= 0;
		#10
		WriteReg = WriteReg +1;

		#50
		op = 7;
		$monitor("%d IS Greater %d : %1d", $signed(ReadData1), $signed(ReadData2), Result);

		#50
		WriteEnb <= 1;
		#10
		WriteEnb <= 0;
		#10
		WriteReg = WriteReg +1;

		#50
		op = 8;
		$monitor("%d IS less    %d : %1d", $signed(ReadData1), $signed(ReadData2), Result);

		#50
		WriteEnb <= 1;
		#10
		WriteEnb <= 0;
		#10
		WriteReg = WriteReg +1;


		#50
		$monitor("Write %h to register of address %h", wd, WriteReg);
		#50
		MUXCtrl <= 0;
		#50
		WriteEnb <= 1;
		#10
		WriteEnb <= 0;
		#10
		WriteReg = WriteReg +1;
	$stop;
	end
	

endmodule



