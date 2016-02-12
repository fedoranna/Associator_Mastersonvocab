% Generates island patterns for 2 or 3 output neurons
% If there are 2 output neurons then all islands are 1, and the rest is 0
% If there are 3 output neurons then half of the islands are 1, the other
% half is 2 and the sea is 0

function matrix2 = patterngen_islands2(P)

size = [numel(P.inputvalues), numel(P.inputvalues)];
radius = P.pattern_radius;
neighborhood = P.pattern_neigh;
darab = P.pattern_param;

matrix = zeros(size);
chosen = randchoose(1:numel(matrix), darab);

if P.size_O == 2
    matrix(chosen) = 1;
    
end

if P.size_O == 3
    half = round(darab/2);
    matrix(chosen(1:half)) = 1;
    matrix(chosen(half+1:end)) = 2;
end

matrix2 = spreading_islands(matrix, radius, neighborhood);
    