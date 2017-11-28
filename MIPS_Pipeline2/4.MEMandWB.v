module mux(input wire[31:0] input_0,input wire[31:0] input_1,input wire selector,output wire[31:0] write_data);

assign write_data=(selector==0)? input_0:
		  (selector==1)?input_1:0;

endmodule 

module DataMemoryWithMux (Clk,MemWrite,Address,WriteData,ReadData,MemRead);
input MemWrite,Clk,MemRead;
input [31:0] Address;
input [31:0]WriteData;
output reg [31:0] ReadData;
parameter MemDepth = (2**8)-1;
reg [31:0] memory [0:MemDepth];

initial begin
		memory[0]  <= 15;
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
		memory[35] <= 77;
		memory[29] <= 0;
		memory[44] <= 0;
		memory[45] <= 47;
		memory[46] <= 50;
		memory[246] <= 250;
end


always @(negedge Clk) begin
  if (MemWrite == 1'b1) begin
    memory[Address] <= WriteData;
  end
  // Use memread to indicate a valid address is on the line and read the memory into a register at that address when memread is asserted
  if (MemRead == 1'b1) begin
    ReadData <= memory[Address];
  end
end

endmodule



module MEMandWB( AlUResult, ReadData2, MemtoReg ,MemRead,MemWrite,Clk,MemtoMux);
input wire  MemWrite,Clk,MemRead,MemtoReg;
input wire [31:0] AlUResult;
input wire [31:0] ReadData2;

output wire [31:0] MemtoMux;

DataMemoryWithMux x(Clk,MemWrite,AlUResult,ReadData2,MemtoMux,MemRead);

endmodule



