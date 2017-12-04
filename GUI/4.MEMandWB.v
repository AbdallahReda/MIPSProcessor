module DataMemory(Clk,MemWrite,Address,WriteData,ReadData,MemRead);

input wire Clk; 		// Clk signal
input MemWrite,MemRead;		//Write and Read enable signals
input [31:0] Address;		//Address of the data that needed to be read from Data Memory
input [31:0]WriteData;		//Data that will be written inside the Data Memory
output reg [31:0] ReadData; 	//the output of data memory
parameter MemDepth = (2**8)-1;  //the depth of data memory ,here it will be 256
reg [31:0] Memory [0:MemDepth]; //the width of data memory , here it will be 32

integer i;
initial begin 		
		$readmemh("data_mem.txt",Memory); //Incase if you would to fill data memory form outside txt file

		/*for(i=0;i<(2**8);i=i+1) begin Memory[i]<=0; end //initializing the Data memory with zeroes
		
		Memory[0]  <= 15;	//Incase if you would to fill data memory manually
		Memory[1]  <= 8;
		Memory[2]  <= 0;
		Memory[3]  <= 0;
		Memory[4]  <= 0;
		Memory[5]  <= 5;
		Memory[6]  <= 0;
		Memory[7]  <= 0;
		Memory[8]  <= 0;
		Memory[9]  <= 0;
		Memory[10] <= 10;
		Memory[11] <= 0;
		Memory[12] <= 0;
		Memory[13] <= 0;
		Memory[14] <= 76;
		Memory[15] <= 12;
		Memory[16] <= 0;
		Memory[17] <= 35;
		Memory[18] <= 44;
		Memory[19] <= 0;
		Memory[20] <= 20;
		Memory[21] <= 0;
		Memory[22] <= 0;
		Memory[23] <= 1;
		Memory[24] <= 0;
		Memory[25] <= 0;
		Memory[26] <= 26;
		Memory[27] <= 0;
		Memory[35] <= 77;
		Memory[29] <= 0;
		Memory[44] <= 0;
		Memory[45] <= 47;
		Memory[46] <= 50;
		Memory[246] <= 250;*/
end


always @(negedge Clk) begin //Reading and writing will be done @negedge of clk

if (MemWrite == 1) begin // if Write is enabled , enter this block
    Memory[Address] <= WriteData;
end

// Use memread to indicate a valid address is on the line and read the memory into a register at that address when memread is asserted
if (MemRead == 1) begin // if Read is enabled , enter this block
    ReadData <= Memory[Address];
end
end

endmodule



module MEMandWB( AlUResult, DataMemoryWriteData, MemtoReg ,MemRead,MemWrite,Clk,MemtoMux); //TopModule of MEM stage

input wire  MemWrite,Clk,MemRead,MemtoReg; //Control signals of DataMemory and Clk signal
input wire [31:0] AlUResult; //Alu output 
input wire [31:0] DataMemoryWriteData; //Data to be Written in the Data memory
output wire [31:0] MemtoMux; //Read data comes form Data memory

DataMemory DatMEM(Clk,MemWrite,AlUResult,DataMemoryWriteData,MemtoMux,MemRead);//Define an instant of DataMemory module

endmodule




