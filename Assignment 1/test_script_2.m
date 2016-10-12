clear all
close all

image_in = imread('hough_simple_1.pgm');

%% Question II Part I Edge Detection

edge_image_out = p5(image_in);
figure; imshow(edge_image_out,[]);
title('Edge Image')

%% Question II Part II Hough Array Generation

[edge_image_thresh_out, hough_image_out] = p6(edge_image_out,100);
figure;imshow(edge_image_thresh_out,[])
figure;imshow(hough_image_out.*255/max(max(hough_image_out)),[])
title('Hough Array')
xlabel('theta (radians)')
ylabel('rho')

%% Question II Part III  Hough lines mapping

line_image_out = p7(image_in, hough_image_out ,0.95);
figure;imshow(line_image_out)

