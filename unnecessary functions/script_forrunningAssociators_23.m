% Runs the model in loops

%% Load default parameters

clear
%rng('shuffle')
folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Associator_Mastersonvocab'; % path to the folder which contains the functions and the RESULTS folder
%addpath(genpath(folder));
cd(folder)
load Associator23_params1

%% Modify parameters

P.functionsfolder = folder; % the folder that includes all the functions, parameters and the vocabfile
P.semanticrep = 'sem_bin'; % sem_bin or sem_ana
P.frequencymeasure = 'J'; % A to J, according to the columns in the frequency worksheet

t=1;
test = 1;
P.nbof_S_epochs = t; % nb of epochs to train model on task S
P.nbof_P_epochs = t; % nb of epochs to train model on task P
P.nbof_R_epochs = t; % nb of epochs to train model on task R
P.nbof_L_epochs = t; % nb of epochs to train model on task L
P.test_performance = test;
P.test_RT = 0;       % has to be a multiple of P.test_performance
P.save_outputs = 0;  % has to be a multiple of P.test_performance
P.save_weights = 0;  % has to be a multiple of P.test_performance
P.print2screen = test;  % has to be a multiple of P.test_performance
P.performance_threshold = 397; % 397
P.weightseed = 1;

%% Run

P.resultsfolder = [P.functionsfolder, '\RESULTS\']; % folder to save results
P.resultsfile = [P.resultsfolder, 'RESULTS_Associator.xlsx']; % file to save summary results
    
r = 1;
seeds = randchoose(1000:9999, 1000);
counter = 0;

for i = 1:r
    
    counter = counter + 1
    P.weightseed = seeds(counter);
    [L, W, P, S, R, V, T, Q, D] = Associator_23_function(P); 
    
end

%% Beep

for i=1:P.beeps
    beep
    pause(0.5)
end