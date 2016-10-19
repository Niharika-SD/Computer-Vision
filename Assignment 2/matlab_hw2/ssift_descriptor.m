function [ descriptors ] = ssift_descriptor(feature_coords,image)
	%%%
	% Computer Vision 600.461/661 Assignment 2
	% Args:
	%	feature_coords: list of (row,col) tuple feature coordinates from image
	%	image: The input image to compute ssift descriptors on. Note: this is NOT the image name or image path.
	% Returns:
	%	descriptors: n-by-128 ssift descriptors. The first row corresponds
	%	to the ssift descriptor of the first feature (index=1) in
	%	feature_coords
	%%%
    
    image = im2double(image);
    wind_size =41;
    s = (wind_size-1)/2;
    [m,n] =size(image);
    grid_r =[5,15,25,35];
    count = 0;
    
    for i =1:size(feature_coords,1)
        
        grad_or= [];
        if(feature_coords(i,1)>s && feature_coords(i,1)<m-s && feature_coords(i,2)>s && feature_coords(i,2)<n-s)
            
            r = feature_coords(i,1);
            c = feature_coords(i,2);
            patch = image(r-s:r+s,c-s:c+s);
            count= count+1;
            
            for j=1:4
                for k=1:4
                    r1 = grid_r(j);
                    c1 = grid_r(k);
                    grid_patch = patch((r1-(s/4))+1:(r1+(s/4)),(c1-s/4)+1:(c1+(s/4)));
                    
                    or_hist = orientation_hist(grid_patch);
                    
                    grad_or = horzcat(grad_or,or_hist);
                
                end
            end
            
            
             %normalising    
           grad_or = normr(grad_or);
           grad_or(grad_or > 0.2)=0.2;
           grad_or = normr(grad_or);
           
           descriptors(i,:)  = grad_or(:);   
           
        
        else 
           descriptors(i,:)  = zeros(1,128);
        end
   
    end


end

