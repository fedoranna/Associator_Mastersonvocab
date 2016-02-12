function all = permutations(elements)

% Systematic generation of all permutations of the elements of a vector
% If the vector contains unique elements only 
%   -> the result will be permutations without repetitions
% If the vector contains duplicate elements too
%   -> the result will be permutations with repetitions#

if numel(elements) > 10
    'Warning: Too many permutations, this would take forever!'
end

if numel(elements) < 11
    all = perms(elements);
    all = unique(all, 'rows');
end

%nchoosek, permute, randperm, perms