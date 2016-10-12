function labels_out = p2(binary_in)
%Given a binarised input image, performs connected component analysis by sequential labeling
%In the first pass equivalences generated are recorded and resolved in the
%second pass. The algorithm implemented is Union Find where the equivalent
%groups are merged
% Source: http://www.cs.duke.edu/courses/cps100e/fall09/notes/UnionFind.pdf


[m,n] = size(binary_in);
id_vector = reshape(1:m*n,[m,n]);
label_vector_size = ones(m,n);

% Creting a vectorised representation for each pixels storing information about adjacent pixels 
adjacent = @(x) x(:);
    first_index = [adjacent(id_vector(:,1:end-1)); adjacent(id_vector(1:end-1,:))];
    second_index = [adjacent(id_vector(:,2:end)); adjacent(id_vector(2:end,:))];

num = length(first_index);
% Grouping for Union Find
for i = 1: num
    
    %take 2 elements to be compared and label in first pass
    first_root = first_index(i);
  
    while first_root~=id_vector(first_root)
        id_vector(first_root) = id_vector(id_vector(first_root));
        first_root = id_vector(first_root);
    end
    
    %repeating first pass labeling with second element
    second_root = second_index(i);
   
    while second_root~=id_vector(second_root)
        id_vector(second_root) = id_vector(id_vector(second_root));
        second_root = id_vector(second_root);
    end
    
    %checking for conflict
    if (first_root==second_root)
        continue
    end
    
    
    %storing the computed sizes of both groups
    
    if (binary_in(first_root)==binary_in(second_root)) % then merge the two groups
        if  (label_vector_size(first_root) < label_vector_size(second_root));
            id_vector(first_root) = second_root;
            label_vector_size(second_root) = label_vector_size(first_root) + label_vector_size(second_root);
        else
            id_vector(second_root) = first_root;
            label_vector_size(first_root) = label_vector_size(first_root) + label_vector_size(second_root);
        end
    end
end

while (true)
    id_zero = id_vector;
    id_vector = id_vector(id_vector);
    if isequal(id_zero,id_vector), break, end
end


% eliminate NaN values
isNaNI = isnan(binary_in);
id_vector(isNaNI) = NaN;
[id_vector,a,b] = unique(id_vector);
binary_in = 1:length(id_vector);
labels_out = reshape(binary_in(b),[m,n]);
labels_out(isNaNI) = 0;

labels_out = labels_out-ones(size(labels_out));
 end
