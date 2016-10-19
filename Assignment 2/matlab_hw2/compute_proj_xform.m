function [proj_xform] = compute_proj_xform(matches,features1,features2,image1,image2)
	%%%
	% Computer Vision 600.461/661 Assignment 2
	% Args:
	%	matches : list of index pairs of possible matches. For example, if the 4-th feature in feature_coords1 and the 1-st feature
	%							  in feature_coords2 are determined to be matches, the list should contain (4,1).
    %   features1 : list of feature coordinates corresponding to image1
    %   features2 : list of feature coordinates corresponding to image2
	% 	image1 : The input image corresponding to features_coords1
	% 	image2 : The input image corresponding to features_coords2
	% Returns:
	%	proj_xform (ndarray): a 3x3 Projective transformation matrix between the two images, computed using the matches.
	% 
    threshold = 0.8;
    NumIter = 1000;
    % extracting and homogenising the co-ordinates
    x_1 =[0,0,0];
    x_2 =[0,0,0];
    for i= 1:size(matches,1)
        x_2 = vertcat(x_2,[features2(matches(i,2),2),features2(matches(i,2),1),1]);
        x_1 = vertcat(x_1,[features1(matches(i,1),2),features1(matches(i,1),1),1]);
    end
    x_1 = x_1(2:end,:);
    x_2 = x_2(2:end,:);
    
    H = zeros(NumIter,9);
    score = zeros(NumIter,1);
    inliers = zeros(NumIter,size(x_1,1));
        
    
    for i =1:NumIter
        indx = randperm(size(matches,1),4);
        
        x1_s =[x_1(indx(1),1),x_1(indx(2),1),x_1(indx(3),1),x_1(indx(4),1)];
        y1_s =[x_1(indx(1),2),x_1(indx(2),2),x_1(indx(3),2),x_1(indx(4),2)];
        x2_s =[x_2(indx(1),1),x_2(indx(2),1),x_2(indx(3),1),x_2(indx(4),1)];
        y2_s =[x_2(indx(1),2),x_2(indx(2),2),x_2(indx(3),2),x_2(indx(4),2)];
        
        A = [];
        for j =1:4
            B =[x2_s(j),y2_s(j),1,0,0,0,-x1_s(j)*x2_s(j),-x1_s(j)*y2_s(j),-x1_s(j); 0,0,0,x2_s(j),y2_s(j),1,-y1_s(j)*x2_s(j),-y1_s(j)*y2_s(j),-y1_s(j)];
            A =vertcat(A,B);
        end
        
        [~,~,V] =svd(A);
        H(i,:) = V(:,9) ;
        X1 = reshape(H(i,:),3,3)' * x_2';
        for v = 1:size(X1,2)
           X1(:,v) = X1(:,v)./X1(3,v);
        end
        
        sq_err = ((X1'-x_1).^2)';
        err = sqrt(sum(sq_err,1));
        score(i,:) = sum(err < threshold);
        inliers(i,:) = (err < threshold);
        
    end
    
    best = find(score == max(score),1,'first');
 
    inl_x_1 =x_1.*[inliers(best,:)',inliers(best,:)',inliers(best,:)'];
    
    A =[];
    inl_x1 = [];
    inl_x2 = [];
    out_x1 =[];
    out_x2 =[];
    for k =1:size(inl_x_1,1)
        if(inl_x_1(k,3)==1)
            
        B =[x_2(k,1),x_2(k,2),1,0,0,0,-x_1(k,1)*x_2(k,1),-x_1(k,1)*x_2(k,2),-x_1(k,1); 0,0,0,x_2(k,1),x_2(k,2),1,-x_1(k,2)*x_2(k,1),-x_1(k,2)*x_2(k,2),-x_1(k,2)];
        A =vertcat(A,B);
        inl_x1 =vertcat(inl_x1,[x_1(k,1),x_1(k,2)]);
        inl_x2 =vertcat(inl_x2,[x_2(k,1),x_2(k,2)]);  
        else
        out_x1 =vertcat(out_x1,[x_1(k,1),x_1(k,2)]);
        out_x2 =vertcat(out_x1,[x_2(k,1),x_2(k,2)]);
        end
            
        
    end
   [~,~,V] = svd(A);
   proj_xform = reshape(V(:,9),[3,3]);
   
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

