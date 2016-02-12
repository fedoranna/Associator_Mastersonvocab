function [phons, sems] = lexicongenerator_Freds_exact(S)

%% Generates a vocabulary as in Fred's thesis, Chapter 6 but exactly 3 units will be active in the semantic representation

% Returns two matrices: phons and sems
% size of vocab = 20 words
% phonology: 3 letter words: 5, 5, 4 possible letters; 
%   14 units, exactly 3 active
% semantics: S > 5 nominal semantic features randomly generated for each word
%   S units, exactly 3 active

%% Phonetic representation

words = {'bad', 'ber', 'bir', 'bor', 'gar', 'gin', 'god', 'gun', 'ped', 'piw', 'pow', 'pur', 'sad', 'sew', 'sod', 'sun', 'tan', 'tar', 'tid', 'ton'}; 
P = 14; % nb of units for the phonological representation: 5+5+4

phons = zeros(length(words), P); % each row is a word
for i=1:length(words)
    if words{i}(1) == 'b' phons(i, 1)=1; end
    if words{i}(1) == 'g' phons(i, 2)=1; end
    if words{i}(1) == 'p' phons(i, 3)=1; end
    if words{i}(1) == 's' phons(i, 4)=1; end
    if words{i}(1) == 't' phons(i, 5)=1; end
    
    if words{i}(2) == 'a' phons(i, 6)=1; end
    if words{i}(2) == 'e' phons(i, 7)=1; end
    if words{i}(2) == 'i' phons(i, 8)=1; end
    if words{i}(2) == 'o' phons(i, 9)=1; end
    if words{i}(2) == 'u' phons(i,10)=1; end
    
    if words{i}(3) == 'd' phons(i,11)=1; end
    if words{i}(3) == 'n' phons(i,12)=1; end
    if words{i}(3) == 'r' phons(i,13)=1; end
    if words{i}(3) == 'w' phons(i,14)=1; end
end

%% Semantic representation

actives = 3;
elements = [ones(1, actives), zeros(1, (S-actives))];

nbof_perms = factorial(numel(elements)) / (factorial(actives) * factorial(S-actives));

if  nbof_perms < numel(words)
    'Warning: Not enough semantic representations! Set S higher!'
end

if S < 11
    all = permutations (elements);
    sems = NaN(numel(words), S);
    order = randperm(nrows(all));
    for i = 1:numel(words)
        sems(i,:) = all(order(i),:);
    end
end

if S > 10
    sems = NaN(0, S);
    while nrows(sems) < numel(words)
        newrow = randchoose(elements, S);
        sems = [sems; newrow];
        sems = unique(sems, 'rows');
    end
end