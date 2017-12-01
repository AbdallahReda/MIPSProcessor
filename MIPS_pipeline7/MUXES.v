/*module mux5bit(input wire[4:0] input_1,input wire[4:0] input_2,input wire selector,output wire[4:0] write_data);

assign write_data=(selector==0)? input_1:
		  (selector==1)?input_2:0;
endmodule

module mux32bit (Result,wd,MUXCtrl,WriteData);
	input[31:0] Result,wd;
	input MUXCtrl;

	output reg [31:0] WriteData;

	always @(MUXCtrl, Result, wd) begin
			case(MUXCtrl)
				0 :  WriteData<=wd;
				1 :  WriteData<= Result;
			endcase
	end

endmodule*/
/*module mux32bit(input wire[31:0] input_0,input wire[31:0] input_1,input wire selector,output wire[31:0] write_data);

assign write_data=(selector==0)? input_0:
		  (selector==1)?input_1:0;

endmodule */


module mux3inputs(input_1,input_2,input_3,selector,WriteData);

input wire[31:0] input_1,input_2,input_3;
input wire[1:0] selector;
output reg[31:0] WriteData;

always @(selector, input_1,input_2,input_3) begin
			case(selector)
				0 :  WriteData<= input_1;
				1 :  WriteData<= input_2;
				2 :  WriteData<= input_3;
				3 :  WriteData<= 0;
			endcase
	end

endmodule

module mux12bit(input_1,input_2,selector,WriteData);

input wire[11:0] input_1,input_2;
input wire selector;
output reg[11:0] WriteData;

always @(selector, input_1,input_2) begin
			case(selector)
				0 :  WriteData<= input_1;
				1 :  WriteData<= input_2;
			endcase
	end

endmodule


module mux12bit(input_1,input_2,selector,WriteData);

input wire[11:0] input_1,input_2;
input wire selector;
output reg[11:0] WriteData;

always @(selector, input_1,input_2) begin
			case(selector)
				0 :  WriteData<= input_1;
				1 :  WriteData<= input_2;
			endcase
	end

endmodule

module muxClk (Clk,Result,wd,MUXCtrl,WriteData);
	input[31:0] Result,wd;
	input MUXCtrl;
	input wire Clk;
	output reg [31:0] WriteData;

	always @(negedge Clk) begin
			case(MUXCtrl)
				0 :  WriteData<=wd;
				1 :  WriteData<= Result;
			endcase
	end

endmodule

