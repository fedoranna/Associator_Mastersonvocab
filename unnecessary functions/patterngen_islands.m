function matrix2 = patterngen_islands(size, radius, neighborhood, darab)

matrix = zeros(size);
chosen = randchoose(1:numel(matrix), darab);

matrix(chosen) = 1;
matrix2 = spreading(matrix, radius, neighborhood);

    