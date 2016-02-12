% compares two vectors and outputs the number of common elements
% - if there are repetitions, only one of them counts
% - the order of the vectors is not important
% e.g.: v1 = 123, v2= 114, nbof_commonelements(v1,v2) = nbof_commonelements(v1,v2) = 1

function nb = nbof_commonelements(v1, v2)

v1 = unique(v1);
v2 = unique(v2);

isitthere = NaN(size(v1));
for i = 1:numel(v1)
    for j=1:numel(v2)
        isitthere(i) = is_partof(v1(i), v2);
    end
end
nb = sum(isitthere);