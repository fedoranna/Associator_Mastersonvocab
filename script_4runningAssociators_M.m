% This script can be used to run many Associator models consecutively
% You can modify the default parameters, e.g., to run atypical models
% Prerequisites: a folder ("folder") containing
% - all the functions
% - the vocabulary file called vocab_Masterson.xlsx
% - the parameter file called Associator_M_params1.mat
% - the RESULTS folder containing the RESULTS_Associator.xlsx file
% To try it, change the path to the "folder"!

%% Load default parameters

clear
folder ='\\psf\Home\Documents\Associator_Mastersonvocab' ; % path to the folder which contains the functions and the RESULTS folder
%addpath(genpath(folder));
cd(folder)
load Associator_M_params_1 % default parameters

%% Modify parameters

P.semanticrep = 'sem_bin'; % the type of semantic representation to use; the name of the worksheet in the vocabfile; sem_bin or sem_ana
P.frequencymeasure = 'J'; % the type of frequency to use; the header of the chosen column in the frequency worksheet; D to J

t=1000;
test = 100;
P.trainingtype = 'fourcycle'; % foucycle, fourphase, twophase, random
P.trainingmode = 0;         % 1=batch, 0=online; BATCH DOES NOT WORK?
P.nbof_S_epochs = t;        % nb of epochs to train model on task S (SS)
P.nbof_P_epochs = t;        % nb of epochs to train model on task P (PP)
P.nbof_R_epochs = t;        % nb of epochs to train model on task R (SP)
P.nbof_L_epochs = t;        % nb of epochs to train model on task L (PS)
P.test_performance = test;  % test the performance after every xth epoch
P.test_RT = test;              % test reaction time after every xth epoch; has to be a multiple of P.test_performance
P.save_outputs = test;         % save outputs after every xth epoch; has to be a multiple of P.test_performance
P.save_weights = test;         % save weights after every xth epoch or at the xth epoch (see P.save_weights_mode)
P.save_weights_mode = 1;    % 1=save weights once, 0=save weights periodically
P.print2screen = test;      % print performance on screen after every xth epoch; has to be a multiple of P.test_performance

P.size_SH = 100;
P.size_PH = 100;
P.size_AR = 100;
P.size_AL = 100;

r = 1;                  % the number of models to run

P.intervention = 0;         % Is it an intervention run?
P.int_interventiontype = 0; % 0=unchanged; 1=only hard words; 2=hard words twice
P.int_oldtimestamp = '2016-02-08-13-16-01';    % timestamp of the original (non-intervention) simulation
P.int_keptepochs = 6;    % How many trained epochs to keep from the original run? Must be one where weights were saved and performance was tested!
P.int_intended_S_epochs = 1;
P.int_intended_P_epochs = 1;
P.int_intended_R_epochs = 1;
P.int_intended_L_epochs = 1;
P.int_trainingtype = 'fourcycle';

%% Run

P.functionsfolder = folder; % the folder that includes all the functions, parameters and the vocabfile
P.resultsfolder = [P.functionsfolder, '\RESULTS\']; % folder to save results
P.resultsfile = [P.resultsfolder, 'RESULTS_Associator.xlsx']; % file to save summary results

 rng('shuffle');
seeds = randchoose(1000:9999, r);   % random seeds for the models
counter = 0;                        % the index of the running model

for i = 1:r    
    counter = counter + 1
    P.weightseed = seeds(counter);
    [P, D, L, W, V, Q, R, S, T] = Associator_M_function(P);     
end

%% Beep: sound alert when the simulations finished

for i=1:P.beeps
    beep
    pause(0.5)
end