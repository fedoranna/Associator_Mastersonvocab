function [P, D, L, W, V, Q, S, R, T] = InitializeAssociator_M(P)

%% Check and correct some of the parameters

P.ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');

if sum(P.noise) == 0
    P.retest = 1;
end

if P.test_performance == 0
    P.test_performance = P.nbof_S_epochs + P.nbof_P_epochs + P.nbof_R_epochs + P.nbof_L_epochs;
end

if gcd(P.test_RT, P.test_performance) ~= P.test_performance
    P.test_RT = P.test_performance;       % has to be a multiple of P.test_performance
end
if gcd(P.save_outputs, P.test_performance) ~= P.test_performance
    P.save_outputs = P.test_performance;       % has to be a multiple of P.test_performance
end
if gcd(P.print2screen, P.test_performance) ~= P.test_performance
    P.print2screen = P.test_performance;       % has to be a multiple of P.test_performance
end

%% Training epochs

P.modes = modesequence(P.trainingtype, P.nbof_S_epochs, P.nbof_P_epochs, P.nbof_R_epochs, P.nbof_L_epochs);
P.intended_epochs = length(P.modes);

%% Vocabulary (lexicon)

% Testingvocab
[num,D.words,raw] = xlsread(P.vocabfile, 'words');
D.testingsems = xlsread(P.vocabfile, P.semanticrep);
D.testingphons = xlsread(P.vocabfile, 'phon');
D.frequencies = xlsread(P.vocabfile, 'freq', [P.frequencymeasure,':',P.frequencymeasure]);

P.vocabsize = size(D.testingphons, 1);
P.Ssize = size(D.testingsems, 2); % nb of semantic features
P.Psize = size(D.testingphons, 2); % nb of phonological features for phoneticsgenerator_exact

% Trainingvocab
D.trainingsems = D.testingsems;
D.trainingphons = D.testingphons;

% Frequencies
D.wc_modulator = ones(size(D.trainingsems,1),1);    % modulator of learning rate for each word
D.tr_prob = NaN(size(D.trainingsems,1),1);          % training probability of each word
if strcmp(P.frequencymeasure, 'D') || strcmp(P.frequencymeasure, 'E') || strcmp(P.frequencymeasure, 'F') || strcmp(P.frequencymeasure, 'J')
    D.wc_modulator = D.frequencies;
end
if strcmp(P.frequencymeasure, 'G') || strcmp(P.frequencymeasure, 'H') || strcmp(P.frequencymeasure, 'I')
    D.tr_prob = D.frequencies;
end   

%% Collect all variables regarding words in V (you could also include semantic category, AoA, etc)

V(1, P.vocabsize) = struct('word', [], 'sem',  [], 'phon',  [], 'freq', []);
for i = 1:P.vocabsize
    V(i).word = D.words(i);
    V(i).sem = D.testingsems(i,:);
    V(i).phon = D.testingphons(i,:);
    V(i).freq = D.frequencies(i);
    V(i).AoA = NaN(1,4);
end

%% Layers

P.size_SI = ncols(D.testingsems);       % retinal/semantic input layer
P.size_SO = ncols(D.testingsems);       % semantic output layer
P.size_PI = ncols(D.testingphons);      % label/phonological input layer
P.size_PO = ncols(D.testingphons);      % phonological output layer

P.layernames = {'SI', 'SH', 'SO', 'PI', 'PH', 'PO', 'AR', 'AL'};
P.layersizes = {P.size_SI, P.size_SH, P.size_SO, P.size_PI, P.size_PH, P.size_PO, P.size_AR, P.size_AL};

L(1, 8) = struct('name', [], 'size', [], 'state', []);
for i = 1:length(P.layernames)
    L(i).name = P.layernames{i};
    L(i).size = P.layersizes{i};
    L(i).state = P.layerinit(1, P.layersizes{i});
end

%% Weights

P.weightnames = {'SISH', 'SHSO', 'PIPH', 'PHPO', 'SHAR', 'ARPH', 'PHAL', 'ALSH'};
P.weightsizes = {
    [P.size_SI, P.size_SH],
    [P.size_SH, P.size_SO],
    [P.size_PI, P.size_PH],
    [P.size_PH, P.size_PO],
    [P.size_SH, P.size_AR],
    [P.size_AR, P.size_PH],
    [P.size_PH, P.size_AL],
    [P.size_AL, P.size_SH],
    };

if strcmp(P.weightseed, 'noseed')
    s = rng;
    P.weightseed = s.Seed;
else
    rng(P.weightseed, 'twister');
end

W(1, 8) = struct('name', [], 'size', [], 'state', [], 'momentumterm', [], 'change', [], 'biasweights', [], 'eliminated', []);
for i = 1:length(P.weightnames)
    W(i).name = P.weightnames{i};
    W(i).size = [P.weightsizes{i}(1) + P.usebias, P.weightsizes{i}(2)];
    W(i).state = P.randmin + (P.randmax-P.randmin) .* P.weightinit(W(i).size);     % For randn this will be: P.randmax*randn(P.weightsizes{i})
    W(i).momentumterm = zeros(W(i).size);
    W(i).change = zeros(W(i).size);
    
    if P.usebias == 1
        W(i).biasweights = nrows(W(i).state) : nrows(W(i).state) : numel(W(i).state); % this gives you a list of the biasweight indices
    else
        W(i).biasweights = [];
    end
    
end

P.bias = zeros(1, P.usebias)+P.biasvalue; % 1x0 empty vector if there is no bias; 1x1 vector contains biasvalue, if usebias = 1

% Non-existent connections
P.densities = {P.dens_SISH, P.dens_SHSO, P.dens_PIPH, P.dens_PHPO, P.dens_SHAR, P.dens_ARPH, P.dens_PHAL, P.dens_ALSH};
for i = 1:length(W)
    nbof_eliminated = round(numel(W(i).state) * (1-P.densities{i}));
    W(i).eliminated = randchoose(1:numel(W(i).state), nbof_eliminated);
    W(i).state(W(i).eliminated) = 0;
end

%% Outputs: Q, O, S, T, R

% Store weights
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
Q(1).epoch = 0;
Q(1).weights = W;

% Store test results
if P.test_performance > 0
    elements = floor(P.intended_epochs/P.test_performance);
else
    elements = 1;
end
S(1, elements) = struct('epoch', [], 'scores_SS',  [], 'scores_PP',  [], 'scores_SP',  [], 'scores_PS',  [], 'errors_SS',  [], 'errors_PP',  [], 'errors_SP',  [], 'errors_PS', [], 'rts_SS',  [], 'rts_PP',  [], 'rts_SP',  [], 'rts_PS', [], 'outputs_SS',  [], 'outputs_PP',  [], 'outputs_SP',  [], 'outputs_PS', []);

% Store summary results
T.start=1;
R.start=1;

