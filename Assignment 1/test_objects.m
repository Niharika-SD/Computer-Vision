clear all
close all

%reading the test image
img = imread('two_objects.pgm');
figure; imshow(img,[]);
title('input image');

%% Question I Part I: Binary Thresholding
%thresholding the test image and displaying the result
binary_in = p1(img,100);
figure;imshow(binary_in);
title('binarised image');

%% Question I Part II: Connected Components Labeling

labels_out = p2(binary_in);
maximum = max(max(labels_out));
figure;imshow(labels_out/maximum,[]);

%% Question I Part III Image Database
[database_out, overlays_out] = p3(labels_out);
 
%% Question I Part IV Object Detection

img_comp1 = imread('many_objects_1.pgm');
binary_1 = p1(img_comp1,100);
figure;imshow(binary_1,[]);
title('binarised image for manyobjects1 image');
labels_in = p2(binary_1);
overlays_out_1 = p4(labels_in, database_out);


img_comp2 = imread('many_objects_2.pgm');
binary_2 = p1(img_comp2,100);
figure;imshow(binary_2,[]);
title('binarised image for manyobjects2 image');
labels_in_2 = p2(binary_2);
overlays_out_2 = p4(labels_in_2, database_out);
