function [P, D] = semanticsgenerator_prototypes(P, D)

%% Semantic representation
% NOT COMPATIBLE WITH ASSOCIATOR22
% there are P.nbof_prototypes prototypes
% prototypes and actual meanings can be all zeros!
% the Eucledian distance of all prototypes have to be > P.mindistance
% there are no polysemies
% the avergae distance within and between prototype classes is calculated
% NO WARNING WHEN P.mindistance IS TOO HIGH!

% Create prototypes (activate units with the probability of prob)
elements = [ones(1, P.Sact), zeros(1, (P.Ssize-P.Sact))];
nbof_perms = factorial(P.Ssize) / (factorial(P.Sact) * factorial(P.Ssize-P.Sact));

if isnan(nbof_perms) || nbof_perms > P.nbof_prototypes*2 && (P.nbof_prototypes==P.vocabsize || P.looseness>0)
    
    % Create prototypes
    prob = P.Sact/P.Ssize;
    P.prototypes = zeros(0, P.Ssize);
    while nrows(P.prototypes) < P.nbof_prototypes        
        P.prototypes = [P.prototypes; zeros(1, P.Ssize)];
         for i = 1:P.Ssize
             if rand < prob
                 P.prototypes(end, i) = 1;
             end
         end
        if nrows(P.prototypes) > 1
            if Eucledian_distance(P.prototypes(end, :), P.prototypes(end-1, :)) < P.mindistance
                P.prototypes(end,:) = [];
            end
        end
    end
    
    % Create actual meanings
    each = floor(P.vocabsize/P.nbof_prototypes);
    residual = P.vocabsize - each * P.nbof_prototypes;
    
    sems = zeros(0, P.Ssize);
    for i = 1:P.nbof_prototypes
        while nrows(sems) < each * i
            sems = [sems; P.prototypes(i,:)];
            for j = 1:numel(sems(end,:)) % create actual meanings
                if rand < P.looseness
                    sems(end,j) = abs(sems(end, j)-1);
                end
            end
            sems = unique(sems, 'rows'); % make sure there are no polysemies
        end
    end
    while nrows(sems) < P.vocabsize
        sems = [sems; P.prototypes(end,:)];
        for j = 1:numel(sems(end,:)) % create actual meanings
            if rand < P.looseness
                sems(end,j) = abs(sems(end, j)-1);
            end
        end        
        sems = unique(sems, 'rows'); % make sure there are no polysemies
    end
    
    % Check distance between actual meanings
    sem_distance = zeros(P.vocabsize, P.vocabsize);
    for i = 1:P.vocabsize
        for j = i:P.vocabsize
            sem_distance(i,j) = Eucledian_distance(sems(i,:), sems(j,:));
        end
    end    
    semdist_withinclasses = [];
    semdist_bwclasses = [];
    for p = 1:P.nbof_prototypes-1
        for i = each*(p-1)+1 : each*p
            for j = i+1 : P.vocabsize
                if j < each*p+1
                    semdist_withinclasses = [semdist_withinclasses, sem_distance(i,j)];
                else
                    semdist_bwclasses = [semdist_bwclasses, sem_distance(i,j)];
                end
            end
        end
    end
    for p = P.nbof_prototypes
        for i = each*(p-1)+1 : P.vocabsize
            for j = i+1 : P.vocabsize
                semdist_withinclasses = [semdist_withinclasses, sem_distance(i,j)];
            end
        end
    end
    P.semdist_withinclasses = mean(semdist_withinclasses);
    P.semdist_betweenclasses = mean(semdist_bwclasses);    
    
    % Randomize order
    classes = NaN(each, P.nbof_prototypes);
    for i = 1:P.nbof_prototypes
        classes(:,i) = repmat(i, each, 1);
    end
    classes = reshape(classes, P.nbof_prototypes*each, 1);
    classes = [classes; repmat(P.nbof_prototypes, residual, 1)];
        
    % Randomize order of words
    sems = [sems, classes];
    shuffledsems = shufflerows(sems);
    D.testingsems = shuffledsems(:, 1:P.Ssize);
    P.protcats = shuffledsems(:, end);

else
    'WARNING: vocabulary is too big, there are not enough semantic representations!'
end

%%
P.words = [];