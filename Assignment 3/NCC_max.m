function x_1 = NCC_max(patch,I_r,y,x1)
%given a patch and the right image as input along with the y coordinate of
%the patch, computes the x_1 corresponding to the max NCC metric

NCC_met = zeros(size(I_r,2));
patch_n = (patch-mean(mean(patch)))/std2(patch);

for x = 16: x1
    if(abs(x-x1)<100)
     test_patch =  I_r(y-15:y+15,x-15:x+15);
     test_patch_n = test_patch-mean(mean(test_patch))/std2(test_patch) ;
     NCC_met(x) = sum(sum(patch_n.*test_patch_n))/225 ; 
    end
end
x_1 = find((NCC_met ==max(NCC_met)),1,'first');
end