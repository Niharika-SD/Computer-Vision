function [matches] = match_features_t1(feature_coords1,feature_coords2,descriptors1,descriptors2,image1,image2)
    %%% 
	% Computer Vision 600.461/661 Assignment 2
	% Args:
	%	feature_coords1 : list of (row,col) feature coordinates from image1
	%	feature_coords2 : list of (row,col)feature coordinates from image2
	% 	image1 : The input image corresponding to features_coords1
	% 	image2 : The input image corresponding to features_coords2
    %   descriptors1 : The descriptors in the image corresponding to features_coords1
	% 	descriptors2 : The descriptors in the image corresponding to
	% 	features_coords2
	% Returns:
	% 	matches : list of index pairs of possible matches. For example, if the 4-th feature in feature_coords1 and the 1-st feature
	%							  in feature_coords2 are determined to be matches, the list should contain (4,1).
	% 
    %%%
    

dist_meas = compute_feature_distances(descriptors1,descriptors2);
matches =[];

for i = 1: size(feature_coords1)
    if(descriptors1(i,:) ~= zeros(1,128))
    
        j_match = find(dist_meas(i,:) == min(dist_meas(i,:)),1,'first');    
        match_array =[];
        f1 = dist_meas(i,j_match);
            
        dist_new = dist_meas(i,:);
        dist_new(dist_new == min(dist_new))= inf;
            
        f2 = dist_meas(i,find(dist_new == min(dist_new),1,'first'));
            
        if(f1/f2 <= 0.6)
           match_array = vertcat(match_array,[i,j_match]);
        end
        
        matches = vertcat(matches,match_array);

    end
end
%

I = [image1 image2];

figure,imshow(I,[]),hold on

[~,n] =size(image1);
for i = 1: size(matches,1)
    c = [(feature_coords1(matches(i,1),2)),n+feature_coords2(matches(i,2),2)];
    r = [(feature_coords1(matches(i,1),1)),(feature_coords2(matches(i,2),1))];
    plot(c,r,'r');
end
hold off
end