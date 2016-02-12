% Categorizes errors of the Associator model, version 22

function [phonemelevel, wordlevel, category] = categorize_errors3(activation, targetword, P, D)

%% Phoneme-level categories

usedphonemes = P.usedphonemes;
phonemelevel = NaN(3, 4);
attempted_word = [];
for i = 1:3 % for each phoneme in the word
    output = frameslider(activation, 19, i);
    
    %Fred's way: based on closest used phoneme
%    differences = NaN(nrows(usedphonemes), 1);
%     for j = 1:nrows(usedphonemes)
%         differences(j) = Eucledian_distance_normalized(output, usedphonemes(j,:));
%     end
%     uncertainty = min(differences);
%     which = which_row(differences, uncertainty);
%     attempted_phoneme = usedphonemes(which,:); % attempted phoneme is the closest phoneme from the used vocabulary
    
    % My idea: based on rounded bits
    uncertainty = binarizationfactor(output);
    attempted_phoneme = round(output);
    which = which_row(usedphonemes, attempted_phoneme);
    if numel(which) == 0
        which = 0;
    end
    
    % Consonant or vowel?
    type = attempted_phoneme(3);
    
    % Correct or not?
    if sum(attempted_phoneme == frameslider(targetword, 19, i))==19
        correctness = 1; % correct if all target phonemes = attempted phonemes
    else
        correctness = 0;
    end
    
    phonemelevel(i,1) = uncertainty; % certain: 0.1, uncertain: 0.2, 0.3, nophoneme: 0.4, 0.5
    phonemelevel(i,2) = which;       % which poneme was attempted (number of rows in usedphonemes)
    phonemelevel(i,3) = correctness; % is it the target phoneme?
    phonemelevel(i,4) = type;        % 0=consonant, 1=vowel
    
    attempted_word = [attempted_word, attempted_phoneme];
end

%% Word-level categories

wordlevel = NaN(1,5);

uncertainty = mean(phonemelevel(:,1));
correctness = sum(phonemelevel(:,3));

% attemptedword = NaN(1, 19*3);
% attemptedword(1:19)  = usedphonemes(phonemelevel(1,2),:);
% attemptedword(20:38) = usedphonemes(phonemelevel(2,2),:);
% attemptedword(39:57) = usedphonemes(phonemelevel(3,2),:);
if numel(which_row(D.trainingphons, attempted_word)) > 0
    wordness = 1;
else wordness = 0;
end

pattern = phonemelevel(:,4)';
legalpatterns = [0 1 0; 0 0 1; 1 0 0];
legality = length(which_row(legalpatterns, pattern));

if wordness == 1
    cat_attemptedword = P.protcats(which_row(D.testingphons, attempted_word));
    cat_targetword = P.protcats(which_row(D.testingphons, targetword));
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

%% Error categories

th1 = 200;  % higher threshold  0.1
th2 = 100; % lower threshold   0.09

category = zeros(1,12);

if wordlevel(1) >= th1                                              % 1. OTHER/no response
    category(1) = 1;
elseif wordlevel(1) >= th2 && wordlevel(1) <= th1                   % 2. OTHER/thingy
    category(2) = 1;
elseif wordlevel(1) < th2                                           % 3. uncertainty is low
    category(3) = 1;
    
    if wordlevel(2) == 3
        if is_correct(targetword, activation, P.upper_TH(3), P.lower_TH(3)) == 1
            category(4) = 1;                  % 4. CORRECT
        else
            category(5) = 1;                  % 5. CORRECT/small phonetic error
        end
    end
    if wordlevel(2) == 2 && wordlevel(3) == 1 && wordlevel(5) == 1      % 6. MIXED
        category(6) = 1;
    end
    if wordlevel(2) < 2 && wordlevel(3) == 1 && wordlevel(5) == 1       % 7. SEMANTIC ERROR (same protcat)
        category(7) = 1;
    end
    if wordlevel(2) == 2 && wordlevel(3) == 1  && wordlevel(5) == 0     % 8. PHON. ERROR/malapropism: phonologically related word
        category(8) = 1;
    end
    if wordlevel(2) < 2 && wordlevel(3) == 1 && wordlevel(5) == 0       % 9. OTHER/unrelated  word
        category(9) = 1;
    end
    if wordlevel(2) == 2 && wordlevel(3) == 0                           % 10. PHON. ERROR/phonologically related non-word
        category(10) = 1;
    end
    if wordlevel(2) <  2 && wordlevel(3) == 0                           % 11. OTHER/unrelated  non-word
        category(11) = 1;
    end
    if wordlevel(4) == 1                                                % 12. phonotactically legal
        category(12) = 1;
    end
end
