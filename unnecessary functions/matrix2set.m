%% Generates a training or testing set from a pattern matrix

function set = matrix2set(matrix, values)

set = NaN(numel(matrix), 4);
k = 0;
for j = 1:ncols(matrix)
    for i = 1:nrows(matrix)    
        k = k+1;
        set(k, 1) = values(i);
        set(k, 2) = values(j);
        set(k, 3) = matrix(i,j);    
        set(k, 4) = abs(set(k, 3) - 1);
    end
end