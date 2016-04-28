% This is the main function that runs the training and testing of one
% Associator model according to the parameters in P
% The vocabulary is imported from an excel file, Masterson vocabulary

function [P, D, L, W, V, Q, R, S, T] = Associator_M_function(P)

%% Initialization

tic
timestamp = datestr(now, 'yyyy-mm-dd-HH-MM-SS')

if P.intervention == 0
    
    clear('int');
    P.int_interventiontype = 0;
    
    [P, D, L, W, V, Q, S, R, T] = InitializeAssociator_M(P);
    'Initialization done'
    
end

%% Load and modify for intervention

if P.intervention == 1
    
    % Save intervention parameters
    newP = P;
    
    % Load
    load([P.resultsfolder, P.int_oldtimestamp, '.mat'], 'P', 'D', 'L', 'W', 'V', 'Q', 'R', 'S', 'T');
    oldP = P;
    oldD = D;
    oldV = V;
    oldQ = Q;
    oldR = R;
    oldS = S;
    oldT = T;
    
    % Rewrite intervention parameters
    P.intervention = newP.intervention;
    P.int_interventiontype = newP.int_interventiontype;
    P.int_oldtimestamp = newP.int_oldtimestamp;
    P.int_keptepochs = newP.int_keptepochs;
    P.int_intended_S_epochs = newP.int_intended_S_epochs;
    P.int_intended_P_epochs = newP.int_intended_P_epochs;
    P.int_intended_R_epochs = newP.int_intended_R_epochs;
    P.int_intended_L_epochs = newP.int_intended_L_epochs;
    P.int_trainingtype = newP.int_trainingtype;
    
    % Modify
    P.ID = [P.int_oldtimestamp, '-start', num2str(P.int_keptepochs), '-int', num2str(P.int_interventiontype), '-', timestamp];
    P.modes = modesequence(P.int_trainingtype, P.int_intended_S_epochs,P.int_intended_P_epochs, P.int_intended_R_epochs, P.int_intended_L_epochs);
    P.intended_epochs = length(P.modes);
    
    % Set weights
    if P.save_weights_mode
        W = Q(2).weights;
    else
        W = Q(P.int_keptepochs/P.save_weights + 1).weights;
    end
    
    % Reinitialize    
    D = trainingset4intervention_M(oldD, S, P); % data in V is according to the original trainingset
    
    clear('Q')
    if P.save_weights > 0
        if P.save_weights_mode
            elements = 1;
        else
            elements = floor(P.intended_epochs/P.save_weights) + 1;
        end
    else
        elements = 1;
    end
    Q(1, elements) = struct('epoch', [], 'weights', []);
    Q(1).epoch = P.int_keptepochs;
    Q(1).weights = W;
    
    clear('S')
    if P.test_performance > 0
        elements = floor(P.intended_epochs/P.test_performance);
    else
        elements = 1;
    end
    S(1, elements) = struct('epoch', [], 'scores_SS',  [], 'scores_PP',  [], 'scores_SP',  [], 'scores_PS',  [], 'errors_SS',  [], 'errors_PP',  [], 'errors_SP',  [], 'errors_PS', [], 'rts_SS',  [], 'rts_PP',  [], 'rts_SP',  [], 'rts_PS', [], 'outputs_SS',  [], 'outputs_PP',  [], 'outputs_SP',  [], 'outputs_PS', []);
    
    clear('R', 'T');
    T.start=1;
    R.start=1;
    
    'No initialization; Loading and modifications done'
    
end

%% Training and testing: temp, P, W, S, Q, T gets modified

'Training starts...'

trainedepochs = 0;
where_Q = 1;
for epoch = 1:P.intended_epochs
    
    if P.modes(epoch) ~= 'N'
        
        % Permute order of words before training
        
        if P.permute
            neworder = randperm(nrows(D.trainingsems));
            D.trainingsems = D.trainingsems(neworder,:);
            D.trainingphons = D.trainingphons(neworder,:);
            D.frequencies = D.frequencies(neworder);
        end
        
        % Training
        
        if P.trainingmode
            W = TrainAssociator_M_batch(L, W, P, D, epoch);
        else
            W = TrainAssociator_M(L, W, P, D, epoch);
        end
        trainedepochs = trainedepochs+1;
        
        % Save weights
        
        if P.save_weights_mode 
            if trainedepochs == P.save_weights;
                where_Q = 2;
                Q(where_Q).epoch = trainedepochs;
                Q(where_Q).weights = W;
            end
        else
            if gcd(trainedepochs, P.save_weights) == P.save_weights
                where_Q = trainedepochs/P.save_weights + 1;
                Q(where_Q).epoch = trainedepochs;
                Q(where_Q).weights = W;
            end
        end
        
        % Testing
        
        if gcd(trainedepochs, P.test_performance) == P.test_performance
            
            % Test
            
            retest.scores = zeros(4,P.vocabsize);
            retest.errors = zeros(4,P.vocabsize);
            retest.rts = zeros(4,P.vocabsize);
            for i = 1:P.retest % retest is necessary when noise > 0
                [scores, errors, rts, outputs] = TestAssociator_M(L, W, P, D, trainedepochs);
                retest.scores = retest.scores + scores;
                retest.errors = retest.errors + errors;
                retest.rts = retest.rts + rts;
            end
            retest.scores = retest.scores / P.retest;
            retest.errors = retest.errors / P.retest;
            retest.rts = retest.rts / P.retest;
            
            % Save test results
            
            where = trainedepochs/P.test_performance;
            S(where).epoch = trainedepochs;
            S(where).scores_SS = retest.scores(1,:);
            S(where).scores_PP = retest.scores(2,:);
            S(where).scores_SP = retest.scores(3,:);
            S(where).scores_PS = retest.scores(4,:);
            S(where).errors_SS = retest.errors(1,:);
            S(where).errors_PP = retest.errors(2,:);
            S(where).errors_SP = retest.errors(3,:);
            S(where).errors_PS = retest.errors(4,:);
            S(where).rts_SS = retest.rts(1,:);
            S(where).rts_PP = retest.rts(2,:);
            S(where).rts_SP = retest.rts(3,:);
            S(where).rts_PS = retest.rts(4,:);
            S(where).outputs_SS = outputs(1,:);
            S(where).outputs_PP = outputs(2,:);
            S(where).outputs_SP = outputs(3,:);
            S(where).outputs_PS = outputs(4,:);
            
            % Print to screen
            
            if gcd(trainedepochs, P.print2screen) == P.print2screen
                ['Training epoch: ', num2str(trainedepochs), '; Vocab: ', num2str(sum(retest.scores(1,:))), ', ', num2str(sum(retest.scores(2,:))), ', ', num2str(sum(retest.scores(3,:))), ', ', num2str(sum(retest.scores(4,:)))]
            end
            
            % Changing the remaining modes based on the last retest
            
            if is_partof(P.modes(epoch+1:end), 'S') && sum(retest.scores(1,:)) >= P.performance_threshold
                P.modes(epoch + regexp(P.modes(epoch+1:end), 'S')) = 'N';
            end
            if is_partof(P.modes(epoch+1:end), 'P') && sum(retest.scores(2,:)) >= P.performance_threshold
                P.modes(epoch + regexp(P.modes(epoch+1:end), 'P')) = 'N';
            end
            if length(regexp(P.modes(epoch+1:end), 'S')) + length(regexp(P.modes(epoch+1:end), 'P')) == 0 && is_partof(P.modes(epoch+1:end), 'R') && sum(retest.scores(3,:)) >= P.performance_threshold
                P.modes(epoch + regexp(P.modes(epoch+1:end), 'R')) = 'N';
            end
            if length(regexp(P.modes(epoch+1:end), 'S')) + length(regexp(P.modes(epoch+1:end), 'P')) == 0 && is_partof(P.modes(epoch+1:end), 'L') && sum(retest.scores(4,:)) >= P.performance_threshold
                P.modes(epoch + regexp(P.modes(epoch+1:end), 'L')) = 'N';
            end
            
        end
        
    else
        % Skip epoch
    end
    
end

'Training finished'

%% Calculate results

% Deleting empty parts
S((floor(trainedepochs/P.test_performance)+1):end)=[];
Q(where_Q+1 : end) = [];

% Adding up results in case of intervention
if P.intervention
    
    for i = 1:length(S)
        S(i).epoch = S(i).epoch + P.int_keptepochs;
    end
    S = [oldS(1:P.int_keptepochs/P.test_performance), S];
    
    for i = 1:length(Q)
        Q(i).epoch = Q(i).epoch + P.int_keptepochs;
    end
    Q = [oldQ(1:P.int_keptepochs/P.save_weights), Q];

    P.modes = [oldP.modes(1:P.int_keptepochs), P.modes];
    
    epoch = P.int_keptepochs + epoch;
    
end

% When were words  finally learnt? (ha elfelejtette es ujra megtanulta, akkor az utso megtanulas szamit)
testedepochs = length(S);
for i = 2 : testedepochs
    learnt = S(i).scores_SS - S(i-1).scores_SS == 1;
    for j = 1:P.vocabsize
        if learnt(j)==1
            V(j).AoA(1) = i * P.test_performance;
        end
    end
    learnt = S(i).scores_PP - S(i-1).scores_PP == 1;
    for j = 1:P.vocabsize
        if learnt(j)==1
            V(j).AoA(2) = i * P.test_performance;
        end
    end
    learnt = S(i).scores_SP - S(i-1).scores_SP == 1;
    for j = 1:P.vocabsize
        if learnt(j)==1
            V(j).AoA(3) = i * P.test_performance;
        end
    end
    learnt = S(i).scores_PS - S(i-1).scores_PS == 1;
    for j = 1:P.vocabsize
        if learnt(j)==1
            V(j).AoA(4) = i * P.test_performance;
        end
    end
end

% T collects the sum of scores, sum of errrors, average reaction times for
% each epoch; useful for plotting
T.score_SS = NaN(1,floor(trainedepochs/P.test_performance));
T.score_PP = NaN(1,floor(trainedepochs/P.test_performance));
T.score_SP = NaN(1,floor(trainedepochs/P.test_performance));
T.score_PS = NaN(1,floor(trainedepochs/P.test_performance));
T.error_SS = NaN(1,floor(trainedepochs/P.test_performance));
T.error_PP = NaN(1,floor(trainedepochs/P.test_performance));
T.error_SP = NaN(1,floor(trainedepochs/P.test_performance));
T.error_PS = NaN(1,floor(trainedepochs/P.test_performance));
if P.test_RT > 0
    elements =floor(trainedepochs/P.test_RT);
else
    elements = 0;
end
T.rt_SS = NaN(1,elements);
T.rt_PP = NaN(1,elements);
T.rt_SP = NaN(1,elements);
T.rt_PS = NaN(1,elements);
for i = 1:numel(S)
    T.score_SS(i) = sum(S(i).scores_SS);
    T.score_PP(i) = sum(S(i).scores_PP);
    T.score_SP(i) = sum(S(i).scores_SP);
    T.score_PS(i) = sum(S(i).scores_PS);
    T.error_SS(i) = sum(S(i).errors_SS);
    T.error_PP(i) = sum(S(i).errors_PP);
    T.error_SP(i) = sum(S(i).errors_SP);
    T.error_PS(i) = sum(S(i).errors_PS);
    if gcd(S(i).epoch, P.test_RT) == P.test_RT
        T.rt_SS(S(i).epoch/P.test_RT) = mean(S(i).rts_SS);
        T.rt_PP(S(i).epoch/P.test_RT) = mean(S(i).rts_PP);
        T.rt_SP(S(i).epoch/P.test_RT) = mean(S(i).rts_SP);
        T.rt_PS(S(i).epoch/P.test_RT) = mean(S(i).rts_PS);
    end
end

% R collects the summary of the results
% Number of epochs needed for each task (ha elfelejtette es ujra megtanulta, akkor az utso megtanulas szamit)
R.passed_epochs = epoch;
if 1==0 % if simulation was stopped by user
    R.passed_epochs = epoch-1;
end

R.completed_S_epochs = length(regexp([P.modes], 'S'));
R.completed_P_epochs = length(regexp([P.modes], 'P'));
R.completed_R_epochs = length(regexp([P.modes], 'R'));
R.completed_L_epochs = length(regexp([P.modes], 'L'));
R.completed_epochs = R.completed_S_epochs + R.completed_P_epochs + R.completed_R_epochs + R.completed_L_epochs;

% When did the Associator finally learn the whole vocab? (ha elfelejtette es ujra megtanulta, akkor az utso megtanulas szamit)
R.epochs_tolearn_SS = NaN;
R.epochs_tolearn_PP = NaN;
R.epochs_tolearn_SP = NaN;
R.epochs_tolearn_PS = NaN;

for i = testedepochs : -1 : 1
    if T.score_SS(i) == P.performance_threshold
        R.epochs_tolearn_SS = i * P.test_performance;
    end
    if T.score_PP(i) == P.performance_threshold
        R.epochs_tolearn_PP = i * P.test_performance;
    end
    if T.score_SP(i) == P.performance_threshold
        R.epochs_tolearn_SP = i * P.test_performance;
    end
    if T.score_PS(i) == P.performance_threshold
        R.epochs_tolearn_PS = i * P.test_performance;
    end
end

% Size of the final vocab
R.vocab_SS = T.score_SS(end);
R.vocab_PP = T.score_PP(end);
R.vocab_SP = T.score_SP(end);
R.vocab_PS = T.score_PS(end);

'Calculating results finished'

%% Categorizing errors
% use S.outputs_SP (naming task)

%% Plot

if P.plot_trajectories
    figure
    title('Developmental trajectories');
    x = P.test_performance : P.test_performance : R.completed_epochs;
    hold all
    plot(x, T.score_SS, '--m', 'LineWidth', 1.5);
    plot(x, T.score_PP, '--c', 'LineWidth', 1.5);
    plot(x, T.score_SP, ':r', 'LineWidth', 1.5);
    plot(x, T.score_PS, ':b', 'LineWidth', 1.5);
    if P.intervention == 1
        plot(repmat(P.int_keptepochs, 1, P.vocabsize+3), -1:P.vocabsize+1,  '-k', 'LineWidth',1);
    end
    felirat3 = [{'Task SS'}; {'Task PP'}; {'Task SP'}; {'Task PS'}];
    set(legend(felirat3),'Location', 'SouthEast');  %[0.6756 0.1897 0.2018 0.2778])
    axis([0 R.completed_epochs+1 0 P.vocabsize+1]);
    set(gca,'TickDir','out');
    xlabel('Number of epochs');
    ylabel('Number of known words');
    hold off
    
    figurefile =  [P.resultsfolder, P.ID, '_trajectories.png'];
    print('-dpng', figurefile);
    close
end

'Plotting finished'
%% Save results

R.runningtime_min = toc/60;
if P.save_matfile == 1 % Save all variables in .mat file; later can be loaded
    save([P.resultsfolder, P.ID, '.mat'], 'L', 'W', 'P','S','R','V','T','Q','D','-v7.3');
end

if P.save_2excel
    where = nrows(xlsread(P.resultsfile))+1;
    tosave = {
        P.ID,
        % Main results
        R.vocab_SS,
        R.vocab_PP,
        R.vocab_SP,
        R.vocab_PS,
        R.completed_epochs,
        R.completed_S_epochs,
        R.completed_P_epochs,
        R.completed_R_epochs,
        R.completed_L_epochs,
        R.runningtime_min,
        % Intervention
        P.intervention,
        P.int_interventiontype,
        % Seeds
        P.weightseed,
        % Input
        P.vocabsize,
        P.performance_threshold,
        % Architecture
        P.size_SH,
        P.size_PH,
        P.size_AR,
        P.size_AL,
        P.dens_SISH;
        P.dens_SHSO;
        P.dens_PIPH;
        P.dens_PHPO;
        P.dens_SHAR;
        P.dens_ARPH;
        P.dens_PHAL;
        P.dens_ALSH;
        P.usebias,
        P.biasvalue,
        % Learning
        P.trainingtype,
        P.recurrence,
        P.timeout,
        P.retest,
        func2str(P.transferfn),
        func2str(P.delta),
        num2str(P.temperatures),
        num2str(P.learningrates),
        num2str(P.momentums),
        num2str(P.noise),
        num2str(P.upper_TH),
        num2str(P.lower_TH),
        func2str(P.weightinit),
        P.randmax,
        };
    
    % Save summary of results to an excel file
    xlswrite(P.resultsfile, tosave', 'results', ['A', num2str(where)]);
end

'Saving results finished'
R