function [matches] = match_features_t1(feature_coords1,feature_coords2,image1,image2)
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
	% graf =7
    %%%
    
wind_size = 17;
s = (wind_size-1)/2 ;
matches =[];
if(size(image1,3)==3&& size(image2,3)==3)
   image_1 = rgb2gray(image1);
   image_2 = rgb2gray(image2);
else
   image_1 = image1;
   image_2 = image2;

end
image1_p = im2double(padarray(image_1,[s,s],'replicate','both'));
image2_p = im2double(padarray(image_2,[s,s],'replicate','both'));

NCC = NCC_gen(feature_coords1,feature_coords2,image1_p,image2_p,s);
NCC_t = NCC' ;

for i = 1: size(feature_coords1)
    j_match = find(NCC(i,:) == max(NCC(i,:)));    
    
    
      match_array =[];
    
      if(~isempty(j_match))
        
        for v = 1:size(j_match)
            if(find(NCC_t(j_match(v),:) == max(NCC_t(j_match(v),:))) == i)
            match_array = vertcat(match_array,[i,j_match(v)]);
            end
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