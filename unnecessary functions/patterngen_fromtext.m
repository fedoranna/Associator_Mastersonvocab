% Generates patterns from text files
% in the file each row is a blob
% must start at row 5

function matrix = patterngen_fromtext(P)

size = [numel(P.inputvalues), numel(P.inputvalues)];
matrix = zeros(size);

file = [P.folder, num2str(P.pattern_param), '.txt'];
pattern = dlmread(file, ' ', 4, 0);
darab = nrows(pattern);

if P.size_O == 2
    for i = 1:darab
        for j = 1:ncols(pattern)
            if pattern(i,j) > 0
                matrix(pattern(i,j)) = 1;
            end
        end
    end
end

if P.size_O == 3
    half = round(darab/2);    
    for i = 1:half
        for j = 1:ncols(pattern)
            if pattern(i,j) > 0
                matrix(pattern(i,j)) = 1;
            end
        end
    end
    for i = (half+1):darab
        for j = 1:ncols(pattern)
            if pattern(i,j) > 0
                matrix(pattern(i,j)) = 2;
            end
        end
    end
end