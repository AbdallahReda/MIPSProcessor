//MUX
module MUX (Result,wd,MUXCtrl,WriteData);
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
//ALU 
module ALU(Result,overFlow, A,B,op,shamt,zero);
	output [31:0] Result;
	output overFlow;
	output zero;

	input [31:0] A,B;
	input [3:0] op;
	input [4:0] shamt;

	assign Result =
		(op==0) ? (A+B): /*add*/
		(op==1) ? (A-B) : /*subtract*/
		(op==2) ? (A&B) : /*and*/
		(op==3) ? (A|B) : /*or*/
		(op==4) ? (A << shamt) : /*shift left*/
		(op==5) ? (A >> shamt) : /*shift right logical*/
		(op==6) ? $signed ($signed(A) >>> shamt)  : /*shift right arithmatic*/
		(op==7) ? ($signed(A)>$signed(B) ? (1):32'b0  ) : /*check .. if A>B print 1 .. else print0*/
		(op==8) ? ($signed(A)<$signed(B) ? (1):32'b0  ) :  /*check .. if A<B print 1 .. else print0*/
		32'b0 ; 

	assign overFlow = (A[31] == B[31] && Result[31] != A[31]) ? 1 : 0;

	assign zero  = ((A-B)==0)? 1 : 0;

endmodule

module Execution(Operand1,Operand2,ALUOp,shamt,ALUSrc,ImmediateField,ALUresult,zeroflag,overFlow,rd,rt,WriteReg,RegDst);
input wire [31:0]Operand1;
input wire [31:0]Operand2;
input wire [3:0]ALUOp;
input wire [4:0]shamt;
input wire ALUSrc;
input wire [31:0]ImmediateField;
output wire [31:0]ALUresult;
input wire RegDst;
output wire zeroflag,overFlow;
input wire [4:0]rd,rt;
output wire [4:0]WriteReg;
wire [31:0]ALUoperand2;
mux5bit RegDst1(rt,rd,RegDst,WriteReg);
MUX  myMUX(ImmediateField,Operand2,ALUSrc,ALUoperand2);
ALU MyALU(ALUresult,overFlow,Operand1,ALUoperand2,ALUOp,shamt,zeroflag);



endmodule










