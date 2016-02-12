%% Collects the rowminimums of a matrix into a vector

function mins=minrows(matrix)
mins=zeros(1,nrows(matrix));
for i=1:nrows(matrix)
    mins(i)=min(matrix(i,:));
end
    
   
