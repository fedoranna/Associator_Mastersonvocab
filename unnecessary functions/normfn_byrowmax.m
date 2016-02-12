%% Normalizes each row of a matrix with the rowmaximum

function matrix=normfn_byrowmax(matrix)
maxs=maxrows(matrix);
for i=1:nrows(matrix)
    if maxs(i)==0
        matrix(i,:)= matrix(i,:);
    elseif maxs(i)<0
        minimum = min(matrix(i,:));
        matrix(i,:)= matrix(i,:)/abs(minimum);
    else
        matrix(i,:)= matrix(i,:)/maxs(i);
    end
end