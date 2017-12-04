// WE WILL REMOVE 
//1: input wire WriteEnable; ===>Removed
//2:wire [31:0]DataMEMtoReg;
//3:wire [31:0]BranchAddress;

module MIPS(Clk/*,ReadData1,ReadData2,FromMUXtoREG,ALUresult*/); //our TOP MODULE MIPS

	input wire Clk ; // Clk signal

			//Defining these signals as outputs to monitor them at TEST BENCH
	  wire [31:0]FromMUXtoREG;
	    wire [31:0]ReadData2;
	   wire [31:0]ReadData1;
	   wire [31:0]ALUresult;    //ALU output

	//wire [31:0]DataMEMtoReg;	// form data  mem to reg
	//wire [31:0]BranchAddress;

	wire [31:0]InputAddress;	//The next address of PC (whether it comes from normal addressing (PC+4) 
								// or comes from branch or jump addresses
	wire [31:0]MemtoMux;		//the ouput of data memory
	
	wire [11:0]ControlLines;	// the control lines that comes from the DECODE stage (output of control unit)
	
	wire [4:0]shamt;		//shift amount value that used in Shift instructions
	wire [31:0]ImmediateField;      // immediate field after extending it to be 32bits instead of 16bits
	
	wire zeroflag;			//this signal become true when the output of the ALU is zero
	wire overFlow;			//this signal detect whether there is an overflow in the ALU result or not 
	
	wire PCSrc;			//PCSrc signal that sent to FETCH stage to decide wether Address will be the next Address
					//Is it the branch Address ? or Jump Address ? or the normal Next Address ?

	wire [31:0]OutputAddress;	 //the output Address of the FETCH stage (the current value of PC )
	wire [31:0]ReadData;		//the instruction that comes from the FETCH stage
	wire [4:0]rt,rd,WriteReg;	//the registers addresses field of an instruction rt,rd,rs
				

					/////Defining the PIPELINE registers/////
	reg [31:0]IFIDPC;
	reg [31:0]IFIDIR; //Instruction
	reg [31:0]IDEXPC;
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
	reg EXEMEMoverflow;
	reg MEMWBoverflow;
	reg [4:0]MEMWBWriteReg;
	reg [31:0]MEMWBALUResult;
	reg [31:0]MEMWBMEMRead;
	reg [11:0]MEMWBControlLines;


					////Forwarding units and stall Detection////

	wire [1:0]ForwardA,ForwardB;//these signals used to detect data hazards
				    //these signals are mux selector to the inputs of ALU 

	wire ForwardC;	//used to detect store word hazard
	wire IDFlush;	//selector of mux to choose between flush(stall) control line (zero Control lines)
			// or normal control lines
	wire [31:0] ForwardAout,ForwardBout,ForwardCout; //these are the outputs of the muxes that selected by
							 //the previous selectors ForwardA,ForwardB,ForwardC
	wire jumpRegDetection; //Detect wether the signal is Jr or not by checking the opcode and the Fn of the fetched instruction

	wire stallDetector;//this is astall detector ,it become false when detecting a situation need to be stalled
	wire [11:0]stallControlLines;//this is the control lines that will be transfered through pipeline 
				     //it will be the normal control lines if IDFlush is 1
				     //else , the control lines will be zeroes (flush condition)
	wire [1:0]ForwardD,ForwardE;//they are mux selectors that detect the control hazards 
				    //they detect the hazards of branch and jump instructions 
	
	initial begin     //Initialize the PIPELINE registers as the simulator initialzes them with xxxx
	IFIDPC<=0;
	IFIDIR<=0; //Instruction
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
	
	initial begin  		//some monitors to view bugs or issues if found

			//$monitor(" WriteReg=%d EXEMEMWriteReg =%d,memRegWrite = %d",WriteReg,EXEMEMWriteReg ,MEMWBWriteReg);
			//$monitor("ForwardA=%d ForwardB=%d ForwardAout=%d ForwardBout=%d EXMEMALUResult=%d",ForwardA,ForwardB,ForwardAout,ForwardBout,EXMEMALUResult);
			//$monitor("%d stallSelector=%d OutputAddress=%d EXMEMALUResult=%d ALUresult=%d ForwardAout=%d ForwardBout=%d IDEXControlLines=%b ",Clk,stallDetector,OutputAddress,EXMEMALUResult,ALUresult,ForwardAout,ForwardBout,ForwardA,ForwardB,IDEXControlLines);
			//$monitor(" Clk=%d MEMWBALUResult=%d MEMWBMEMRead=%d MEMWBControlLines[4]=%d FromMUXtoREG=%d EXMEMALUResult=%d ALUresult=%d  ",Clk,MEMWBALUResult,MEMWBMEMRead,MEMWBControlLines[4],FromMUXtoREG,EXMEMALUResult,ALUresult);
			//$monitor($time,,"%d IDEXControlLines=%b IFIDIR=%x ReadData=%x stallDetector=%d OutputAddress=%d",Clk,IDEXControlLines,IFIDIR,ReadData,stallDetector,OutputAddress);
			//$monitor($time,,"%d stallDetector=%d IDEXControlLines=%b",Clk,stallDetector,IDEXControlLines);
			//$monitor($time,,"%d stallDetector=%b EXMEMControlLines[3]=%b ",Clk,stallDetector,EXMEMControlLines[3]);
			//$monitor($time,,"%d IFIDIR[31:26]=%b stallControlLines=%b EXEMEMWriteReg=%b IFIDIR[25:21]=%b IFIDIR[20:16]=%b ForwardD=%d ForwardE=%d stallDetector=%b PCSrc=%b IDFlush=%d",Clk,IFIDIR[31:26],stallControlLines,EXEMEMWriteReg,IFIDIR[25:21],IFIDIR[20:16],ForwardD,ForwardE,stallDetector,PCSrc,IDFlush);
			//$monitor($time,,"%d IFIDIR[31:26]=%b IFIDIR[25:21]=%b IFIDIR[20:16]=%b EXMEMrt=%b EXMEMrt=%b stallDetector=%b habd2=%d  EXMEMControlLines[3]=%b IFIDIR=%b",Clk,IFIDIR[31:26],IFIDIR[25:21],IFIDIR[20:16],EXMEMrt,EXMEMrt,stallDetector,habd2,EXMEMControlLines[3],IFIDIR);
			//$monitor($time,,"%d ALUresult=%d ReadData1=%d ReadData2=%d",Clk,ALUresult,ReadData1,ReadData2);
			//$monitor($time,,"%d ForwardD=%d ForwardE=%d IFIDIR[25:21]=%b IFIDIR[20:16]=%b MEMWBWriteReg=%b EXEMEMWriteReg=%b",Clk,ForwardD,ForwardE,IFIDIR[25:21],IFIDIR[20:16],MEMWBWriteReg,EXEMEMWriteReg);
			//$monitor($time,,"%d ForwardD=%d ForwardE=%d ControlLines[2]=%b jumpRegDetection=%b EXEMEMWriteReg=%b IFIDIR[25:21]=%b IDEXrd=%b stall=%b",Clk,ForwardD,ForwardE,ControlLines[2],jumpRegDetection,EXEMEMWriteReg,IFIDIR[25:21],IDEXrd,stallDetector);
			//$monitor($time,,"%d IDEXImmediate[10:6]=%b EXMEMALUResult=%d ALUresult=%d",Clk,IDEXImmediate[10:6],EXMEMALUResult,ALUresult);
		end

	always @(posedge Clk) begin  //start Writing in the PIPELINE registers @posedge of clk

							//IFID PIPLINE REGISTERS
			if(stallDetector==1) begin IFIDIR<=ReadData;  IFIDPC<=OutputAddress; end 
			if (PCSrc==1 && stallDetector==1) begin  IFIDIR<=0;  end 
		  
							//IDEX PIPLINE REGISTER
			//IDEXPC<=IFIDPC; 
			IDEXReadData1<=ReadData1; IDEXReadData2<=ReadData2;
			IDEXControlLines<=stallControlLines;
			IDEXrt<=IFIDIR[20:16];IDEXrd<=IFIDIR[15:11]; IDEXrs<=IFIDIR[25:21];
			IDEXImmediate<={{16{IFIDIR[15]}},IFIDIR[15:0]};
			
									//EXMEM PIPLINE REGISTER
			EXMEMControlLines<=IDEXControlLines;
			EXMEMALUResult<=ALUresult;
			EXMEMWReadData2<=ForwardBout;
			EXEMEMWriteReg<=WriteReg;
			EXMEMrs<=IDEXrs; EXMEMrt<=IDEXrt;
			EXEMEMoverflow<=overFlow;

									//MEMWB PIPLINE REGISTER
			MEMWBWriteReg<=EXEMEMWriteReg;
			MEMWBALUResult<=EXMEMALUResult;
			MEMWBMEMRead<=MemtoMux;
			MEMWBControlLines<=EXMEMControlLines;
			MEMWBrt<=EXMEMrt; MEMWBrs<=EXMEMrs; 
			MEMWBoverflow<=EXEMEMoverflow;
				end
	
	assign ForwardA=((EXMEMControlLines[11] == 1 ) && EXEMEMWriteReg == IDEXrs )?2'b10: //why this doesnt contain || EXMEMControlLines[9]==1???
			((MEMWBControlLines[11] == 1 && MEMWBWriteReg == IDEXrs)&& (EXEMEMWriteReg != IDEXrs || EXMEMControlLines[11] == 0))?2'b01:2'b00;
	//forwardA signal will be one if the condition of forwarding from exememaluresult to the operands of the alu in case of read after write 
	// this happens in case of that an instruction uses a value is being modified in an instruction that before the preeceding instruction
	//it is set to 2 in case of that an instruction uses a value is being modified in an instruction that just the preeceding instruction
	//this happens in case of the first operand of the alu 
	//it is set to be zero if there is no hazards so it will take the first operand as normal from the IDexc pipeline register
	assign ForwardB=( (EXMEMControlLines[11] == 1 || EXMEMControlLines[9]==1) && EXEMEMWriteReg == IDEXrt)?2'b10:
			((MEMWBControlLines[11]==1 && MEMWBWriteReg == IDEXrt) && (EXEMEMWriteReg != IDEXrt || EXMEMControlLines[11] == 0))?2'b01:2'b00;
	//the same as the ForwardA but in case of the the second operand of the alu 
	assign ForwardC=(MEMWBrt==EXMEMrt&& MEMWBControlLines[3]==EXMEMControlLines[9] && MEMWBControlLines[11]==1)?1'b0:1'b1;
	//it used in case of a sw instruction wants to store a word  in the memory and this address come from  the value is being modified in another instruction just before 
	//the sw if there is hazards this signal will set to 1 to foraward the value from the mem stage to exc stage to calcualte the address properly 
	assign stallDetector=(( (IDEXControlLines[3]== 1 ) && (IDEXrt == IFIDIR[25:21] || IDEXrt == IFIDIR[20:16])   )||
				( (ControlLines[2]||jumpRegDetection)&&((IFIDIR[20:16]==IDEXrd)||(IFIDIR[25:21]==IDEXrd)) &&IDEXControlLines[11]) )||
				(  (EXMEMControlLines[3]&&(ControlLines[2]||jumpRegDetection)) && (EXMEMrt == IFIDIR[25:21] || EXMEMrt == IFIDIR[20:16]) )
					?1'b0:1'b1;
	//stall detector signal is used to detect that there is a hazard in the lw instructions so if there is the hazards and the forward cannot be happened 
	//so stall detector is set to zero and it is used as a "id flush" to flush the controllines .if there is not hazards it is set to zero 
	// and the normal control lines is passed to idex pipeline register
	//this is used in case of lw ,jr,beq,bne instructions that needs flushing the controllines in case of the hazards is acheived  	
	assign IDFlush= (stallDetector &  ~PCSrc);
	//id flush signal is signal that come from this bolean expression and it is used as a selector to the stall mux 
	//if the id flush ws zero this measn to flush the controllines and if it was 1 it make the mus output the normal controllines 
	//this boolean expression is generated from a truth table between the pcsrs that means that the branch is acheived and the stall detector 
	// the explaination for stall detector is as explained before 
	assign ForwardD= ( (ControlLines[2]||jumpRegDetection) && (MEMWBWriteReg!=0)    && (MEMWBWriteReg  == IFIDIR[25:21]) && MEMWBControlLines[3])?2'b10:
		         ( (ControlLines[2]||jumpRegDetection) && (EXEMEMWriteReg != 0) && (EXEMEMWriteReg == IFIDIR[25:21]) && ForwardE!=2 /*&& ~MEMWBControlLines[3]*/)?2'b01:2'b00;
	//it is a signal used in the hazards with the control instructions like beq,bne,jr .
	//if there is hazard is achieved in case of r-format before the control instructions it is set to 1 to make forward from the exc stage to the decode stage
	//if there is hazard is achieved in case of lw instruction before the control instructions it is set to 2 to make forward from the mem stage to the decode stage
	// if there is no hazards the mux will output the normal outputs to the branchcompartor unit in the decode stage which is the readdata1 and readdata2
	//it the selector to the mux in the decode stage  that generates the output for the first input to the branchcompartor circuit  

	assign ForwardE=(ControlLines[2] && (MEMWBWriteReg!=0)    && (MEMWBWriteReg  == IFIDIR[20:16]) && MEMWBControlLines[3])?2'b10:
		        (ControlLines[2] && (EXEMEMWriteReg != 0) && (EXEMEMWriteReg == IFIDIR[20:16]) && ForwardD!=2 /*&&~MEMWBControlLines[3]*/)?2'b01:2'b00;
	//the same as the forwardD but for the seconf input to the branch compartor 
	FetchStage Fetch(Clk,ReadData,InputAddress,OutputAddress,PCSrc,stallDetector);//instance of the fetch stage 
	Decode Dec(Clk,IFIDIR,ControlLines,FromMUXtoREG,ReadData1,ReadData2,shamt,ImmediateField,PCSrc,InputAddress,IFIDPC,rt,rd,MEMWBWriteReg,MEMWBControlLines[11],ForwardD,ForwardE,EXMEMALUResult,MemtoMux,jumpRegDetection,MEMWBoverflow);
	//instance of the decode stage "100 hundred years of decode stage and writing comments "
	Execution Exexcution(ForwardAout,ForwardBout,IDEXControlLines[8:5],IDEXImmediate[10:6],IDEXControlLines[10],IDEXImmediate,ALUresult,zeroflag,overFlow,IDEXrd,IDEXrt,WriteReg,IDEXControlLines[0]);
	//instance of excuetion stage 
	MEMandWB MEM(EXMEMALUResult,ForwardCout,EXMEMControlLines[4],EXMEMControlLines[3],EXMEMControlLines[9],Clk,MemtoMux);
	//instance of mem stage
	mux WBresult(MEMWBALUResult,MEMWBMEMRead,MEMWBControlLines[4],FromMUXtoREG);//this mux is found @WB stage , 
									    //it decides whether the ouptut of ALU or Memory will be written																			//this is used  in case of "lw,R-Format
	mux3inputs ForwardAmux(IDEXReadData1,FromMUXtoREG,EXMEMALUResult,ForwardA,ForwardAout);//mux detect data hazards
	mux3inputs ForwardBmux(IDEXReadData2,FromMUXtoREG,EXMEMALUResult,ForwardB,ForwardBout);//mux detect data hazards
	mux ForwardCmux(MEMWBMEMRead,EXMEMWReadData2,ForwardC,ForwardCout);//mux used to detect store word instruction hazard

	mux12bit stall(12'b00000000000000,ControlLines,IDFlush,stallControlLines); //output of the mux is the normal control lines
		
		//or the fluch control lines (zero control lines)

endmodule

module MIPS_TB; //TEST BENCH of our TOP MODULE MIPS
	reg Clk;
	/*wire [31:0]ReadData1;
	wire [31:0]ReadData2;	
	wire [31:0]FromMUXtoREG;
	wire [31:0]ALUresult;*/

	MIPS MIPS1(Clk/*,ReadData1,ReadData2,FromMUXtoREG,ALUresult*/);

	
always begin #10 Clk=~Clk; end // Clk cycle is 20ns
initial begin
	Clk<=0;
	//$monitor($time,"Clk=%d ReadData1=%d ReadData2=%d FromMUXtoREG=%d ALU=%d  ControlLines=%b ",Clk,ReadData1,ReadData2,FromMUXtoREG,ALUresult,ControlLines);
	
	//#500 $finish; //finish the simulation to terminate the monitor of GUI
	end

endmodule





