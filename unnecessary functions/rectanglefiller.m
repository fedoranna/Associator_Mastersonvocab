% rectanglefiller

size = 50;
TR = 10;
BR = 21;
LC = 15;
RC = 26;

rectangle1 = [];

for c = LC:RC
    for r = TR:BR
        rectangle1 = [rectangle1, (c-1)*50+r];
    end
end

numel(rectangle1)
%%

TR = 29;
BR = 40;
LC = 26;
RC = 37;

rectangle2 = [];

for c = LC:RC
    for r = TR:BR
        rectangle2 = [rectangle2, (c-1)*50+r];
    end
end

numel(rectangle2)

%%
P.trainingmatrix(rectangle1) = P.testingmatrix(rectangle1);
P.trainingmatrix(rectangle2) = P.testingmatrix(rectangle2);

P.trainingset = matrix2set2(P.trainingmatrix, P.inputvalues, P.size_O);
for i = nrows(P.trainingset) : -1 : 1
    if isnan(P.trainingset(i,3)) 
        P.trainingset(i,:) = [];
    end
end

%%

plotmatrix(P.trainingmatrix, 1:50, 1:50)
axis ij
axis square
%%
matrix = zeros(size, size);
matrix(rectangle1) = 1;
matrix(rectangle2) = 1;

%%

ID = '2012-05-17-17-28-02'; % around
%ID = '2012-05-17-10-12-03'; % between

filename = [P.folder, ID, '.mat'];
F = load(filename, 'P');
P.trainingmatrix = F.P.trainingmatrix;
P.trainingset = F.P.trainingset;
P.testingmatrix = F.P.testingmatrix;
P.testingset = F.P.testingset;

'done'

