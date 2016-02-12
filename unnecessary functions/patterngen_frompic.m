%% Generates pattern from png files
% the basic blue, green and red colours can be used from paint

%%
function matrix = patterngen_frompic(P)

file = [P.folder, num2str(P.pattern_param), '.png'];
pic = imread(file);

matrix = NaN(size(pic, 1), size(pic, 2));

for i = 1:numel(matrix)
    if pic(i)==63 && pic(numel(matrix)+i)==72 && pic(numel(matrix)*2+i)==204 % blue
        matrix(i) = 0;
    elseif pic(i)==34 && pic(numel(matrix)+i)==177 && pic(numel(matrix)*2+i)==76 % green
        matrix(i) = 1;
    elseif pic(i)==237 && pic(numel(matrix)+i)==28 && pic(numel(matrix)*2+i)==36 % red
        matrix(i) = 2;
    end
end


