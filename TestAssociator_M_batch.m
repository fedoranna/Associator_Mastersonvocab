% Tests Associator on 4 different tasks for 1 epoch
% Each word in the testingset gets tested once for each task
% Recurrence is either part of the testing or not, depending on a switch (P.recurrence)

% Tried batch testing, but it might only be possible when RT is not
% measures. RT has to be measured separately for each word.

function [scores, errors, rts, outputs] = TestAssociator_M_batch(L, W, P, D, trainedepochs)

scores = NaN(4,P.vocabsize); % 1/0 for each word (each row is a task)
errors = NaN(4,P.vocabsize); % MSE for each word (each row is a task)
rts = NaN(4,P.vocabsize); % reaction time for each word (each row is a task)
outputs = cell(4,P.vocabsize); % the relevant output layer activation for each word (each row is a task)

input_sem = D.testingsems;
input_phon = D.testingphons;
target_SO = D.testingsems;
target_PO = D.testingphons;

%% Task S->S

L = ActivateAssociator(L, W, P, 'S', input_sem);

if P.recurrence == 1 || gcd(trainedepochs, P.test_RT) == P.test_RT
    L_beforerecurrence = L;
    diffs = Inf;
    RT = 0;
    for i=1:P.timeout
        if sum(diffs) > P.asymptote_TH
            prevstate = L(3).state;
            RT = RT + 1;
            L = ActivateAssociator(L, W, P, 'S', prevstate + randomnoise(P.noise(1), size(L(1).state)));
            diffs = abs(prevstate - L(3).state);
        end
    end
    if P.recurrence == 0
        L = L_beforerecurrence;
    end
    
    % Save reaction time
    if gcd(trainedepochs, P.test_RT) == P.test_RT
        rts(1,sweep) = RT;
    end
    
end

% Save outputs
if gcd(trainedepochs, P.save_outputs) == P.save_outputs
    outputs{1,sweep} = L(3).state;
end

% Save scores and errors
scores(1,sweep) = is_correct(target_SO, L(3).state, P.upper_TH(1), P.lower_TH(1));
errors(1,sweep) = MSE(target_SO, L(3).state);

%% Task P->P

L = ActivateAssociator(L, W, P, 'P', input_phon);

if P.recurrence == 1 || gcd(trainedepochs, P.test_RT) == P.test_RT
    L_beforerecurrence = L;
    diffs = Inf;
    RT = 0;
    for i=1:P.timeout
        if sum(diffs) > P.asymptote_TH
            prevstate = L(6).state;
            RT = RT + 1;
            L = ActivateAssociator(L, W, P, 'P', prevstate + randomnoise(P.noise(2), size(L(4).state)));
            diffs = abs(prevstate - L(6).state);
        end
    end
    if P.recurrence == 0
        L = L_beforerecurrence;
    end
    
    % Save reaction time
    if gcd(trainedepochs, P.test_RT) == P.test_RT
        rts(2,sweep) = RT;
    end
    
end

% Save outputs
if gcd(trainedepochs, P.save_outputs) == P.save_outputs
    outputs{2,sweep} = L(6).state;
end

% Save scores and errors
scores(2,sweep) = is_correct(target_PO, L(6).state, P.upper_TH(2), P.lower_TH(2));
errors(2,sweep) = MSE(target_PO, L(6).state);

%% Task S->P

L = ActivateAssociator(L, W, P, 'R', input_sem);

if P.recurrence == 1 || gcd(trainedepochs, P.test_RT) == P.test_RT
    L_beforerecurrence = L;
    diffs = Inf;
    RT = 0;
    for i=1:P.timeout
        if sum(diffs) > P.asymptote_TH
            prevstate = L(6).state;
            RT = RT + 1;
            L = ActivateAssociator(L, W, P, 'P', prevstate + randomnoise(P.noise(2), size(L(4).state)));
            diffs = abs(prevstate - L(6).state);
        end
    end
    if P.recurrence == 0
        L = L_beforerecurrence;
    end
    
    % Save reaction time
    if gcd(trainedepochs, P.test_RT) == P.test_RT
        rts(3,sweep) = RT;
    end
    
end

% Save outputs
if gcd(trainedepochs, P.save_outputs) == P.save_outputs
    outputs{3,sweep} = L(6).state;
end

% Save scores and errors
scores(3,sweep) = is_correct(target_PO, L(6).state, P.upper_TH(3), P.lower_TH(3));
errors(3,sweep) = MSE(target_PO, L(6).state); % accumulating SSE for this epoch

%% Task P->S

L = ActivateAssociator(L, W, P, 'L', input_phon);

if P.recurrence == 1 || gcd(trainedepochs, P.test_RT) == P.test_RT
    L_beforerecurrence = L;
    diffs = Inf;
    RT = 0;
    for i=1:P.timeout
        if sum(diffs) > P.asymptote_TH
            prevstate = L(3).state;
            RT = RT + 1;
            L = ActivateAssociator(L, W, P, 'S', prevstate + randomnoise(P.noise(1), size(L(1).state)));
            diffs = abs(prevstate - L(3).state);
        end
    end
    if P.recurrence == 0
        L = L_beforerecurrence;
    end
    
    % Save reaction time
    if gcd(trainedepochs, P.test_RT) == P.test_RT
        rts(4,sweep) = RT;
    end
    
end

% Save outputs
if gcd(trainedepochs, P.save_outputs) == P.save_outputs
    outputs{4,sweep} = L(3).state;
end

% Save scores and errors
scores(4,sweep) = is_correct(target_SO, L(3).state, P.upper_TH(4), P.lower_TH(4));
errors(4,sweep) = MSE(target_SO, L(3).state); % accumulating SSE for this epoch


