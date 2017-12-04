module read(clk,data,out);
input clk;
reg [7:0]count;
input [31:0]data;
output reg [31:0] out;
reg[31:0] temp[0:1024];

initial begin count = 0; end

always@(posedge clk)
begin
temp[count] <= data;
$readmemb("bin.txt",temp);
out = temp[count];
count = count + 1;
end


endmodule 


module read_tb();
reg clk;
reg [31:0]data;
wire [31:0]out;
read myread(clk,data,out);

always
#1 clk = ~clk;

initial
begin
clk = 0;
$monitor("%b",out);

end

endmodule



