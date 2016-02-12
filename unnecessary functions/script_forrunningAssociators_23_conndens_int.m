% Runs the model in loops

%% Load default parameters

clear
maxNumCompThreads(1);
rng('shuffle')
addpath(genpath('C:\Matlab_functions'));
load('C:\Matlab_functions\model_Associator\Associator23_params1.mat')

%% Modify parameters

P.folder = 'C:\Matlab_functions\RESULTS\Associator model_23\8. AT_conndens_mixed locations\'; % folder to save results

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
'2013-07-30-10-56-55';
'2013-07-30-12-04-11';
'2013-07-30-13-10-23';
'2013-07-30-13-55-38';
'2013-07-30-14-30-08';
'2013-07-30-15-36-45';
'2013-07-30-16-42-32';
'2013-07-30-17-25-16';
'2013-07-30-18-03-13';
'2013-07-30-19-00-52';
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