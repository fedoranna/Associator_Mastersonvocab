% randomly reorders a string or vector

function neworder = reorder(oldorder)

order = randperm(length(oldorder));
neworder = oldorder;

for i = 1:length(neworder)
    neworder(i) = oldorder(order(i));
end