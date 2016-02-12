%% Plunkett model - from scratch - with Fred's lexicon

%% Parameters

clear
path('E:\Matlab_functions',path);
%path('E:\Matlab_functions\functions_WFDmodel_Anna Fedor', path);

% Saving results
saveresults = 1;
folder = 'E:\Matlab_functions\RESULTS\Plunkett model\';
resultsfile = [folder, 'RESULTS_Plunkett model.xlsx'];

% Stop conditions
nbof_epochs = 100000;
convergence_threshold = 1.0e-008; % break condition/weight; with 1.0e-004 breaks instantly
error_threshold = 1.0e-009; % break condition for error/both output layers

% Evaluating
upper_TH = 0.8; % threshold of activation for answer = 1
lower_TH = 0.2; % threshold of activation for answer = 0

% Training
transferfn = @transferfn_sigmoid; % (NNToolbox: logsig, tansig, purelin)
normfn = @nochange;
learningrate = 0.1;
momentum = 0.5;
modes = {'S'}; % {'B,' 'S', 'P'}: both input, semantics only, phonetics only

% Input
nbof_sem_feat = 10;     % =size(sems, 2);

% Size of variable size layers
SH =  5;                % retinal hidden layer: originally 30
PH = 10;                % label hidden layer
CH = 30;                % common hidden layer

% Initialization
layerinit = @zeros;
weightinit = @rand;

'Parameter reading done'
%% Initialization

% Fixed parameters: Size of fixed size layers, parameters of lexicon

tic
nbof_phon_feat = 14;    % =size(phons, 2);
vocabsize = 20;         % =size(phons,1);
SI = nbof_sem_feat;     % retinal/semantic input layer: originally 171; 175*12=2100
PI = nbof_phon_feat;    % label/phonetic input layer
SO = SI;                % retinal output layer
PO = PI;                % label output layer

% Input
[phons, sems] = lexicongenerator_Freds(nbof_sem_feat);

% Layers
layer_SI = layerinit(1, SI);
layer_SH = layerinit(1, SH);
layer_SO = layerinit(1, SO);
layer_PI = layerinit(1, PI);
layer_PH = layerinit(1, PH);
layer_PO = layerinit(1, PO);
layer_CH = layerinit(1, CH);

% Weights
weights_SISH = weightinit(SI, SH);
weights_SHCH = weightinit(SH, CH);
weights_CHSO = weightinit(CH, SO);
weights_PIPH = weightinit(PI, PH);
weights_PHCH = weightinit(PH, CH);
weights_CHPO = weightinit(CH, PO);

% Weightchanges
weightchange_SISH = 0;
weightchange_SHCH = 0;
weightchange_CHSO = 0;
weightchange_PIPH = 0;
weightchange_PHCH = 0;
weightchange_CHPO = 0;

% Diagnostics
collect_SSE_epoch = NaN(1, nbof_epochs);

'Initialization done'
%% Training

'Training starts...'

for epoch = 1:nbof_epochs

    SSE_epoch = 0;

    weights_SISH_prev = weights_SISH;
    weights_SHCH_prev = weights_SHCH;
    weights_CHSO_prev = weights_CHSO;
    weights_PIPH_prev = weights_PIPH;
    weights_PHCH_prev = weights_PHCH;
    weights_CHPO_prev = weights_CHPO;

    for sweep = 1:vocabsize

        for mode = modes % 1,2,3: both input, semantics only, phonetics only
            
            % Input according to mode %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            if mode{1} == 'B'
                input_sem = sems(sweep,:);
                input_phon = phons(sweep,:);
            end
            if mode{1} == 'S'
                input_sem = sems(sweep,:);
                input_phon = zeros(1, ncols(phons));
            end
            if mode{1} == 'P'
                input_sem = zeros(1, ncols(sems));
                input_phon = phons(sweep,:);
            end

            % Activations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            layer_SI = input_sem;
            layer_PI = input_phon;
            layer_SH = transferfn(layer_SI * weights_SISH);
            layer_PH = transferfn(layer_PI * weights_PIPH);
            layer_CH = transferfn(layer_SH * weights_SHCH + layer_PH * weights_PHCH);
            layer_SO = transferfn(layer_CH * weights_CHSO);
            layer_PO = transferfn(layer_CH * weights_CHPO);

            % Back-propagation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            target_SO = sems(sweep,:);
            target_PO = phons(sweep,:);

            % Calculate delta for all layers

            delta_SO = delta(layer_SO, target_SO);
            delta_PO = delta(layer_PO, target_PO);

            delta_CH_R = delta(layer_CH, delta_SO, weights_CHSO);
            delta_CH_L = delta(layer_CH, delta_PO, weights_CHPO);
            delta_CH = delta_CH_R + delta_CH_L;

            delta_SH = delta(layer_SH, delta_CH, weights_SHCH);
            delta_PH = delta(layer_PH, delta_CH, weights_PHCH);

            delta_SI = delta(layer_SI, delta_SH, weights_SISH);
            delta_PI = delta(layer_PI, delta_PH, weights_PIPH);

            % Apply weight change
            
            if mode{1} == 'B' || mode{1} == 'S';
           
                momentumterm = momentum * weightchange_CHSO;
                weightchange_CHSO = incr(learningrate, layer_CH, delta_SO) + momentumterm;
                weights_CHSO = weights_CHSO + weightchange_CHSO;

                momentumterm = momentum * weightchange_SHCH;
                weightchange_SHCH = incr(learningrate, layer_SH, delta_CH) + momentumterm;
                weights_SHCH = weights_SHCH + weightchange_SHCH;

                momentumterm = momentum * weightchange_SISH;
                weightchange_SISH = incr(learningrate, layer_SI, delta_SH) + momentumterm;
                weights_SISH = weights_SISH + weightchange_SISH;

            end
            if mode{1} == 'B' || mode{1} == 'P'

                momentumterm = momentum * weightchange_CHPO;
                weightchange_CHPO = incr(learningrate, layer_CH, delta_PO) + momentumterm;
                weights_CHPO = weights_CHPO + weightchange_CHPO;

                momentumterm = momentum * weightchange_PHCH;
                weightchange_PHCH = incr(learningrate, layer_PH, delta_CH) + momentumterm;
                weights_PHCH = weights_PHCH + weightchange_PHCH;

                momentumterm = momentum * weightchange_PIPH;
                weightchange_PIPH = incr(learningrate, layer_PI, delta_PH) + momentumterm;
                weights_PIPH = weights_PIPH + weightchange_PIPH;

            end

            % Normalize weights
            
            weights_SISH = normfn(weights_SISH);
            weights_SHCH = normfn(weights_SHCH);
            weights_CHSO = normfn(weights_CHSO);
            weights_PIPH = normfn(weights_PIPH);
            weights_PHCH = normfn(weights_PHCH);
            weights_CHPO = normfn(weights_CHPO);

            % Diagnostics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            error_SO = target_SO - layer_SO;
            error_PO = target_PO - layer_PO;
            SSE = sum(error_SO.^2) + sum(error_PO.^2); % sum of squared errors in this sweep
            SSE_avg = SSE/(SO+PO);
            SSE_epoch = SSE_epoch + SSE_avg; % accumulating SSE for this epoch

        end

    end % end of sweep

    collect_SSE_epoch(epoch) = SSE_epoch; % collecting SSE for each epoch

    % Did weights converge?
    convergence = zeros(1,6);
    if sum(sum(abs(weights_SISH_prev-weights_SISH))) < convergence_threshold * (SI * SH); convergence(1)=1; end
    if sum(sum(abs(weights_SHCH_prev-weights_SHCH))) < convergence_threshold * (SH * CH); convergence(2)=1; end
    if sum(sum(abs(weights_CHSO_prev-weights_CHSO))) < convergence_threshold * (CH * SO); convergence(3)=1; end
    if sum(sum(abs(weights_PIPH_prev-weights_PIPH))) < convergence_threshold * (PI * PH); convergence(4)=1; end
    if sum(sum(abs(weights_PHCH_prev-weights_PHCH))) < convergence_threshold * (PH * CH); convergence(5)=1; end
    if sum(sum(abs(weights_CHPO_prev-weights_CHPO))) < convergence_threshold * (CH * PO); convergence(6)=1; end
    if sum(convergence) == 6
        stoppingreason='All weights converged.'
        break;
    end

    % Is the error small enough?
    if SSE_epoch < error_threshold
        stoppingreason='Error is small enough.'
        break
    end

    ['Epoch: ', num2str(epoch), '; Error: ', num2str(SSE_epoch), '...']

    % Did training stop because the number of epochs reached the preset number?
    if epoch == nbof_epochs
        stoppingreason='Training finished because the number of epochs reached the preset number.'
    end

end

%plot(collect_SSE_epoch)

%% Evaluate

'Evaluating...'

scores = NaN(vocabsize, 7);
scores(:,1)=1:vocabsize;
collect_SSE = NaN(1, vocabsize*3);

for sweep = 1:vocabsize
    for mode = {'B', 'S', 'P'} % both input, semantics only, phonetics only

        % Input according to mode %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if mode{1} == 'B'
            input_sem = sems(sweep,:);
            input_phon = phons(sweep,:);
        end
        if mode{1} == 'S'
            input_sem = sems(sweep,:);
            input_phon = zeros(1, ncols(phons));
        end
        if mode{1} == 'P'
            input_sem = zeros(1, ncols(sems));
            input_phon = phons(sweep,:);
        end

        % Activations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        layer_SI = input_sem;
        layer_PI = input_phon;
        layer_SH = transferfn(layer_SI * weights_SISH);
        layer_PH = transferfn(layer_PI * weights_PIPH);
        layer_CH = transferfn(layer_SH * weights_SHCH + layer_PH * weights_PHCH);
        layer_SO = transferfn(layer_CH * weights_CHSO);
        layer_PO = transferfn(layer_CH * weights_CHPO);

        % Diagnostics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        target_SO = sems(sweep,:);
        target_PO = phons(sweep,:);
        error_SO = target_SO - layer_SO;
        error_PO = target_PO - layer_PO;
        SSE = sum(error_SO.^2) + sum(error_PO.^2); % sum of squared errors in this sweep
        SSE_avg = SSE/(SO+PO);
        collect_SSE(firstnan(collect_SSE)) = SSE_avg; % collecting SSE for each sweep

        % Is the output correct?

        answer_sem = act2bin(layer_SO, upper_TH, lower_TH);
        answer_phon = act2bin(layer_PO, upper_TH, lower_TH);
        if sum(answer_sem == sems(sweep,:)) == length(answer_sem)
            iscorrect_sem = 1;
        else iscorrect_sem = 0;
        end
        if sum(answer_phon == phons(sweep,:)) == length(answer_phon)
            iscorrect_phon = 1;
        else iscorrect_phon = 0;
        end

        % Saving scores

        if mode{1} == 'B'
            scores(sweep, 2:3) = [iscorrect_sem, iscorrect_phon];
        end
        if mode{1} == 'S'
            scores(sweep, 4:5) = [iscorrect_sem, iscorrect_phon];
        end
        if mode{1} == 'P'
            scores(sweep, 6:7) = [iscorrect_sem, iscorrect_phon];
        end

    end
end

scoresums = sum(scores);
modeB_scoreSO = scoresums(2);
modeB_scorePO = scoresums(3);
modeS_scoreSO = scoresums(4);
modeS_scorePO = scoresums(5);
modeP_scoreSO = scoresums(6);
modeP_scorePO = scoresums(7);

SSE_both = sum(collect_SSE(1:20))
SSE_semonly = sum(collect_SSE(21:40))
SSE_phononly = sum(collect_SSE(41:60))

%% Save results

if saveresults == 1
    where = nrows(xlsread(resultsfile))+1;
    timestamp=datestr(now);
    timestamp(end-2)='-';
    timestamp(end-5)='-';
    timestamp(end-8)='-';
    parameters = {
        timestamp,
        %%% Parameters
        % Stop conditions:
        nbof_epochs,
        convergence_threshold,
        error_threshold,
        % Evaluating:
        upper_TH,
        lower_TH,
        % Training:
        func2str(transferfn),
        func2str(normfn),
        learningrate,
        momentum,
        [modes{:}],
        % Input:
        nbof_sem_feat,
        % Size of layers:
        SH,
        PH,
        CH,
        %%% Initialization:
        func2str(layerinit),
        func2str(weightinit),
        %%% Training
        stoppingreason,
        %%% Evaluating
        SSE_both,
        SSE_semonly,
        SSE_phononly,
        modeB_scoreSO,
        modeB_scorePO,
        modeS_scoreSO,
        modeS_scorePO,
        modeP_scoreSO,
        modeP_scorePO
        };

    % Save all parameters to an excel file
    xlswrite(resultsfile, parameters', 'results', ['A', num2str(where)]);

    % Save all variables in .mat file; later load
    save([folder, timestamp, '.mat']);

    % Save scores
    xlswrite([folder, timestamp, '.xlsx'], scores);

    % Save figure
    figtitle = ['Timestamp: ', timestamp];
    figurefile = [folder, timestamp, '.jpg'];
    figure;
    name=figtitle;
    plot(collect_SSE_epoch);
    xlabel('Number of epochs');
    ylabel('SSE');
    %suptitle(figtitle);
    title(figtitle);
    print('-djpeg', figurefile);

end
toc
beep;
%% TODO

% Code different correctness criteria (e.g.: closest word from lexicon)
% training in random order with seed
% miért nem m?ködik, ha weightinit = zeros
% miért nem m?ködik, ha normbyrowmax? a matrix maximumaval kene normalizalni
% save weights after each epoch
% batch learning
% Different error types to plot?
% Code conjugate gradient descent





