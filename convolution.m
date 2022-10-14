U = imread('cameraman.tif');

/// Sobel left filter
%I = [
%        -1, 0 ,1;
%        -2, 0 ,2;
%        -1, 0, 1;
%    ];


/// Guassian smoothening filter for 3x3 kernel
%I = [
%        1,2,1;
%        2,4,2;
%        1,2,1;
%    ];


/// Guassian smoothening filter for 5x5 kernel
%I = [
%        1,4,7,4,1;
%        4,16,26,16,4;
%        7,26,41,26,7;
%        4,16,26,16,4;
%        1,4,7,4,1;
%    ];

/// Guassian smoothening filter for 7x7 kernel
I = [
        0,0,1,2,1,0,0;
        0,3,13,22,13,3,0;
        1,13,59,97,59,13,1;
        2,22,97,159,97,22,2;
        1,13,59,97,59,13,1;
        0,3,13,22,13,3,0;
        0,0,1,2,1,0,0;
    ];


R = (conv2(uint8(U),I,'same'));




R1 = mat2gray(R);


figure
imshow(R1)

%figure
%imshow(U)

P1 = 256;

Ra = zeros(P1,P1);

for a = 1 : 1 : P1
    for b = 1 : 1 : P1
        if(R(a,b) <= -256)
            Ra(a,b) = (R(a,b)+256) * -1; 
            Ra(a,b) = Ra(a,b) - 256;
        else
            Ra(a,b) = -1*(R(a,b));
        end
    end
end

erra = [];
errb = [];
errR = [];
errA2 = [];
errs = [];

count = 0;



for a = 1 : 1 : P1
    for b = 1 : 1 : P1
        if(~(Ra(a,b) == A2(a,b)) && ~(a==P1) && ~(b==P1))
        %if(~(Ra(a,b) == A2(a,b)))
            %disp('yes');
            erra(end+1) = a;
            errb(end+1) = b;
            errR(end+1) = Ra(a,b);
            errA2(end+1) = A2(a,b);
            errs(end+1) = abs(Ra(a,b)) + abs(A2(a,b));
            if(~(errs(end) == 256))
                disp('yes1')
                count = count + 1;
            end
        end
    end
end
