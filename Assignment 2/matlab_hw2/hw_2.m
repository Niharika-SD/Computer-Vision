%%CV Assignment 2

clear all 
close all

%% Part 1: Feature Detection

image_in_1 = imread('graf1.png');
image_in_2 = imread('graf2.png');

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

[matches] = match_features(feature_coords1,feature_coords2,image1,image2);

%% Part 3: Computing Homographies, affine and projective transformations

[H_affine] = compute_affine_xform(matches,feature_coords1,feature_coords2,image1,image2);
[H_proj] = compute_proj_xform(matches,feature_coords1,feature_coords2,image1,image2);
