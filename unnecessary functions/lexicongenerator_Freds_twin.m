function [phons, sems] = lexicongenerator_Freds_twin(S)

%% Generates a phonology as in Fred's thesis, Chapter 6 and copies the same to semantics

% Returns two matrices: phons and sems
% size of vocab = 20 words
% phonology: 3 letter words: 5, 5, 4 possible letters
% semantics: the copy of the phonetics matrix

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

sems=phons;
