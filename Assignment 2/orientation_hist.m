function hist = orientation_hist(patch)
%creates the gradient oriented histogram from the patch with 8 bins

mask = [-1 0 1; -1 0 1; -1 0 1];
hist =zeros(1,8);
  
I_x = conv2(double(patch),mask, 'same');
Ix_2 = I_x.^2 ;

I_y = conv2(double(patch),mask', 'same');
Iy_2 = I_y.^2;

%bring angles in range -pi to pi
ang = atan2(I_y,I_x) + pi;
mag = sqrt(Ix_2+Iy_2);

for i =1:size(hist,2)
    %create histogram using angle range
    ang_pick = mag((ang>(i-1)*pi/4)& (ang <(i)*pi/4));
    hist(1,i) = sum(sum(ang_pick));
end

end
