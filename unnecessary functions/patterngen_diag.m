function matrix2 = patterngen_diag(sizeof, radius, neighborhood, direction)

matrix = zeros(sizeof);

if strcmp(direction, 'left')
    for i = 1:nrows(matrix)
        for j = 1:ncols(matrix)
            if i == j
                matrix(i,j) = 1;
            end
        end
    end
end
if strcmp(direction, 'right')
    for j = ncols(matrix) :-1 : 1
        for i = 1:nrows(matrix)
            if i+j == ncols(matrix)+1
                matrix(i,j) = 1;
            end
        end
    end
end

matrix2 = spreading(matrix, radius, neighborhood);

