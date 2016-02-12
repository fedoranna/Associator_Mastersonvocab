function [composition, matrix] = pic_analyzator(picfile)

pic = imread(picfile);

matrix = NaN(size(pic, 1), size(pic, 2));
for i = 1:numel(matrix)
    if pic(i)==63 && pic(numel(matrix)+i)==72 && pic(numel(matrix)*2+i)==204        % blue
        matrix(i) = 0;
    elseif pic(i)==34 && pic(numel(matrix)+i)==177 && pic(numel(matrix)*2+i)==76    % green
        matrix(i) = 1;
    elseif pic(i)==237 && pic(numel(matrix)+i)==28 && pic(numel(matrix)*2+i)==36    % red
        matrix(i) = 2;
    end
end

all = size(pic, 1) * size(pic, 2);

blues = 0;
greens = 0;
reds = 0;
whites = 0;
for i=1:numel(matrix)
    if matrix(i) == 0
        blues = blues + 1;
    end
    if matrix(i) == 1
        greens = greens + 1;
    end
    if matrix(i) == 2
        reds = reds + 1;
    end
    if isnan(matrix(i))
        whites = whites + 1;
    end
end

composition = NaN(1,5);
composition(1) = (blues/all)*100;
composition(2) = (greens/all)*100;
composition(3) = (reds/all)*100;
composition(4) = sum(composition(1:3));
composition(5) = (whites/all)*100;









