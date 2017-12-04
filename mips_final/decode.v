module RegisterFile(Clk, WriteEnb, ReadReg1, ReadReg2, WriteReg, ReadData1, ReadData2, WriteData,opcode,jalAddress,raReturnAddress,MEMWBoverflow);

	input [4:0] ReadReg1; //Address of first regfile operand
	input [4:0] ReadReg2; //Address of second regfile operand
	input [4:0] WriteReg; //Address of reg that we want to write in (in case of lw,R-Format instructions)
	input [31:0] WriteData; //Data to be written in (in case of lw,R-Format instructions)
	input wire WriteEnb ;	//Write enable signal of  Regfile 
	input wire Clk;		//Clk signal

	output reg [31:0] ReadData1; //First output of regfile
	output reg [31:0]ReadData2; //Second output of regfile
	reg [31:0] Registers [0:31]; //Regfile definition 32 registers with width one WORD
	
	input wire [31:0]jalAddress;//Address to be written in case of "jal" instruction
	input wire [5:0]opcode;	//opcode signal to check that the instruction is "jal"
	input wire [4:0]raReturnAddress; // this wire contain a constant (31) to refer to Register[$ra]
					// which contain jump address 						

	input wire MEMWBoverflow; // to Check the overflow of ALU , if overflow==1 then DONT wirte in the regfile
	
		/////Parameters definition of Registers names
	parameter [4:0] zero=5'h0,at=5'h1,v0=5'h2,v1=5'h3,a0=5'h4,a1=5'h5,a2=5'h6,a3=5'h7,
			t0=5'h8,t1=5'h9,t2=5'ha,t3=5'hb,t4=5'hc,t5=5'hd,t6=5'he,t7=5'hf,
			s0=5'h10,s1=5'h11,s2=5'h12,s3=5'h13,s4=5'h14,s5=5'h15,s6=5'h16,s7=5'h17,
			t8=5'h18,t9=5'h19,k0=5'h1a,k1=5'h1b,gp=5'h1c,sp=5'h1d,fp=5'h1e,ra=5'h1f;


initial begin      //initialize the Regfile automatically from a txt file or manually 

	//$readmemh("regs.txt", Registers); //Incase if you would to fill regfile form outside txt file

		Registers[zero]<= 0; //Incase if you would to fill regfile manually
		Registers[at]  <= 0; 
		Registers[v0]  <= 32'h00000002;
		Registers[v1]  <= 32'h00000004;
		Registers[a0]  <= 32'h00000500;
		Registers[a1]  <= 32'h00000070;
		Registers[a2]  <= 32'h00000008;
		Registers[a3]  <= 32'h00000060;
		Registers[t0]  <= 12;
		Registers[t1]  <= 10;
		Registers[t2]  <= 30;
		Registers[t3]  <= 70;
		Registers[t4]  <= 6;
		Registers[t5]  <= 100;
		Registers[t6]  <= 32'h00000090;
		Registers[t7]  <= 32'h00000000;
		Registers[s0]  <= 32'h00000005;
		Registers[s1]  <= 17;
		Registers[s2]  <= 18; 
		Registers[s3]  <= 17; 
		Registers[s4]  <= 32'h00000005;
		Registers[s5]  <= 40; 
		Registers[s6]  <= 0; 
		Registers[s7]  <= 45;
		Registers[t8]  <= 14; 
		Registers[t9]  <= 32'h00000000;
		Registers[k0]  <= 32'h00000000;
		Registers[k1]  <= 32'h00000000;
		Registers[gp]  <= 32'h00000000;
		Registers[sp]  <= 32'h00000000;
		Registers[fp]  <= 32'h00000000;
		Registers[ra]  <= 0;
end

always@(posedge Clk) begin //to wirte the address of "jal" instruction , we check that it "jal" form opcode
		if(opcode==3)begin Registers[raReturnAddress]<=jalAddress+4; end
end

always @(*) // whenever Addresses of Registers changes , we change the ReadData
begin
ReadData1<=Registers[ReadReg1];
ReadData2<=Registers[ReadReg2];
end

always @(negedge Clk) // We take advantage of writing @negedge to write the Result of (lw,R-Format instruction) 
		      // and make this  result available for any instruction need to decode after them 
begin
if(WriteEnb && WriteReg!=0 && WriteReg!=31 && ~MEMWBoverflow) 
//we dont need to write in Reg[$zero] Register as standards of MIPS 
//we also dont need to wirte Reg[$ra] as we write in it @posedge and when the instruction is "jal"
//we also dont need to write in Regfile when the value is overflowed so we add ~MEMWBoverflow	
begin	
Registers[WriteReg]<=WriteData;	end
end

endmodule

module ControlUnit(Fn,Opcode,ControlLines,Instruction); //Control Unit module inputs instruction,Fn,Opcode 
input wire [31:0] Instruction; //Instruction is input as we check the instruction change and as aresult of 
			       // check operation we decide that the control lines must to change or not 
input wire [5:0] Fn;//We check the function of R-Format instruction
input wire [5:0] Opcode;//We chech the opcode of all instructions and decide wether it R-Format,I-Fromat or J-Fomrat

output reg [11:0]ControlLines; //Control lines are 12bits not as standard because we increase 
			       //the ALUOp bit from 2bits to 4bits to cancel the ALUControlUnit in the EXE stage
			       //so we send the ALUOp to the ALU directly and it decides the operation should do  

				//Our ControlLines 
//RegDst    =ControlLines[0]; //Jump      =ControlLines[1];
//Branch    =ControlLines[2]; //MemRead   =ControlLines[3];
//MemtoReg  =ControlLines[4];
//ALUOp[3:0]={ControlLines[8],ControlLines[7],ControlLines[6],ControlLines[5]}; We make ALUOp 4bits as we explained 
//MemWrite  =ControlLines[9]; //ALUSrc    =ControlLines[10];
//RegWrite  =ControlLines[11]; 

	
always@(Instruction or Opcode or Fn)//Enter this block @ each instruction change
	begin
		case(Opcode)	
			0:  	//R-FORMAT supported instructions 	
				if(Fn==32) begin ControlLines<=12'b100_0000_00001; end//ADD
				else if(Fn==36) begin ControlLines<=12'b100_0010_00001; end//AND
				else if(Fn==34) begin ControlLines<=12'b100_0001_00001;	end//SUB
				else if(Fn==37) begin ControlLines<=12'b100_0011_00001;	end//OR
				else if(Fn==0)  begin ControlLines<=12'b100_0100_00001;	end//SLL
				else if(Fn==42) begin ControlLines<=12'b100_1000_00001;	end//SLT
				else if(Fn==2)  begin ControlLines<=12'b100_0101_00001;	end//SRL
				else if(Fn==3)  begin ControlLines<=12'b100_0110_00001;	end//SRA 
				else if(Fn==8)	begin ControlLines<=12'b000_0000_00010;	end//Jr
				else if(Fn==39)	begin ControlLines<=12'b100_1010_00001;	end//NOR
				else if(Fn==38)	begin ControlLines<=12'b100_1011_00001;	end//XOR
						
				//I-Format supported instructions 						
			4:  ControlLines<=12'b000_0001_00100; //BEQ
			5:  ControlLines<=12'b000_0001_00100; //BNE
			35: ControlLines<=12'b110_0000_11000; //LW
			43: ControlLines<=12'b011_0000_00000; //SW
			8:  ControlLines<=12'b110_0000_00000; //ADDI
			12: ControlLines<=12'b110_0010_00000; //ANDI
			13: ControlLines<=12'b110_0011_00000; //ORI
			10: ControlLines<=12'b110_1000_00000; //SLTI
			15: ControlLines<=12'b110_1001_00000; //LUI
			14: ControlLines<=12'b110_1011_00000; //XORI

				//J-Format supported instructions 	
			2:  ControlLines<=12'b000_0000_00010; //J
			3:  ControlLines<=12'b000_0000_00010; //JAL
			
		endcase
end
endmodule

 
module Decode(Clk,Instruction,ControlLines,DataMEMtoReg,ReadData1,ReadData2,shamt,ImmediateField,PCSrc,NextAddress,InputAddress,rt,rd,WriteReg,WriteRegEnable,ForwardD,ForwardE,EXMEMALUResult,MemtoMux,jumpRegDetection,MEMWBoverflow);
//this is the Topmodule for the DECODE stage  

input wire Clk; //Clk signal
input wire [31:0]Instruction; //Instruction that comes from FETCH stage 
input wire [31:0]DataMEMtoReg; //Result that comes from WB stage (wether from ALU or DataMemory 
			       //it is determined by the MemtoReg control signal
output wire [11:0]ControlLines; //Controls lines that comes from ControlUnit
output wire [31:0]ReadData1; //First output of regfile
output wire [31:0]ReadData2; //Second output of regfile
output wire [4:0]shamt;	     //shift amount value that used in Shift instructions
output wire [31:0]ImmediateField;//ImmediateField of the instruction (it comes form Instruction[16:0])
				//but we Extend it to 32bits using Concatenation
output wire PCSrc; //PCSrc signal that sent to FETCH stage to decide wether Address will be the next Address
		  //Is it the branch Address ? or Jump Address ? or the normal Next Address ?

output wire [4:0]rt,rd; //These are the Addresses of destsination registers , rd in case if R-Format or rt in case of I-Format 
			//These addresses are sent to EXE stage and to decide wether RegAddress that would write
	 
input wire [4:0]WriteReg;//Address of reg that we want to write in (in case of lw,R-Format instructions)
input wire [31:0]MemtoMux;//Forwarding from MEM stage used in case of dependet (lw,beq,bne,j) instructions			
input wire WriteRegEnable;//Enable signal that comes from WB pipeline reg and allows the Regfile to write 
input wire MEMWBoverflow;//Overflow signal that comes from WB pipeline reg to check the overflow of ALU
input wire [31:0]InputAddress;//its the PC Address the comes form FETCH stage and used to calculate the 
				//Jump Addresss or Branch address  
input wire [1:0]ForwardD,ForwardE;//Mux Selectors responsible for forwarding Data from EXEMEM stage or MEMWB stage
				//0: pass the output of regfile , 1:pass the EXEMEMALUresult
				//2: pass the MEMWBALUresult 
input wire[31:0]EXMEMALUResult;//ALUresult that comes form EXEMEM pipeline reg 
output wire [31:0] NextAddress;//Address that will be sent to FETCH stage , it may be the branch address
				//or Jump address , or the ordinary address (PC+4)
output wire jumpRegDetection;//Detection signal that detects if the instruction is "Jr" or not  
				//it sent to FETCH stage to pass the address contained in the reg
				//it also sent to MIPS module to use it in stall and forwarding conditions 
wire [4:0]raReturnAddress;//this is a5bit address that is defined to hold 31 (the $ra register address)
			  //we used it in "Jal" instructions that write the current address in Reg $ra
assign raReturnAddress=31;//the 31 number is just the address of $ra Register that hold current address of "jal"

wire [31:0]BranchAddress;//a 32bit wire that is defined to hold the branch address 

wire BranchComparator;//the ouptut of comparison between the two operands of "Beq" instructions
wire bneComparator;//the ouptut of comparison between the two operands of "Bne" instructions
wire [31:0]BranchComparatorInput1,BranchComparatorInput2;//the two operands of "Beq,Bne" instructions

wire [31:0] jumpAddress;//a 32bit wire that is defined to hold the jump address 
wire [31:0]jumpRegAddress;//a 32bit wire that is defined to hold the "jr" address 


assign rt=Instruction[20:16];//These are the Addresses of destsination registers ,
assign rd=Instruction[15:11];//rd in case if R-Format or rt in case of I-Format

assign BranchComparator=(BranchComparatorInput1==BranchComparatorInput2)?1'b1:1'b0;//the output is 1 if the condtion of beq is true
assign bneComparator=(BranchComparatorInput1!=BranchComparatorInput2)?1'b1:1'b0;//the output is 1 if the condtion of bne is true

assign PCSrc = (((BranchComparator||bneComparator) & ControlLines[2])||ControlLines[1]);
		//this signal set to 1 if the instructions are jump "j,jal,jr" 
		// it also set to 1 if the instructions are branch "beq,bne" when
		// the condititons of this instructions become TRUE

assign BranchAddress=(InputAddress)+(ImmediateField<<2);
		//Calculating the Branch adddress by adding the current address (PC) to the immediate offset 16bits
		//after shifting it left by 2 (Multiply the offset by 4)

//assign shamt=Instruction[10:6]; //shift amount value that used in Shift instructions
	
assign ImmediateField={ {16{Instruction[15]}}, Instruction[15:0] };
		//Sign extend the immediate field to be 32bits instead of 16bits

assign jumpAddress={ {InputAddress[31:28]},{Instruction[25:0]<<2}}; //asebha zai ma hya ? walla an2s 4???
		//Calculating the jump adddress by adding the most sig bits of current address (PC)
		 //to the immediate offset 26bits  after shifting it left by 2 (Multiply the offset by 4)

assign jumpRegDetection=(Instruction[5:0]==8 && Instruction[31:26]==0)?1'b1:1'b0;
		//Detect wether the signal is Jr or not by checking the opcode and the Fn of the fetched instruction

assign jumpRegAddress=jumpRegDetection?BranchComparatorInput1:jumpAddress;
		//Detetrmine wether to take the jump address from the forwarding unit in case of hazard
		//or calculating it from PC as normal

ControlUnit CU(Instruction[5:0],Instruction[31:26],ControlLines,Instruction);//definig an instant of Control unit

RegisterFile RegFile(Clk,WriteRegEnable,Instruction[25:21],Instruction[20:16],WriteReg,ReadData1,ReadData2,DataMEMtoReg,Instruction[31:26],InputAddress,raReturnAddress,MEMWBoverflow); //definig an instant of Regfile 

mux3inputs beqForwardD(ReadData1,EXMEMALUResult,MemtoMux,ForwardD,BranchComparatorInput1);
	//for the instructions that have Read after write dependencies,we explain the selector states before

mux3inputs beqForwardE(ReadData2,EXMEMALUResult,MemtoMux,ForwardE,BranchComparatorInput2);
	//like the previous mux but for the second operand of camparison

mux2inputs jumpMux(BranchAddress,jumpRegAddress,ControlLines[1],NextAddress);
	//mux used to send the branch address or jumpreg address to the FETCH stage 

//some monitors to trace bugs and issues if found
//initial begin $monitor($time,,"%d ForwardD=%d ForwardE=%d BranchComparatorInput1=%d BranchComparatorInput2=%d BranchComparator=%d MemtoMux=%d PCSrc=%d Instruction=%b jumpAddress=%d jumpRegAddress=%d",Clk,ForwardD,ForwardE,BranchComparatorInput1,BranchComparatorInput2,BranchComparator,MemtoMux,PCSrc,Instruction,jumpAddress); end
//initial begin $monitor($time,,"%d  jumpRegDetection=%b PCSrc=%d ForwardD=%d ForwardE=%d jumpAddress=%d jumpRegAddress=%d Instruction[10:6]=%b",Clk,jumpRegDetection,PCSrc,ForwardD,ForwardE,jumpAddress,jumpRegAddress,Instruction[10:6]); end

endmodule

