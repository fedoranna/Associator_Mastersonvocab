% Plotting dimensions
% The first part of this script is for writing out AoAs from several different models with the same vocabulary to an excelfile
% The second part of this script is fro plotting AoA against different dimensions

%% Parameters

clear
directory = 'C';
addpath(genpath([directory, ':\Matlab_functions']));
version = 15;
folder = [directory, ':\Matlab_functions\RESULTS\Associator model_', num2str(version), '\']; % folder to save results
excelfile = 'F:\Birkbeck\WFD project\Modelling strand\Dimensions.xlsx';

rescale_min = 52; % 44-137 for Funnel data; 50-104 for own data
rescale_max = 102;

sheet = 'model1';
timestamps = {
    '2011-12-20-11-52-09',
    %'2011-12-31-00-59-25',
    %'2011-12-31-02-47-32',
    %'2011-12-28-19-28-02'
    };
timestamp = '';

%% Loading

alphabet = {'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};

for m = 1 : length(timestamps)
    
    load([folder, timestamps{m}, '.mat'], 'T', 'P', 'V');
    
    %% Preprocessing data
    
    AoA_SP = NaN(1, P.vocabsize);
    for i = 1:P.vocabsize
        AoA_SP(i) = V(i).AoA(3);
    end
    AoA_SP = rescale(AoA_SP, rescale_min, rescale_max); % Rescaling to better fit human data: AoA in months
    
    %% Write to excelfile
    
    if m == 1
        transcript = cell(1, P.vocabsize);
        for i = 1:P.vocabsize
            transcript{i} = [V(i).P_transcript{1}, V(i).P_transcript{2}, V(i).P_transcript{3}];
        end
        
        xlswrite(excelfile, transcript', sheet, ['A', num2str(2)]);
        xlswrite(excelfile, [V.frequency]', sheet, ['B', num2str(2)]);
        xlswrite(excelfile, [V.S_imag]', sheet, ['C', num2str(2)]);
        xlswrite(excelfile, [V.P_denseness]', sheet, ['D', num2str(2)]);
    end
    
    xlswrite(excelfile, AoA_SP', sheet, [alphabet{m}, num2str(2)]);
    m
end
%% Sort AoA

% % According to frequency
% AoA_SP_fsorted = cell(max([V.frequency]), P.vocabsize);
% for i = 1:P.vocabsize
%     for j = 1:max([V.frequency])
%         if V(i).frequency == j
%             AoA_SP_fsorted{j, i} = V(i).AoA(3);
%         end
%     end
% end
%
% f1 = [AoA_SP_fsorted{1,:}];
% f2 = [AoA_SP_fsorted{2,:}];
%
% % According to denseness of phonological neighbourhood
% AoA_SP_dsorted = cell(max([V.P_denseness])+1, P.vocabsize);
% for i = 1:P.vocabsize
%     for j = 0:max([V.P_denseness])
%         if V(i).P_denseness == j
%             AoA_SP_dsorted{j+1, i} = V(i).AoA(3);
%         end
%     end
% end
%
% d0 = [AoA_SP_dsorted{1,:}];
% d1 = [AoA_SP_dsorted{2,:}];
% d2 = [AoA_SP_dsorted{3,:}];
%
% %% Plotting (plot, scatter, bar, errorbar)
%
% % Plotting all words
% plot([V.frequency], AoA_SP, '*')
% plot([V.P_denseness], AoA_SP, '*')
% %axis([0 max([V.frequency])+1 0 max(AoA_SP)+100]);
%
% % Plotting mean and SD when there are 2 levels
% a = f1;
% b = f2;
% bar(1:2, [mean(a), mean(b)])
% errorbar(1:2, [mean(a), mean(b)], [std(a), std(b)], 'xr');
%
% % Plotting mean and SD when there are 3 levels
% a = d0;
% b = d1;
% c = d2;
% errorbar(1:3, [mean(a), mean(b), mean(c)], [std(a), std(b), std(c)], 'xr');









