clear
%% Parameters

folder = 'C:\Matlab_functions\RESULTS\Associator model_17\recurrence 0 noise 0\';
outfile = 'avg.xlsx';

%% Load data and calculate average

filenames = dir([folder, '*.mat']);
for i = 1%:length(filenames)
  infile = [folder, filenames(i).name];
  load(infile)
end


%% Write to excel

where = nrows(xlsread(O))+1;
%xlswrite(O, avgT.SS_all, 'Sheet1', ['A', num2str(where)]);