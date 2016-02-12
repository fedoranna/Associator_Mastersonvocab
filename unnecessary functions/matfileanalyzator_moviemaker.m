%% Parameters
% Makes movies of activations of 3 output neurons and performance plots

function matfileanalyzator_moviemaker(matfile, param)

frames = param.frames;
fps = param.fps;
reruns = param.reruns;
%% Load

quality = 100; % 0-100
load(matfile, 'S', 'P', 'T', 'R')

%% Initialize video 

if strcmp(frames, 'all')
    frames = 1:length(S);
end
for i = length(frames) : -1 : 1
    if frames(i) > length(S)
        frames(i) = [];
    end
end
nframes = length(frames);

outfile = [matfile(1:end-4), '_', num2str(nframes), '_', num2str(fps), '_', num2str(reruns), '.avi'];

V = VideoWriter(outfile);
V.FrameRate = fps;
V.Quality = quality; 

%% Create and save animation

opengl software % This should solve the mirrored labels
open(V);
scrsz = get(0,'ScreenSize');
x=0.9;
f = figure('Position',[1 1 scrsz(3)*x scrsz(4)*x]); % 1 1 scrsz(3) scrsz(4)
for j = 1:reruns
    for i = 1:nframes
%%       
        subplot(2,3,1)
        plotmatrix(S(frames(i)).activationmatrix1, P.inputvalues, P.inputvalues);
        set(gca, 'CLim', [0, 1])
        title('Activation of Unit 1')
        xlabel('Input value 1')
        ylabel('Input value 2')
        
        subplot(2,3,2)
        plotmatrix(S(frames(i)).activationmatrix2, P.inputvalues, P.inputvalues);
        set(gca, 'CLim', [0, 1])
        title('Activation of Unit 2')
        xlabel('Input value 1')
        ylabel('Input value 2')

        subplot(2,3,3)
        plotmatrix(S(frames(i)).activationmatrix3, P.inputvalues, P.inputvalues);
        set(gca, 'CLim', [0, 1])
        title('Activation of Unit 3')
        xlabel('Input value 1')
        ylabel('Input value 2')
        
        subplot(2,3,4:6)
        hold all
        s = plot(T.epoch(1:frames(i)), T.scores(1:frames(i)));
        set(s,'Color','blue','LineWidth',2)
        e =plot(T.epoch(1:frames(i)), T.error(1:frames(i)));
        set(e,'Color','red','LineWidth',2)
        plot(repmat(R.trainedepochs_before, 1, R.sizeof_testset+3), -1:R.sizeof_testset+1,  '-k', 'LineWidth',1);
        plot([0, T.epoch], repmat(R.sizeof_testset, 1, length(T.epoch)+1),  '-k', 'LineWidth',1);
        axis([0 T.epoch(end) 0 R.sizeof_testset+R.sizeof_testset*0.006])
        hold off
        title(['Performance at epoch ', num2str(S(frames(i)).epoch)])
        xlabel('Epoch')
        ylabel('Performance') 
  %%      
        currFrame = getframe(f); %  cdata: [343x435x3 uint8]
        writeVideo(V, currFrame);
    end
end

for i = 1:50
    writeVideo(V, currFrame);
end
%% Close

close(V);
close
'Saving video finished'