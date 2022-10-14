
module sysarray(clk,flg,arr1,arr2,dpin);

parameter N = 31;
parameter n = 3;
parameter odr = 2*n-1;

input clk;
input [6:0] flg;
// input [N:0]arr1[n-1:0];
// input [N:0]arr2[n-1:0];
input [((N+1)*(n))-1 :0]arr1;
input [((N+1)*(n))-1 :0]arr2;

reg [N:0]A[odr-1:0][odr:0];
reg [N:0]B[odr:0][odr-1:0];
reg [N:0]C[odr:0][odr:0];

wire [N:0]A1[odr:0][odr:0];
wire [N:0]B1[odr:0][odr:0];
wire [N:0]C1[odr:0][odr:0];

output reg [N:0]dpin;

function integer twos(input [N:0] inp);
    twos = inp;
endfunction

function [N:0]slicei(input [((N+1)*(n))-1:0] inp,b);
    integer i;
    begin
        inp = inp >> (b);
        slicei = inp[N:0];
    end
endfunction

// module PE(a,b,c,a1,b1,out,clock);
// module delay(a,b,a1,b1,clock);
genvar i,j;
generate
    for(i = 0 ; i < odr; i = i + 1) begin
        for(j = 0 ; j < odr; j = j + 1) begin
            if(i < n - 1) begin
                if(j <= odr - n + i) begin
                    PE x0(
                        .clk(clk),
                        .a(A[i][j]),
                        .b(B[i][j]),
                        .c(C[i][j]),
                        .a1(A1[i][j+1]),
                        .b1(B1[i+1][j]),
                        .out(C1[i+1][j+1])
                    );
                end
                else begin
                    delay y0(
                        .clk(clk),
                        .a(A[i][j]),
                        .b(B[i][j]),
                        .a1(A1[i][j+1]),
                        .b1(B1[i+1][j])
                    );
                end
            end
            else if(i == n - 1) begin
                PE x(
                    .clk(clk),
                    .a(A[i][j]),
                    .b(B[i][j]),
                    .c(C[i][j]),
                    .a1(A1[i][j+1]),
                    .b1(B1[i+1][j]),
                    .out(C1[i+1][j+1])
                );
            end
            else if(i > n -1 ) begin
                if(j <=  i - n ) begin
                    delay y1(
                        .clk(clk),
                        .a(A[i][j]),
                        .b(B[i][j]),
                        .a1(A1[i][j+1]),
                        .b1(B1[i+1][j])
                    );
                end
                else begin
                    PE x(
                        .clk(clk),
                        .a(A[i][j]),
                        .b(B[i][j]),
                        .c(C[i][j]),
                        .a1(A1[i][j+1]),
                        .b1(B1[i+1][j]),
                        .out(C1[i+1][j+1])
                    );
                end
            end
        end
    end
endgenerate

integer i1,j1;

always @(posedge clk) begin
    if(flg < n) begin
        if(flg == 0) begin
            for(i1 = 0;i1<=odr;i1 = i1 + 1) begin
                C[0][i1] <= 0;
                C[i1][0] <= 0;
            end
            for(i1 = 0;i1<odr;i1 = i1 + 1) begin
                A[i1][0] <= 0;
                B[0][i1] <= 0;
            end
        end
        for(i1 = 0;i1<odr;i1 = i1 + 1) begin
            A[i1][0] <= 0;
            B[0][i1] <= 0;
        end
        for(i1 = 0;i1<n;i1 = i1 + 1) begin
            A[i1+flg][0] <= slicei(arr1,i1*(N+1));
            // $write("A[%d][%d] = %d ",i1+flg,0,A[i1+flg][0]);
        end
        // $write("\n");
        for(i1 = 0;i1<n;i1 = i1 + 1) begin
            B[0][i1+flg] <= slicei(arr2,i1*(N+1));
            // $write("B[%d][%d] = %d  ",0,i1+flg,B[0][i1+flg]);
        end
        // $write("\n");
    end
    else begin
        for(i1 = 0;i1<=n;i1 = i1 + 1) begin
                C[0][i1] <= 0;
                C[i1][0] <= 0;
                A[i1][0] <= 0;
                B[0][i1] <= 0;
        end
    end

    
    for(i1 = 0; i1 < odr;i1 = i1 + 1) begin
        for(j1 = 1; j1 <= odr ;j1 = j1+1) begin
            A[i1][j1] <= A1[i1][j1];
            // $write("A[%d][%d] = %d  ",i1,j1,twos(A[i1][j1]));
        end
        // $write("\n");
    end
    // $write("\n");
    for(i1 = 1; i1 <= odr; i1 = i1 + 1 ) begin
        for(j1 = 0; j1 < odr; j1 = j1 + 1) begin
            B[i1][j1] <= B1[i1][j1];
            // $write("B[%d][%d] = %d  ",i1,j1,twos(B[i1][j1]));
        end
        // $write("\n");
    end
    // $write("\n");
    for(i1 = 1; i1 <= odr; i1 = i1 + 1) begin
        for(j1 = 1; j1 <= odr; j1 = j1 + 1) begin
            C[i1][j1] <= C1[i1][j1];
            // $write("C[%d][%d] = %d  ",i1,j1,twos(C[i1][j1]));
        end
        // $write("\n");
    end
    // $write("\n");
    dpin <= C1[odr][odr];
    // $display("sysdpin = %d",twos(dpin));
end

endmodule