% Tests Associator on 4 different tasks for 1 epoch
% Recurrence is either part of the testing or not, depending on a switch (P.recurrence)

function [T, SCORES, ERRORS] = TestAssociator22(L, W, P, T, D, trainedepochs, temp)

scores.SS = NaN(1,P.vocabsize);
scores.PP = NaN(1,P.vocabsize);
scores.SP = NaN(1,P.vocabsize);
scores.PS = NaN(1,P.vocabsize);
error.SS = 0;
error.PP = 0;
error.SP = 0;
error.PS = 0;

for sweep = 1:nrows(D.testingsems)
    
    input_sem = D.testingsems(sweep,:);
    input_phon = D.testingphons(sweep,:);
    target_SO = D.testingsems(sweep,:);
    target_PO = D.testingphons(sweep,:);
    
    %% Task S->S
    
    L = ActivateAssociator22(L, W, P, 'S', input_sem);
    
    if P.recurrence == 1 || gcd(trainedepochs, P.test_RT) == P.test_RT
        L_beforerecurrence = L;
        diffs = Inf;
        RT = 0;
        for i=1:P.timeout
            if sum(diffs) > P.asymptote_TH
                prevstate = L(3).state;
                RT = RT + 1;
                L = ActivateAssociator22(L, W, P, 'S', prevstate + randomnoise(P.noise(1), [1, L(1).size]));
                diffs = abs(prevstate - L(3).state);
            end
        end
        
        if gcd(trainedepochs, P.test_RT) == P.test_RT
            where = trainedepochs/P.test_RT;
            T.RT_SS(where, sweep) = RT;
        end
        
        if P.recurrence == 0
            L = L_beforerecurrence;
        end
    end
    
    if gcd(trainedepochs, P.save_outputs) == P.save_outputs
        where = trainedepochs/P.save_outputs;
        T.outputs_SS{where, sweep} = L(3).state;
    end
    
    scores.SS(sweep) = is_correct(target_SO, L(3).state, P.upper_TH(1), P.lower_TH(1));
    error.SS = error.SS + (1-MSE(target_SO, L(3).state)); % accumulating SSE for this epoch
    
    %% Task P->P
    
    L = ActivateAssociator22(L, W, P, 'P', input_phon);
    
    if P.recurrence == 1 || gcd(trainedepochs, P.test_RT) == P.test_RT
        L_beforerecurrence = L;
        diffs = Inf;
        RT = 0;
        for i=1:P.timeout
            if sum(diffs) > P.asymptote_TH
                prevstate = L(6).state;
                RT = RT + 1;
                L = ActivateAssociator22(L, W, P, 'P', prevstate + randomnoise(P.noise(2), [1, L(4).size]));
                diffs = abs(prevstate - L(6).state);
            end
        end
        
        if gcd(trainedepochs, P.test_RT) == P.test_RT
            where = trainedepochs/P.test_RT;
            T.RT_PP(where, sweep) = RT;
        end
        
        if P.recurrence == 0
            L = L_beforerecurrence;
        end
    end
    
    if gcd(trainedepochs, P.save_outputs) == P.save_outputs
        where = trainedepochs/P.save_outputs;
        T.outputs_PP{where, sweep} = L(6).state;
    end
    
    scores.PP(sweep) = is_correct(target_PO, L(6).state, P.upper_TH(2), P.lower_TH(2));
    error.PP = error.PP + (1-MSE(target_PO, L(6).state)); % accumulating SSE for this epoch
    
    %% Task S->P
    
    L = ActivateAssociator22(L, W, P, 'R', input_sem);
    
    if P.recurrence == 1 || gcd(trainedepochs, P.test_RT) == P.test_RT
        L_beforerecurrence = L;
        diffs = Inf;
        RT = 0;
        for i=1:P.timeout
            if sum(diffs) > P.asymptote_TH
                prevstate = L(6).state;
                RT = RT + 1;
                L = ActivateAssociator22(L, W, P, 'P', prevstate + randomnoise(P.noise(2), [1, L(4).size]));
                diffs = abs(prevstate - L(6).state);
            end
        end
        
        if gcd(trainedepochs, P.test_RT) == P.test_RT
            where = trainedepochs/P.test_RT;
            T.RT_SP(where, sweep) = RT;
        end
        
        if P.recurrence == 0
            L = L_beforerecurrence;
        end
    end
    
    if gcd(trainedepochs, P.save_outputs) == P.save_outputs
        where = trainedepochs/P.save_outputs;
        T.outputs_SP{where, sweep} = L(6).state;
    end
    
    scores.SP(sweep) = is_correct(target_PO, L(6).state, P.upper_TH(3), P.lower_TH(3));
    error.SP = error.SP + (1-MSE(target_PO, L(6).state)); % accumulating SSE for this epoch
    
    %% Task P->S
    
    L = ActivateAssociator22(L, W, P, 'L', input_phon);
    
    if P.recurrence == 1 || gcd(trainedepochs, P.test_RT) == P.test_RT
        L_beforerecurrence = L;
        diffs = Inf;
        RT = 0;
        for i=1:P.timeout
            if sum(diffs) > P.asymptote_TH
                prevstate = L(3).state;
                RT = RT + 1;
                L = ActivateAssociator22(L, W, P, 'S', prevstate + randomnoise(P.noise(1), [1, L(1).size]));
                diffs = abs(prevstate - L(3).state);
            end
        end
        
        if gcd(trainedepochs, P.test_RT) == P.test_RT
            where = trainedepochs/P.test_RT;
            T.RT_PS(where, sweep) = RT;
        end
        
        if P.recurrence == 0
            L = L_beforerecurrence;
        end
    end
    
    if gcd(trainedepochs, P.save_outputs) == P.save_outputs
        where = trainedepochs/P.save_outputs;
        T.outputs_PS{where, sweep} = L(3).state;
    end
    
    scores.PS(sweep) = is_correct(target_SO, L(3).state, P.upper_TH(4), P.lower_TH(4));
    error.PS = error.PS + (1-MSE(target_SO, L(3).state)); % accumulating SSE for this epoch
    
end % of epoch

%% Saving results

SCORES = NaN(4, P.vocabsize);
SCORES(1,:) = scores.SS;
SCORES(2,:) = scores.PP;
SCORES(3,:) = scores.SP;
SCORES(4,:) = scores.PS;
ERRORS = NaN(4,1);
ERRORS(1) = error.SS;
ERRORS(2) = error.PP;
ERRORS(3) = error.SP;
ERRORS(4) = error.PS;

