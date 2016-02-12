clear all
%% Parameters

from = 31;
to = from+9;
folder = 'C:\Matlab_functions\RESULTS\Associator model_23\8. AT_conndens_mixed locations\';
outfile = 'RESULTS_Associator model_23.xlsx';
addpath(genpath('C:\Matlab_functions'));

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

%% Calculate average

avgT.SS_all = zeros(1, testedepochs);
avgT.PP_all = zeros(1, testedepochs);
avgT.SP_all = zeros(1, testedepochs);
avgT.PS_all = zeros(1, testedepochs);
avgT.SP_frequency = zeros(2, testedepochs);
avgT.SP_imag = zeros(2, testedepochs);
avgT.RT_SP_frequency = zeros(2, testedepochs);
avgT.RT_SP_imag = zeros(2, testedepochs);
avgT.mainerrortypes = zeros(testedepochs, 5);
freq = zeros(2,1);
imag = zeros(2,1);

for i = 1:db
    
    T = Ts{i};    
    %T.SP_imag = (T.SP_imag/P.vocabsize)*100;
    
    if numel(T.SS_all) < testedepochs
        missing = testedepochs-numel(T.SS_all);
        T.SS_all = [T.SS_all, repmat(T.SS_all(end), 1, missing)];
        T.PP_all = [T.PP_all, repmat(T.PP_all(end), 1, missing)];
        T.SP_all = [T.SP_all, repmat(T.SP_all(end), 1, missing)];
        T.PS_all = [T.PS_all, repmat(T.PS_all(end), 1, missing)];
        T.SP_frequency = [T.SP_frequency, repmat(T.SP_frequency(:,end), 1 , missing)];
        T.SP_imag = [T.SP_imag, repmat(T.SP_imag(:,end), 1 , missing)];
        T.RT_SP_frequency = [T.RT_SP_frequency, repmat(T.RT_SP_frequency(:,end), 1 , missing)];
        T.RT_SP_imag = [T.RT_SP_imag, repmat(T.RT_SP_imag(:,end), 1 , missing)];
        T.mainerrortypes = [T.mainerrortypes; repmat(T.mainerrortypes(end,:), missing, 1)];
    end
    avgT.SS_all = avgT.SS_all + T.SS_all;
    avgT.PP_all = avgT.PP_all + T.PP_all;
    avgT.SP_all = avgT.SP_all + T.SP_all;
    avgT.PS_all = avgT.PS_all + T.PS_all;
    avgT.SP_frequency = avgT.SP_frequency + T.SP_frequency;
    avgT.SP_imag = avgT.SP_imag + T.SP_imag;
    avgT.RT_SP_frequency = avgT.RT_SP_frequency + T.RT_SP_frequency;
    avgT.RT_SP_imag = avgT.RT_SP_imag + T.RT_SP_imag;
    avgT.mainerrortypes = avgT.mainerrortypes + T.mainerrortypes;
    freq = freq + [numel(Ps{i}.frequency{1}); numel(Ps{i}.frequency{2})];
    imag = imag + [numel(Ps{i}.imag{1}); numel(Ps{i}.imag{2})];
    
end
avgT.SS_all = (avgT.SS_all/db); % / vocabsize * 100;
avgT.PP_all = (avgT.PP_all/db); % / vocabsize * 100;
avgT.SP_all = (avgT.SP_all/db); % / vocabsize * 100;
avgT.PS_all = (avgT.PS_all/db); % / vocabsize * 100;
avgT.SP_frequency = round(avgT.SP_frequency/db);
avgT.SP_imag = round(avgT.SP_imag/db);
avgT.RT_SP_frequency = avgT.RT_SP_frequency/db;
avgT.RT_SP_imag = avgT.RT_SP_imag/db;
avgT.mainerrortypes = avgT.mainerrortypes/db;

freq = round(freq/db);
imag = round(imag/db);

'Averaging done'

%% Write to excel

%towrite = [testingat : testingat : epochs; avgT.SS_all; avgT.PP_all; avgT.SP_all; avgT.PS_all];
%xlswrite([folder, outfile], towrite', 'avg', ['A2']);

'Writing done'

%% Saving figure

P.ID = ['avg-', num2str(from), '-', num2str(to)];

P.frequency{1} = ones(1,freq(1));
P.frequency{2} = ones(1,freq(2));
P.imag{1} = ones(1,imag(1));
P.imag{2} = ones(1,imag(2));

R.completed_epochs = epochs;
avgT.prodsavedat = testingat : testingat : epochs;

compositefigs(P, avgT, R)


