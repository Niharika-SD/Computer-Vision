function edge_image_out = p5(image_in)
%takes input as an image and generates the thresholded edge image as
%output. The mask used is the Sobel mask and the thresholding is done by
%the function im2bw

mask = [1 2 1; 0 0 0; -1 -2 -1];

%gradient calculation along x axis
x_grad = conv2(double(image_in),mask, 'same');
x_grad = imresize(x_grad,size(image_in));

%gradient calculation along y axis
y_grad = conv2(double(image_in),mask','same');
y_grad =imresize(y_grad,size(image_in));

%magnitude calculation and thresholding
edge_image_out= uint8(sqrt(x_grad.*x_grad + y_grad.*y_grad));

end