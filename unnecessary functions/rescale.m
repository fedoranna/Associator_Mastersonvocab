function O = rescale(I, minimum, maximum)

unit = (maximum-minimum)/(max(I)-min(I));
O = NaN(size(I));

for i = 1:length(I)
    O(i) = minimum + unit * (I(i)-min(I));
end



