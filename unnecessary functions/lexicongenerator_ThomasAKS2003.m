function P = lexicongenerator_ThomasAKS2003(P)

%% Generates a vocabulary as in Thomas & AKS, 2003

% Returns two matrices: phons and sems


%% Phonetic representation

% 42 phonemes= 24 consonants + 18 vowels

P.phonemes={ 
    '/p/'   ;   '/b/'   ;    '/m/'   ;    '/f/'   ;    '/v/'   ;    '/8/'  ;   '/5/'   ;
    '/sh/'  ;   '/3/'   ;    '/t/'   ;    '/d/'   ;    '/n/'   ;    '/s/'  ;   '/z/'   ;
    '/ch/'  ;   '/d3/'  ;    '/k/'   ;    '/g/'   ;    '/n¬/'  ;    '/h/'  ;   '/l/'   ;
    '/r/'   ;   '/j/'   ;    '/w/'   ;    '/i/'   ;    '/e/'   ;    '/u/'  ;   '/o/'   ;
    '/ae/'  ;   '/^/'   ;    '/aj/'  ;    '/oi/'  ;    '/I/'   ;    '/E/'  ;   '/U/'   ;
    '/O/'   ;   '/au/'  ;    '/o-/'  ;    '/a:/'  ;    '/u8/'  ;    '/E8/' ;   '/&/'   };

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                19 Features
%_Fromkin & Rodman: An introduction to language_______________________________
%| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12| 13| 14| 15| 16| 17| 18| 19|
%----------------------------------------------------------------------------
%| s | c | s | c | v | l | a | + | b | s | n | l | - | h | c | l | r | t | d |
%| o | o | y | o | o | a | n | c | a | t | a | a | c | i | e | o | o | e | i |
%| r | n | l | n | i | b | t | o | c | r | s | t | o | g | n | w | u | n | p |
%| o | s | l | t | c | i | e | r | k | i | a | e | r | h | t |   | n | s | t |
%| n | o | a | i | e | a | r | o |   | d | l | r | o |   | r |   | d | e | h |
%| a | n | b | n | d | l | i | n |   | e |   | a | n |   | a |   | e |   | o |
%| n | a | i | u |   |   | o | a |   | n |   | l | a |   | l |   | d |   | n |
%| t | n | c | a |   |   | r | l |   | t |   |   | l |   |   |   |   |   | g |
%|   | t |   | n |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
%|   | a |   | t |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
%|   | l |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
%-----------------------------------------------------------------------------
% * = these phonemes are the Plunkett & Marchman 1991 phoneme set

consonants = [
    0   1   0   0   0   1   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % 1; '/p/'  spill    *
    
    0   1   0   0   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % 2; '/b/'  bill     *
    
    1   1   0   0   1   1   1   0   0   0   1   0   0   0   0   0   0   0   0 ;   % 3; '/m/'  mill     *
    
    0   1   0   1   0   1   1   0   0   1   0   0   0   0   0   0   0   0   0 ;   % 4; '/f/'  feel     *
    
    0   1   0   1   1   1   1   0   0   1   0   0   0   0   0   0   0   0   0 ;   % 5; '/v/'  veal     *
    
    0   1   0   1   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % 6; '/8/'  thigh    *
    
    0   1   0   1   1   0   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % 7; '/5/'  thy      *
    
    0   1   0   1   0   0   1   0   0   1   0   0   1   1   0   0   0   0   0 ;   % 8; '/sh/' shop
    
    0   1   0   1   1   0   1   0   0   1   0   0   1   1   0   0   0   0   0 ;   % 9; '/3/'  measure
    
    0   1   0   0   0   0   1   1   0   0   0   0   0   0   0   0   0   0   0 ;   % 10; '/t/'  still    *
    
    0   1   0   0   1   0   1   1   0   0   0   0   0   0   0   0   0   0   0 ;   % 11; '/d/'  dill     *
    
    1   1   0   0   1   0   1   1   0   0   1   0   0   0   0   0   0   0   0 ;   % 12; '/n/'  nil      *
    
    0   1   0   1   0   0   1   1   0   1   0   0   0   0   0   0   0   0   0 ;   % 13; '/s/'  seal     *
    
    0   1   0   1   1   0   1   1   0   1   0   0   0   0   0   0   0   0   0 ;   % 14; '/z/'  zeal     *
    
    0   1   0   0   0   0   1   1   0   1   0   0   0   0   0   0   0   0   0 ;   % 15; '/ch/' church
    
    0   1   0   0   1   0   1   1   0   1   0   0   0   0   0   0   0   0   0 ;   % 16; '/d3/' June
    
    0   1   0   0   0   0   0   0   1   0   0   0   0   0   0   0   0   0   0 ;   % 17; '/k/'  skill    *
    
    0   1   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0 ;   % 18; '/g/'  gill     *
    
    1   1   0   0   1   0   0   0   1   0   1   0   0   0   0   0   0   0   0 ;   % 19; '/n¬/' ring     *
    
    1   1   0   1   0   0   0   0   1   0   0   0   0   0   0   0   0   0   0 ;   % 20; '/h/'  high     *
    
    1   1   0   1   1   0   1   1   0   0   0   1   1   0   0   0   0   0   0 ;   % 21; '/l/'  leaf     *
    
    1   0   0   1   1   0   1   1   0   0   0   0   0   0   0   0   0   0   0 ;   % 22; '/r/'  reef     *
    
    1   1   0   1   1   0   0   1   0   0   0   0   1   0   0   0   0   0   0 ;   % 23; '/j/'  you      *
    
    1   0   0   1   1   1   0   0   1   0   0   0   0   0   0   0   0   0   0 ;   % 24; '/w/'  witch    *
    ];

vowels = [
    1   0   1   1   1   0   1   0   0   0   0   0   1   1   0   0   0   1   0 ;   % 1; '/i/' beet      *
    
    1   0   1   1   1   0   1   0   0   0   0   0   1   0   1   0   0   1   1 ;   % 2; '/e/' bait      *
    
    1   0   1   1   1   0   0   0   1   0   0   0   0   1   0   0   1   1   1 ;   % 3; '/u/' boot      *
    
    1   0   1   1   1   0   0   0   1   0   0   0   0   0   1   0   1   1   1 ;   % 4; '/o/' boat      *
    
    1   0   1   1   1   0   1   0   0   0   0   0   1   0   0   1   0   0   0 ;   % 5; '/ae/' bat      *
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   0   1   0   0   0 ;   % 6; '/^/'  but      *
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   0   1   0   0   1 ;   % 7; '/aj/' bite     *
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   1   0   1   1   1 ;   % 8; '/oi/' boy
    
    1   0   1   1   1   0   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % 9; '/I/'  bit      * central changed
    
    1   0   1   1   1   0   1   0   0   0   0   0   0   0   1   0   0   0   0 ;   % 10; '/E/'  bet      *
    
    1   0   1   1   1   0   0   0   1   0   0   0   0   1   1   0   1   0   0 ;   % 11; '/U/' foot      *
    
    1   0   1   1   1   0   0   0   1   0   0   0   0   0   1   0   1   0   0 ;   % 12; '/O/' bought/or *
    
    1   0   1   1   1   0   0   0   1   0   0   0   0   0   0   1   1   0   1 ;   % 13; '/au/' bout/cow *
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   0   1   1   0   0;    % 14; '/o-/' dog
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   0   1   0   0   0;    % 15; '/a:/' bath
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   1   0   0   1   1   1;    % 16; '/u8/' tour
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   1   0   0   1   1;    % 17; '/E8/' hair
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   1   0   0   0   0     % 18; '/&/'  about
    
    ];

nbof_consonants = nrows(consonants);
nbof_vowels = nrows(vowels);
nbof_phonfeat = ncols(consonants);

% Create word-patterns

nbof_CVC = floor(P.vocabsize/3);
nbof_CCV = floor(P.vocabsize/3);
nbof_VCC = P.vocabsize - nbof_CVC - nbof_CCV;

if nbof_consonants * nbof_vowels * nbof_consonants > nbof_CVC*2
    CVC = NaN(0, 3);
    while nrows(CVC) < nbof_CVC
        new = [randchoose(1:nbof_consonants, 1), randchoose(1:nbof_vowels, 1), randchoose(1:nbof_consonants, 1)];
        CVC = [CVC; new];
        CVC = unique(CVC, 'rows');
    end
    CVC_repr = NaN(nbof_CVC, nbof_phonfeat*3);
    for i = 1: nrows(CVC)
        first = consonants(CVC(i, 1), :);
        second = vowels(CVC(i, 2), :);
        third = consonants(CVC(i, 3), :);
        word = [first, second, third];
        CVC_repr(i, :) = word;
    end
else
    'WARNING: vocabulary is too big, there are not enough phonetic representations!'
end

if nbof_consonants * nbof_consonants * nbof_vowels > nbof_CVC*2
    CCV = NaN(0, 3);
    while nrows(CCV) < nbof_CCV
        new = [randchoose(1:nbof_consonants, 1), randchoose(1:nbof_consonants, 1), randchoose(1:nbof_vowels, 1)];
        CCV = [CCV; new];
        CCV = unique(CCV, 'rows');
    end
    CCV_repr = NaN(nbof_CCV, nbof_phonfeat*3);
    for i = 1: nrows(CCV)
        first = consonants(CCV(i, 1), :);
        second = consonants(CCV(i, 2), :);
        third = vowels(CCV(i, 3), :);
        word = [first, second, third];
        CCV_repr(i, :) = word;
    end
else
    'WARNING: vocabulary is too big, there are not enough phonetic representations!'
end

if nbof_vowels * nbof_consonants * nbof_consonants > nbof_CVC*2
    VCC = NaN(0, 3);
    while nrows(VCC) < nbof_VCC
        new = [randchoose(1:nbof_vowels, 1), randchoose(1:nbof_consonants, 1), randchoose(1:nbof_consonants, 1)];
        VCC = [VCC; new];
        VCC = unique(VCC, 'rows');
    end
    VCC_repr = NaN(nbof_VCC, nbof_phonfeat*3);
    for i = 1: nrows(VCC)
        first = vowels(VCC(i, 1), :);
        second = consonants(VCC(i, 2), :);
        third = consonants(VCC(i, 3), :);
        word = [first, second, third];
        VCC_repr(i, :) = word;
    end
else
    'WARNING: vocabulary is too big, there are not enough phonetic representations!'
end

P.Psize = nbof_phonfeat*3;
P.Pact = mean(mean(sum(consonants, 2)), mean(sum(vowels, 2)));

% Code phonological neighbourhood

CVC_recode = CVC;
CVC_recode(:,2) = CVC(:,2) + 24;
CCV_recode = CCV;
CCV_recode(:,3) = CCV(:,3) + 24;
VCC_recode = VCC;
VCC_recode(:,1) = VCC(:,1) + 24;

all = [CVC_recode; CCV_recode; VCC_recode];
phon_closeness = NaN(P.vocabsize, P.vocabsize);
for i = 1:P.vocabsize
    for j = i:P.vocabsize
        phon_closeness(i,j) = nbof_commonelements(all(i,:), all(j,:));
    end
end
for i = 1: P.vocabsize
    phon_closeness(i,i) = NaN;
end

neighbours = NaN(P.vocabsize, 4);
for i = 1:P.vocabsize
    neighbours(i, 1) = sum(phon_closeness(i,:)==0);
    neighbours(i, 2) = sum(phon_closeness(i,:)==1);
    neighbours(i, 3) = sum(phon_closeness(i,:)==2);
    neighbours(i, 4) = sum(phon_closeness(i,:)==3);
end

% Randomize order
orderedphons = [CVC_repr; CCV_repr; VCC_repr];
orderedphons = [orderedphons, all, neighbours];
shuffled = shufflerows(orderedphons);
P.testingphons = shuffled(:, 1:P.Psize);
P.patterns = shuffled(:, P.Psize+1:end-4);
P.phon_neighbours = shuffled(:, end-3:end-1);

%% Semantic representation
% there are P.nbof_prototypes prototypes
% prototypes and actual meanings can be all zeros!
% the Eucledian distance of all prototypes have to be > P.mindistance
% there are no polysemies
% the avergae distance within and between prototype classes is calculated
% NO WARNING WHEN P.mindistance IS TOO HIGH!

% Create prototypes (activate units with the probability of prob)
elements = [ones(1, P.Sact), zeros(1, (P.Ssize-P.Sact))];
nbof_perms = factorial(numel(elements)) / (factorial(P.Sact) * factorial(P.Ssize-P.Sact));

if isnan(nbof_perms) | nbof_perms > P.nbof_prototypes*2 && (P.nbof_prototypes==P.vocabsize | P.looseness>0)
    
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
        
    sems = [sems, classes];
    shuffledsems = shufflerows(sems);
    P.testingsems = shuffledsems(:, 1:P.Ssize);
    P.protcats = shuffledsems(:, end);

else
    'WARNING: vocabulary is too big, there are not enough semantic representations!'
end