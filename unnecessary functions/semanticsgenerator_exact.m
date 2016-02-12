% Generates distributed representtaions
% length = P.Ssize
% number of active features: exactly P.Sact in each word

function [P,D] = semanticsgenerator_exact(P,D)

vocabsize = P.vocabsize;
Ssize = P.Ssize;
Sact = P.Sact;

%% Semantic representation

elements = [ones(1, Sact), zeros(1, (Ssize-Sact))];
nbof_perms = factorial(numel(elements)) / (factorial(Sact) * factorial(Ssize-Sact));

if  nbof_perms < vocabsize
    'Warning: Not enough semantic representations! Set Ssize higher or vocabsize lower (changing Sact might also help)!'
else
    if Ssize < 11
        all = permutations (elements);
        sems = NaN(vocabsize, Ssize);
        order = randperm(nrows(all));
        for i = 1:vocabsize
            sems(i,:) = all(order(i),:);
        end
    end

    if Ssize > 10
        sems = NaN(0, Ssize);
        while nrows(sems) < vocabsize
            newrow = randchoose(elements, Ssize);
            sems = [sems; newrow];
            sems = unique(sems, 'rows'); % unique rendezi is a sorokat novekevo sorrendbe
        end
    end
end

D.testingsems = sems;

%% Rewriting parameters that were used for prototype based semantics

P.Ssize = ncols(sems); % nb of semantic features 120
P.Sact_avg =  sum(sum(sems, 2))/nrows(sems); % avg nb of active semantic features in each prototype 12
P.nbof_prototypes = 0; % nb of semantic prototypes 5
P.mindistance = []; % the minimum Eucledian distance of semantic prototypes; above 37 it takes very long, no warning when not possible!
P.looseness = []; % the looseness of semantic prototype-categories (the probability that an activation is different from that of the prototype)
P.prototypes = [];
P.Sact = [];
