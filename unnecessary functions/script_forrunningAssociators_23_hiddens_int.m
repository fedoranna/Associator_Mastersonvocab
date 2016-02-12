% Runs the model in loops

%% Load default parameters

clear
maxNumCompThreads(1);
rng('shuffle')
addpath(genpath('C:\Matlab_functions'));
load('C:\Matlab_functions\model_Associator\Associator23_params1.mat')

%% Modify parameters

P.folder = 'C:\Matlab_functions\RESULTS\Associator model_23\6. AT_hiddens_mixed locations\'; % folder to save results

% Intervention
P.intervention = 1; % Is it an intervention run?
P.int_interventiontype = 0; % 0=unchanged; 1=only hard words; 2=hard words twice
P.int_trainingtype = 'random';
P.int_keptepochs = 500; % How many trained epochs to keep from the previous run? Must be one where weights were saved!
x = 1000;
P.int_intended_S_epochs = x-P.int_keptepochs/4;
P.int_intended_P_epochs = (x-P.int_keptepochs/4) * 2;
P.int_intended_R_epochs = x-P.int_keptepochs/4;
P.int_intended_L_epochs = x-P.int_keptepochs/4;

timestamps = [
'2013-07-23-18-13-54';
'2013-07-23-18-50-52';
'2013-07-23-19-27-00';
'2013-07-23-20-06-41';
'2013-07-23-20-41-59';
'2013-07-23-21-19-54';
'2013-07-23-21-40-24';
'2013-07-23-21-54-59';
'2013-07-23-22-09-34';
'2013-07-23-22-24-32';
];

%% Run

P.resultsfile = [P.folder, 'RESULTS_Associator model_', num2str(P.version), '.xlsx']; % file to save summary results
counter = 0;

for i = 1:size(timestamps,1)
    
    counter = counter + 1
    P.int_oldtimestamp = timestamps(i,:);

    [L, W, P, S, R, V, T, Q, D] = Associator_23_function(P); 
    
end

%% Beep

for i=1:P.beeps
    beep
    pause(0.5)
end