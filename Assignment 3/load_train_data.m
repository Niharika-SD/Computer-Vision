function [des,feat] = load_train_data(flag)
%loads the features and descriptors for each image using sift, set flag to 0 for train and to 1 for test

if (flag ==0) 
   datafolder = '/home/shimona/Documents/sem1/CV/assignments/Assignment 3/CV_Assignment3/train/';
else
   datafolder = '/home/shimona/Documents/sem1/CV/assignments/Assignment 3/CV_Assignment3/test/';    
end
listname = dir([datafolder '*/*.jpg']);

des = [];
feat =[];
for k =1:size(listname,1)
    image = imread(strcat(listname(k).folder,'/',listname(k).name));
    
    %check rgb condition
    if (size(image,3)==3)
        image = single(imresize(rgb2gray(image),0.25,'Antialiasing',true));
    else
        image = single(imresize(image,0.25,'Antialiasing',true));
    end
    
    [f,d] = vl_sift(image);
    %feat(k).f =f;
    feat(k).d =d';
    des = vertcat(des,d');
end

end
