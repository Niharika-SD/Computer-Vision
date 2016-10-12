function [x,y] = calculate_moment(overlay,area)
%given the overlay and the area calculates the mean positions at x and y
%for the object
[n,m] = size(overlay);
x = 0;
y = 0;
for i= 1:n
    for j =1:m
    x = x + overlay(i,j)*j;
    y = y + overlay(i,j)*i;
    end
end
x = x/area;
y = y/area;
end