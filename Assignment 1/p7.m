function [line_image_out] = p7(image_in,hough_image_in,hough_thresh)
%given a hough image for an input image and a threshold plots lines
%recognised by the threshold on the input image named image_in

[m,n] = size(image_in);
[M,N]=size(hough_image_in);

theta_res = 1/360;
rho_res = 1/500;

%rho and theta span
theta = -pi/2:pi*theta_res:pi/2;
diagonal = sqrt(m^2+n^2);

%initialise empty matrix
matrix_store = [];
for i=1:M
    for j=1:N
        if(hough_image_in(i,j)>hough_thresh)
            x = ((i*2*diagonal*rho_res)-diagonal+ n*sin(theta(j)))/cos(theta(j));
            y = ((i*2*diagonal*rho_res)-diagonal)/(cos(theta(j)));
            matrix_store = [matrix_store ;n y 0 x];
        end
    end
end
matrix_store;

line_image_out = insertShape(image_in,'line',matrix_store,'color','yellow');
end