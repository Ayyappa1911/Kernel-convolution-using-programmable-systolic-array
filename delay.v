
module delay(a,b,a1,b1,clk);

parameter N = 31;

input [N:0] a,b;
input clk;
output [N:0] a1,b1;
reg [N:0] a1,b1;

//Delay block is just used as a regester to hold the a,and b for a clock cycle.
//Posedge is preferred for FPGA programming.(reason given in PE.v)

always @(negedge clk)
begin
	a1 <= a;
	b1 <= b;
end

endmodule
