//Testbench
module mux32bit (Result,wd,MUXCtrl,WriteData);
	input[31:0] Result,wd;
	input MUXCtrl;

	output reg [31:0] WriteData;

	always @(MUXCtrl, Result, wd) begin
			case(MUXCtrl)
				0 :  WriteData<=wd;
				1 :  WriteData<= Result;
			endcase
	end

endmodule
module MIPS(Clk,WriteData,WriteEnable,ReadData1,ReadData2,FromMUXtoREG,ALUresult,MEMWBControlLines);

	input wire Clk ;
	input wire [31:0]WriteData;
	input wire WriteEnable;
	wire [31:0]InputAddress;
	

	wire [31:0]MemtoMux;
	output wire [31:0]FromMUXtoREG;
	output wire [31:0]ReadData2;
	output wire [31:0]ReadData1;
	 wire [31:0]DataMEMtoReg;// form data mem to reg
	 wire [11:0]ControlLines;
	
	wire [4:0]shamt;
	wire [31:0]ImmediateField;
	output wire [31:0]ALUresult;
	wire zeroflag,overFlow;
	wire [31:0]BranchAddress;
	wire PCSrc;
	wire [31:0]OutputAddress;
	wire [31:0]ReadData;
	wire [4:0]rt,rd,WriteReg;	
	//////pipeline registers
	reg  [31:0]IFIDPC;
	reg  [31:0]IFIDIR; //Instruction
	reg  [31:0]IDEXPC;
	reg [31:0]IDEXReadData1;
	reg [31:0]IDEXReadData2;
	reg [11:0]IDEXControlLines;
	reg [4:0]IDEXrd,IDEXrt;
	reg [31:0]IDEXImmediate; //Extract shamt from it shamt=IDEXImmediate[10:6]
	reg [11:0]EXMEMControlLines;
	reg [31:0]EXMEMALUResult;
	reg [31:0]EXMEMWReadData2;
	reg [4:0]EXEMEMWriteReg;
	 reg[4:0]MEMWBWriteReg;
	reg [31:0]MEMWBALUResult;
	reg [31:0]MEMWBMEMRead;
	output reg [11:0]MEMWBControlLines;
	always @(posedge Clk) begin IFIDPC<=OutputAddress; IFIDIR<=ReadData;//IFID PIPLINE REGISTER
 			//$monitor(" WriteReg=%d EXEMEMWriteReg =%d,memRegWrite = %d",WriteReg,EXEMEMWriteReg ,MEMWBWriteReg);
				//IDEX PIPLINE REGISTER
			IDEXPC<=IFIDPC;
			IDEXReadData1<=ReadData1;
			IDEXReadData2<=ReadData2;
			IDEXControlLines<=ControlLines;
			IDEXrt<=IFIDIR[20:16];IDEXrd<=IFIDIR[15:11];
			IDEXImmediate<={{16{IFIDIR[15]}},IFIDIR[15:0]};		
			
				//EXMEM PIPLINE REGISTER
			EXMEMControlLines<=IDEXControlLines;
			EXMEMALUResult<=ALUresult;
			EXMEMWReadData2<=IDEXReadData2;
			EXEMEMWriteReg<=WriteReg;

				//MEMWB PIPLINE REGISTER
			MEMWBWriteReg<=EXEMEMWriteReg;
			MEMWBALUResult<=EXMEMALUResult;
			MEMWBMEMRead<=MemtoMux;
			MEMWBControlLines<=EXMEMControlLines;

				end
	
	/*FetchStage Fetch(Clk,WriteData,ReadData,WriteEnable,InputAddress,OutputAddress,PCSrc);

	Decode Dec(Clk,ReadData,ControlLines,FromMUXtoREG,ReadData1,ReadData2,shamt,ImmediateField,PCSrc,InputAddress,OutputAddress,rt,rd,WriteReg);

	Execution Exexcution(ReadData1,ReadData2,ControlLines[8:5],shamt,ControlLines[10],ImmediateField,ALUresult,zeroflag,overFlow,rd,rt,WriteReg,ControlLines[0]);

	MEMandWB MEM(ALUresult,ReadData2,ControlLines[4],ControlLines[3],ControlLines[9],Clk,MemtoMux);

	mux hh(ALUresult,MemtoMux,ControlLines[4],FromMUXtoREG);*/
	FetchStage Fetch(Clk,WriteData,ReadData,WriteEnable,InputAddress,OutputAddress,PCSrc);
	Decode Dec(Clk,IFIDIR,ControlLines,FromMUXtoREG,ReadData1,ReadData2,shamt,ImmediateField,PCSrc,InputAddress,IFIDPC,rt,rd,MEMWBWriteReg,MEMWBControlLines[11]);
	Execution Exexcution(IDEXReadData1,IDEXReadData2,IDEXControlLines[8:5],IDEXImmediate[10:6],IDEXControlLines[10],IDEXImmediate,ALUresult,zeroflag,overFlow,IDEXrd,IDEXrt,WriteReg,IDEXControlLines[0]);
	MEMandWB MEM(EXMEMALUResult,EXMEMWReadData2,EXMEMControlLines[4],EXMEMControlLines[3],EXMEMControlLines[9],Clk,MemtoMux);
	mux hh(MEMWBALUResult,MEMWBMEMRead,MEMWBControlLines[4],FromMUXtoREG);
	
	
	


endmodule

module MIPS_TB;
	reg Clk;
	reg [31:0]WriteData;
	reg WriteEnable;
	wire [31:0]ReadData1;
	wire [31:0]ReadData2;	
	wire [31:0]FromMUXtoREG;
	wire [31:0]ALUresult;
	wire [11:0]ControlLines;
	wire [31:0]InputAddress;
wire[4:0] MEMWBWriteReg;
	MIPS MIPS1(Clk,WriteData,WriteEnable,ReadData1,ReadData2,FromMUXtoREG,ALUresult,ControlLines);

	
always begin #10 Clk=~Clk; end
initial begin
	Clk<=0;
	WriteEnable<=0;
	$monitor($time,"Clk=%d ReadData1=%d ReadData2=%d FromMUXtoREG=%d ALU=%d  ControlLines=%b ",Clk,ReadData1,ReadData2,FromMUXtoREG,ALUresult,ControlLines);
	end

endmodule



