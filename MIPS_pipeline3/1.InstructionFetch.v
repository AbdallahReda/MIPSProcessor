module PC(Clk,InputAddress,PCSrc,OutputAddress);
input wire Clk;
input wire [31:0]InputAddress;
input wire PCSrc;
output reg [31:0]OutputAddress;

//initial begin InputAddress<=0; end              take care
initial begin OutputAddress<=0; end           
always@(posedge Clk)
begin
if(PCSrc==1) begin OutputAddress<=(InputAddress+4); end
else begin OutputAddress <= OutputAddress + 4; end
end

endmodule 

module InstMem(Clk,PCaddress,WriteData/*From file!*/,ReadData,WriteEnable);

input wire Clk;
input wire[31:0]PCaddress ;
input wire[31:0]WriteData/*From file!*/;
output reg [31:0] ReadData;
parameter MemDepth = (2**8)-1;
reg [31:0] InstrucionMem [0:MemDepth];
input wire  WriteEnable;
integer i;

/*

00000010001101001000100000100000
00000010101100011010100000100010


*/
initial begin 	for(i=0;i<(2**8);i=i+1) begin InstrucionMem[i]<=0; end 
		//InstrucionMem[3]  <= 32'b000000_10001_10010_01000_00000_100000;//add $t0, $s0, $s1 ->t0=35
		//InstrucionMem[4]  <= 32'b000000_01000_01011_01100_00000100010;//sub $t4,$t0,$t3
		
		//InstrucionMem[5]  <= 32'b000000_01000_01000_01000_00000_100000;//add $t0, $t0,$t0 ->t0=47

		//InstrucionMem[3]  <= 32'b00000010010100111000100000100000;//add $s1, $s2, $s3
		//InstrucionMem[4]  <= 32'b00000010001101001000100000100000; //add $s1, $s1, $s4
		//InstrucionMem[5]  <= 32'b000000_10101_10001_10101_00000100010; //sub $s5, $s5, $s1
		//InstrucionMem[3] <= 32'b00000010010100111000100000100000;//add	$1, $2, $3
		//InstrucionMem[6]  <= 32'b10101110100100010000000000000000;//sw	 $4, 0($1)
		//InstrucionMem[3]  <= 32'b10001110010100010000000000000000;
		InstrucionMem[3]  <= 32'b00000010010100111000100000100000;
		InstrucionMem[4]  <= 32'b00000010101101101010000000100010;//sw $t0,0($s1) 
		InstrucionMem[5]  <= 32'b00000010000100010110100000100000;//lw $s0, 17(0)
		
		InstrucionMem[6]  <= 32'b00000001001010100100000000100000; //sw $t0,0($t0)
		



end


//always @(posedge Clk) begin if(WriteEnable) begin InstrucionMem[PCaddress>>2] <= WriteData;end end

always @(posedge Clk) begin ReadData <= InstrucionMem[PCaddress>>2];end //Read from InstMem @ negedge

endmodule

module FetchStage(Clk,WriteData,ReadData,WriteEnable,InputAddress,OutputAddress,PCSrc);
input wire Clk;
input wire [31:0]WriteData;
input wire WriteEnable;
output wire [31:0]ReadData;
input wire [31:0]InputAddress;
input wire PCSrc;
output wire [31:0]OutputAddress;
PC PC1(Clk,InputAddress,PCSrc,OutputAddress);
InstMem MyInst(Clk,OutputAddress,WriteData/*From file!*/,ReadData,WriteEnable);
endmodule

