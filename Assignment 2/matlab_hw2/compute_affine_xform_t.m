function [affine_xform] = compute_affine_xform_t(matches,a1,b1,a2,b2,A,B)
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
    A = im2double(A);
    B = im2double(B);
    d = 60;
    Count = [];
    N = 300;
    s = 5;
    [m1,n1] = size(A);
    [m2,n2] = size(B);
    Thresh = 50;
    r1 = [];r2 =[]; c1 = []; c2 =[];
    for i=1:length(a1)
        if(a1(i)>15&&a1(i)<m1-15&&b1(i)>15&&b1(i)<n1-15)
            r1 = [r1,a1(i)]; c1 = [c1,b1(i)];
        end
    end

    for i=1:length(a2)
        if(a2(i)>15&&a2(i)<m2-15&&b2(i)>15&&b2(i)<n2-15)
            r2 = [r2,a2(i)]; c2 = [c2,b2(i)];
        end
    end
    Count = [];
    %computing the transformation(affine)
    for i=1:N
        C = [];b = [];count=0;
        samples = randsample(matches,3);
        for j=1:length(samples)
            x1 = r1(samples(j,1)); y1 =c1(samples(j,1));
            x2 = r2(samples(j,2)); y2 =c2(samples(j,2));
            C = [C;x1 y1 1 0 0 0;0 0 0 x1 y1 1];
            b = [b;x2;y2];
        end
        t(:,i) = pinv(C)*b;
        H = [t(1,i) t(2,i) t(3,i);t(4,i) t(5,i) t(6,i);0 0 1];
        for j=1:length(matches)
            xn = H*[r1(matches(j,1));c1(matches(j,1));1];
            error(i,j) = sum(([xn(1);xn(2)]-[r2(matches(j,2));c2(matches(j,2))]).^2);
            if (error(i,j)<Thresh)
                count = count+1;
            end
        end
        Count = [Count,count];
    end
    Count;
    index = find(Count==max(Count));
    kl = error(index,:);
    required_affine = t(:,index);
    inliers = []; outliers =[];
    for i = 1:length(matches)
        error(index(1),i);
        if (error(index(1),i)<Thresh)
            inliers = [inliers;matches(i,:)];
        else
            outliers = [outliers;matches(i,:)];
        end
    end
       C = [A B];
    imshow(C); hold on;
    plot(c1(outliers(:,1)),r1(outliers(:,1)),'*','color','blue'); hold on;
    plot(c2(outliers(:,2))+n1,r2(outliers(:,2)), '*','color','blue'); hold on;
    plot(c1(inliers(:,1)),r1(inliers(:,1)),'+','color','red'); hold on;
    plot(c2(inliers(:,2))+n1,r2(inliers(:,2)), '+','color','red'); hold on; 
%     plot([c1(matches(:,1)) c2(matches(:,2))+n1],[r1(matches(:,1)) r2(matches(:,2))],'color','y');
    for i=1:length(matches)

    plot([c1(matches(i,1)) c2(matches(i,2))+n1],[r1(matches(i,1)) r2(matches(i,2))],'color','yellow');hold on;
    end
    
    
    
    affine_xform = reshape(required_affine,[3,3]);
    
    %ransac algorithm to find outliers
%     for i=1:N
%         count = 0;
%         samples = randsample(matches,s);
%         p(i,:) = polyfit(samples(:,1),samples(:,2),1);
%         for j=1:length(samples)
%             l = abs(p(i,1)*samples(j,1)+p(i,2)-samples(j,2))/sqrt(p(i,1)^2+p(i,2)^2);
%             if(l<d)
%                 count = count+1;
%             end
%             
%         end
%         Count = [Count,count];
%     end
%         flag = find(Count==max(Count));
%         line_p = p(flag,:);
%         outliers = [];
%         inliers = [];
%     for i=1:length(matches)
%         l = abs(line_p(1)*matches(i,1)+line_p(2)-matches(i,2))/sqrt(line_p(1)^2+line_p(2)^2);
%         if(l>d)
%             outliers = [outliers;matches(i,:)];
%         else
%             inliers = [inliers;matches(i,:)];
%         end
%     end
%     outliers
%     C = [A B];
%     imshow(C); hold on;
%     plot(c1(outliers(:,1)),r1(outliers(:,1)),'*','color','blue'); hold on;
%     plot(c2(outliers(:,2))+n1,r2(outliers(:,2)), '*','color','blue'); hold on;
%     plot(c1(inliers(:,1)),r1(inliers(:,1)),'+','color','red'); hold on;
%     plot(c2(inliers(:,2))+n1,r2(inliers(:,2)), '+','color','red'); hold on;
%     plot(c1(matches(:,1)),r1(matches(:,1)),'*');
    
end
