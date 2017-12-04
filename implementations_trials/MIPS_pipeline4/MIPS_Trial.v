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

///////////////////Combinational Circuit is asssssssssssssssssiiiiiiiiiiiiiiigggggggggggnnnnnnnnn

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
	reg [4:0]IDEXrd,IDEXrt,IDEXrs;
	reg [4:0]EXMEMrt,EXMEMrs;
	reg [4:0]MEMWBrt,MEMWBrs;
	reg [31:0]IDEXImmediate; //Extract shamt from it shamt=IDEXImmediate[10:6]
	reg [11:0]EXMEMControlLines;
	reg [31:0]EXMEMALUResult;
	reg [31:0]EXMEMWReadData2;
	reg [4:0]EXEMEMWriteReg;
	reg[4:0]MEMWBWriteReg;
	reg [31:0]MEMWBALUResult;
	reg [31:0]MEMWBMEMRead;
	wire [1:0]ForwardA,ForwardB;
	wire ForwardC;
	
	wire [31:0] ForwardAout,ForwardBout,ForwardCout;
	output reg [11:0]MEMWBControlLines;

	wire stallMuxSelector;
	wire [11:0]stallControlLines;
	initial begin
	
	IFIDPC<=0;
	IFIDIR=0; //Instruction
	IDEXPC<=0;
	IDEXReadData1<=0;
	IDEXReadData2<=0;
	IDEXControlLines<=0;
	IDEXrd<=0;IDEXrt<=0;IDEXrs<=0;
	EXMEMrt<=0;EXMEMrs<=0;
	MEMWBrt<=0;MEMWBrs<=0;
	IDEXImmediate<=0; //Extract shamt from it shamt=IDEXImmediate[10:6]
	EXMEMControlLines<=0;
	EXMEMALUResult<=0;
	EXMEMWReadData2<=0;
	EXEMEMWriteReg<=0;
	MEMWBWriteReg<=0;
	MEMWBALUResult<=0;
	MEMWBMEMRead<=0;
		end
	
	always @(posedge Clk) begin 
              if(stallMuxSelector==1) begin IFIDIR<=ReadData;   end IFIDPC<=OutputAddress;
		 //IFID PIPLINE REGISTER
 			//$monitor(" WriteReg=%d EXEMEMWriteReg =%d,memRegWrite = %d",WriteReg,EXEMEMWriteReg ,MEMWBWriteReg);
				//$monitor("ForwardA=%d ForwardB=%d ForwardAout=%d ForwardBout=%d EXMEMALUResult=%d",ForwardA,ForwardB,ForwardAout,ForwardBout,EXMEMALUResult);
			//$monitor("%d stallSelector=%d OutputAddress=%d EXMEMALUResult=%d ALUresult=%d ForwardAout=%d ForwardBout=%d IDEXControlLines=%b ",Clk,stallMuxSelector,OutputAddress,EXMEMALUResult,ALUresult,ForwardAout,ForwardBout,ForwardA,ForwardB,IDEXControlLines);
			//$monitor(" Clk=%d MEMWBALUResult=%d MEMWBMEMRead=%d MEMWBControlLines[4]=%d FromMUXtoREG=%d EXMEMALUResult=%d ALUresult=%d  ",Clk,MEMWBALUResult,MEMWBMEMRead,MEMWBControlLines[4],FromMUXtoREG,EXMEMALUResult,ALUresult);
				//$monitor($time,,"%d IDEXControlLines=%b IFIDIR=%x ReadData=%x stallMuxSelector=%d OutputAddress=%d",Clk,IDEXControlLines,IFIDIR,ReadData,stallMuxSelector,OutputAddress);
			$monitor($time,,"%d stallMuxSelector=%d ",Clk,stallMuxSelector);
			
					//IDEX PIPLINE REGISTER
			/*IDEXPC<=IFIDPC;
			//IDEXReadData1<=ReadData1;
			//IDEXReadData2<=ReadData2;
			IDEXControlLines<=ControlLines;
			IDEXrt<=IFIDIR[20:16];IDEXrd<=IFIDIR[15:11];
			IDEXImmediate<={{16{IFIDIR[15]}},IFIDIR[15:0]};*/
			
				//EXMEM PIPLINE REGISTER
			EXMEMControlLines<=IDEXControlLines;
			EXMEMALUResult<=ALUresult;
			EXMEMWReadData2<=ForwardBout;
			EXEMEMWriteReg<=WriteReg;
			EXMEMrs<=IDEXrs; EXMEMrt<=IDEXrt;
				//MEMWB PIPLINE REGISTER
			MEMWBWriteReg<=EXEMEMWriteReg;
			MEMWBALUResult<=EXMEMALUResult;
			MEMWBMEMRead<=MemtoMux;
			MEMWBControlLines<=EXMEMControlLines;
			MEMWBrs<=EXMEMrs; MEMWBrt<=EXMEMrt;

				end
	always @(negedge Clk or ReadData1 or ReadData2) // wiered fash55555555
		 begin
		IDEXPC<=IFIDPC; 
		IDEXReadData1<=ReadData1;
		IDEXReadData2<=ReadData2;
		//IDEXControlLines<=ControlLines;       //Back here
		IDEXControlLines<=stallControlLines;
		IDEXrt<=IFIDIR[20:16];IDEXrd<=IFIDIR[15:11]; IDEXrs<=IFIDIR[25:21];
		IDEXImmediate<={{16{IFIDIR[15]}},IFIDIR[15:0]};

		end 

	assign ForwardA=((EXMEMControlLines[11] == 1 ) && EXEMEMWriteReg == IDEXrs )?2:
			((MEMWBControlLines[11] == 1 && MEMWBWriteReg == IDEXrs)&& (EXEMEMWriteReg != IDEXrs || EXMEMControlLines[11] == 0))?1:0;
	
	assign ForwardB=( (EXMEMControlLines[11] == 1 || EXMEMControlLines[9]==1) && EXEMEMWriteReg == IDEXrt)?2:
			((MEMWBControlLines[11]==1 && MEMWBWriteReg == IDEXrt) && (EXEMEMWriteReg != IDEXrt || EXMEMControlLines[11] == 0))?1:0;

	assign ForwardC=(MEMWBrt==EXMEMrt&& MEMWBControlLines[3]==EXMEMControlLines[9] && MEMWBControlLines[11]==1)?0:1;
	

	
	assign stallMuxSelector= ( (IDEXControlLines[3] == 1) && (IDEXrt == IFIDIR[25:21] || IDEXrt == IFIDIR[20:16]) )?0:1;
	


	FetchStage Fetch(Clk,WriteData,ReadData,WriteEnable,InputAddress,OutputAddress,PCSrc,stallMuxSelector);
	Decode Dec(Clk,IFIDIR,ControlLines,FromMUXtoREG,ReadData1,ReadData2,shamt,ImmediateField,PCSrc,InputAddress,IFIDPC,rt,rd,MEMWBWriteReg,MEMWBControlLines[11]);
	Execution Exexcution(ForwardAout,ForwardBout,IDEXControlLines[8:5],IDEXImmediate[10:6],IDEXControlLines[10],IDEXImmediate,ALUresult,zeroflag,overFlow,IDEXrd,IDEXrt,WriteReg,IDEXControlLines[0]);
	MEMandWB MEM(EXMEMALUResult,ForwardCout,EXMEMControlLines[4],EXMEMControlLines[3],EXMEMControlLines[9],Clk,MemtoMux);
	mux hh(MEMWBALUResult,MEMWBMEMRead,MEMWBControlLines[4],FromMUXtoREG);

	mux3inputs ForwardAmux(IDEXReadData1,FromMUXtoREG,EXMEMALUResult,ForwardA,ForwardAout);
	mux3inputs ForwardBmux(IDEXReadData2,FromMUXtoREG,EXMEMALUResult,ForwardB,ForwardBout);
	mux ForwardCmux(MEMWBMEMRead,EXMEMWReadData2,ForwardC,ForwardCout);

	mux12bit stall(12'b00000000000000,ControlLines,stallMuxSelector,stallControlLines);
	


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




