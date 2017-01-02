function dist_measure = compute_feature_distances(descriptors1,descriptors2)

%%given two features descriptors computes the distance measure between them
%input are the two descriptors descriptor1(mx128) and descriptor2(nx128)
%output is the distance measure which is an (mxn) matrix

dist_measure =zeros(size(descriptors1,1),size(descriptors2,1));

for i = 1:size(descriptors1,1)
    for j = 1:size(descriptors2,1)
        dist_measure(i,j) = sqrt(sum(((descriptors1(i,:))-(descriptors2(j,:))).^2));
    end
end

end