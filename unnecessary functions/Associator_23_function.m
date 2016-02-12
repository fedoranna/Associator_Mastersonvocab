% This is the main function that runs the training and testing of one
% Associator model according to the parameters in P
% The vocabulary is imported from an excel file

function [L, W, P, S, R, V, T, Q, D] = Associator_23_function(P)

%% Initialization

tic
timestamp = datestr(now, 'yyyy-mm-dd-HH-MM-SS')

if P.intervention == 0
    
    clear('int');
    [L, W, P, S, R, V, T, Q, D] = InitializeAssociator23(P);
    'Initialization done'
    
    P.int_interventiontype = 0;
    
end

%% Load and modify for intervention

if P.intervention == 1
    
    % Save intervention parameters
    newP = P;
    
    % Load
    load([P.folder, P.int_oldtimestamp, '.mat'], 'L', 'W', 'D', 'P', 'S', 'Q', 'T', 'V', 'R');
    
    % Rewrite parameters
    oldP = P;
    P.intervention = newP.intervention;
    P.int_interventiontype = newP.int_interventiontype;
    P.int_trainingtype = newP.int_trainingtype;
    P.int_oldtimestamp = newP.int_oldtimestamp;
    P.int_keptepochs = newP.int_keptepochs;
    P.int_intended_S_epochs = newP.int_intended_S_epochs;
    P.int_intended_P_epochs = newP.int_intended_P_epochs;
    P.int_intended_R_epochs = newP.int_intended_R_epochs;
    P.int_intended_L_epochs = newP.int_intended_L_epochs;
    
    % Modify
    P.ID = [P.int_oldtimestamp, '-start', num2str(P.int_keptepochs), '-int', num2str(P.int_interventiontype), '-', timestamp];
    P.modes = modesequence(P.int_trainingtype, P.int_intended_S_epochs,P.int_intended_P_epochs, P.int_intended_R_epochs, P.int_intended_L_epochs);
    if is_partof(P.modes, 'S') &&  T.SS_all(P.int_keptepochs/P.test_performance) >= P.performance_threshold
        P.modes(regexp(P.modes, 'S')) = 'N';
    end
    if is_partof(P.modes, 'P') &&  T.PP_all(P.int_keptepochs/P.test_performance) >= P.performance_threshold
        P.modes(regexp(P.modes, 'P')) = 'N';
    end
    if length(regexp(P.modes, 'S')) + length(regexp(P.modes, 'P')) == 0 && is_partof(P.modes, 'R') &&  T.SP_all(P.int_keptepochs/P.test_performance)>= P.performance_threshold
        P.modes(regexp(P.modes, 'R')) = 'N';
    end
    if length(regexp(P.modes, 'S')) + length(regexp(P.modes, 'P')) == 0 && is_partof(P.modes, 'L') &&  T.PS_all(P.int_keptepochs/P.test_performance) >= P.performance_threshold
        P.modes(regexp(P.modes, 'L')) = 'N';
    end
    P.intended_epochs = length(P.modes);
    P.test_RT = P.test_performance : P.test_performance : (P.intended_epochs + P.int_keptepochs);
    
    % Set weights
    where = which_element(P.int_keptepochs, P.save_weights);
    W = Q(where+1).weights;
    
    % Reinitialize
    oldD = D;
    oldQ = Q;
    oldS = S;
    oldT = T;
    oldR = R;
    
    D = trainingset4intervention_23(oldD, S, P); % data in V is according to the original trainingset
    
    Q(1).epoch = P.int_keptepochs;
    Q(1).weights = W;
    
    clear('S');
    S(1, P.intended_epochs) = struct('epoch', [], 'test_SS',  [], 'test_PP',  [], 'test_SP',  [], 'test_PS',  [], 'error_SS',  [], 'error_PP',  [], 'error_SP',  [], 'error_PS', []);
    
    T = struct('SS_all', [], 'PP_all', [], 'SP_all', [], 'PS_all', [], 'SS_frequency', [], 'PP_frequency', [], 'SP_frequency', [], 'PS_frequency', [], 'SS_denseness', [], 'PP_denseness', [], 'SP_denseness', [], 'PS_denseness', [], 'SS_atypicality', [], 'PP_atypicality', [], 'SP_atypicality', [], 'PS_atypicality', [], 'SS_imag', [], 'PP_imag', [], 'SP_imag', [], 'PS_imag', []);
    T.RT_SS = NaN(length(P.test_RT), nrows(D.testingsems));
    T.RT_PP = NaN(length(P.test_RT), nrows(D.testingsems));
    T.RT_SP = NaN(length(P.test_RT), nrows(D.testingsems));
    T.RT_PS = NaN(length(P.test_RT), nrows(D.testingsems));
    if isempty(P.test_errors_atperc) == 0
        T.production = cell(numel(P.test_errors_atperc), nrows(D.testingsems));
    end
    if isempty(P.test_errors_atepoch) == 0
        T.production = cell(numel(P.test_errors_atepoch), nrows(D.testingsems));
    end
    T.prodsavedat = [];
    
    'No initialization; Loading and modifications done'
    
end

%% Training and testing: temp, P, W, S, Q, T gets modified

'Training starts...'

trainedepochs = 0;
temp.retest_scores = zeros(4, P.vocabsize);

for epoch = 1:P.intended_epochs
    
    if P.modes(epoch) ~= 'N'
        
        % Permute order of words before training
        
        if P.permute == 1
            neworder = randperm(nrows(D.trainingsems));
            oldphons = D.trainingphons;
            oldsems = D.trainingsems;
            for i = 1:nrows(D.trainingsems)
                D.trainingphons(i, :) = oldphons(neworder(i), :);
                D.trainingsems(i, :) = oldsems(neworder(i), :);
            end
        end
        
        % Training
        
        W = TrainAssociator22(L, W, P, D, epoch);
        trainedepochs = trainedepochs+1;
        
        % Save weights
        
        if gcd(trainedepochs, P.save_weights) == P.save_weights
            where = trainedepochs/P.save_weights + 1;
            Q(where).epoch = trainedepochs;
            Q(where).weights = W;
        end
        
        % Testing
        
        if gcd(trainedepochs, P.test_performance) == P.test_performance
            
            temp.retest_scores = zeros(4, P.vocabsize);
            temp.retest_errors = zeros(4,1);
            for i = 1:P.retest
                
                [T, SCORES, ERRORS] = TestAssociator22(L, W, P, T, D, trainedepochs, temp);
                
                temp.retest_scores = temp.retest_scores + SCORES;
                temp.retest_errors = temp.retest_errors + ERRORS;
            end
            temp.retest_scores = temp.retest_scores / P.retest;
            temp.retest_errors = temp.retest_errors / P.retest;
            
            % Save test results
            
            where = trainedepochs/P.test_performance;
            S(where).epoch = trainedepochs;
            S(where).test_SS = SCORES(1,:);  % contains score (1/0) for each word in each testing mode in each epoch
            S(where).test_PP = SCORES(2,:);
            S(where).test_SP = SCORES(3,:);
            S(where).test_PS = SCORES(4,:);
            S(where).error_SS = ERRORS(1);
            S(where).error_PP = ERRORS(2);
            S(where).error_SP = ERRORS(3);
            S(where).error_PS = ERRORS(4);
            
            % Print to screen
            
            if gcd(trainedepochs, P.print2screen) == P.print2screen
                ['Training epoch: ', num2str(trainedepochs), '; Vocab: ', num2str(sum(SCORES(1,:))), ', ', num2str(sum(SCORES(2,:))), ', ', num2str(sum(SCORES(3,:))), ', ', num2str(sum(SCORES(4,:)))]
            end
            
            % Changing the remaining modes
            
            if is_partof(P.modes(epoch+1:end), 'S') && sum(SCORES(1,:)) >= P.performance_threshold
                P.modes(epoch + regexp(P.modes(epoch+1:end), 'S')) = 'N';
            end
            if is_partof(P.modes(epoch+1:end), 'P') && sum(SCORES(2,:)) >= P.performance_threshold
                P.modes(epoch + regexp(P.modes(epoch+1:end), 'P')) = 'N';
            end
            if length(regexp(P.modes(epoch+1:end), 'S')) + length(regexp(P.modes(epoch+1:end), 'P')) == 0 && is_partof(P.modes(epoch+1:end), 'R') && sum(SCORES(3,:)) >= P.performance_threshold
                P.modes(epoch + regexp(P.modes(epoch+1:end), 'R')) = 'N';
            end
            if length(regexp(P.modes(epoch+1:end), 'S')) + length(regexp(P.modes(epoch+1:end), 'P')) == 0 && is_partof(P.modes(epoch+1:end), 'L') && sum(SCORES(4,:)) >= P.performance_threshold
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
last_savedweights = which_element(0, P.save_weights > trainedepochs);
Q(last_savedweights+2 : end) = [];

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

% Adding up results in case of intervention
if P.intervention
    
    for i = 1:length(S)
        S(i).epoch = S(i).epoch + P.int_keptepochs;
    end
    S = [oldS(1:P.int_keptepochs/P.test_performance), S];
    
    which = which_element(0, P.save_weights > P.int_keptepochs);
    Q = [oldQ(1:which+1), Q];
    
    which = which_element(0, P.test_RT > P.int_keptepochs);
    T.RT_SS = [oldT.RT_SS(1:which, :); T.RT_SS];
    T.RT_PP = [oldT.RT_PP(1:which, :); T.RT_PP];
    T.RT_SP = [oldT.RT_SP(1:which, :); T.RT_SP];
    T.RT_PS = [oldT.RT_PS(1:which, :); T.RT_PS];
    
    which = which_element(0, oldT.prodsavedat > P.int_keptepochs);
    T.production = [oldT.production(1:which,:); T.production];
    T.prodsavedat = T.prodsavedat + P.int_keptepochs;
    T.prodsavedat = [oldT.prodsavedat(1:which), T.prodsavedat];
    
    oldmodes = oldP.modes;
    oldmodes(regexp(oldmodes, 'N')) = [];
    newmodes = P.modes;
    newmodes(regexp(newmodes, 'N')) = [];
    modes = [oldmodes(1:P.int_keptepochs), newmodes];
    R.passed_epochs = R.passed_epochs + oldR.completed_epochs;
    R.completed_S_epochs = length(regexp(modes, 'S'));
    R.completed_P_epochs = length(regexp(modes, 'P'));
    R.completed_R_epochs = length(regexp(modes, 'R'));
    R.completed_L_epochs = length(regexp(modes, 'L'));
    R.completed_epochs = R.completed_epochs + P.int_keptepochs;
    
end

% When were words  finally learnt? (ha elfelejtette es ujra megtanulta, akkor az utso megtanulas szamit)
testedepochs = length(S);
for i = 2 : testedepochs
    learnt = S(i).test_SS - S(i-1).test_SS == 1;
    for j = 1:P.vocabsize
        if learnt(j)==1
            V(j).AoA(1) = i * P.test_performance;
        end
    end
    learnt = S(i).test_PP - S(i-1).test_PP == 1;
    for j = 1:P.vocabsize
        if learnt(j)==1
            V(j).AoA(2) = i * P.test_performance;
        end
    end
    learnt = S(i).test_SP - S(i-1).test_SP == 1;
    for j = 1:P.vocabsize
        if learnt(j)==1
            V(j).AoA(3) = i * P.test_performance;
        end
    end
    learnt = S(i).test_PS - S(i-1).test_PS == 1;
    for j = 1:P.vocabsize
        if learnt(j)==1
            V(j).AoA(4) = i * P.test_performance;
        end
    end
end

% Deleting empty rows
for i = nrows(T.RT_SP) : -1 : 1
    if isnan(T.RT_SP(i,1))
        T.RT_SS(i, :) = [];
        T.RT_PP(i, :) = [];
        T.RT_SP(i, :) = [];
        T.RT_PS(i, :) = [];
    end
end
if P.save_outputs > 0
    for i = nrows(T.outputs_SS) : -1 : 1
        if  isempty(T.outputs_SS{i,1})
            T.outputs_SS(i,:) = [];
            T.outputs_PP(i,:) = [];            
            T.outputs_SP(i,:) = [];            
            T.outputs_PS(i,:) = [];            
        end
    end
end

% Size of the vocabs after each epoch according to different dimensions - collecting data for plotting
% T is a structure; each field represents one dimension in one task; size of fields = matrix(nb of levels in the dimension, completed epochs)

for i = 1:testedepochs
    T.SS_all(i) = sum(S(i).test_SS);
    T.PP_all(i) = sum(S(i).test_PP);
    T.SP_all(i) = sum(S(i).test_SP);
    T.PS_all(i) = sum(S(i).test_PS);
end

% When did the Associator finally learn the whole vocab? (ha elfelejtette es ujra megtanulta, akkor az utso megtanulas szamit)
R.epochs_tolearn_SS = NaN;
R.epochs_tolearn_PP = NaN;
R.epochs_tolearn_SP = NaN;
R.epochs_tolearn_PS = NaN;

for i = testedepochs : -1 : 1
    if T.SS_all(i) == P.performance_threshold
        R.epochs_tolearn_SS = i * P.test_performance;
    end
    if T.PP_all(i) == P.performance_threshold
        R.epochs_tolearn_PP = i * P.test_performance;
    end
    if T.SP_all(i) == P.performance_threshold
        R.epochs_tolearn_SP = i * P.test_performance;
    end
    if T.PS_all(i) == P.performance_threshold
        R.epochs_tolearn_PS = i * P.test_performance;
    end
end

% Size of the final vocab
R.vocab_SS = T.SS_all(end);
R.vocab_PP = T.PP_all(end);
R.vocab_SP = T.SP_all(end);
R.vocab_PS = T.PS_all(end);

'Calculating results finished'

% Categorize errors

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
        P.Ssize,
        P.Psize,
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

%% Plot composite figure

if P.plot_trajectories
    figure
    title('Developmental trajectories');
    x = P.test_performance : P.test_performance : R.completed_epochs;
    hold all
    plot(x, T.SS_all, '--m', 'LineWidth', 1.5);
    plot(x, T.PP_all, '--c', 'LineWidth', 1.5);
    plot(x, T.SP_all, ':r', 'LineWidth', 1.5);
    plot(x, T.PS_all, ':b', 'LineWidth', 1.5);
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
rng('shuffle')