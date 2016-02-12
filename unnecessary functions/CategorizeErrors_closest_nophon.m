% Categorizes errors of the Associator model, version 22
% categorizes all the saved production data from T.production (all words in all saved epochs)
% creates T.errortypes, T.mainerrortypes and T.mainerrorperc
% Can be used with any semantic representations that have semantic classes
% (semanticsgenerator_prototypes, _ecological, _ratio)
% Can be used with phonological representations that does not have phonemes

function T = CategorizeErrors_closest_nophon(T, D, P)

T.errortypes = zeros(nrows(T.production), 12);
T.mainerrortypes = zeros(nrows(T.errortypes), 5);

for p = 1:nrows(T.production)
    for w = 1:P.vocabsize
        activation = T.production{p,w};
        targetword = D.testingphons(w,:);
        
        %% Word-level categories
        % Attempted word based on closest word; uncertainty
        differences = NaN(nrows(D.testingphons), 1);
        for j = 1:nrows(D.testingphons)
            differences(j) = Eucledian_distance_normalized(activation, D.testingphons(j,:));
        end
        uncertainty = min(differences);
        which = which_row(differences, uncertainty);
        attempted_word = D.testingphons(which,:); % attempted phoneme is the closest phoneme from the used vocabulary
        
        % Correctness
        correctnb = sum(attempted_word == targetword);
        correctperc = (correctnb/numel(targetword))*100;
        if correctperc == 100
            correctness = 3;
        end
        if correctperc < 100 && correctperc > 50
            correctness = 2;
        end
        if correctperc < 50
            correctness = 1;
        end            
        
        % Wordness
        % Maybe restrict based on Eucledian distance
        wordness = 1;
        
        % Semantic category
        if wordness == 1
            cat_attemptedword = P.protcats(which_row(D.testingphons, attempted_word));
            cat_targetword = P.protcats(which_row(D.testingphons, targetword));
            if cat_attemptedword == cat_targetword
                samecat = 1;
            else samecat = 0;
            end
        else samecat = 0;
        end
        
        wordlevel = NaN(1,5);
        wordlevel(1) = uncertainty;     % the Eucledian distance of the target word and the output activation
        wordlevel(2) = correctness;     % 3, 2 or 1 based on the percentage of correct features
        wordlevel(3) = wordness;        % is it an existing word?; 1/0
        %wordlevel(4) = legality;        % is it a phonotactically (C-V order) legal word?
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
            if wordlevel(2) == 2 && wordlevel(3) == 1  && wordlevel(5) == 0     % 8. PHON. ERROR/phonologically related word (malapropism)
                category(8) = 1;
            end
            if wordlevel(2) < 2 && wordlevel(3) == 1 && wordlevel(5) == 0       % 9. OTHER/unrelated  word
                category(9) = 1;
            end
            if wordlevel(2) == 2 && wordlevel(3) == 0                         % 10. PHON. ERROR/phonologically related non-word
                category(10) = 1;
            end
            if wordlevel(2) <  2 && wordlevel(3) == 0                           % 11. OTHER/unrelated  non-word
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

