%% Where is the first NaN element in a matrix?
% outputs the index of the first NaN element of a matrix
% indices go from 1st column top-> down, 2nd column...

function answer = firstnan(matrix)

for i=1:numel(matrix)
    if isnan(matrix(i)) == 1
        answer = i;
        break
    end
end