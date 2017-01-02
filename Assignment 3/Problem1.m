clear all
close all

%% Part b i 
%display sift features for an image

image = single(rgb2gray(imread('f000000.jpg')));
[features, descriptors] = vl_sift(image);

figure;imshow(image,[]);
perm = randperm(size(features,2)) ;
sel = perm(1:50) ;
h1 = vl_plotframe(features(:,sel)) ;
h2 = vl_plotframe(features(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

h3 = vl_plotsiftdescriptor(descriptors(:,sel),features(:,sel)) ;
set(h3,'color','g') ;

%% part b ii : k means clustering on codebook

[des,feat] = load_train_data(0);
[centers,labels] = vl_kmeans(double(des'),800);
labels = labels';
centers =centers';

%% part b iii : BOW representation for test data from codebook

codebook = KDTreeSearcher(centers);
BOW_train = perform_knn(feat,codebook);

fprintf('Each row of BOW train matrix represents the bag of words \n based representation for each image. \n the class for ith image can be found by doing a ceil(i)/150 operation \n')

%% part b iv: Perform classification on testing data

%computing features
[~,feat_test] = load_train_data(1);

BOW_test = perform_knn(feat_test,codebook);

Mdl = KDTreeSearcher(BOW_train);
Idx = knnsearch(Mdl,BOW_test);

knn_Acc = 0;
% calculate accuracy of search
for i = 1: size(Idx,1)   
    knn_Acc = knn_Acc+ (ceil(Idx(i)/150) == ceil(i/51));
end
knn_Acc = knn_Acc/size(Idx,1);

fprintf('Testing accuracy is %f \n',knn_Acc)

%% part c SVM based classification

%extract train labels

train_labels = 1:900;
train_labels = ceil(train_labels/150)';

a =ones(1,size(BOW_test,2));
a1 =ones(1,size(BOW_train,2));
max1 = max(BOW_test')' ;
max2 = max(BOW_train')' ;

BOW_test_norm = 2*(BOW_test./(max1*a))-1;
BOW_train_norm = 2*(BOW_train./(max2*a1))-1;

Idx_svm = multisvm(BOW_train_norm,train_labels,BOW_test_norm);

SVM_Acc = 0;
% calculate accuracy of svm based classification
for i = 1: size(Idx_svm,1)   
    SVM_Acc = SVM_Acc+ (Idx_svm(i) == ceil((i/51)));
end
SVM_Acc = SVM_Acc/size(Idx_svm,1);

fprintf('Testing accuracy for SVM is %f \n',SVM_Acc)