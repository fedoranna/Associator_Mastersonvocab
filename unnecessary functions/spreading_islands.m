function matrix2 = spreading_islands(matrix, radius, neighborhood)

h = 0;
v = 0;
d = 0;

if neighborhood == '+'
    h = radius;
    v = radius;
    d = 0;
end
if neighborhood == 'x'
    h = 0;
    v = 0;
    d = radius;
end
if neighborhood == '*' 
    h = radius;
    v = radius;
    d = radius;
end

matrix2 = matrix;

for i = 1:nrows(matrix)
    for j = 1:ncols(matrix)
        if matrix(i,j) > 0
            for r = 0:radius
                if h>0
                    if i+r <= nrows(matrix)
                        matrix2(i+r, j) = matrix(i,j);
                    end
                    if i-r > 0
                        matrix2(i-r, j) = matrix(i,j);
                    end
                end
                if v>0
                    if j+r <= ncols(matrix)
                        matrix2(i, j+r) = matrix(i,j);
                    end
                    if j-r > 0
                        matrix2(i, j-r) = matrix(i,j);
                    end
                end
                if d>0
                    if i-r > 0 && j-r > 0
                        matrix2(i-r, j-r) = matrix(i,j);
                    end
                    if i-r > 0 && j+r <= ncols(matrix)
                        matrix2(i-r, j+r) = matrix(i,j);
                    end
                    if i+r <= nrows(matrix) && j-r > 0
                        matrix2(i+r, j-r) = matrix(i,j);
                    end
                    if i+r <= nrows(matrix) && j+r <= ncols(matrix)
                        matrix2(i+r, j+r) = matrix(i,j);
                    end
                end
                if neighborhood == 'o'
                    if i-r > 0 
                        sortol = i-r;
                    end
                    if j-r > 0 
                        oszloptol = j-r;
                    end
                    if i+r <= nrows(matrix) 
                        sorig = i+r;
                    end
                    if j+r <= ncols(matrix)
                        oszlopig = j+r;
                    end 
                    matrix2(sortol:sorig, oszloptol:oszlopig) = matrix(i,j);
                end
            end
        end
    end
end
