

//Implementation of the processing element

module PE(a,b,c,a1,b1,out,clk);

parameter N = 31;

input [N:0] a,b,c; 
output  [N:0] a1,b1;
input clk;

output [N:0] out;
reg [N:0] a1,b1;
reg [N:0] out;

function automatic [N:0] func(input [N:0] a,b,c);
    begin
        func = c+a*b;
    end
endfunction

// For this model the functionality of the PE is not changed with the change in data type.
// a, b is passed through PE as a regester and another output c+a*b is calculated for each clock cycle.

//For programming it on FPGA. It is preferred to use posedge clock as the FPGA has only either posedge clock triggered Flipflops or negedge triggered Flipflops.
// If clock is used while synthesis in FPGA IT cannot allocate any FLIPFlops to the PE's and data flow in the systolic array observed is not same as expected.  

always @(negedge clk)
begin
	a1 <= a;
	b1 <= b;
    out <= func(a,b,c);
end

endmodule
