function indices = which_row(M, v)

indices = NaN(0,1);
for i = 1:nrows(M)
    if M(i,:) == v
        indices = [indices, i];
    end
end