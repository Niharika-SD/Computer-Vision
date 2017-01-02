load('depth_image.mat')

A = 1 ./depth_image;
depth_imageshw = max(max(A(17:end-17,17:end-17)))-A ; 
figure; imshow(depth_imageshw*100);
title('depth image')