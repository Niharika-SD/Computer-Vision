function overlays_out = p4(labels_in, database_in)
%given a database and a labeled image, find's objects in the labels
%matching the database, only roundness is used as a comparison criteria
%because rotational and scaling invariance in matching is desired 

num = database_in(end).objectlabel;
[database_comp, overlays_comp] =p3(labels_in);

num_comp = size(database_comp,1);
count =0; %stores the number of matches found

for i = 1:num-1
    A = database_in(i).roundness;
    if (A >= 0.1)
       %condition for elimination of false edges
      for j= 1:num_comp
          
          %thresholds the roundness comparison
            if(database_comp(j).roundness < (A+0.025) && database_comp(j).roundness > (A-0.025))
                count =count+1;
                centers(count,:) = database_comp(j).center;
                overlays_out(count,:,:) = overlays_comp(j,:,:);
                [~,~,theta] =calculate_min_moment(overlays_out,sum(sum(labels_in)));
                thetas_out(count) =theta;
            end
      end
    end
end

%show background
output_fig =zeros(size(labels_in));

%display overlays
for i= 1:count
    B = overlays_out(i,:,:);
    C = reshape(B,size(B,2),size(B,3));
    output_fig = output_fig +C ;
end

figure; imshow(output_fig)
title('matching overlays displayed as binary masks with centers and orientations')
hold on

%plot center matches
for i = 1:count
    xstart = ceil(centers(i,1));
    ystart = ceil(centers(i,2));
    xfinal = xstart +100;
    yfinal = xfinal*thetas_out(i);
    quiver(xstart,ystart,(xfinal-xstart)/10,(yfinal-ystart)/10,0);
    plot(ceil(centers(i,1)),ceil(centers(i,2)),'Marker','p','Color','r','MarkerSize',2);
    
end
end