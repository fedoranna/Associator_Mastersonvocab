function newmatrix = shufflerows(oldmatrix)

newmatrix = NaN(size(oldmatrix));
neworder = randperm(nrows(oldmatrix));
for i = 1:nrows(oldmatrix)
    newmatrix(i, :) = oldmatrix(neworder(i), :);
end