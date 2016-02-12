%% Normalizes each row of a matrix with the rowmaximum

function matrix=normfn_bymatrixmax(matrix)
m = max(matrix(:));
if m==0
    matrix=matrix;
elseif m<0
    minimum = min(matrix(:));
    matrix = matrix/abs(minimum);    
else
    matrix = matrix/m;
end
