%%CV Assignment 2

clear all 
close all

%% Part 1: Feature Detection

image_in_1 = imread('leuven1.png');
image_in_2 = imread('leuven3.png');

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
title('feature points in first image')
[rows2,cols2] = detect_features(image2);
title('feature points in second image')

%% Part 2: Feature Matching

feature_coords1 = [rows1,cols1] ;
feature_coords2 = [rows2,cols2] ;

[matches] = match_features(feature_coords1,feature_coords2,image1,image2);
title('Feature matching using NCC')
%% Part 3A: Computing affine transformation with alignment and stitching

[H_affine] = compute_affine_xform(matches,feature_coords1,feature_coords2,image1,image2);
title('Inliers after RANSAC (affine)')

[B, RB] = imwarp(image2,imref2d(size(image2)),affine2d(H_affine'),'OutputView', imref2d(size(image1)));

C = imfuse(image1,imref2d(size(image1)),B,RB,'blend','Scaling','joint');
figure; imshow(C)
title('Fused image after affine warping')

figure; imshow([image1,imresize(B,size(image1))])
title('Original image vs Warped image using affine transformation')

%% Part 3B: Computing projective transformation with alignment and stitching

[H_proj] = compute_proj_xform(matches,feature_coords1,feature_coords2,image1,image2);
title('Inliers after RANSAC (projective)')

[B1, RB1] = imwarp(image2,imref2d(size(image2)),projective2d(H_proj),'OutputView', imref2d(size(image1)));

C = imfuse(image1,imref2d(size(image1)),B1,RB1,'blend','Scaling','joint');
figure; imshow(C)
title('Fused image after projective warping')

figure; imshow([image1,imresize(B1,size(image1))])
title('Original image vs Warped image using projective transformation')

%% Part 4: Feature Matching using s-sift

descriptors1 =ssift_descriptor(feature_coords1,image1);
descriptors2 =ssift_descriptor(feature_coords2,image2);

[ssift_matches] = match_features_t1(feature_coords1,feature_coords2,descriptors1,descriptors2,image1,image2);
title('Feature matching using ssift')

[H_affine_ssift] = compute_affine_xform(ssift_matches,feature_coords1,feature_coords2,image1,image2);
title('Inliers after RANSAC on ssift (affine)')

[B2, RB2] = imwarp(image2,imref2d(size(image2)),affine2d(H_affine_ssift'),'OutputView', imref2d(size(image1)));

C = imfuse(image1,imref2d(size(image1)),B2,RB2,'blend','Scaling','joint');
figure; imshow(C)
title('result of fusing on Warped image after affine transformation using ssift matches')

figure; imshow([image1,imresize(B2,size(image1))])
title('Original image vs Warped image using affine transformation on ssift matches')