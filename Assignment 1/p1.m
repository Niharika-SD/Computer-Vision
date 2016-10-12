function binary_out = p1(gray_in, thresh_val)

%extracting size
[m,n] = size(gray_in);
binary_out =zeros(m,n);

%thresholding the pixel values
for i =1:m
    for j=1:n
        if(gray_in(i,j)>thresh_val)
            binary_out(i,j) = 255;
        else
            binary_out(i,j) = 0;
        end
    end
    
   
end