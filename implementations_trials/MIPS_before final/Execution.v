module ALU(Result,overFlow, A,B,op,shamt,zero); //ALU

	output [31:0] Result;		//Output of ALU
	output overFlow;		//overflow detection signal
	output zero;			//zero flag detection signal

	input wire[31:0] A,B;		//The two operands of ALU
	input wire[3:0] op;		//ALUOp that comes from DECODE stage
					//they are 4bits controll operations 
	input wire[4:0] shamt;		//shift amount value that used in Shift instructions

	assign Result =
		(op==0) ? (A+B): 	//ADDITION operation
		(op==1) ? (A-B) :	//SUBTRACTION operation
		(op==2) ? (A&B) : 	//BITWISE AND operation
		(op==3) ? (A|B) : 	//BITWISE OR operation
		(op==4) ? (B << shamt): //SHIFT LEFT LOGICAL
		(op==5) ? (B >> shamt): //SHIFT RIGHT LOGICAL
		(op==6) ? $signed ($signed(B) >>> shamt) : //SHIFT RIGHT ARITHMETIC
		(op==7) ? ($signed(A)>$signed(B) ? (1):32'b0  ) : //CHECK: if A>B => ALUout=1 ,else ALUout=0
		(op==8) ? ($signed(A)<$signed(B) ? (1):32'b0  ) : //CHECK: if A<B => ALUout=1 ,else ALUout=0
		(op==9) ? (B<<16): //LOAD UPPER HALF Word
		(op==10)? ~(A|B):  //NOR
		(op==11)?  (A^B):  //XOR
			32'b0 ; 

	assign overFlow = (A[31] == B[31] && Result[31] != A[31])?1:0; //Detect the overflow signal

	assign zero  = ((A-B)==0)?1:0; //Detect the zeroflag signal

endmodule

module Execution(Operand1,Operand2,ALUOp,shamt,ALUSrc,ImmediateField,ALUresult,zeroflag,overFlow,rd,rt,WriteReg,RegDst);

input wire [31:0]Operand1; //First operand of ALU
input wire [31:0]Operand2; //Second operand of ALU selected by ALUSrc mux
input wire [3:0]ALUOp;	   //ALUOp that comes from DECODE stage
input wire [4:0]shamt;	   //shift amount value that used in Shift instructions
input wire ALUSrc;	   //ControlLines[10] that comes form DECODE stage 
			   //it is a mux selector that selects between rs or rt 
			   //the output of the mux is the input of ALU

input wire [31:0]ImmediateField;// immediate field after extending it to be 32bits instead of 16bits

output wire [31:0]ALUresult; //ALU output
input wire RegDst;	    //ControlLines[0] that comes form DECODE stage 
			    //it is a mux selector that selects between rd or rt (writeReg)
			    //rd is the output in case of R-Format or rt in case of I-Format

output wire zeroflag,overFlow;//they defined as output signals to be transfered to next pipeline stages

input wire [4:0]rd,rt;
output wire [4:0]WriteReg; //Address of the register that will be write in
wire [31:0]ALUoperand2;	//Second operand of ALU selected by ALUSrc mux

mux5bit RegDst1(rt,rd,RegDst,WriteReg); //Definig an instant of mux its output contain 
					//the address of the reg that we want to write in

MUX1  myMUX(ImmediateField,Operand2,ALUSrc,ALUoperand2); //Definig an instant of mux its output contain 
							//the second operand of ALU

ALU MyALU(ALUresult,overFlow,Operand1,ALUoperand2,ALUOp,shamt,zeroflag);//Define an instant of ALU module

endmodule











