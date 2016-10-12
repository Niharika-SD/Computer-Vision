function [a,b,c] = calculate_second_moment(overlay ,x_mean,y_mean,area)
%given the overlay and x and y mean positions with the area, calculates the
%second moment terms a,b and c for the overlay
[n,m] = size(overlay);
a =0;
b =0;
c =0;
for i= 1:n
    for j = 1:m
    a = a+ (j-x_mean)^2 * overlay(i,j) ;
    c = c+ (i-y_mean)^2 * overlay(i,j) ;
    b = b+ (i-y_mean)*(j- x_mean)*overlay(i,j) ;
    end
end
a = a/area ;
b = 2*b/area;
c = c/area;
end