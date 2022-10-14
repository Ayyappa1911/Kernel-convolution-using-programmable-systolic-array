fid1 = fopen('outgsf_7x7.txt');
fid = fopen('out2.txt','w');
A1 = [];
tline = fgetl(fid1);
while ischar(tline)
    %disp(tline)
    if(~(tline(1) == '/'))
        fprintf(fid,'%s\n',tline);
        %sum = 0;
        %for a = 1 : 1 : 4
        %    sum = 2*sum + (tline(a))-48;
        %end
        
        sum1 = 0;

        i = 24;

        for a = 2: 1 : i
            sum1 = 2*sum1 + (tline(a)) - 48;
        end
        
        if((tline(1)-48) == 1)
            sum1 = sum1 - (2^(i-1));
        end

        %sum = sum*16+ sum1;

        A1(end+1) = sum1;
        %if(sum < 128)
        %    A1(end+1) = sum;
        %elseif(sum >= 128)
        %    A1(end+1) = sum - 256;
        %end
        %disp(uint8(tline))
    end
    tline = fgetl(fid1);
end
fclose(fid1);
fclose(fid);

P1 = 256;

A2 = zeros(P1,P1);

for a = 1 : 1 : P1
    for b = 1 : 1 : P1
        A2(a,b) = -1*-1*(A1(((a-1)*P1) + b));
    end
end

K = mat2gray(A2);

figure
imshow(K)



[peaksnr, snr] = psnr(K, R1);

ssimval = ssim(K,R1);


if(R1 == K)
    disp('same')
end

%A1 = (textread('out2.txt','%s'));
%fid2 = fopen('out2.txt');
%C = textscan(fid2, '%b\n');
%fclose(fid2);

