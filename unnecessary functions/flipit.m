% flips a matrix along the vertical axis

function flipped = flipit(orig)

flipped = orig;
for i = 1:nrows(orig)
    flipped(i, :) = orig((nrows(orig)-i+1), :);
end

