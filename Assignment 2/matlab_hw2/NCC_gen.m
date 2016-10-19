function NCC = NCC_gen(feature_coords1,feature_coords2,image1_p,image2_p,s)
%%
%given padded images image1_p and image2_p and window half size s for NCC 
% along with the features co-ordinates in 1 and 2, computes the normalised 
%cross correlation matrix NCC
wind_size = s*2 +1;

for i = 1:size(feature_coords1)
   
    for j =1:size(feature_coords2)
        
        %extract row and column information
        a = feature_coords1(i,:);
        r1 = a(1);
        c1 = a(2);
        b = feature_coords2(j,:);
        r2 = b(1);
        c2 = b(2);
        
        img1_vec = image1_p(r1:r1+2*s,c1:c1+2*s);
        img1_vec = reshape(img1_vec,[wind_size^2,1]) - mean(mean(img1_vec)) ;
        img1_vec = img1_vec/std(img1_vec);
        
        img2_vec = image2_p(r2:r2+2*s,c2:c2+2*s);
        img2_vec = reshape(img2_vec,[wind_size^2,1]) - mean(mean(img2_vec));
        img2_vec = img2_vec/std(img2_vec);
        
        NCC(i,j) = sum(img1_vec.*img2_vec)/(wind_size)^2 ;
    end
end

end