function F = compute_fund_matrix(x_l,x_r,y_l,y_r)
%from the co-ordinates of matches x_l,x_r,y_l,y_r computes the fundamental
%matrix associated with the epipolar construct by least squares estimation

A =ones(size(x_l,1),9);
threshold = 5;
NumIter = 1000;
score = zeros(NumIter,1);
inliers = zeros(NumIter,size(x_l,1));

x_1 = horzcat(x_l,y_l,ones(size(x_l,1),1));
x_2 = horzcat(x_r,y_r,ones(size(x_r,1),1));

for i =1:NumIter
   
   indx = randperm(size(x_l,1),4);
   for k =1:size(indx,2)
      A(k,:) = [x_l(indx(k))*x_r(indx(k)), x_l(indx(k))*y_r(indx(k)), x_l(indx(k)), y_l(indx(k))*x_r(indx(k)),y_l(indx(k))*y_r(indx(k)),y_l(indx(k)), x_r(indx(k)),y_r(indx(k)),1];        
   end
   [~,~,V] = svd(A);
   H(i,:) = V(:,9) ;
   err = zeros(size(x_1,1),1);
   for v =1:size(x_1,1)
       err(v) =  x_1(v,:)*reshape(H(i,:),3,3)'*x_2(v,:)';
   end
        score(i,:) = sum(abs(err) < threshold);
        inliers(i,:) = (abs(err) < threshold);
        
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
        B =[x_1(k,1)*x_2(k,1), x_1(k,1)*x_2(k,2), x_1(k,1), x_1(k,2)*x_2(k,1),x_1(k,2)*x_2(k,2),x_1(k,2), x_2(k,1),x_2(k,2),1];              
        A =vertcat(A,B);
        inl_x1 =vertcat(inl_x1,[x_1(k,1),x_1(k,2)]);
        inl_x2 =vertcat(inl_x2,[x_2(k,1),x_2(k,2)]);  
        else
        out_x1 =vertcat(out_x1,[x_1(k,1),x_1(k,2)]);
        out_x2 =vertcat(out_x2,[x_2(k,1),x_2(k,2)]);
        end
        
end
[~,~,V] = svd(A);
F =reshape(V(:,9)',[3,3]);
end