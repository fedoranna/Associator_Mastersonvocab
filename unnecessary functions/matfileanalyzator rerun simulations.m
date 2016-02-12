%% Rerun simulations from saved P

clear
addpath(genpath('C:\Matlab_functions'));

folder = 'C:\Matlab_functions\RESULTS\Categorizator model_7\PAPER Categorizator\reruns\';
ID = '2012-11-26-19-01-26';
%

%% Load and run

matfile = [folder, ID, '.mat'];
load(matfile, 'P');
P.test_performance = 1;
P.print2screen = 1;
P.intended_epochs = 600;
P.folder = folder;

[L, W, P, S, R, T, Q] = Categorizator_7_function(P);

%% Beep
for i=1:P.beeps
    beep
    pause(0.5)
end
