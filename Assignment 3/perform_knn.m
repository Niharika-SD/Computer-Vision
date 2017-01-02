function BOW = perform_knn(feat,Mdl)
%given the features and kDTree model computes the BOW representation for
%each image using a prespecified number of cluster centers 800
%The output is a normalised histogram BOW representation corresponding to
%one per image (in each respective row)

BOW = zeros(size(feat,2),800);

for i = 1:size(feat,2) %for each class 6 total for each image 150 total
     
     Y = feat(i).d; 
     Idx = knnsearch(Mdl,Y);  
    
     %create histogram for each image based on the centers of the clusters
     for k =1:size(BOW,2)
        BOW(i,k) = sum(Idx == k);
     end
     BOW(i,:) = BOW(i,:)/sum(BOW(i,:));
end
end

