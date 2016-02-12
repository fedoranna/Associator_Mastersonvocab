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
P.intervention = 0; % Is it an intervention run?
P.int_interventiontype = 0; % 0=unchanged; 1=only hard words; 2=hard words twice
P.int_oldtimestamp = '';
P.int_keptepochs = 2700; % How many trained epochs to keep from the previous run? Must be one where weights were saved!
x = 2000;
P.int_intended_S_epochs = x;
P.int_intended_P_epochs = x;
P.int_intended_R_epochs = x;
P.int_intended_L_epochs = x;

%% Run

P.resultsfile = [P.folder, 'RESULTS_Associator model_', num2str(P.version), '.xlsx']; % file to save summary results
    
r = 10;
seeds = randchoose(1000:9999, 1000);
counter = 0;

P.dens_SISH = 0.7;
P.dens_SHSO = 0.7;
P.dens_PIPH = 0.1;
P.dens_PHPO = 0.1;
for i = 1:r
    
    counter = counter + 1
    P.weightseed   = seeds(counter+100);
    P.semanticseed = seeds(counter+200);
    P.phoneticseed = seeds(counter+300); 
    [L, W, P, S, R, V, T, Q, D] = Associator_23_function(P); 
    
end

% P.dens_SISH = 1;
% P.dens_SHSO = 1;
% P.dens_PIPH = 0.4;
% P.dens_PHPO = 0.4;
% for i = 1:r
%     
%     counter = counter + 1
%     P.weightseed   = seeds(counter+100);
%     P.semanticseed = seeds(counter+200);
%     P.phoneticseed = seeds(counter+300); 
%     [L, W, P, S, R, V, T, Q, D] = Associator_23_function(P); 
%     
% end
% 
% P.dens_PIPH = 1;
% P.dens_PHPO = 1;
% P.dens_SHAR = 0.4;
% P.dens_ARPH = 0.4;
% P.dens_PHAL = 0.4;
% P.dens_ALSH = 0.4;
% for i = 1:r
%     
%     counter = counter + 1
%     P.weightseed   = seeds(counter+100);
%     P.semanticseed = seeds(counter+200);
%     P.phoneticseed = seeds(counter+300); 
%     [L, W, P, S, R, V, T, Q, D] = Associator_23_function(P); 
%     
% end

%% Beep

for i=1:P.beeps
    beep
    pause(0.5)
end