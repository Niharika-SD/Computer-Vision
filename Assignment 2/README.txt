CV Assignment 2


Instructions: run the script titled hw2.m
Currently the result will be displayed on the leuven1 and leuven2 images

Find results for other images in a folder titled results

Results has 4 subfolders for the 4 categories of image pairs bikes, leuven, graf and wall
Each subfolder has 3 more corresponding to the 3 different pairs of images 1&2 and 1&3
results: result1.jpg :feature points in first image
         result2.jpg :feature points in first image
         result3.jpg :Feature matching using NCC
         result4.jpg :Inliers after RANSAC (affine)
         result5.jpg :Fused image after affine warping
         result6.jpg :Original image vs Warped image using affine transformation
         result7.jpg :Inliers after RANSAC (projective)
         result8.jpg :Fused image after projective warping
         result9.jpg :Original image vs Warped image using projective transformation
         result10.jpg :Feature matching using ssift
         result11.jpg :Inliers after RANSAC on ssift (affine)
         result12.jpg :result of fusing on Warped image after affine transformation using ssift matches
         result13.jpg :Original image vs Warped image using affine transformation on ssift matches


Thresholds: 

harris coners :0.05
NCC window size:7x7
affine error threshold: 1
projective error threshold:1
ssift threshold: 0.6
Inliers are painted in red lines while outliers are painted in yellow 

comments:
1.When the threshold for harris corners is low, many points are detected and the computational time for NCC increases
2.NCC window size can affect the accuracy of detecting matches, when the distortion is high, the matches are poor. See results for wall 1 and wall 3
3.The geometry of the scene is a major factor impeding this procedure, for eg. the orientations in graf1 and graf3 make feature matching very difficult because of which the estimation of tranformations fails

Discussions and notable points:

1.During matching using NCC criterion, a padding of the window half size is given to account for feature points at the boundaries of the image

2.Mutual marriages is implemented by searching across rows of the NCC matrix and searching across the corresponding maxima column to establish a match.Thus multiple corresondences are avoided

3.Computation of the projective transformation and overlaying, in general gives a better result compared to using an affine transformation, this is because affine tranformations have 6 degrees of freedom which cannot account for all image distortions. eg.see the result on bikes1 and bikes2.In general, a shift in the locations while overlaying the images may be observed for the affine cases because 

a.The sizes of the images and interpolation after using imwarp
b.Since every distortion cannot be accounted for by an affine transformation, the best it can perform is align to the same plane. for eg in case of (graf 1 and graf 2) and (graf 1 and graf 3), the affine estimation is poor, but the homography aligns well
c.Affine computation may not be exact (least square solution)
d.Thresholds used are not idealised w.r.t each image

4.During matching using ssift criterion, features at the boundary points of the image are not considered  

5.Ssift descriptor works well when the image gradients are stronger, however when the image is warped too much out of plane, correspondences may be difficult to compute.eg. See result of graf1 and graf2, where the matches detected are poor because of which the affine transformation doesn't give a good result vs wall1 and wall2 which gives better results.

Extra functions:

1. NCC = NCC_gen(feature_coords1,feature_coords2,image1_p,image2_p,s)
given padded images image1_p and image2_p and window half size s for NCC 
along with the features co-ordinates in 1 and 2, computes the normalised 
cross correlation matrix NCC

2.dist_measure = compute_feature_distances(descriptors1,descriptors2)
given two features descriptors computes the distance measure between them
input are the two descriptors descriptor1(mx128) and descriptor2(nx128)
output is the distance measure which is an (mxn) matrix

3.hist = orientation_hist(patch)
creates the gradient oriented histogram from the patch with 8 bins

4.match_features_t1(feature_coords1,feature_coords2,descriptors1,descriptors2,image1,image2)
computes the matching features for image1 and image2 at locations feature_coords1 and feature_coords2 using nx128 dimensional descriptors1 and descriptors2
