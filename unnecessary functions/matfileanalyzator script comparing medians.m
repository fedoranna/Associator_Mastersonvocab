% Reads two excel files with median scores for 100:100:4000 epochs
% Makes median +/- 1.5*SD boxplots from TD data and datapoints from AT data
% at epoch=500

clear all
addpath(genpath('C:\Matlab_functions'));

%% Parameters

ATsheet = 'HTC';
%ATfolder = 'C:\Matlab_functions\RESULTS\Associator model_23\6. AT_hiddens_mixed locations\';
%ATfolder = 'C:\Matlab_functions\RESULTS\Associator model_23\7. AT_temperature_mixed locations\';
ATfolder = 'C:\Matlab_functions\RESULTS\Associator model_23\';
cim = 'Temperature = 0.4';

TDfolder = 'C:\Matlab_functions\RESULTS\Associator model_23\';
TDsheet = 'TD';

%% Load data

for d = 1:length(ATsheet)
    
    [TDdata, txt, raw] = xlsread([TDfolder, 'RESULTS_Associator model_23.xlsx'], TDsheet);
    [ATdata, txt, raw] = xlsread([ATfolder, 'RESULTS_Associator model_23.xlsx'], ATsheet(d));
    
    'Writing done'
    
    %% Plotting trajectories
    
    figure
    title('Developmental trajectories');
    x = TDdata(:,1);
    
    hold all
    plot(x, TDdata(:,2), '-m', 'LineWidth', 3);
    plot(x, TDdata(:,3), '-c', 'LineWidth', 1.5);
    plot(x, TDdata(:,4), '-r', 'LineWidth', 1.5);
    plot(x, TDdata(:,5), '-b', 'LineWidth', 1.5);
    plot(x, ATdata(:,2), '--m', 'LineWidth', 3);
    plot(x, ATdata(:,3), '--c', 'LineWidth', 1.5);
    plot(x, ATdata(:,4), '--r', 'LineWidth', 1.5);
    plot(x, ATdata(:,5), '--b', 'LineWidth', 1.5);
    
    felirat3 = [{'TD - Task SS'}; {'TD - Task PP'}; {'TD - Task SP'}; {'TD - Task PS'}; {'AT - Task SS'}; {'AT - Task PP'}; {'AT - Task SP'}; {'AT - Task PS'}];
    set(legend(felirat3),'Location', 'SouthEast');  %[0.6756 0.1897 0.2018 0.2778])
    axis([0 4100 0 101]);
    set(gca,'TickDir','out');
    xlabel('Number of epochs');
    ylabel('Number of known words');
    hold off
    
    print('-dpng', [ATfolder, 'compare TD - ', ATsheet(d)]);
    close
    
    %% Data for boxplots
    
    epoch = 5;
    
    TDperc = [
        TDdata(epoch, 2:5); % %
        TDdata(epoch, 6:9)  % SD
        ];
    
    % Deficits
    individualdata(d,:) = ATdata(epoch, 2:5);
    
end

%% Transform data

descriptives = TDperc;

criteria = NaN(3, size(descriptives,2));
criteria(1,:) = descriptives(1,:) - descriptives(2,:)*1.5;  % TD median - 1.5*SD
criteria(2,:) = descriptives(1,:);                          % TD median
criteria(3,:) = descriptives(1,:) + descriptives(2,:)*1.5;  % TD median + 1.5*SD

plotdata = NaN(size(descriptives));
plotdata(1,:) = criteria(1,:);
plotdata(2,:) = criteria(2,:) - criteria(1,:);
plotdata(3,:) = criteria(3,:) - criteria(2,:);

xlabels = {'PJ (SS)', 'CNRep (PP)', 'Picture Naming (SP)', 'WPVT (PS)'};

%% Plot boxplots

ymatrix1 = plotdata';

figure1 = figure;
axes1 = axes('Parent',figure1,'XTickLabel',xlabels,'XTick',1:size(descriptives,2));
box('on');
hold('all');
bar1 = bar(ymatrix1, 'BarLayout','stacked', 'Parent',axes1);
set(bar1(1),'FaceColor',[1 1 1],'EdgeColor',[1 1 1]);
set(bar1(2),'FaceColor',[0.9412 0.9412 0.9412]);
set(bar1(3),'FaceColor',[0.8 0.8 0.8]);

pointtypes = {'ok', '*k', 'sk', 'dk', '+k', 'xk', '.k', '^k', 'vk', '<k', '>k', 'pk', 'hk'};
for i = 1:size(individualdata,1)
    plot(1:4, individualdata(i,:), pointtypes{i})
end

%legend('', 'TD median - SD*1.5', 'TD median + SD*1.5', 'S deficit', 'P deficit', 'A deficit')
L = cell(1, numel(ATsheet)+3);
for i = 1:numel(ATsheet)
    L{i+3} = ATsheet(i);
end    
L{1}= '';
L{2}= 'TD median - SD*1.5';
L{3}= 'TD median + SD*1.5';
legend(L)

title(cim);
print('-dpng', [ATfolder, 'boxplot_', ATsheet]);


