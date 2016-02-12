function matrix2 = patterngen_diag2(P)

size = [numel(P.inputvalues), numel(P.inputvalues)];
radius = P.pattern_radius;
neighborhood = P.pattern_neigh;
direction = P.pattern_param;

matrix = zeros(size);


for i = 1:nrows(matrix)
    for j = 1:ncols(matrix)
        if i == j
            matrix(i,j) = 1;
        end
        if P.size_O == 3 % the upper trianngle = 3
            if i < j
                matrix(i,j) = 2;
            end
        end
    end
end

if strcmp(direction, 'right') % mirror
    mirrored = matrix;
    for i = 1:nrows(matrix)
        for j = 1:ncols(matrix)
            mirrored(i, end-(j-1)) = matrix(i,j);
        end
    end
    matrix = mirrored;    
end

matrix2 = spreading_diag(matrix, radius, neighborhood);