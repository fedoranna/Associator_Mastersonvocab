% Transforms data for SPSS from Categorizator intervention experiments
% Checklist:
% - Top rows should be the controls, intervention data should start after that
% - Intervention and control cases are the same subjects (same weightseed)
% - Each subject should go in order: phase 1 - int 1, phase 1 - int 2..., phase 2 - int 1, phase 2 - int 2, ...
% - Check excel file to make sure that the above order of simulations is correct!
% - Makes 3 different version of toSPSS worksheets and copies data there
% - If performance did not change with intervention, use nb of epochs instead (line 69 and 73)

%% Parameters

clear
addpath(genpath('C:\Matlab_functions'));
folder = 'C:\Matlab_functions\RESULTS\Categorizator model_7\4_intervention\'; % folder to save results
file = 'intervention results_at timeout and 2000';

pattern = 'i';      % pattern name (diag or islands); this will be in the header
nbof_patterns = 6;  % nb of intervention patterns
nbof_phases = 3;    % nb of intervention times
nbof_subjects = 10; % nb of subjects or weightseed

%% Read raw data
 
filename = [folder, file, '.xlsx'];
[num, text, raw] = xlsread(filename, 'transposed diffs');

data = cell(nrows(raw), 5);
data(:,1) = raw(:,2);       % final performance 
data(:,2) = raw(:,3);       % all trained epochs
data(:,3) = raw(:,8);       % trained epochs before intervention
data(:,4) = raw(:,15);      % weightseed
data(:,5) = raw(:,23);      % intervention pattern
data(1:2,:) = [];           % delete header

%data = data(1:190,:);
if nrows(data) ~= nbof_subjects*nbof_phases*nbof_patterns+10
    'WARNING! Missing or extra cases!' 
    ['Number of rows in excel file should be ', num2str(nbof_subjects*nbof_phases*nbof_patterns+12)]
end

%% Recode data to numbers

rec = NaN(size(data));
rec(:,1) = [data{:,4}];             % subject (weightseed)
rec(:,2) = [data{:,1}];             % final performance
rec(:,3) = [data{:,2}];             % nb of all epochs 
rec(1:nbof_subjects, 4) = 0;        % phase in numbers 1,2,3...
rec(nbof_subjects+1, 4) = 1; 
rec(1:nbof_subjects, 5) = 0;
rec(nbof_subjects+1:end, 5) = [repmat((1:nbof_patterns)', nbof_phases*nbof_subjects, 1)]; % intervention in numbers, 1,2,3...

for i = nbof_subjects+1:nrows(data)
    if data{i,3} == data{i-1,3}
        rec(i,4) = rec(i-1,4);
    elseif data{i,3} > data{i-1,4}
        rec(i,4) = rec(i-1,3)+1;
    elseif data{i,3} < data{i-1,4}
        rec(i,4) = 1;
    end
end

%% Rearrange data so that 1 subject = 1 row

performance = rec(nbof_subjects+1:end, 2)';
epochs = rec(nbof_subjects+1:end, 3)';

rea = NaN(nbof_subjects, nbof_phases*nbof_patterns+2);
rea(:,1) = rec(1:10,1); % weightseed
rea(:,2) = rec(1:10,2); % control performance
%rea(:,2) = rec(1:10,3); % control epochs

for i = 1 : nbof_subjects
    rea(i,3:end) = frameslider(performance, nbof_phases*nbof_patterns, i); % using perfmance or nb of epochs as a measure of successful intervention
    %rea(i,3:end) = frameslider(epochs, nbof_phases*nbof_patterns, i);
end

%% Make header

header = cell(1, nbof_phases*nbof_patterns);
for i = 1:nbof_phases
    for j = 1:nbof_patterns
        header{(i-1)*nbof_patterns+j} = ['p', num2str(i), '_', pattern, num2str(j)]; % diagonal or islands
    end
end
header = ['control', header];
header = ['subjects', header];

%% Save 3 different versions

warning off MATLAB:xlswrite:AddSheet

% Full version: all variables
xlswrite(filename, header, 'toSPSS1', 'A1');
xlswrite(filename, rea, 'toSPSS1', 'A2');

% Reduced version: only use it, if the control case was run in every phase
if 1 == 0
    header([23, 16, 9]) = [];
    header{2} = 'control';
    rea(:,[23, 16, 9]) = [];
    xlswrite(filename, header, 'toSPSS2', 'A1');
    xlswrite(filename, rea, 'toSPSS2', 'A2');
end

% Differences: treatment-control values
diffs = NaN(size(rea));
for j = 3:ncols(rea)
    for i = 1:nrows(rea)
        diffs(i,j) = rea(i,j)-rea(i,2);
    end
end
diffs(:,1) = rea(:,1);
diffs(:,2) = [];
header(2) = [];
xlswrite(filename, header, 'toSPSS3', 'A1');
xlswrite(filename, diffs, 'toSPSS3', 'A2');

close
'Kész!'









