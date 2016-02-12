%% Collects the rowmaximums of a matrix into a vector

function maxs=maxrows(matrix)
maxs=zeros(1,nrows(matrix));
for i=1:nrows(matrix)
    maxs(i)=max(matrix(i,:));
end
    
   
