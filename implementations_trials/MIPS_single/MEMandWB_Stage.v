module mux(input wire[31:0] input_0,input wire[31:0] input_1,input wire selector,output wire[31:0] write_data);

assign write_data= (selector==0)? input_0: (selector==1)?input_1:0;

endmodule 

module DataMemoryWithMux (Clk,MemWrite,Address,WriteData,ReadData,MemRead);
input MemWrite,Clk,MemRead;
input [31:0] Address,WriteData;
output reg [31:0] ReadData;
parameter TooBig = (2^30)-1;
reg [31:0] memory [0:TooBig];

initial begin
		memory[0]  <= -15;
		memory[1]  <= 8;
		memory[2]  <= 0;
		memory[3]  <= 0;
		memory[4]  <= 0;
		memory[5]  <= 0;
		memory[6]  <= 0;
		memory[7]  <= 0;
		memory[8]  <= 0;
		memory[9]  <= 0;
		memory[10] <= 0;
		memory[11] <= 0;
		memory[12] <= 0;
		memory[13] <= 0;
		memory[14] <= 0;
		memory[15] <= 0;
		memory[16] <= 0;
		memory[17] <= 0;
		memory[18] <= 0;
		memory[19] <= 0;
		memory[20] <= 0;
		memory[21] <= 0;
		memory[22] <= 0;
		memory[23] <= 0;
		memory[24] <= 0;
		memory[25] <= 0;
		memory[26] <= 0;
		memory[27] <= 0;
		memory[28] <= 0;
		memory[29] <= 0;
		memory[30] <= 0;
		memory[31] <= 0;
end

always @(posedge Clk) begin
  if (MemWrite == 1'b1) begin
    memory[Address] <= WriteData;
  end
end
always @(negedge Clk)begin
 if (MemRead == 1'b1) begin
    ReadData <= memory[Address];
  end
end


endmodule

module TopModule( AluResult, ReadData2, MemtoReg ,WriteDataReg,MemRead,MemWrite,Clk);
input wire  MemWrite,Clk,MemRead,MemtoReg;
input wire [31:0] AluResult;
input wire [31:0] ReadData2;
output wire [31:0] WriteDataReg;
//ha3mel wire n abwslo be read data beta3t el memory le input 1 beta3t el mux
wire [31:0] MemtoMux;
DataMemoryWithMux x(Clk,MemWrite,AluResult,ReadData2,MemtoMux,MemRead);
mux g(ALUResult,MemtoMux,MemtoReg,WriteDataReg);


endmodule



