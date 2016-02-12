% Reads data from matfiles and calculates medians and SDs of scores
% Writes median and SD of scores for 100:100:4000 epochs in the results excel file

clear all
addpath(genpath('C:\Matlab_functions'));
%% Parameters

from = 1;
deficitat = 'S';

%folder = 'C:\Matlab_functions\RESULTS\Associator model_23\6. AT_hiddens_mixed locations\';
%folder = 'C:\Matlab_functions\RESULTS\Associator model_23\7. AT_temperature_mixed locations\';
folder = 'C:\Matlab_functions\RESULTS\Associator model_23\2. AT_learningrate\';

to = from + 9;
outfile = 'RESULTS_Associator model_23.xlsx';
save2excel = 1;
saveplot = 1;

%% Load data

filenames = dir([folder, '*.mat']);
filenames = filenames(from:to);
db = length(filenames);

testingat = zeros(1, db);
intendedepochs = zeros(1, db);
vocabsize = zeros(1, db);
Ts = cell(db, 1);
Ps = cell(db, 1);
testerrors = NaN(db, 1000);
legtobb = 0;

for i = 1:db
    
    infile = [folder, filenames(i).name];
    load(infile, 'P', 'T', 'R')
    
    testingat(i) = P.test_performance;
    intendedepochs(i) = P.intended_epochs;
    vocabsize(i) = P.vocabsize;
    Ts{i} = T;
    Ps{i} = P;
    
    testerrors(i,1:length(P.test_errors_atepoch)) = P.test_errors_atepoch;
    if length(P.test_errors_atepoch) > legtobb
        legtobb = length(P.test_errors_atepoch);
    end
    
end
testerrors(:, legtobb+1:end) = [];

%% Check if the simulations are comparable

if sum(testingat(1) == testingat) ~= db
    ['Different testing period!']
    testingat
else
    testingat = testingat(1);
end

if sum(vocabsize(1) == vocabsize) ~= db
    ['Different vocabsize!']
    vocabsize
else
    vocabsize = vocabsize(1);
end

epochs = max(intendedepochs);
testedepochs = epochs/testingat;
testederrors = length(testerrors);

%% Calculate medians

collectT.SS_all = zeros(0, testedepochs);
collectT.PP_all = zeros(0, testedepochs);
collectT.SP_all = zeros(0, testedepochs);
collectT.PS_all = zeros(0, testedepochs);

for i = 1:db
    
    T = Ts{i};    
    
    if numel(T.SS_all) < testedepochs
        missing = testedepochs-numel(T.SS_all);
        T.SS_all = [T.SS_all, repmat(T.SS_all(end), 1, missing)];
        T.PP_all = [T.PP_all, repmat(T.PP_all(end), 1, missing)];
        T.SP_all = [T.SP_all, repmat(T.SP_all(end), 1, missing)];
        T.PS_all = [T.PS_all, repmat(T.PS_all(end), 1, missing)];
    end
    collectT.SS_all = [collectT.SS_all; T.SS_all];
    collectT.PP_all = [collectT.PP_all; T.PP_all];
    collectT.SP_all = [collectT.SP_all; T.SP_all];
    collectT.PS_all = [collectT.PS_all; T.PS_all];    
end
medians = [
    median(collectT.SS_all); 
    median(collectT.PP_all); 
    median(collectT.SP_all); 
    median(collectT.PS_all); 
    ];
SDs = [
    std(collectT.SS_all); 
    std(collectT.PP_all); 
    std(collectT.SP_all); 
    std(collectT.PS_all); 
    ];

'Averaging done'

%% Write to excel

if save2excel == 1
    towrite = [testingat : testingat : epochs; medians; SDs];
    xlswrite([folder, outfile], towrite', deficitat, ['A2']);
end

'Writing done'

%% Saving figure

if saveplot == 1
    
    P.ID = ['median-', num2str(from), '-', num2str(to)];
    R.completed_epochs = epochs; 
    
    figure
    title('Developmental trajectories');
    x = testingat : testingat : epochs;
    hold all
    plot(x, medians(1,:), '--m', 'LineWidth', 1.5);
    plot(x, medians(2,:), '--c', 'LineWidth', 1.5);
    plot(x, medians(3,:), ':r', 'LineWidth', 1.5);
    plot(x, medians(4,:), ':b', 'LineWidth', 1.5);
    if P.intervention == 1
        plot(repmat(P.int_keptepochs, 1, P.vocabsize+3), -1:P.vocabsize+1,  '-k', 'LineWidth',1);
    end
    felirat3 = [{'Task SS'}; {'Task PP'}; {'Task SP'}; {'Task PS'}];
    set(legend(felirat3),'Location', 'SouthEast');  %[0.6756 0.1897 0.2018 0.2778])
    axis([0 R.completed_epochs+100 0 P.vocabsize+1]);
    set(gca,'TickDir','out');
    xlabel('Number of epochs');
    ylabel('Number of known words');
    hold off
    
    figurefile =  [P.folder, P.ID, '_trajectories.png'];
    print('-dpng', figurefile);
    close
end

