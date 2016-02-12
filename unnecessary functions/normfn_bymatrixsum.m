%% Normalizes a matrix with the matrixsum

function matrix=normfn_bymatrixmax(matrix)
s = sum(matrix(:));
if s==0
    matrix=matrix;
elseif s<0
    matrix = matrix/abs(s);  
else
    matrix = matrix/s;
end