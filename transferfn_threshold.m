function output = transferfn_threshold(weightedsum, threshold)
output=NaN(size(weightedsum));
for i = 1:numel(weightedsum)

    if weightedsum(i) > threshold
        output(i) = 1;
    else output(i) = -1;
    end
end
