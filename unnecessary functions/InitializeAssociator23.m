function [L, W, P, S, R, V, T, Q, D] = InitializeAssociator23(P)

P.ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
P.modes = modesequence(P.trainingtype, P.nbof_S_epochs, P.nbof_P_epochs, P.nbof_R_epochs, P.nbof_L_epochs);
P.intended_epochs = length(P.modes);
if sum(P.noise) == 0
    P.retest = 1;
end

%% Generate input

% Testingvocab
D.start = [];
D.testingphons = xlsread(P.vocabfile, 'phon');
D.testingsems = xlsread(P.vocabfile, P.semanticrep);
D.frequencies = xlsread(P.vocabfile, 'freq', [P.frequencymeasure,':',P.frequencymeasure]);

P.vocabsize = size(D.testingphons, 1);
P.Ssize = size(D.testingsems, 2); % nb of semantic features
P.Psize = size(D.testingphons, 2); % nb of phonological features for phoneticsgenerator_exact

D.trainingphons = D.testingphons;
D.trainingsems = D.testingsems;

% Trainingvocab: change frequency of words
% Collect all variables regarding words in V
V = [];
% Categorize words according to levels in the dimensions

%% Layers

P.size_SI = ncols(D.testingsems);    % retinal/semantic input layer
P.size_SO = ncols(D.testingsems);
P.size_PI = ncols(D.testingphons);    % label/phonetic input layer
P.size_PO = ncols(D.testingphons);

P.layernames = {'SI', 'SH', 'SO', 'PI', 'PH', 'PO', 'AR', 'AL'};
P.layersizes = {P.size_SI, P.size_SH, P.size_SO, P.size_PI, P.size_PH, P.size_PO, P.size_AR, P.size_AL};

for i = 1:length(P.layernames)
    L(i).name = P.layernames{i};
    L(i).state = P.layerinit(1, P.layersizes{i});
    L(i).size = P.layersizes{i};
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

for i = 1:length(P.weightnames)
    W(i).name = P.weightnames{i};
    W(i).size = [P.weightsizes{i}(1) + P.usebias, P.weightsizes{i}(2)];
    W(i).state = P.randmin + (P.randmax-P.randmin) .* P.weightinit(W(i).size);     % For randn this will be: P.randmax*randn(P.weightsizes{i})
    W(i).momentumterm = zeros(W(i).size);
    W(i).change = zeros(W(i).size);
    
    if P.usebias == 1
        W(i).biasweights = nrows(W(i).state) : nrows(W(i).state) : numel(W(i).state); % this gives you a list of the biasweight Nos (sorszamok)
    else
        W(i).biasweights = [];
    end
    
end

P.bias = zeros(1, P.usebias)+P.biasvalue; % 1x0 empty vector if no bias; 1x1 vector contains biasvalue, if usebias = 1

% Non-existent connections
P.densities = {P.dens_SISH, P.dens_SHSO, P.dens_PIPH, P.dens_PHPO, P.dens_SHAR, P.dens_ARPH, P.dens_PHAL, P.dens_ALSH};
for i = 1:length(W)
    nbof_eliminated = round(numel(W(i).state) * (1-P.densities{i}));
    rng(1);
    W(i).eliminated = randchoose(1:numel(W(i).state), nbof_eliminated);
    W(i).state(W(i).eliminated) = 0;
end

% Store weights
Q(1).epoch = 0;
Q(1).weights = W;

%% Tests, scores, errors

if gcd(P.test_RT, P.test_performance) ~= P.test_performance && P.test_RT ~= 0
    P.test_RT = P.test_performance;       % has to be a multiple of P.test_performance
end
if gcd(P.save_outputs, P.test_performance) ~= P.test_performance && P.save_outputs ~= 0
    P.save_outputs = P.test_performance;       % has to be a multiple of P.test_performance
end
if gcd(P.save_weights, P.test_performance) ~= P.test_performance && P.save_weights ~= 0
    P.save_weights = P.test_performance;       % has to be a multiple of P.test_performance
end
if gcd(P.print2screen, P.test_performance) ~= P.test_performance && P.print2screen ~= 0
    P.print2screen = P.test_performance;       % has to be a multiple of P.test_performance
end

S(1, P.intended_epochs) = struct('epoch', [], 'test_SS',  [], 'test_PP',  [], 'test_SP',  [], 'test_PS',  [], 'error_SS',  [], 'error_PP',  [], 'error_SP',  [], 'error_PS', []);

T = struct('SS_all', [], 'PP_all', [], 'SP_all', [], 'PS_all', [], 'SS_frequency', [], 'PP_frequency', [], 'SP_frequency', [], 'PS_frequency', [], 'SS_denseness', [], 'PP_denseness', [], 'SP_denseness', [], 'PS_denseness', [], 'SS_atypicality', [], 'PP_atypicality', [], 'SP_atypicality', [], 'PS_atypicality', [], 'SS_imag', [], 'PP_imag', [], 'SP_imag', [], 'PS_imag', []);
T.RT_SS = [];
T.RT_PP = [];
T.RT_SP = [];
T.RT_PS = [];
T.outputs_SS = {};
T.outputs_PP = {};
T.outputs_SP = {};
T.outputs_PS = {};

R.start = 1;

