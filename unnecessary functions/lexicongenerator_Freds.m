function [phons, sems] = lexicongenerator_Freds(S)

%% Generates a vocabulary as in Fred's thesis, Chapter 6

% Returns two matrices: phons and sems
% S = number of units in the semantic representation
% size of vocab = 20 words
% phonology: 3 letter words: 5, 5, 4 possible letters
% semantics: S > 4 nominal semantic features randomly generated for each word
% WARNING: S must be > 4 otherwise there are not enough semantic representations and the function goes into infinite loop

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

%S = 5; % number of units in the semantic representation (originally 40); must be > 4
prob = 0.1; % the probability of each unit to be active (originally 0.1)
nbof_min = 2; % the minimum number of units that have to be active in each word (originally 2)

% Activate units with the probability of prob
sems = zeros(length(words), S);
for i=1:numel(sems)    
    if rand < prob sems(i)=1; end
end

% Makes sure that there are enough active units in each word: activates more units
for i=1:length(words)
    while sum(sems(i,:)) < nbof_min
        sems(i,randchoose(1:S,1)) = 1;
    end
end

% Makes sure that there are no identical semantic representations, like nyúl
translation =[];
for i=1:length(words)
    translation=[translation, bin2dec(num2str(sems(i,:)))];
end
sorted=sort(translation, 'descend');
rest = 1:(2^S);
for i=1:length(words) % deletes the numbers already used from rest
    if i==1
        prev=sorted(i);
        rest(prev)=[];
    end
    if i>1
        if sorted(i) ~= prev
            prev=sorted(i);
            rest(prev)=[];
        end
    end
end

for i=1:length(words)
    equals=0;
    for j=1:length(words)
        equals = equals + isequal(sems(i,:), sems(j,:));
    end
    if equals > 1 % if there are duplicates, they have to be changed
        y=randchoose(rest,1);
        for j=1:length(rest) % delete y from rest
            if rest(j)==y
                rest(j)=[];
                break
            end
        end
        x=dec2bin(y);
        while length(x)<S x=['0' x]; end
        for j=1:S sems(i, j) = str2num(x(j)); end
        
        while sum(sems(i,:)) < nbof_min % if there are not enough active units, repeat above process
            y=randchoose(rest,1);
            for j=1:length(rest) % delete y from rest
                if rest(j)==y
                    rest(j)=[];
                    break
                end
            end
            x=dec2bin(y);
            while length(x)<S x=['0' x]; end
            for j=1:S sems(i, j) = str2num(x(j)); end
        end        
    end
end;
