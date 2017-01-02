function [ rows,cols ] = detect_features(image)
    %%%
	% Computer Vision 600.461/661 Assignment 2
	% Args:
	% 	image (ndarray): The input image to detect features on. Note: this is NOT the image name or image path.
	% Returns:
	% 	rows: A list of row indices of detected feature locations in the image
    % 	cols: A list of col indices of detected feature locations in the image
	%%%
    
    if size(image,3) == 3
        image1 = rgb2gray(image);
    else
        image1 = image;
    end
    
    image1 = im2double(image1);
    %computing gradients and average gradient images using smoothing Gaussian filter
    sigma = 2;
    mask = [-1 0 1; -1 0 1; -1 0 1];
    
    I_x = conv2(double(image1),mask, 'same');
    Ix_2 = conv2(I_x.^2 ,fspecial('gaussian',max(1,fix(6*sigma)), sigma),'same');
    
    I_y = conv2(double(image1),mask', 'same');
    Iy_2 = conv2(I_y.^2, fspecial('gaussian',max(1,fix(6*sigma)), sigma), 'same');
    
    Ix_Iy = conv2(I_y.*I_x, fspecial('gaussian',max(1,fix(6*sigma)), sigma), 'same');
    
    corner_measure = (Ix_2.*Iy_2 - Ix_Iy.^2)./(Ix_2 + Iy_2 + eps);
    %eps prevents the denominator from going to zero
    
    threshold = 0.05;
    radius = 1;
    
    %threshold the corner image
    [rows,cols] = nonmaxsuppts(corner_measure, radius, threshold, image);    
end

