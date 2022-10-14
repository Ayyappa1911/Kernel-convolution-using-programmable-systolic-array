
module conv(clk,flg);

parameter N = 31;
parameter n = 3;
parameter img1 = 256 + (n-1);
parameter img = 256 + (n-1);

parameter dt = 8;

input clk;

reg [N:0]array[(img1-1):0][(img1-1):0];
reg [dt-1:0] A[0:((img1-(n-1))*(img1-(n-1)))-1]; 
reg [N:0]out[(img-1)-(n-1):0][(img-1)-(n-1):0];
reg [2*dt -1:0] Aout[0:((img-(n-1))*(img-(n-1)))-1];
reg [N:0]ker[n-1:0][n-1:0];

reg flag = 0;

reg [((N+1)*(n))-1 :0]arr1;
reg [((N+1)*(n))-1 :0]arr2;
// reg [6:0] flg;
input [6:0] flg;

wire [N:0]dpin;

integer i1,j1;
integer i,j,k;
integer p,q;
integer dotpdt;

function integer twos(input [N:0] inp);
    twos = inp;
endfunction

sysarray xyz(
    .clk(clk),
    .flg(flg),
    .arr1(arr1),
    .arr2(arr2),
    .dpin(dpin)
);

always @(posedge clk) begin
    if(flag == 0) begin
        // $display("flag = 0");
        $readmemh("inp1.txt",A);

        for(i1 = 0; i1 < img1; i1 = i1 + 1) begin
            for(j1 = 0 ; j1 < img1; j1 = j1 + 1) begin // will work only for odd n values !
                if(i1 < n-2 || i1 > (img1)-(n-1) || j1 <(n-2) || j1 > (img1)-(n-1)) begin
                    array[i1][j1] = 0;
                    // $display("i1 = %d j1  = %d array[i1][j1] = %d",i1,j1,array[i1][j1]);
                end
                else begin
                    array[i1][j1] = A[((i1-(n-2))*(img1-(n-1)))+(j1-(n-2))];
                    // $display("i1 = %d j1  = %d array[i1][j1] = %d",i1,j1,array[i1][j1]);
                end
            end
        end
        
        // flg = 0;
        flag = 1;

        ker[0][0] = -1;
        // ker[0][0] = 1;
        ker[0][1] = 0;
        ker[0][2] = 1;
        ker[1][0] = -2;
        // ker[1][0] = 2;
        ker[1][1] = 0;
        ker[1][2] = 2;
        ker[2][0] = -1;
        // ker[2][0] = 1;
        ker[2][1] = 0;
        ker[2][2] = 1;

        // ker[0][0] = -1;
        // // ker[0][0] = 1;
        // ker[0][1] = -2;
        // ker[0][2] = 1;
        // ker[1][0] = 0;
        // // ker[1][0] = 2;
        // ker[1][1] = 0;
        // ker[1][2] = 0;
        // ker[2][0] = 1;
        // // ker[2][0] = 1;
        // ker[2][1] = 2;
        // ker[2][2] = 1;

        // ker[0][0] = 0;
        // // ker[0][0] = 1;
        // ker[0][1] = 0;
        // ker[0][2] = 0;
        // ker[1][0] = 0;
        // // ker[1][0] = 2;
        // ker[1][1] = 1;
        // ker[1][2] = 0;
        // ker[2][0] = 0;
        // // ker[2][0] = 1;
        // ker[2][1] = 0;
        // ker[2][2] = 0;

        i = 0;
        j = 0;
    end
end

always @(negedge clk) begin


    if(flag == 1) begin

        // $display("started");
        if(flg == 0) begin
            dotpdt = 0;
            // $display("%d",dotpdt);
        end
        if(flg < n) begin
            arr1 = 0;
            for(k = 0 ; k < n ; k = k + 1) begin
                arr1 = arr1 + (array[i+flg][j+k]) * (2**(k*(N+1))) ;
                // $display("%b started1",arr1);
            end

            arr2 = 0;
            for(k = 0 ; k < n ; k = k + 1) begin
                // arr2 = arr2 + (ker[i+flg][j+k]) * (2**(k*(N+1))) ;
                arr2 = arr2 + (ker[flg][k]) * (2**(k*(N+1))) ;
                // $display("%b started2",arr2);
            end

        end

        // $display("%d flg = %d dpin = %d",dotpdt,flg,twos(dpin));

        if(flg > 2*n-1 && flg < 3*n) begin
            dotpdt = dotpdt + dpin;
            // $display("%d dotproduct",twos(dotpdt));
        end

        if(flg == 3*n-1) begin
            // array
            out[i][j] = dotpdt;
            // $display("output[%d][%d] = %d",i,j,twos(out[i][j]));
            j = j + 1;
            if(j == (img)-(n-1)) begin
                j = 0;
                i = i + 1;
            end
            // $display("i = %d j = %d",i,j);
            // flg = 0;
        end
        // else begin
        //     flg = flg + 1;
        // end

        // if(i == (img)-(n-1) && j == (img)-(n-1)) begin
        if(i == (img)-(n-1)) begin
            flag = 5;
            k = 0;
            for(p = 0; p < (img-(n-1)) ; p = p + 1) begin
                for(q = 0 ; q < (img-(n-1)) ; q = q + 1) begin
                    Aout[k] = out[p][q];
                    // $display("Aout = %d  q=%d p = %d",twos(Aout[k]),p,q);
                    k = k + 1;
                end
             end
            // $writememh("out.txt",Aout,0,((img-(n-1))*(img-(n-1)))-1);
            $writememb("oute.txt",Aout);
        end
    end

end

endmodule