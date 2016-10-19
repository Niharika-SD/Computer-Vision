function [matches] = match_features(feature_coords1,feature_coords2,image1,image2)
    %%% 
	% Computer Vision 600.461/661 Assignment 2
	% Args:
	%	feature_coords1 : list of (row,col) feature coordinates from image1
	%	feature_coords2 : list of (row,col)feature coordinates from image2
	% 	image1 : The input image corresponding to features_coords1
	% 	image2 : The input image corresponding to features_coords2
	% Returns:
	% 	matches : list of index pairs of possible matches. For example, if the 4-th feature in feature_coords1 and the 1-st feature
	%							  in feature_coords2 are determined to be matches, the list should contain (4,1).
	%%%
    
wind_size = 3;
s = (wind_size-1)/2 ;
matches =[];
if(size(image1,3)==3&& size(image2,3)==3)
   image_1 = rgb2gray(image1);
   image_2 = rgb2gray(image2);
else
   image_1 = image1;
   image_2 = image2;

end
image1_p = im2double(padarray(image_1,[s,s],'symmetric','both'));
image2_p = im2double(padarray(image_2,[s,s],'symmetric','both'));

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
    
      j_match = find(NCC(i,:) == max(NCC(i,:)));    
    
    
      match_array =[];
    
      if(~isempty(j_match))
        
        for v = 1:size(j_match)
            match_array = vertcat(match_array,[i,j_match(v)]);
        end
      end


matches = vertcat(matches,match_array);
end

I = [image1 image2];

figure,imshow(I,[]),hold on

[~,n] =size(image1);
for i = 1: size(matches,1)
    fprintf('%d,%d, \n',(feature_coords1(matches(i,1),2)),(feature_coords1(matches(i,1),1)));
    fprintf('%d,%d, \n',(feature_coords2(matches(i,2),2)),(feature_coords2(matches(i,2),1)));
    c = [(feature_coords1(matches(i,1),2)),n+feature_coords2(matches(i,2),2)];
    r = [(feature_coords1(matches(i,1),1)),(feature_coords2(matches(i,2),1))];
    plot(c,r,'r');
end
hold off
end


