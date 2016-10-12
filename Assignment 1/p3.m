function [database_out, overlays_out] = p3(labels_in)
%Takes the input as the labeled image and number of labels and outputs an array of structures as the database and an array of object overlays
%The fields of the database include the object label, moment(a 2D vector
%with x and y position), the minimum moment and the roundness
num = max(max(labels_in));
for i = 1:num-1
   overlays_out(i,:,:) = double(labels_in == i); 
   A = double(labels_in == i);
   database_out(i,:,:).objectlabel = i;
   area = sum(sum(A));
   
   [x_center,y_center] = calculate_moment(A,area);
   database_out(i,:,:).center = [x_center,y_center] ;
   
   [database_out(i,:,:).min_moment database_out(i,:,:).roundness] = calculate_min_moment(A,area);

end


end
