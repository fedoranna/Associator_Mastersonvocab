%% Making movies for Categorizator

%% Parameters

clear
addpath(genpath('C:\Matlab_functions'));

tf = 1;        % testingfrequency: every tf-th epoch will be plotted
length = 600;   % nb of epochs on top figure; should not be longer than the shortest run
fps = 24;       % frame per sec
reruns = 1;     % reruns in loop

folder= 'C:\Matlab_functions\RESULTS\Categorizator model_7\PAPER Categorizator\reruns\'
typical = '2012-11-19-16-49-11';
basic = '2013-02-12-18-12-30'; % atypical development, deficit
intervention = '2013-02-12-18-12-56'; % phase 2 intervention

%% Load

matfile_TD = [folder, typical, '.mat'];
matfile_basic = [folder, basic, '.mat'];
matfile_int = [folder, intervention, '.mat'];
TD = load(matfile_TD, 'S', 'P', 'T', 'R');
B = load(matfile_basic, 'S', 'P', 'T', 'R');
I = load(matfile_int, 'S', 'P', 'T', 'R');

if B.P.weightseed ~= I.P.weightseed
    'Seeds do not match!'
end

%% Modify: if one of the simulations was measured more often than the others resolution must be adjusted

TD.T.scores = TD.T.scores(tf:tf:numel(TD.T.scores));
TD.T.error = TD.T.error(tf:tf:numel(TD.T.error));
TD.T.epoch = TD.T.epoch(tf:tf:numel(TD.T.epoch));
TD.S = TD.S(tf:tf:numel(TD.S));
nframes = length/tf; % because every tenth epoch was measured

%% Initialize video

opengl software
outfile = [matfile_basic(1:end-4), '_', matfile_int(end-22:end-4), '.avi']; %num2str(nframes), '_', num2str(fps), '_', num2str(reruns), '.avi'];
V = VideoWriter(outfile);
V.FrameRate = fps;
V.Quality = 100;

%% Create and save animation

open(V);

set(0,'Units','pixels')
scrsz = get(0,'ScreenSize');
%scrsz = get(0,'MonitorPositions');
x=0.9;
FIG = figure('Position',[1 1 scrsz(3)*x scrsz(4)*x]);

for r = 1:reruns
    for f = 1:nframes
        f
        % Trajectories
        subplot(2, 3, 1:3)        
        hold all   
        
        p =plot(TD.T.epoch(1:f), TD.T.scores(1:f));
        %set(p,'LineWidth',2, 'Color',[0 0 0], 'LineStyle', '-')
        set(p,'LineWidth',2, 'Color','k', 'LineStyle', '-')
        p =plot(I.T.epoch(1:f), I.T.scores(1:f));
        %set(p,'LineWidth',2, 'Color',[0 0 0], 'LineStyle', '-.')
        set(p,'LineWidth',2, 'Color','b', 'LineStyle', '-')
        p = plot(B.T.epoch(1:f), B.T.scores(1:f));
        %set(p, 'LineWidth',2, 'Color',[0 0 0], 'LineStyle', '--')
        set(p,'LineWidth',2, 'Color','r', 'LineStyle', '-')
        
        axis([0 TD.T.epoch(length/tf) 0 TD.R.sizeof_testset])
        legend('TD', 'Intervention', 'C=0.3', 'Location', 'SouthEast')
        hold off
        title(['Performance at epoch ', num2str(I.S(f).epoch)])
        xlabel('Epoch')
        ylabel('Performance')
        
        % Plot internal representations
        
        subplot(2,3,4)
        plotmatrix(TD.S(f).activationmatrix2, TD.P.inputvalues, TD.P.inputvalues);
        title('Typical development')
        
        subplot(2,3,5)
        plotmatrix(B.S(f).activationmatrix2, B.P.inputvalues, B.P.inputvalues);
        title('Atypical development')
        
        subplot(2,3,6)
        plotmatrix(I.S(f).activationmatrix2, I.P.inputvalues, I.P.inputvalues);
        title('Intervention')
        
        currFrame = getframe(FIG); %  cdata: [343x435x3 uint8]
        writeVideo(V, currFrame);
    end
end

close(V);
close
'Saving video finished'
