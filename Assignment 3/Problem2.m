close all 
clear all

%% Part a Depth image formation

I_l = imread('scene_l.bmp');
I_r = imread('scene_r.bmp');

% Baseline and focal length
B = 100;
f_l =400;

[m,n] = size(I_l);
depth_image =zeros(m,n);
disp =zeros(m,n);

for x =16:n-16
    for y =16:m-16
        x_1 = NCC_max(I_l(y-15:y+15,x-15:x+15),I_r,y,x);    
        depth_image(y,x) = B*f_l/((x-x_1)+eps);
        disp(y,x) = (x-x_1);
    end
end
A = 1 ./depth_image;
depth_imageshw = max(max(A(17:end-17,17:end-17)))-A ; 
figure; imshow(depth_imageshw*100);
title('depth image')

figure; imshow(disp,[]);
title('disparity image')

%% Part b Point cloud estimation

Pt_cld_3D = zeros((n-16)*(m-16),3);
count =1 ;

%extracting the 3-D point cloud
for x = 16:n-16
    for y = 16:m-16
        if (depth_image(y,x) <= 8000)
        Pt_cld_3D(count,:) = [x*depth_image(y,x)/f_l,(m-y)*depth_image(y,x)/f_l,depth_image(y,x)];
        count =count+1;
        end
    end
end

%storing as a text file

fid=fopen('3D_point_cloud.txt','w');
fprintf(fid, '%f %f %f \n', Pt_cld_3D');
fclose(fid);
