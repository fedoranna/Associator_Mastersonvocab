function O = matfileanalyzator_errors(matfile, param)

load(matfile, 'T');
m = max(T.mainerrortypes); % 1: correct, 2: S, 3: P, 4: mixed, 5: other
O = m(3);
