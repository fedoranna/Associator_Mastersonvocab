%% Parameters

function matfileanalyzator_moviemaker_compare(matfile_basic, matfile_int, param)

frames = param.frames;
fps = param.fps;   
reruns = param.reruns;

%% Load

quality = 100; % 0-100
B = load(matfile_basic, 'S', 'P', 'T', 'R');
I = load(matfile_int, 'S', 'P', 'T', 'R');

if B.P.weightseed ~= I.P.weightseed
    'Seeds do not match!'
end
%% Initialize video 

outfile = [matfile_basic(1:end-4), '_', matfile_int(end-22:end-4), '.avi']; %num2str(nframes), '_', num2str(fps), '_', num2str(reruns), '.avi'];

hossz = length(frames);
    
if strcmp(frames, 'all')
    if length(B.S) < length(I.S)
        hossz = length(B.S);
    else
        hossz = length(I.S);
    end
    frames = 1:hossz;
end
for i = length(frames) : -1 : 1
    if frames(i) > hossz
        frames(i) = [];
    end
end
nframes = length(frames);

V = VideoWriter(outfile);
V.FrameRate = fps;
V.Quality = quality; 

%% Create and save animation

open(V);

set(0,'Units','pixels')
scrsz = get(0,'ScreenSize');
%scrsz = get(0,'MonitorPositions');
x=0.9;
f = figure('Position',[1 1 scrsz(3)*x scrsz(4)*x]);

for j = 1:reruns
    for i = 1:nframes
%%       
        subplot(2,3,1)
        plotmatrix(B.S(frames(i)).activationmatrix2, B.P.inputvalues, B.P.inputvalues);
        set(gca, 'CLim', [0, 1])
        title('Without intervention')
        xlabel('Input value 1')
        ylabel('Input value 2')
        colormap('Jet')
        freezeColors
        
        subplot(2,3,2)
        plotmatrix(I.S(frames(i)).activationmatrix2, I.P.inputvalues, I.P.inputvalues);
        set(gca, 'CLim', [0, 1])
        title('With intervention')
        xlabel('Input value 1')
        ylabel('Input value 2')
        colormap('Jet')
        freezeColors

        subplot(2,3,3)
        if I.S(frames(i)).epoch < I.R.trainedepochs_before
            plotmatrix(I.P.trainingmatrix_before, I.P.inputvalues, I.P.inputvalues);
        else
            plotmatrix(I.P.trainingmatrix, I.P.inputvalues, I.P.inputvalues);
        end            
        set(gca, 'CLim', [0, 1])
        title('Training items')
        xlabel('Input value 1')
        ylabel('Input value 2')
        set(gca, 'CLim', [-2, I.P.size_O+2])
        colormap('Gray')
        freezeColors
        
        % ColorSpec: magenta, cyan, green, red, blue
        subplot(2,3,4:6)
        hold all
        s = plot(B.T.epoch(1:frames(i)), B.T.scores(1:frames(i)));
        set(s, 'LineWidth',2, 'Color',[0 0 0], 'LineStyle', '--')
        e =plot(I.T.epoch(1:frames(i)), I.T.scores(1:frames(i)));
        set(e,'LineWidth',2, 'Color',[0 0 0])
        if length(B.S) < length(I.S)
            plot(repmat(B.R.trainedepochs_before, 1, B.R.sizeof_testset+3), -1:B.R.sizeof_testset+1,  '-k', 'LineWidth',1);
            plot([0, B.T.epoch], repmat(B.R.sizeof_testset, 1, length(B.T.epoch)+1),  '-k', 'LineWidth',1);
            axis([0 B.T.epoch(frames(end)) 0 B.R.sizeof_testset+B.R.sizeof_testset*0.006])
        else
            plot(repmat(I.R.trainedepochs_before, 1, I.R.sizeof_testset+3), -1:I.R.sizeof_testset+1,  '-k', 'LineWidth',1);
            plot([0, I.T.epoch], repmat(I.R.sizeof_testset, 1, length(I.T.epoch)+1),  '-k', 'LineWidth',1);
            axis([0 I.T.epoch(frames(end)) 0 I.R.sizeof_testset+I.R.sizeof_testset*0.006])
        end            
        legend('Without intervention', 'With intervention', 'Location', 'NorthEast')
        hold off
        title(['Performance at epoch ', num2str(I.S(frames(i)).epoch)])
        xlabel('Epoch')
        ylabel('Performance') 
  %%      
        currFrame = getframe(f); %  cdata: [343x435x3 uint8]
        writeVideo(V, currFrame);
    end
end

%%
% for i = 1:50
%     writeVideo(V, currFrame);
% end
%% Close

close(V);
close
'Saving video finished'