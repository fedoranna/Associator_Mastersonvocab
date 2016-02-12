%% Description
% This script lists all the parameters necessary to run Associator_M and
% saves them in a mat file

%% Parameters

clear

% Initialization
P.layerinit = @zeros;   % layer initialization function; does not make any difference
P.weightinit = @randn;  % weight initialization function: rand, randn (zeros do not work, because increment will be always 0)
P.randmin = 0;          % rand: the lower limit of randomly initialized uniform weights; randn: the mean of the normally distributed random weights; zeros: has to be 0
P.randmax = 0.1;        % rand: the upper limit of randomly initialized uniform weights; randn: the multiplier of the standard normal distribution
P.weightseed = 'noseed';% random seed for initializing weights; 'noseed' or a number between 0 and 2^31-2

% Vocabulary
P.functionsfolder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Associator_Mastersonvocab'; % path to the folder which contains the functions and the RESULTS folder
P.vocabfile = [P.functionsfolder, '\vocab_Masterson.xlsx']; % path to the vocabfile
P.semanticrep = 'sem_bin';  % the type of semantic representation to use; the name of the worksheet in the vocabfile; sem_bin or sem_ana
P.frequencymeasure = 'J';   % the type of frequency to use; the header of the chosen column in the frequency worksheet; A to J

% Size of variable size layers (the size of all other layers depends on the lexicon)
P.size_SH = 500; % hidden layer in the semantic (left) module
P.size_PH = 500; % hidden layer in the phonological (right) module
P.size_AR = 500; % hidden (associator) layer between SH and PH, on the pathway to the right side of the model
P.size_AL = 500; % hidden (associator) layer between PH and SH, on the pathway to the left side of the model
P.usebias = 1;   % 1= yes, 0=no                    
P.biasvalue = 1; % the value of the bias

% Connection densities (=< 1)
P.dens_SISH = 1;
P.dens_SHSO = 1;
P.dens_PIPH = 1;
P.dens_PHPO = 1;
P.dens_SHAR = 1;
P.dens_ARPH = 1;
P.dens_PHAL = 1;
P.dens_ALSH = 1;

% Training
P.trainingtype = 'fourcycle';           % fourphase, fourcycle, random, twophase
P.trainingmode = 0;                     % 1=batch, 0=online; BATCH DOES NOT WORK?
P.permute = 0;                          % permute order of items before each training epoch in online learning
P.transferfn = @transferfn_logsig;      % transferfn_logsig for 0/1 targets; use tansig when target is -1/1; threshold does not work with backprop
P.delta = @delta_logsig_withT;          % use it according to the transferfn! logsig, logsig_CE, tansig
P.offset = 0;                           % the offset of the transferfunction
P.temperatures =  [1.0, 1.0, 1.0, 1.0]; % temperature for logsig and tansig transferfunctions, the threshold for threshold/step transferfn
P.learningrates = [0.1, 0.1, 0.1, 0.1]; % SS (SISH, SHSO), PP (PIPH, PHPO), SP (SHAR, ARPH), PS (PHAL, ALSH)
P.momentums =     [0.3, 0.3, 0.3, 0.3]; % SS (SISH, SHSO), PP (PIPH, PHPO), SP (SHAR, ARPH), PS (PHAL, ALSH)
P.noise =         [0.0, 0.0, 0.0, 0.0]; % maximum absolute value of random noise

% Evaluating
test = 100;
P.upper_TH = [0.9, 0.9, 0.9, 0.9];  % threshold of activation for answer = 1
P.lower_TH = 1-P.upper_TH;          % threshold of activation for answer = 0
P.test_performance = test;          % test the performance after every xth epoch
P.test_RT = 0;                      % test reaction time after every xth epoch; has to be a multiple of P.test_performance
P.retest = 1;                       % retest performance x times in each testing event (1=testing just once, no retesting)
P.recurrence = 1;                   % 1/0 switch for using recurrent connections during testing
P.timeout = 100;                    % maximum number of cycles for the recurrent connections 
P.asymptote_TH = 10^(-15);          % threshold for cleanup recurrence

% Stop conditions
t=1000;
P.nbof_S_epochs = t;            % nb of epochs to train model on task S (SS)
P.nbof_P_epochs = t;            % nb of epochs to train model on task P (PP)
P.nbof_R_epochs = t;            % nb of epochs to train model on task R (SP)
P.nbof_L_epochs = t;            % nb of epochs to train model on task L (PS)
P.performance_threshold = 397;  % stop training when performance reaches this criterion (nb of words) in each task
P.beeps = 3;                    % Do you want a very annoying reminder when the simulation is over?

% Saving results, controlling outputs
P.resultsfolder = [P.functionsfolder, '\RESULTS\'];             % folder to save results
P.resultsfile = [P.resultsfolder, 'RESULTS_Associator.xlsx'];   % file to save summary results
P.save_2excel = 1;          % switch to save results to excel
P.save_matfile = 1;         % switch to save matfile
P.plot_trajectories = 1;    % switch to save figure
P.save_outputs = test;      % save outputs after every xth epoch; has to be a multiple of P.test_performance
P.save_weights = test;      % save weights after every xth epoch or at the xth epoch (see P.save_weights_mode)
P.save_weights_mode = 1;    % 1=save weights once, 0=save weights periodically
P.print2screen = test;      % print performance on screen after every xth epoch; has to be a multiple of P.test_performance

% Intervention
P.intervention = 0;         % Is it an intervention run?
P.int_interventiontype = 0; % 0=unchanged; 1=only hard words; 2=hard words twice
P.int_oldtimestamp = '';    % timestamp of the original (non-intervention) simulation
P.int_keptepochs = 2700;    % How many trained epochs to keep from the original run? Must be one where weights were saved!
P.int_intended_S_epochs = 2000;
P.int_intended_P_epochs = 2000;
P.int_intended_R_epochs = 2000;
P.int_intended_L_epochs = 2000;
P.int_trainingtype = 'fourcycle';

%% Save

save([P.functionsfolder, '\Associator_M_params_1.mat'], 'P')

'Parameters saved'

