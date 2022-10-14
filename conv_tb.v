
`timescale 10ns/1ps

module conv_tb();

parameter n = 3;
parameter img = 256+(n-1);

reg clk;

reg [6:0] flg;

integer i;

conv uut(.clk(clk),
         .flg(flg)
         );

initial begin

    clk = 0;
    flg = 0;
    #10;
    clk = ~clk;
    #10;
    clk = ~clk;
    // for(i = 0; i < 256*256*100; i = i + 1) begin
    //     #10;
    //     clk = ~clk;
    //     #10;
    //     clk = ~clk;
    // end

    for(i = 0; i < ((img-(n-1))*(img-(n-1)) * 3*n ); i = i + 1) begin
        if(flg == 3*n) begin
            flg = 0;
        end
        #10;
        clk = ~clk;
        #10;
        clk = ~clk;
        flg = flg + 1;
    end

end


endmodule