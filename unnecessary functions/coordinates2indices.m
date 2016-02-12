% Transforms matrix coordinates to indices
% coordinates: as in xy coordinate system
% indices: as MatLab matrix indices
% e.g., if indices are:
% |1 4 7 10
% |2 5 8 11
% |3 6 9 12
% ----------
% (2,1) -> 6

function indices = coordinates2indices(x, y, sorok, oszlopok)

indices = zeros(1, numel(x));

for i = 1:numel(x)
    indices(i) = (x-1) * sorok + (sorok-y+1);
end

