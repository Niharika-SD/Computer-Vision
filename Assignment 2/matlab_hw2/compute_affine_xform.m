function [affine_xform] = compute_affine_xform(matches,features1,features2,image1,image2)
	%%%
	% Computer Vision 600.461/661 Assignment 2
	% Args:
	%	matches : list of index pairs of possible matches. For example, if the 4-th feature in feature_coords1 and the 1-st feature
	%							  in feature_coords2 are determined to be matches, the list should contain (4,1).
    %   features1 (list of tuples) : list of feature coordinates corresponding to image1
    %   features2 (list of tuples) : list of feature coordinates corresponding to image2
	% 	image1 : The input image corresponding to features_coords1
	% 	image2 : The input image corresponding to features_coords2
	% Returns:
	%	affine_xform (ndarray): a 3x3 Affine transformation matrix between the two images, computed using the matches.
	% 
    threshold = 0.9;
    NumIter = 1000;
    % extracting and homogenising the co-ordinates
    x_1 =[];
    x_2 =[];
    
    for i= 1:size(matches,1)
        x_2 = vertcat(x_2,[features2(matches(i,2),2),features2(matches(i,2),1),1]);
        x_1 = vertcat(x_1,[features1(matches(i,1),2),features1(matches(i,1),1),1]);
    end
   
    score = zeros(NumIter,1);
    inliers = zeros(NumIter,size(x_1,1));
        
    
    for i =1:NumIter
        indx = randperm(size(matches,1),3);
        
        x1_s =[x_1(indx(1),1),x_1(indx(2),1),x_1(indx(3),1)];
        y1_s =[x_1(indx(1),2),x_1(indx(2),2),x_1(indx(3),2)];
        x2_s =[x_2(indx(1),1),x_2(indx(2),1),x_2(indx(3),1)];
        y2_s =[x_2(indx(1),2),x_2(indx(2),2),x_2(indx(3),2)];
        
        A = [];
        A1 =[];
        for j =1:3
            B =[x2_s(j),y2_s(j),1,0,0,0;0,0,0,x2_s(j),y2_s(j),1];
            C= [x1_s(j),y1_s(j)]';
            A1 = vertcat(A1,C);
            A = vertcat(A,B);
        end
        
        H = [reshape(pinv(A)*A1,[3,2])';[0,0,1]];
        X1 = H*x_2';
        sq_err = ((X1'-x_1).^2)';
        err = sqrt(sum(sq_err,1));
        score(i,:) = sum(err < threshold);
        inliers(i,:) = (err < threshold);
    end
    
    best = find(score == max(score),1,'first');
 
    inl_x_1 =x_2.*[inliers(best,:)',inliers(best,:)',inliers(best,:)'];
    
    A =[];
    A1 =[];
    inl_x1 = [];
    inl_x2 = [];
    out_x1 = [];
    out_x2 = [];
    for k =1:size(inl_x_1,1)
        
        if(inl_x_1(k,3)==1)
            
        B =[x_2(k,1),x_2(k,2),1,0,0,0;0,0,0,x_2(k,1),x_2(k,2),1];
        C = [x_1(k,1);x_1(k,2)];
        A =vertcat(A,B);
        A1 =vertcat(A1,C);
        inl_x1 =vertcat(inl_x1,[x_1(k,1),x_1(k,2)]);
        inl_x2 =vertcat(inl_x2,[x_2(k,1),x_2(k,2)]);
        else
        out_x1 =vertcat(out_x1,[x_1(k,1),x_1(k,2)]);
        out_x2 =vertcat(out_x1,[x_2(k,1),x_2(k,2)]);
        end   
        
    end
   
   affine_xform = [reshape(pinv(A)*A1,[3,2])';[0,0,1]];
   
   I = [image1 image2];
   figure,imshow(I,[]),hold on
   [~,n]=size(image1);
   
   for k = 1: size(inl_x1,1)
    x = [inl_x1(k,1),n+inl_x2(k,1)];
    y = [inl_x1(k,2),inl_x2(k,2)];
    plot(x,y,'r');
   end
   
   for k = 1: size(out_x1,1)
    x = [out_x1(k,1),n+out_x2(k,1)];
    y = [out_x1(k,2),out_x2(k,2)];
    plot(x,y,'y');
   end
    
end


