changes = cell(80, 5);
th1 = 0.1;
th2 = 0.09;
P.

%for sweep = 1:80
    %sweep = 79
    
    input_sem = P.testingsems(sweep,:);
    input_phon = P.testingphons(sweep,:);
    target_SO = P.testingsems(sweep,:);
    target_PO = P.testingphons(sweep,:);
    
    L = propagate_activation(L, W, P, 'R', input_sem);
    
    %% Error categories
    
    [phonemelevel, wordlevel] = categorize_errors(L(6).state, target_PO, P);
    if wordlevel(1) >= th1                                              % 1. OTHER/no response
        cat_before = 'no response';
    elseif wordlevel(1) >= th2 && wordlevel(1) <= th1                   % 2. OTHER/thingy
        cat_before = 'thingy';
    elseif wordlevel(1) < th2                                           % 3. uncertainty is low
        if wordlevel(2) == 3
            if is_correct(target_PO, L(6).state, P.ass_upper_TH, P.ass_lower_TH) == 1
                cat_before = 'CORRECT';                  % 4. CORRECT
            else
                cat_before = 'CORR/small phon';                  % 5. CORRECT/small phonetic error
            end
        end
        if wordlevel(2) == 2 && wordlevel(3) == 1 && wordlevel(5) == 1      % 6. MIXED
            cat_before = 'MIXED';
        end
        if wordlevel(2) < 2 && wordlevel(3) == 1 && wordlevel(5) == 1       % 7. SEMANTIC ERROR (same protcat)
            cat_before = 'SEMANTIC';
        end
        if wordlevel(2) == 2 && wordlevel(3) == 1  && wordlevel(5) == 0     % 8. PHON. ERROR/malapropism
            cat_before = 'PHON/malapropism';
        end
        if wordlevel(2) < 2 && wordlevel(3) == 1 && wordlevel(5) == 0       % 9. OTHER/unrelated  word
            cat_before = 'OTHER/unrelated  word';
        end
        if wordlevel(2) == 2 && wordlevel(3) == 0                           % 10. PHON. ERROR/all other types
            cat_before = 'PHON/other';
        end
        if wordlevel(2) <  2 && wordlevel(3) == 0                           % 11. OTHER/unrelated  non-word
            cat_before = 'OTHER/unrel. non-word';
        end
    end
    score_before = is_correct(target_PO, L(6).state, P.sep_upper_TH, P.sep_lower_TH);
    
    %% Recurrence
    
    uncertainty = NaN(1,P.timeout);
    error = NaN(1,P.timeout);
    diffs = Inf;
    RT = 0;
    for i=1:P.timeout
        if sum(diffs) > P.asymptote_TH
            prevstate = L(6).state;
            RT = RT + 1;
            L = propagate_activation(L, W, P, 'P', prevstate + randomnoise(P.noise(2), [1, L(4).size]));
            diffs = abs(prevstate - L(6).state);
            [phonemelevel, wordlevel] = categorize_errors(L(6).state, target_PO, P);
            uncertainty(i) = wordlevel(1);
            error(i) = MSE(target_PO, L(6).state);
        end
    end
    
    %% Error categories
    
    [phonemelevel, wordlevel] = categorize_errors(L(6).state, target_PO, P);
    if wordlevel(1) >= th1                                              % 1. OTHER/no response
        cat_after = 'no response';
    elseif wordlevel(1) >= th2 && wordlevel(1) <= th1                   % 2. OTHER/thingy
        cat_after = 'thingy';
    elseif wordlevel(1) < th2                                           % 3. uncertainty is low
        if wordlevel(2) == 3
            if is_correct(target_PO, L(6).state, P.ass_upper_TH, P.ass_lower_TH) == 1
                cat_after = 'CORRECT';                  % 4. CORRECT
            else
                cat_after = 'CORR/small phon';                  % 5. CORRECT/small phonetic error
            end
        end
        if wordlevel(2) == 2 && wordlevel(3) == 1 && wordlevel(5) == 1      % 6. MIXED
            cat_after = 'MIXED';
        end
        if wordlevel(2) < 2 && wordlevel(3) == 1 && wordlevel(5) == 1       % 7. SEMANTIC ERROR (same protcat)
            cat_after = 'SEMANTIC';
        end
        if wordlevel(2) == 2 && wordlevel(3) == 1  && wordlevel(5) == 0     % 8. PHON. ERROR/malapropism
            cat_after = 'PHON/malapropism';
        end
        if wordlevel(2) < 2 && wordlevel(3) == 1 && wordlevel(5) == 0       % 9. OTHER/unrelated  word
            cat_after = 'OTHER/unrelated  word';
        end
        if wordlevel(2) == 2 && wordlevel(3) == 0                           % 10. PHON. ERROR/all other types
            cat_after = 'PHON/all other types';
        end
        if wordlevel(2) <  2 && wordlevel(3) == 0                           % 11. OTHER/unrelated  non-word
            cat_after = 'OTHER/unrel. non-word';
        end
    end
    score_after = is_correct(target_PO, L(6).state, P.sep_upper_TH, P.sep_lower_TH);
    
    %% Print
    changes{sweep, 1} = cat_before;
    changes{sweep, 2} = score_before;
    changes{sweep, 3} = '->';
    changes{sweep, 4} = cat_after;
    changes{sweep, 5} = score_after;
    
    subplot(1,2,1), plot(uncertainty);
    set(legend('uncertainty'));
    subplot(1,2,2), plot(error);
    set(legend('error'));
    
%end
%changes
%%

% changes{41}
%  16     1    63     0     0     0     1     0    30     1    31    63

    80    80    80    80


ans =

    78    79    79    78


ans =

    72    78    78    72


ans =

    70    78    78    70


ans =

    70    78    78    70


%% Check error
P.timeout = 0;
allscores = NaN(10,4);
% [R, T, SCORES, ERRORS] = TestAssociator17(L, W, P, S, R, T, epoch, trainedepochs);
% sum(SCORES')

for i = 1:10
    P.timeout = P.timeout+1;
    [R, T, SCORES, ERRORS] = TestAssociator17(L, W, P, S, R, T, epoch, trainedepochs);
    allscores(i,:) = sum(SCORES');
end
plot(allscores)
set(legend('SS', 'PP', 'SP', 'PS'));
    
    
