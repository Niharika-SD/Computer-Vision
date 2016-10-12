function [min_mom, roundness,theta] = calculate_min_moment(overlay,area)
%given the overlay and area, calculates the minimum moment and roundness
%for the object
[center_x,center_y] = calculate_moment(overlay,area);
[a,b,c] = calculate_second_moment(overlay,center_x,center_y,area);
theta = atan2(double(b),double(a-c))/2 ;
min_mom = a*(sin(theta)^2) - b*sin(theta)*cos(theta) + c*(cos(theta)^2);
theta2 = theta + pi/2 ;
max_mom = a*(sin(theta2)^2) - b*sin(theta2)*cos(theta2) + c*(cos(theta2)^2);
roundness = min_mom/max_mom ;
end
