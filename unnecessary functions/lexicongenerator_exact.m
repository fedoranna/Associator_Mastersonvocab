function [phons, sems] = lexicongenerator_exact(vocabsize, Ssize, Sact, Psize, Pact)
%% Generates a vocabulary as in Fred's thesis, Chapter 6

% vocabsize = size of vocab
% phonology: Psize features, exactly Pact active
% semantics: Ssize features, exactly Sact active

%% Phonetic representation

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