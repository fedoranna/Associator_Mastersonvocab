function [P, D] = semanticsgenerator_prototypes2(P, D)

%% Semantic representation
% there are P.nbof_prototypes prototypes
% actual meanings can be all zeros!
% the Eucledian distance of all prototypes have to be > P.mindistance
% there are no polysemies: all meanings are unique
% the avergae distance within and between prototype classes is calculated
% Changes since previous version:
% - Warning for too high P.mindistance and reset it to lower value
% - Prototypes can only be allzeros if P.Sact = 0
% - There are exactly P.Sact 1s in each prototype (in previous version it was probabilistic)
% - It calculates P.Sact_avg: the average nb of active features in meanings
% - It breaks when creating prototypes or meanings takes too long (more than 10 min) - THIS DOES NOT WORK!

% Create prototypes (activate units with the probability of prob)

% Checking parameter settings
if P.mindistance > 2*min(P.Sact, (P.Ssize-P.Sact))
    P.mindistance = 2*min(P.Sact, (P.Ssize-P.Sact));
    'P.mindistance was too high! It had been reset to the highest possible value.'
end
if P.looseness==0 && P.nbof_prototypes~=P.vocabsize
    P.looseness = rand;
    'P.looseness cannot be 0 with prototype structure! It was set to a higher value.'
end

elements = [ones(1, P.Sact), zeros(1, (P.Ssize-P.Sact))];
nbof_perms = factorial(P.Ssize) / (factorial(P.Sact) * factorial(P.Ssize-P.Sact));
if (isnan(nbof_perms) || nbof_perms > P.nbof_prototypes)
    
    tic
    % Create prototypes
    P.prototypes = zeros(0, P.Ssize);
    while nrows(P.prototypes) < P.nbof_prototypes
        new = elements(randperm(P.Ssize));
        P.prototypes = [P.prototypes; new];
        if nrows(P.prototypes) > 1
            if Eucledian_distance(P.prototypes(end, :), P.prototypes(end-1, :)) < P.mindistance
                P.prototypes(end,:) = [];
            end
        end
        if toc > 600
            'It took too long to generate prototypes. Function was aborted'
            break
        end
    end
    
    % Create actual meanings
    each = floor(P.vocabsize/P.nbof_prototypes);        % the number of meaning in each prototype class
    residual = P.vocabsize - each * P.nbof_prototypes;  % the last class gets the remaining meanings
    
    sems = zeros(0, P.Ssize);
    for i = 1:P.nbof_prototypes
        while nrows(sems) < each * i
            sems = [sems; P.prototypes(i,:)];
            for j = 1:numel(sems(end,:)) % create actual meanings
                if rand < P.looseness
                    sems(end,j) = abs(sems(end, j)-1);
                end
            end
            sems = unique(sems, 'rows'); % make sure there are no polysemies: all meanings are unique
        end
        if toc > 600
            'It took too long to generate prototypes. Function was aborted'
            break
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
        if toc > 600
            'It took too long to generate prototypes. Function was aborted'
            break
        end
    end
    
    % Calculate distance between actual meanings
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
    
    % Randomize order of meanings
    classes = NaN(each, P.nbof_prototypes);
    for i = 1:P.nbof_prototypes
        classes(:,i) = repmat(i, each, 1);
    end
    classes = reshape(classes, P.nbof_prototypes*each, 1);
    classes = [classes; repmat(P.nbof_prototypes, residual, 1)];    
    
    sems = [sems, classes];
    shuffledsems = shufflerows(sems);
    D.testingsems = shuffledsems(:, 1:P.Ssize);
    P.protcats = shuffledsems(:, end);
    P.Sact_avg = mean(sum(D.testingsems, 2));
    
else
    'WARNING: vocabulary is too big, there are not enough semantic representations!'
end


%%
P.words = [];