function [epl1,epl2] = EpipolarLines(F,x_1,x_2)
%with the fundamental matrix and the points in both images as input,
%computes the epipolar lines eli1 and eli2

epl1 = F' * x_2;
epl2 = F * x_1;
end