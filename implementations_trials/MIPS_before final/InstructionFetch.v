module PC(Clk,InputAddress,PCSrc,OutputAddress,stallDetector);
input wire Clk; //Clk signal
input wire [31:0]InputAddress;  //The address that comes from DECODE stage
input wire PCSrc; 		//PCSrc signal that comes form DECODE stage
				//This signal decides whether the next PC address will be
				//the normal PC address , branch address or jump address
				//this done by using the PCSrc as a selector of mux its inputs
				//the jump/branch address or the normal address
				//in this code i didnt define a real mux module to do this
				//i just put a condition that act like a mux 
				//you will find it and understand it in the DECODE file

output reg [31:0]OutputAddress; //The nex PC address it may be the normal address (PC+4)
				//May be a jump address or branch address
input wire stallDetector;	//stall Detector signal that comes from MIPS TOPMODULE

initial begin OutputAddress<=0; end //Initialize the output address to be 0 as simualtor intializes it with xxxxx   
         
always@(posedge Clk) //@ every posedge of Clk cycle we get anew PC address 
begin
if(PCSrc==1) begin OutputAddress<=(InputAddress+4); end //if PCSrc==1 means that i have a branch or jump
							//so the new PC will be the address of branching or jumping added to 4

else if(stallDetector==0) begin OutputAddress <= (OutputAddress); end
						//stall Detector=0 when it faces a stall situation
						//in stall in need to Prevent update of PC and IF/ID register
						//so the output address of PC still same 

else begin OutputAddress <= OutputAddress + 4; end //normal condition as the instructions are executed smoothly
						   //increase the current address by 4
end 

endmodule 

module InstMem(Clk,PCaddress,ReadData); //Instruction memory module

input wire Clk;  //Clk signal
input wire[31:0]PCaddress ; //the address that we want to read from Instruction Memory
output reg [31:0] ReadData; // the output data of instruction memory (the Instruction) 
parameter MemDepth = (2**8)-1; //the depth of instruction memory ,here it will be 256
reg [31:0] InstructionMem [0:MemDepth];//the width of instruction memory , here it will be 32

integer i;

initial begin 	
		//$readmemh("test.txt", InstructionMem); //Incase if you would to fill data instruction form outside txt file
		

		//for(i=0;i<(2**8);i=i+1) begin InstructionMem[i]<=0; end //initializing the instruction memory with zeroes
		
						///////////SAMPLE of TEST CASES///////////

		  /*InstructionMem[0]  <= 32'b10001110011100010000000000010100; //lw $s1, 20($s3)
		  InstructionMem[1]  <= 32'b10001110001010000000000000000000; //lw $t0, 0($s1) 
		  InstructionMem[2]  <= 32'b10001101000100100000000000000000; //lw $s2, 0($t0)*/ 
		
                  /*InstructionMem[0] <= 32'b100011_10000_010010000000000000000;   //lw $t1, 0($s0)
                  InstructionMem[1] <= 32'b000000_01001_10011_01010_00000100000;  //add $t2,$t1,$s3
                  InstructionMem[2] <= 32'b00010001001010100000000000000001;   //beq $t1,$t2,label
                  InstructionMem[3] <= 32'b00000010011100111000100000100000;   //add $s1,$s3,$s3
                  InstructionMem[4] <= 32'b00000010010100111000100000100000;   //label: add $s1,$s2,$s3*/
           
                  /*InstructionMem[0] <= 32'b100011_10000_01001_0000000000000000;   //lw $t1, 0($s0)
                  InstructionMem[1] <= 32'b100011_10000_01010_0000000000000000;   //lw $t2, 0($s0)
                  InstructionMem[2] <= 32'b000100_01001_01010_0000000000001010;   //beq $t1,$t2,label
                  InstructionMem[3] <= 32'b000000_10011_10011_10010_00000100000;   //add $s2,$s3,$s3
                  InstructionMem[13] <= 32'b000000_01001_01010_10001_00000100000;   //label: add $s1,$t1,$t2*/
                 

                  /*InstructionMem[0] <= 32'b100011_10000_01001_0000000000000000;   //lw $t1, 0($s0)
                  InstructionMem[1] <= 32'b101011_01010_01001_0000000000000000;   //sw $t1, 0($t2)
                  InstructionMem[2] <= 32'b100011_01010_01100_0000000000000000;   //lw $t4, 0($t2)
                  InstructionMem[3] <= 32'b000100_01001_01100_0000000000000001;   //beq $t1,$t4,label
                  InstructionMem[4] <= 32'b00000010011100111000100000100000;   //add $s1,$s3,$s3
                  InstructionMem[5] <= 32'b00000010010100111000100000100000;   //label: add $s1,$s2,$s3*/

		 /* InstructionMem[0] <= 32'b00000010010100111000100000100000;   //add $s1,$s2,$s3
                  InstructionMem[1] <= 32'b00000010100101011001100000100000;   //add $s3,$s4,$s5
                  InstructionMem[2] <= 32'b00000001001010100100000000100000;   //add $t0,$t1,$t2
                  InstructionMem[3] <= 32'b00010010001100100000000000001010;   //beq $s1,$s2,Loop
                  InstructionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  InstructionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstructionMem[14]<= 32'b00000001000010100100000000100000;  //Loop: add $t0,$t0,$t2*/

		/* InstructionMem[0] <= 32'b00000010100101011001000000100000;   //add $s2,$s4,$s5
                  InstructionMem[1] <= 32'b00000010010101101000100000100000;   //add $s1,$s2,$6
                  InstructionMem[2] <= 32'b00000001001010100100000000100000;   //add add $t0,$t1,$t2
                 InstructionMem[3] <= 32'b00010010001100100000000000001010;   //beq $s1,$s2,Loop
                  //InstructionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  //InstructionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstructionMem[14]<= 32'b00000001000010100100000000100000;  //Loop: add $t0,$t0,$t2*/

		/*InstructionMem[0] <= 32'b00000010100101011001000000100000;   //add $s2,$s4,$s5
		 InstructionMem[1] <= 32'b00000001001010100100000000100000;   //add $t0,$t1,$t2
                  InstructionMem[2] <= 32'b00000010010101101000100000100000;   //add $s1,$s2,$6
                 
                  InstructionMem[3] <= 32'b000100_10001_01000_0000000000001010;   //beq $s1,$t0,Loop
                  InstructionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  InstructionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstructionMem[14]<= 32'b00000001000010100100000000100000;  //Loop: add $t0,$t0,$t2*/

		  /*InstructionMem[0] <= 32'b10001110011100010000000000010100;   //lw $s1, 20($s3)
               InstructionMem[1] <= 32'b10001110001010000000000000000000;   //lw $t0,0($s1)
                  InstructionMem[2] <= 32'b10001101000100100000000000000000;   //lw $s2,0($t0)
                  InstructionMem[3] <= 32'b00000010010100011000000000100000;   //add $s0,$s2,$s1
                  //InstructionMem[4] <= 32'b00000000000000000000000000000000;   //nop*/

		/*  InstructionMem[0] <= 32'b00000010001100101000000000100000;   //add $s0,$s1,$s2
                  InstructionMem[1] <= 32'b00000010000100000100000000100000;   //add $t0,$s0,$s0
                  InstructionMem[2] <= 32'b00000001000100000100100000100000;   //add $t1,$t0,$s0
		  InstructionMem[3] <= 32'b10001110000010100000000000000000;   //lw $t2,0($s0)*/

		 /* InstructionMem[0] <= 32'b00000010100101011001000000100000;   //add $s2,$s4,$s5
                  InstructionMem[1] <= 32'b00000010010101101000100000100000;   //add $s1,$s2,$6
                  //InstructionMem[2] <= 32'b00000010010101101001100000100000;   //add $s3,$s2,$s6
                 // InstructionMem[2] <= 32'b000100_10001_10010_0000_0000_0000_1010;   //beq $s1,$s2,Loop
                  //InstructionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  //InstructionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		//  InstructionMem[13]<= 32'b00000001000010100100000000100000;  //Loop: add $t0,$t0,$t2*/

		/* InstructionMem[1] <= 32'b00000010001100101000000000100000;   //add $s0,$s1,$s2
		 InstructionMem[2] <= 32'b10001110001010010000000000000000;   //lw $t1,0($s1)
                InstructionMem[3] <= 32'b00010001001010100000000000001011;   //beq $t1,$t2, Label
                 //InstructionMem[5] <= 32'b00000000000000000000000000000000;   //nop
                //  InstructionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  //InstructionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstructionMem[15]<= 32'b00000010000100101000000000100000;  //Label: add $s0,$s0,$s2*/

 		 /*InstructionMem[0] <= 32'b00000010100101011001000000100000;   //add $s2,$s4,$s5
                  InstructionMem[1] <= 32'b000000_10010_10110_1000100000100000;   //add $s1,$s2,$6
                  InstructionMem[2] <= 32'b000000_10010_10110_10011_00000100000;   //add $s3,$s2,$s6
                  InstructionMem[3] <= 32'b000100_10001_10011_0000000000001010;   //beq $s1,$s3,Loop
                  InstructionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  InstructionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstructionMem[14]<= 32'b00000001000010100100000000100000;  //Loop: add $t0,$t0,$t2*/

             	/* InstructionMem[0]<= 32'b00100010001100000000000000001010;  //addi $s0,$s1,10
		 InstructionMem[1]<= 32'b00100010000100100000000000010100;  //addi $s2,$s0,20*/

		  /*InstructionMem[0] <= 32'b10001110001010010000000000000000;   //lw $t1,0($s1)
		  InstructionMem[1] <= 32'b00000010001100100101000000100000;   //add $t2,$s1,$s2
                  InstructionMem[2] <= 32'b00010001001010100000000000001011;   //beq $t1,$t2, Label
                  InstructionMem[3] <= 32'b000000_10010_10110_10011_00000100000;   //add $s3,$s2,$s6
                //  InstructionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  //InstructionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstructionMem[14]<= 32'b00000010000100101000000000100000;  //Label: add $s0,$s0,$s2*/

		 /*InstructionMem[1]<= 32'b000011_00000000000000000000010011;  //jal L
		 InstructionMem[20]<=32'b000000_10001_10010_10000_00000100000;  //add $s0,$s1,$s2 de 3awza 200ns leh?*/

		/*InstructionMem[1]<= 32'b00000001011011000110100000100000;  //add $t5,$t3,$t4
		 InstructionMem[2]<=32'b00000001101000000000000000001000;  //jr $t5
		 InstructionMem[3]<=32'b00000010001100100101000000100000;   //add $t2,$s1,$s2
		InstructionMem[20]<=32'b00000010001100101000000000100000;  //add $s0,$s1,$s2  // de 3awza 180ns*/

		/*InstructionMem[1]<= 32'b10001111000011010000000000000000;  //lw $t5,0($t8)
		 InstructionMem[2]<=32'b00000001101000000000000000001000;  //jr $t5
		 InstructionMem[3]<=32'b00000010001100100101000000100000;   //add $t2,$s1,$s2
		InstructionMem[20]<=32'b00000010001100101000000000100000;  //add $s0,$s1,$s2  // de 3awza 200ns*/

		//InstructionMem[1]<= 32'b00111100000100000000000000110010; //lui $s0,50

		//InstructionMem[1]<= 32'b00000010011100101000100000_101010; //sgt $s1,$s2,$s3 NOT Suported

		//InstructionMem[1]<= 32'b00000000000010100100101010000000;

		//InstructionMem[1]<= 32'b00100001000010000000000000000001;//addi $t0,$t0,1 overflow detection

		 /* InstructionMem[0] <= 32'b00000010001100101001100000100000;   //add $s3,$s1,$s2
		  InstructionMem[1] <= 32'b00000010001100111000100000100000;   //add $s1,$s1,$s3
                  InstructionMem[2] <= 32'b00010110001100000000000000001011;   //bne $s1,$s0,Label
                  InstructionMem[3] <= 32'b000000_10010_10110_10011_00000100000;   //add $s3,$s2,$s6
                //  InstructionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  //InstructionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstructionMem[14]<= 32'b10001110010010000000000000000000;  //Label:lw $t0,0($s2)*/


end


initial begin ReadData<=0; end//Initialize the ReadData (the instruction) to be 0 as simualtor intializes it with xxxxx   
         
always @(negedge Clk) begin ReadData <= InstructionMem[PCaddress>>2];end //Read from InstMem @ negedge
									 //each cycle the output is a new instruction 
									 //or the same instruction in case of stalling

endmodule

module FetchStage(Clk,ReadData,InputAddress,OutputAddress,PCSrc,stallDetector);//Top Module of Fetch stage

input wire Clk; //Clk signal

output wire [31:0]ReadData;//instruction readed

input wire [31:0]InputAddress;//the input address of the PC module (the new address that i will branch or jump in case they are found )

input wire PCSrc;	//PCSrc signal that comes form DECODE stage, its explained before

output wire [31:0]OutputAddress; //the output address of PC module (the current PC address)

input wire stallDetector; //stall Detector signal that comes from MIPS TOPMODULE , its explained there

PC PC1(Clk,InputAddress,PCSrc,OutputAddress,stallDetector);//definig an instant of PC module

InstMem MyInst(Clk,OutputAddress,ReadData);//definig an instant of Instruction memory module
endmodule


