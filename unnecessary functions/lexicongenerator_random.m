%% Generates a random lexicon

% Localist, orthogonal representation
% Generates a "forms" and a "meanings" matrix
% Both matrices are composed from 1s and 0s; there is only one 1 in each row
% forms: diagonal matrix of size=n*n; 
% meanings: has the rows of forms randomly permuted

%%
function  [forms, meanings]=lexicongenerator_random(n)
forms=diag(ones(n,1));
meanings=zeros(n,n);
pairing=randperm(n);
for i=1:n
    meanings(i,:)=forms(pairing(i),:);
end


