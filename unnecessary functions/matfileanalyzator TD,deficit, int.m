% Makes a composite plot
% Top plot shows 3 trajectories
% Below that there is a matrix of activation plots, all from Unit 2
% top row: TD, middle row: atypical, bottom row: intervention
% columns: different snapshot times (epochs)

clear
addpath(genpath('C:\Matlab_functions'));

folder = 'C:\Matlab_functions\RESULTS\Categorizator model_7\PAPER Categorizator\';
typical = '2012-11-19-16-49-11';
basic = '2012-11-20-03-43-20'; % atypical development, deficit
intervention = '2012-11-27-22-36-24'; % phase 2
%intervention = '2012-11-28-00-24-45'; % phase 3

length = 600; % nb of epochs on top figure; should not be longer than the shortest run
snapshot1 = 100; % when do you want to take the first snapshot?
snapshot2 = 120;
snapshot3 = 400;


%% Load

matfile_TD = [folder, typical, '.mat'];
matfile_basic = [folder, basic, '.mat'];
matfile_int = [folder, intervention, '.mat'];
opengl software

TD = load(matfile_TD, 'S', 'P', 'T', 'R');
B = load(matfile_basic, 'S', 'P', 'T', 'R');
I = load(matfile_int, 'S', 'P', 'T', 'R');

if B.P.weightseed ~= I.P.weightseed
    'Seeds do not match!'
end

TD.T.scores = TD.T.scores(10:10:numel(TD.T.scores));
TD.T.error = TD.T.error(10:10:numel(TD.T.error));
TD.T.epoch = TD.T.epoch(10:10:numel(TD.T.epoch));
TD.S = TD.S(10:10:numel(TD.S));

%% Plot trajectories

figure
subplot(4, 3, 1:3)

hold all

% Trajectories
p =plot(TD.T.epoch(1:length/10), TD.T.scores(1:length/10));
set(p,'LineWidth',2, 'Color',[0 0 0], 'LineStyle', '-')
p =plot(I.T.epoch(1:length/10), I.T.scores(1:length/10));
set(p,'LineWidth',2, 'Color',[0 0 0], 'LineStyle', '-.')
p = plot(B.T.epoch(1:length/10), B.T.scores(1:length/10));
set(p, 'LineWidth',2, 'Color',[0 0 0], 'LineStyle', '--')

% Start of intervention line (plot verical lines)
m = 100;
snapshot1 = I.R.trainedepochs_before;
plot(repmat(snapshot1, 1, B.R.sizeof_testset+m), 0:B.R.sizeof_testset+m-1,  '-k', 'LineWidth',1);
plot(repmat(snapshot2, 1, B.R.sizeof_testset+m), 0:B.R.sizeof_testset+m-1,  '-k', 'LineWidth',1);
plot(repmat(snapshot3, 1, B.R.sizeof_testset+m), 0:B.R.sizeof_testset+m-1,  '-k', 'LineWidth',1);
axis([0 length 0 B.R.sizeof_testset+m])

legend('TD', 'Intervention', 'C=0.3', 'Location', 'SouthEast')
hold off
title('Performance')
xlabel('Epoch')
ylabel('Performance')

%% Plot internal representations of deficit case

toplot = [snapshot1/10, snapshot2/10, snapshot3/10];
j = 4;
for i = toplot
    subplot(4,3,j)
    plotmatrix(TD.S(i).activationmatrix2, B.P.inputvalues, B.P.inputvalues);
    
    if i == toplot(1)
        ylabel('Typical development')
    end
    j = j+1;
end

for i = toplot
    subplot(4,3,j)
    plotmatrix(B.S(i).activationmatrix2, B.P.inputvalues, B.P.inputvalues);
    
    if i == toplot(1)
        ylabel('Atypical development')
    end
    j = j+1;
end

for i = toplot
    subplot(4,3,j)
    plotmatrix(I.S(i).activationmatrix2, B.P.inputvalues, B.P.inputvalues);
    
    if i == toplot(1)
        ylabel('Intervention')
        xlabel('Snapshot 1')
    end
    
    if i == toplot(2)
        xlabel('Snapshot 2')
    end
    
    if i == toplot(3)
        xlabel('Snapshot 3')
    end
    j = j+1;
end


%% Save

figurefile = [matfile_basic(1:end-4), '_', matfile_int(end-22:end-4), 'plusTD.png']; %num2str(nframes), '_', num2str(fps), '_', num2str(reruns), '.avi'];
%print('-dpng', figurefile);
%close
