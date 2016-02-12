function matfileanalyzator_colours(matfile, param)

load(matfile, 'T', 'P')

R = 0;
G = 0;
B = 0;

for i = 1:numel(P.testingmatrix)
    if P.testingmatrix(i) == 0
        B = B+1;
    elseif P.testingmatrix(i) == 1
        G = G+1;
    elseif P.testingmatrix(i) == 2
        R = R+1;
    end
end

[R,G,B]