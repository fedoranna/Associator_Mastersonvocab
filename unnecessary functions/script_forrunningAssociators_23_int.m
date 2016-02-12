% Runs the model in loops

%% Load default parameters

clear
rng('shuffle')
addpath(genpath('C:\Matlab_functions'));
load('C:\Matlab_functions\model_Associator\Associator23_params1.mat')

%% Modify parameters

t=1000;
test = 100;
P.nbof_S_epochs = t; % nb of epochs to train model on task S
P.nbof_P_epochs = t; % nb of epochs to train model on task P
P.nbof_R_epochs = t; % nb of epochs to train model on task R
P.nbof_L_epochs = t; % nb of epochs to train model on task L

P.print2screen = test;
P.test_performance = test;
P.test_errors_atepoch = [test:test:t*4]; % test errortypes at these epochs; don't use atperc and atepoch together!
P.test_RT = [test:test:t*4]; % test reaction time in these epochs
P.save_weights = [test:test:t*4]; 
P.plot_errorfigures = 1;
P.plot_compositefig = 1; % save composite figure
P.plot_trajectories = 1;

% Lexicon
P.semanticsgenerator = @semanticsgenerator_prototypes2; % prototypes2, ecological, ratio, exact
P.phoneticsgenerator = @phoneticsgenerator_phonpheat;
P.wordlength = 5;
P.vocabsize = 100;
P.Ssize = 95; % nb of semantic features 120; the following 5 parameters are only work in semanticsgenerator_prototypes
P.Sact = 31; % avg nb of active semantic features in each prototype (prototypes), or exact number of active features in each word (exact)
P.mindistance = 40; % the minimum Eucledian distance of semantic prototypes
P.looseness = 0.05; % the looseness of semantic prototype-classes (the probability that an activation is different from that of the prototype)
P.nbof_prototypes = 5; % nb of semantic prototypes 5
P.recurrence = 1;

P.folder = 'C:\Matlab_functions\RESULTS\Associator model_23\1. TD\'; % folder to save results

% Intervention
P.intervention = 1; % Is it an intervention run?
P.int_interventiontype = 2; % 0=unchanged; 1=only hard words; 2=hard words twice
P.int_oldtimestamp = '';
P.int_keptepochs = 2700; % How many trained epochs to keep from the previous run? Must be one where weights were saved!

s = 0.7;
p = 0.1;
r = 0.1;
l = 0.1;
x = 4000;
P.int_intended_S_epochs = s*x;
P.int_intended_P_epochs = p*x;
P.int_intended_R_epochs = r*x;
P.int_intended_L_epochs = l*x;

%% Run

P.resultsfile = [P.folder, 'RESULTS_Associator model_', num2str(P.version), '.xlsx']; % file to save summary results
P.performance_threshold = P.vocabsize;
    
r = 10;
seeds = randchoose(1000:9999, 1000);
counter = 0;

for i = 1:r
    
    counter = counter + 1
    P.weightseed   = seeds(counter+100);
    P.semanticseed = seeds(counter+200);
    P.phoneticseed = seeds(counter+300); 
    [L, W, P, S, R, V, T, Q, D] = Associator_23_function(P); 
    
end

%% Beep

for i=1:P.beeps
    beep
    pause(0.5)
end