module PC(Clk,Address);
input Clk;
output reg [31:0]Address;
initial begin Address<=0; end
always@(posedge Clk)
begin 
Address <= Address + 4;
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

initial begin 	//000000_10001_10010_01000_00000_100000 
		InstrucionMem[0]  <= 32'b000000_10001_10010_01000_00000_100000;//add $t0, $s0, $s1 ->t0=35
		InstrucionMem[1]  <= 32'b100011_10001_01000_0000000000011100;//lw $t0, 28($s0) ->t0=47
		InstrucionMem[2]  <= 32'b000000_01000_01000_01000_00000_100000;//add $t0,$t0,$t0 ->t0=94
		InstrucionMem[3]  <= 32'b101011_01000_01000_0000000000000000; //sw $t0,0($t0) ->t0=94
		InstrucionMem[4]  <= 32'b100011_01000_10001_0000000000000000; //lw $s0,0($t0) ->s0=94
		//InstrucionMem[5]  <= 32'b000000_10001_10001_10001_00000_100000;//add $s0,$s0,$s0
		//InstrucionMem[0]  <= 32'b101011_10010_01000_0000000000000000;//sw $t0,0($s1) 
		//InstrucionMem[1]  <= 32'b100011_00000_01000_0000000000010010;//lw $s0, 17(0)
		//InstrucionMem[2]  <= 32'b000000_01000_01000_01000_00000_100000;//add $t0,$t0,$t0
		//InstrucionMem[3]  <= 32'b101011_01000_01000_0000000000000000; //sw $t0,0($t0)
		
end


//always @(posedge Clk) begin if(WriteEnable) begin InstrucionMem[PCaddress>>2] <= WriteData;end end

always @(posedge Clk) begin ReadData <= InstrucionMem[PCaddress>>2];end //Read from InstMem @ negedge

endmodule

module FetchStage(Clk,WriteData,ReadData,WriteEnable);
input wire Clk;
input wire [31:0]WriteData;
input wire WriteEnable;
output wire [31:0]ReadData;

wire [31:0]PCaddress;
PC MyPC(Clk,PCaddress);
InstMem MyInst(Clk,PCaddress,WriteData/*From file!*/,ReadData,WriteEnable);
endmodule

