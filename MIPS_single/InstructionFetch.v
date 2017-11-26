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
input wire[31:0]PCaddress ,WriteData/*From file!*/;
output reg [31:0] ReadData;
parameter MemDepth = (2^30)-1;
reg [31:0] InstrucionMem [0:MemDepth];
input wire  WriteEnable;

initial begin
		InstrucionMem[0]  <= 0;
		InstrucionMem[1]  <= 1;
		InstrucionMem[2]  <= 2;
		InstrucionMem[3]  <= 3;
		InstrucionMem[4]  <= 4;
		InstrucionMem[5]  <= 5;

end


always @(posedge Clk) begin if(WriteEnable) begin InstrucionMem[PCaddress>>2] <= WriteData;end end

always @(negedge Clk) begin ReadData <= InstrucionMem[PCaddress>>2];end //Read from InstMem @ negedge

endmodule

module FetchStage(Clk,WriteData,ReadData,WritEnable);
input wire Clk;
input wire [31:0]WriteData;
input wire WritEnable;
output wire [31:0]ReadData;

wire [31:0]PCaddress;
PC MyPC(Clk,PCaddress);
InstMem MyInst(Clk,PCaddress,WriteData/*From file!*/,ReadData,WriteEnable);
endmodule

