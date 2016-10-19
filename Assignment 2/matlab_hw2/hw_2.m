%%CV Assignment 2

clear all 
close all

%% Part 1: Feature Detection

image_in_1 = imread('leuven1.png');
image_in_2 = imread('leuven2.png');

if(size(image_in_1,3)==3)
   image1 = rgb2gray(image_in_1);
else
   image1 = image_in_1;
end


if(size(image_in_2,3)==3)
   image2 = rgb2gray(image_in_2);
else
   image2 = image_in_2;
end

if size(image1,1) ~= size(image2,1) || size(image1,2) ~= size(image2,2)
  image2 = imresize(image2,size(image1));
end

[rows1,cols1] = detect_features(image1);
[rows2,cols2] = detect_features(image2);

%% Part 2: Feature Matching

feature_coords1 = [rows1,cols1] ;
feature_coords2 = [rows2,cols2] ;

[matches] = match_features_t1(feature_coords1,feature_coords2,image1,image2);

%% Part 3A: Computing affine transformation with alignment and stitching

[H_affine] = compute_affine_xform(matches,feature_coords1,feature_coords2,image1,image2);

B = imwarp(image2,affine2d(H_affine'));
figure; imshow(B)
C = imfuse(image1,imresize(B,size(image1)),'blend','Scaling','joint');
figure; imshow(C)

%% Part 3B: Computing projective transformation with alignment and stitching

[H_proj] = compute_proj_xform(matches,feature_coords1,feature_coords2,image1,image2);
B = imwarp(image2,projective2d(H_proj));
figure; imshow(B)
C = imfuse(image1,imresize(B,size(image1)),'blend','Scaling','joint');
figure; imshow(C)
