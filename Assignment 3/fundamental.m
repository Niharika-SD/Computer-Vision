close all
clear all

%% Part a

I_l = imread('hopkins1.JPG');
I_r = imread('hopkins2.JPG');

%computing Sift features
[f_l,d_l] =vl_sift(single(rgb2gray(I_l)));
[f_r,d_r] =vl_sift(single(rgb2gray(I_r)));

%matching sift features
[m,n,p] = size(I_l);
[matches, scores] = vl_ubcmatch(d_l, d_r,2.5);

I= [I_l,I_r];
figure;imshow(I);
title('Feature matching using sift')
hold on

x_l =zeros(size(matches,2),1);
y_l =zeros(size(matches,2),1);
x_r =zeros(size(matches,2),1);
y_r =zeros(size(matches,2),1); 

for i=1:size(matches,2)
    x_l(i) = ceil(f_l(1,matches(1,i)));
    y_l(i) = ceil(f_l(2,matches(1,i)));
    x_r(i) = ceil(f_r(1,matches(2,i)));
    y_r(i) = ceil(f_r(2,matches(2,i)));
    plot([x_l(i),(n+x_r(i))],[y_l(i),y_r(i)],'r'); 
end

%% Part b Fundamental matrix estimation

F = compute_fund_matrix(x_l,x_r,y_l,y_r);
 
%homogenising co-ordinates 
P_l = vertcat(x_l',y_l',ones(size(x_l')));
P_r = vertcat(x_r',y_r',ones(size(x_r')));

%% Part c Epipolar lines

[epiLines_1,epiLines_2] = EpipolarLines(F, P_l,P_r);
points_1 = lineToBorderPoints(epiLines_1', size(I_r));
x = randi(size(points_1,1),[1,8]);
figure;subplot(1,2,1);imshow(I_l,'DisplayRange',[])
title('Feature points in image 1')
hold on
for i=1:8
    plot(P_l(1,x(i)),P_l(2,x(i)),'.');
end
hold off
subplot(1,2,2);imshow(I_r,'DisplayRange',[])
line(points_1(x, [1,3])', points_1(x, [2,4])');
hold on
title('Epipolar Lines in image 2, intersection gives the epipole')
hold off

