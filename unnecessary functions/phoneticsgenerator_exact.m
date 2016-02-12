% Generates distributed representations
% length = P.Psize
% number of active features: exactly P.Pact in each word

function [P,D] = phoneticsgenerator_exact(P,D)

vocabsize = P.vocabsize;
Psize = P.Psize;
Pact = P.Pact;

% Phonetic representation

elements = [ones(1, Pact), zeros(1, (Psize-Pact))];
nbof_perms = factorial(numel(elements)) / (factorial(Pact) * factorial(Psize-Pact));

if  nbof_perms < vocabsize
    'Warning: Not enough phonetic representations! Set Psize higher or vocabsize lower (changing Pact might also help)!'
else
    if Psize < 11
        all = permutations (elements);
        phons = NaN(vocabsize, Psize);
        order = randperm(nrows(all));
        for i = 1:vocabsize
            phons(i,:) = all(order(i),:);
        end
    end

    if Psize > 10
        phons = NaN(0, Psize);
        while nrows(phons) < vocabsize
            newrow = randchoose(elements, Psize);
            phons = [phons; newrow];
            phons = unique(phons, 'rows');
        end
    end
end

D.testingphons = phons;
P.Pact_avg = mean(sum(D.testingphons, 2));