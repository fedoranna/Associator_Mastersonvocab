function O = matfileanalyzator_Assoc_numberoferrors(matfile, param)

load(matfile, 'P', 'R', 'T', 'D');

T = CategorizeErrors_rounded(T, D, P);

for i = 1:size(T.mainerrortypes,1)
    if T.mainerrortypes(i,2) == max(T.mainerrortypes(:,2))
        best = i;
    end
end
score = abs(50 - T.mainerrortypes(best,1)) + abs(25 - T.mainerrortypes(best,2)) + abs(25 - T.mainerrortypes(best,5));

where = nrows(xlsread(P.resultsfile, 'errors'))+1;
tosave = {
    P.ID,
    % Main results
    R.vocab_SS,
    R.vocab_PP,
    R.vocab_SP,
    R.vocab_PS,
    R.completed_epochs,   
    P.Ssize,
    P.Sact,
    P.nbof_prototypes,
    P.mindistance,
    P.looseness,
    P.semdist_withinclasses,
    P.semdist_betweenclasses,
    P.Sact_avg,
    P.Psize,
    P.Pact_avg,
    % Architecture
    P.size_SH,
    P.size_PH,
    P.size_AR,
    P.size_AL,
    func2str(P.errorcatfn),  
    % Errors
    T.mainerrortypes(best,1), % 1: correct, 2: S, 3: P, 4: mixed, 5: other
    T.mainerrortypes(best,2),
    T.mainerrortypes(best,3),
    T.mainerrortypes(best,4),
    T.mainerrortypes(best,5),
    score
    };

% Save summary of results to an excel file
xlswrite(P.resultsfile, tosave', 'errors', ['A', num2str(where)]);
O = 1;
