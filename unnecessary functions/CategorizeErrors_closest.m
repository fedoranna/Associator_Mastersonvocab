% Categorizes errors of the Associator model, version 22
% categorizes all the saved production data from T.production (all words in all saved epochs)
% creates T.errortypes, T.mainerrortypes and T.mainerrorperc

function T = CategorizeErrors_closest(T, D, P)

%%
T.errortypes = zeros(nrows(T.production), 12);
usedphonemes = P.usedphonemes;
wordlength = P.wordlength;
%wordlength = 3;
semantic(1,nrows(T.errortypes)) = struct('targetword', [], 'attemptedword', [], 'semcat', []);

for p = 1:nrows(T.production)
    for w = 1:P.vocabsize
        
        activation = T.production{p,w};
        targetword = D.testingphons(w,:);
        
        %% Phoneme-level categories        
        
        phonemelevel = NaN(wordlength, 4);
        attempted_word = [];
        for i = 1:wordlength % for each phoneme in the word
            output = frameslider(activation, 19, i);
            
            % Attempted phoneme based on closest used phoneme
            differences = NaN(nrows(usedphonemes), 1);
            for j = 1:nrows(usedphonemes)
                differences(j) = Eucledian_distance_normalized(output, usedphonemes(j,:));
            end
            uncertainty = min(differences);
            which = which_row(differences, uncertainty);
            if numel(which)>1 % if more than 1 phoneme has the same uncertainty (Eucledian distance)
                which = which(1);
            end
            attempted_phoneme = usedphonemes(which,:); % attempted phoneme is the closest phoneme from the used vocabulary
            
            % Consonant or vowel?
            type = attempted_phoneme(3);
            
            % Correct or not?
            if sum(attempted_phoneme == frameslider(targetword, 19, i))==19
                correctness = 1; % correct if all target phonemes = attempted phonemes
            else
                correctness = 0;
            end
            
            phonemelevel(i,1) = uncertainty; % the Eucledian distance of the output and the closest phoneme
            phonemelevel(i,2) = which;       % which poneme was attempted (number of rows in usedphonemes)
            phonemelevel(i,3) = correctness; % is it the target phoneme?
            phonemelevel(i,4) = type;        % 0=consonant, 1=vowel
            
            attempted_word = [attempted_word, attempted_phoneme];
        end
        
        %% Word-level categories
        
        wordlevel = NaN(1,5);        
        uncertainty = max(phonemelevel(:,1));
        correctness = sum(phonemelevel(:,3));

        if numel(which_row(D.trainingphons, attempted_word)) > 0
            wordness = 1;
        else wordness = 0;
        end
        
        if strcmp(func2str(P.phoneticsgenerator), func2str(@phoneticsgenerator_ThomasAKS2003))
            pattern = phonemelevel(:,4)';
            legalpatterns = [0 1 0; 0 0 1; 1 0 0];
            legality = length(which_row(legalpatterns, pattern));
        else
            legality = 1;
        end
        
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
        
        th1 = P.lower_TH(3)*2;  % higher threshold  0.1
        th2 = P.lower_TH(3); % lower threshold   0.09
        
        category = zeros(1,12);
        
        if wordlevel(1) > th1                                              % 1. OTHER/no response
            category(1) = 1;
        elseif wordlevel(1) > th2 && wordlevel(1) <= th1                   % 2. OTHER/thingy
            category(2) = 1;
        elseif wordlevel(1) <= th2                                           % 3. uncertainty is low
            category(3) = 1;
            
            if wordlevel(2) == wordlength
                if is_correct(targetword, activation, P.upper_TH(3), P.lower_TH(3)) == 1
                    category(4) = 1;                  % 4. CORRECT
                else
                    category(5) = 1;                  % 5. CORRECT/small phonetic error
                end
            end
            if wordlevel(2) > wordlength/2 && wordlevel(2) < wordlength && wordlevel(3) == 1 && wordlevel(5) == 1      % 6. MIXED
                category(6) = 1;
            end
            if wordlevel(2) <= wordlength/2 && wordlevel(3) == 1 && wordlevel(5) == 1       % 7. SEMANTIC ERROR (same protcat)
                category(7) = 1;
                semantic(p).targetword = [semantic(p).targetword, w];
                semantic(p).attemptedword = [semantic(p).attemptedword, attempted_word];
                semantic(p).semcat = [semantic(p).semcat, cat_attemptedword];
            end
            if wordlevel(2) > wordlength/2 && wordlevel(2) < wordlength && wordlevel(3) == 1  && wordlevel(5) == 0     % 8. PHON. ERROR/phonologically related word (malapropism)
                category(8) = 1;
            end
            if wordlevel(2) <= wordlength/2 && wordlevel(3) == 1 && wordlevel(5) == 0       % 9. OTHER/unrelated  word
                category(9) = 1;
            end
            if wordlevel(2) > wordlength/2 && wordlevel(2) < wordlength && wordlevel(3) == 0                         % 10. PHON. ERROR/phonologically related non-word
                category(10) = 1;
            end
            if wordlevel(2) <= wordlength/2 && wordlevel(3) == 0                           % 11. OTHER/unrelated  non-word
                category(11) = 1;
            end
            if wordlevel(4) == 1                                                % 12. phonotactically legal
                category(12) = 1;
            end
        end
        T.errortypes(p,:) = T.errortypes(p,:) + category;
    end
end

%% Main error types

T.mainerrortypes = zeros(nrows(T.errortypes), 5);
T.mainerrortypes(:,1) = T.errortypes(:, 4) + T.errortypes(:, 5);            % correct
T.mainerrortypes(:,2) = T.errortypes(:, 7);                                 % semantic error
T.mainerrortypes(:,3) = T.errortypes(:, 8) + T.errortypes(:, 10);           % phonological error
T.mainerrortypes(:,4) = T.errortypes(:, 6);                                 % mixed error
T.mainerrortypes(:,5) = T.errortypes(:, 1) + T.errortypes(:,2) + T.errortypes(:, 9) + T.errortypes(:,11);            % other type of error

T.mainerrorperc = T.mainerrortypes;
T.mainerrorperc(:,1) = [];
allerrors = sum(T.mainerrorperc, 2);
for i = 1:ncols(T.mainerrorperc)
    T.mainerrorperc(:, i) = (T.mainerrorperc(:, i) ./ allerrors) * 100;
end
T.semanticerrors = semantic;

