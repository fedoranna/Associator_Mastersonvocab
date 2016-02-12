
%% Parameters
clear
folder = 'C:\Matlab_functions\RESULTS\Associator model_17\recurrence 1 noise 0\';
outfile = 'avg.xlsx';

addpath(genpath('C:\Matlab_functions'));

%% Load data

filenames = dir([folder, '*.mat']);
db = length(filenames);

testingat = zeros(1, db);
intendedepochs = zeros(1, db);
vocabsize = zeros(1, db);
epochs = zeros(1, db);
Ts = cell(db, 1);
testerrors = NaN(db, 1000);
legtobb = 0;

for i = 1:db
    
  infile = [folder, filenames(i).name];
  load(infile, 'P', 'T', 'R')
  
  testingat(i) = P.test_performance;
  intendedepochs(i) = P.intended_epochs;
  vocabsize(i) = P.vocabsize;
  epochs(i) = R.completed_epochs;
  Ts{i} = T;
  
  P.test_errors
  testerrors(i,1:length(P.test_errors)) = P.test_errors;
  if length(P.test_errors) > legtobb
      legtobb = length(P.test_errors);
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

for i = 1:db
    
   testerrors;
    
end


epochs = max(epochs);
testedepochs = epochs/testingat;
testederrors = length(testerrors);

%% Calculate average

avgT.SS_all = zeros(1, testedepochs);
avgT.PP_all = zeros(1, testedepochs);
avgT.SP_all = zeros(1, testedepochs);
avgT.PS_all = zeros(1, testedepochs);

avgE = zeros(testederrors, 5);

successes = 0;

for i = 1:db
    if  Ts{i}.SP_all(end) +  Ts{i}.PS_all(end) == vocabsize*2 % include only successful runs
        successes = successes +1;
        for j = 1: testedepochs
            
            if j < length(Ts{i}.SS_all) + 1
                avgT.SS_all(j) = avgT.SS_all(j) + Ts{i}.SS_all(j);
                avgT.PP_all(j) = avgT.PP_all(j) + Ts{i}.PP_all(j);
                avgT.SP_all(j) = avgT.SP_all(j) + Ts{i}.SP_all(j);
                avgT.PS_all(j) = avgT.PS_all(j) + Ts{i}.PS_all(j);
            else
                avgT.SS_all(j) = avgT.SS_all(j) + vocabsize;
                avgT.PP_all(j) = avgT.PP_all(j) + vocabsize;
                avgT.SP_all(j) = avgT.SP_all(j) + vocabsize;
                avgT.PS_all(j) = avgT.PS_all(j) + vocabsize;
            end
            
        end
        
        for j = 1: nrows(Ts{i}.mainerrortypes)
            all = sum(Ts{i}.mainerrortypes(j, 2:5));
            if all > 0
                avgE(j, 2:5) = avgE(j, 2:5) + Ts{i}.mainerrortypes(j, 2:5) / all
                avgE(j, 1) = avgE(j, 1) + 1;
            end
        end
    end

end
avgT.SS_all = (avgT.SS_all/successes) / vocabsize * 100;
avgT.PP_all = (avgT.PP_all/successes) / vocabsize * 100;
avgT.SP_all = (avgT.SP_all/successes) / vocabsize * 100;
avgT.PS_all = (avgT.PS_all/successes) / vocabsize * 100;

for i = 1:nrows(avgE)
    avgE(i, 2:5) = avgE(i, 2:5)/avgE(i, 1);
end
avgE(:, 1) = testerrors'; S, P, Mixed, other

'Averaging done'

%% Write to excel

towrite = [testingat : testingat : epochs; avgT.SS_all; avgT.PP_all; avgT.SP_all; avgT.PS_all];
xlswrite([folder, outfile], towrite', 'Sheet1', ['A2']);

'Writing done'


