function [edge_image_thresh_out,hough_image_out] = p6(edge_image_in,edge_thresh)
%given an edge image as input, thresholds it according to edge threshold
%and computes the hough matrix representation for the image, rho values
%increase across rows and theta values increase along columns


[m,n] = size(edge_image_in);
edge_image_thresh_out =(edge_image_in > edge_thresh);

%resolutions for theta and rho
theta_res = 1/360;
rho_res = 1/500;

theta = -pi/2:pi*theta_res:pi/2;

%for rho range
diag = sqrt(m^2+n^2);

r = zeros(1/rho_res+1,length(theta));
for i=2:m-1
    for j=2:n-1
        
        if(edge_image_in(i,j)>0)
            this = 1;
            
            for k=1:length(theta)    
            cond = -j*sin(theta(k))+i*cos(theta(k));
            rho_sub = ceil((cond+diag)/(2*diag*rho_res));
            r(rho_sub,this) = r(rho_sub,this)+1;
            
            this = this+1;
           
            end
        end   
    end
end

hough_image_out = r.*(1/max(max(r)));
imshow(hough_image_out);

%scaling
imshow(edge_image_thresh_out.*255);