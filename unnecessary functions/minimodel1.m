%% Description
% small model for learning association between two layers
% SH -> PH

% L: layers
% W: weights
% P: parameters
% N: nonchanging parameters
% E: errors
% T: test results
% V: vocabulary known by the network
% R: short results
% repr1: representation of words without associative links
% repr2: representation of words with associative links

%% Parameters

clear
path('F:\Matlab_functions',path);

% Saving results
beeps = 2; % Do you want a very annoying reminder when the running is over?
P.saveresults = 0; % save results or not?
P.folder = 'F:\Matlab_functions\RESULTS\minimodel1\'; % folder to save results
P.resultsfile = [P.folder, 'RESULTS_minimodel1.xlsx']; % file to save summary results

% Stop conditions
P.nbof_epochs = 300000;
P.convergence_threshold = 1.0e-008; % break condition/weight; with 1.0e-004 breaks instantly
P.error_threshold = 1.0e-009; % break condition for error/both output layers

% Evaluating
P.upper_TH = 0.8; % threshold of activation for answer = 1
P.lower_TH = 0.2; % threshold of activation for answer = 0

% Training
P.transferfn = @transferfn_logsig; % transferfn_logsig, tansig; threshold does not work
P.T = 1; % temperature for logsig and tansig transferfunctions, the threshold for threshold/step transferfn
P.normfn = @nochange;
P.learningrate = 0.8  ;
P.momentum = 0.3;

% Input
P.vocabsize = 20;

% Size of variable size layers
P.size_SH = 10;
P.size_PH = 10;

% Initialization
P.layerinit = @zeros;
P.weightinit = @rand;
P.seed = 1; % 'noseed' or a number

'Parameter reading done'
%% Initialization

% Input
sems = rand(P.vocabsize, P.size_SH);
phons = rand(P.vocabsize, P.size_PH);

% Layers
N.layernames = {'SH', 'PH'};
N.layersizes = {P.size_SH, P.size_PH};
for i = 1:length(N.layernames)
    L(i).name = N.layernames{i};
    L(i).state = P.layerinit(1, N.layersizes{i});
    L(i).size = N.layersizes{i};
end

% Weights
W(1).name = 'SHPH';
if P.seed ~= 'noseed'
    rand('seed', P.seed);
end
W(1).state = P.weightinit(P.size_SH, P.size_PH);
W(1).change = 0;

% Diagnostics
E.collect_SSE_PH_epoch = NaN(1, P.nbof_epochs);

'Initialization done'
%% Training and testing associative links

'Training associative links starts...'

for epoch = 1:P.nbof_epochs

    %% Training %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    W(1).prevstate = W(1).state;
    E.SSE_PH_epoch = 0;

    for sweep = 1:P.vocabsize

        % Activations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        L(1).state = sems(sweep, :);
        L(2).state = P.transferfn(L(1).state * W(1).state, P.T); % SH

        % Back-propagation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Calculate delta for all layers

        target_PH = phons(sweep, :);
        L(2).delta = delta(L(2).state, target_PH); % PH

        % Apply weight change

        W(1).momentumterm = P.momentum * W(1).change;
        W(1).change = incr(P.learningrate, L(1).state, L(2).delta) + W(1).momentumterm;
        W(1).state = W(1).state + W(1).change; % Update weights
        W(1).state = P.normfn(W(1).state); % Normalize weights

        % Diagnostics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        target_PH = phons(sweep,:);
        error_PH = target_PH - L(2).state;
        SSE_PH = sum(error_PH.^2);  % sum of squared errors in this sweep
        avgSSE_PH = SSE_PH/P.size_PH;
        E.SSE_PH_epoch = E.SSE_PH_epoch + avgSSE_PH; % accumulating SSE for this epoch

        E.collect_SSE_PH_epoch(epoch) = E.SSE_PH_epoch; % collecting SSE for each epoch

    end % end of training epoch

    %% Testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    scores.SP = NaN(1, P.vocabsize);

    for sweep = 1:P.vocabsize
        
        % Activations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        L(1).state = sems(sweep, :);
        L(2).state = P.transferfn(L(1).state * W(1).state, P.T); % SH
        
        % Task: S -> P
        
        target_PH = phons(sweep,:);
        scores.SP(sweep) = is_correct(target_PH, L(2).state, P.upper_TH, P.lower_TH);
        repr(sweep).ass = {{L(1).state},{L(2).state}};

        T(epoch) = scores; % contains score (1/0) for each word in each testing mode in each epoch
        V.SP(epoch) = sum(T(epoch).SP); % contains nb of words known in each testing mode in each epoch
        
    end % end of testing epoch

    %% Stopping reason %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Did the network learn all words?
    if V.SP(epoch) == P.vocabsize
        R.stoppingreason = 'Network learned all words.';
        R.epochs = epoch;
        break
    end

    % Is the error small enough?
    if (E.SSE_PH_epoch) < P.error_threshold
        R.stoppingreason = 'Error is small enough.';
        R.epochs = epoch;
        break
    end

    % Did weights converge?
    convergence = zeros(1,1);
    if sum(sum(abs(W(1).prevstate - W(1).state))) < P.convergence_threshold * numel(W(1).state);
        convergence=1;
        R.stoppingreason = 'All weights converged.';
        R.epochs = epoch;
        break;
    end

    ['Training epoch: ', num2str(epoch), '; Error: ', num2str(E.SSE_PH_epoch, '%6.15f'), ' ...']

    % Did training stop because the number of epochs reached the preset number?
    if epoch == P.nbof_epochs
        R.stoppingreason_ass = 'The number of epochs reached the preset number.';
        R.epochs = epoch;
    end

end % end of training and testing

R.vocab_SP = V.SP(R.epochs);

% When did the Associator learn the whole vocab?
R.epochs_tolearn_SP = NaN;
for i = R.epochs : -1 : 1
    if V.SP(i) == P.vocabsize
        R.epochs_tolearn_SP = i;
    end
end

x = toc;
R.runningtime_min = x/60;

R

%% Save results

if P.saveresults == 1
    where = nrows(xlsread(P.resultsfile))+1;
    timestamp=datestr(now);
    timestamp(end-2)='-';
    timestamp(end-5)='-';
    timestamp(end-8)='-';

    tosave = {
        timestamp,
        %%% Results
        R.vocab_SS,
        R.vocab_PP,
        R.vocab_SP,
        R.vocab_PS,
        R.epochs_sep,
        R.epochs_ass,
        R.epochs_all,
        R.epochs_tolearn_SS,
        R.epochs_tolearn_PP,
        R.epochs_tolearn_SP,
        R.epochs_tolearn_PS,
        R.stoppingreason_sep,
        R.stoppingreason_ass,
        R.runningtime_min,
        %%% Parameters
        P.learningrate,
        P.momentum,
        P.nbof_sem_feat,
        P.size_SH,
        P.size_PH,
        P.upper_TH,
        P.lower_TH,
        P.convergence_threshold,
        P.error_threshold,
        func2str(P.transferfn),
        P.T,
        func2str(P.normfn),
        func2str(P.layerinit),
        func2str(P.weightinit),
        P.seed
        };

    % Save all parameters to an excel file
    xlswrite(P.resultsfile, tosave', 'results', ['A', num2str(where)]);

    % Save all variables in .mat file; later can be loaded
    save([P.folder, timestamp, '.mat']);

    % Save figure
    figtitle = ['Associator2; Timestamp: ', timestamp];
    figurefile = [P.folder, timestamp, '.jpg'];

    figure;
    name=figtitle;
    hold all
    plot(E.collect_SSE_PH_epoch(1:R.epochs));
    plot(V.SP(1:R.epochs));
    axis([-100 R.epochs+100 -1 21]);
    set(gca,'TickDir','out');
    xlabel('Number of epochs');
    title(figtitle); % kesobbi MatLabban %suptitle(figtitle);
    print('-djpeg', figurefile);

    hold off
end

%% Beep-beep

for i=1:beeps
    beep
    pause(0.5)
end

%% Check representations step-by-step

if 1==2

    sweep = 2;

    words = {'bad', 'ber', 'bir', 'bor', 'gar', 'gin', 'god', 'gun', 'ped', 'piw', 'pow', 'pur', 'sad', 'sew', 'sod', 'sun', 'tan', 'tar', 'tid', 'ton'};
    word= words(sweep);

    SI_sep = repr1(sweep).sep{3,1}{1};
    SH_sep = repr1(sweep).sep{2,1}{1};
    SO_sep = repr1(sweep).sep{1,1}{1};
    PI_sep = repr1(sweep).sep{3,2}{1};
    PH_sep = repr1(sweep).sep{2,2}{1};
    PO_sep = repr1(sweep).sep{1,2}{1};

    SI_ass = repr2(sweep).ass{3,1}{1};
    SH_ass = repr2(sweep).ass{2,1}{1};
    SO_ass = repr2(sweep).ass{1,1}{1};
    PI_ass = repr2(sweep).ass{3,2}{1};
    PH_ass = repr2(sweep).ass{2,2}{1};
    PO_ass = repr2(sweep).ass{1,2}{1};

    SS = isequal(SI_sep, act2bin(SO_sep, P.upper_TH, P.lower_TH));
    PP = isequal(PI_sep, act2bin(PO_sep, P.upper_TH, P.lower_TH));
    PS = isequal(SI_ass, act2bin(SO_ass, P.upper_TH, P.lower_TH));
    SP = isequal(PI_ass, act2bin(PO_ass, P.upper_TH, P.lower_TH));

    % Write
    results = {
        ['PJ test (SS): ', num2str(SS)]
        ['BPVS (PS): ', num2str(PS)]
        ['CNRep (PP): ', num2str(PP)]
        ['Picture Naming (SP): ', num2str(SP)]};

    % Plot
    %colormap(hot);

    clf
    p1 = subplot(2,1,1);
    im1 = imagesc([SH_sep; SH_ass]);
    %set(gca, 'Title', 'Semantic representation');
    title('Semantic representation');
    set(gca, 'YTick', [1, 2], 'YTickLabel', {'Sees', 'Listens'}, 'YGrid', 'off', 'DataAspectRatio', [1,1,1]);
    line([-1, 21], [1.5, 1.5], 'LineWidth',4,'Color',[.8 .8 .8]);
    a=annotation('textbox', 'Position',[0.06171 0.4 0.2722 0.1881], 'FitBoxToText','on','VerticalAlignment', 'bottom','String', results);

    subplot(2,1,2), imagesc([PH_sep; PH_ass]);
    title('Phonetic representation');
    set(gca, 'YTick', [1, 2], 'YTickLabel', {'Listens', 'Sees'}, 'YGrid', 'off', 'DataAspectRatio', [1,1,1]);
    line([-1, 21], [1.5, 1.5], 'LineWidth',4,'Color',[.8 .8 .8]);

    suptitle(['Word: ', char(word)]);
    colorbar('peer',gca,[0.925 0.2143 0.025 0.5381],'LineWidth',1);

end

%% Notes

    % Fredt?l megkérdezni, hogy pontosan hogy legyen az ass. training és
    % testing!!!
    % miért nem m?ködik zeros weightinit-tel? nem változnak

    % miért nehezebb megtanulni az associative linkeket?
    % - mert csak egy rétegnyi súly van rá
    % - mert az SO-PO-t tesztelem, de a hidden layereket tanítom csak
    % miért könnyebb SP-t megtanulni, mint PS-t?
