% Categorizes errors of the Associator model

function [phonemelevel, wordlevel] = categorize_errors(activation, targetword, P)
%% Phoneme-level categories

usedphonemes = P.usedphonemes;

phonemelevel = NaN(3, 4);
differences = NaN(nrows(usedphonemes), 1);
for i = 1:3 % for each phoneme in the word
    output = frameslider(activation, 19, i);
    
    %Fred's way: based on closest used phoneme
    for j = 1:nrows(usedphonemes)
        differences(j) = Eucledian_distance_normalized(output, usedphonemes(j,:));
    end
    uncertainty = min(differences);
    which = which_row(differences, uncertainty);
    attempted_phoneme = usedphonemes(which,:);
    
    % My idea: based on rounded bits - does not work with word categorization below
%     uncertainty = binarizationfactor(output);    
%     attempted_phoneme = round(output);
%     which = which_row(usedphonemes, attempted_phoneme);
%     if length(which) == 0
%         which = 0;
%     end
    
    % Consonant or vowel?
    type = attempted_phoneme(3); 
    
    % Correct or not?
    if sum(attempted_phoneme == frameslider(targetword, 19, i))==19
        correctness = 1;
    else
        correctness = 0;
    end        
    
    phonemelevel(i,1) = uncertainty; % certain: 0.1, uncertain: 0.2, 0.3, nophoneme: 0.4, 0.5
    phonemelevel(i,2) = which;       % which poneme was attempted (number of rows in usedphonemes)
    phonemelevel(i,3) = correctness; % is it the target phoneme?
    phonemelevel(i,4) = type;        % 0=consonant, 1=vowel
end

%% Word-level categories

wordlevel = NaN(1,5);

uncertainty = mean(phonemelevel(:,1));
correctness = sum(phonemelevel(:,3));

attemptedword = NaN(1, 19*3);
attemptedword(1:19)  = usedphonemes(phonemelevel(1,2),:);
attemptedword(20:38) = usedphonemes(phonemelevel(2,2),:);
attemptedword(39:57) = usedphonemes(phonemelevel(3,2),:);
if length(which_row(P.trainingphons, attemptedword)) > 0
    wordness = 1;
else wordness = 0;
end

pattern = phonemelevel(:,4)';
legalpatterns = [0 1 0; 0 0 1; 1 0 0];
legality = length(which_row(legalpatterns, pattern));

if wordness == 1
    cat_attemptedword = P.protcats(which_row(P.testingphons, attemptedword));
    cat_targetword = P.protcats(which_row(P.testingphons, targetword));
    if cat_attemptedword == cat_targetword
        samecat = 1;
    else samecat = 0;
    end
    wordlevel(5) = samecat;
else samecat = 0;
end

wordlevel(1) = uncertainty;     % uncertainty of the word
wordlevel(2) = correctness;     % how many phonemes are correct? (if 3 then attemptedword = targetword)
wordlevel(3) = wordness;        % is it an existing word?; 1/0
wordlevel(4) = legality;        % is it a phonotactically (C-V order) legal word?
wordlevel(5) = samecat;         % if the attemptedword in the same protoype category as the targetword?; 0/1

