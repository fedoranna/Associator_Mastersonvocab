% Draws separation line for each hidden unit in input space
% Based on: http://www.csc.kth.se/utbildning/kth/kurser/DD2432/ann08/delta-eng.pdf
% patterns: each row is a training item [y, x] values
% targets: targets for the output unit (not the hiddens); 1 row vector
% weights: weitghs from input units+bias to hidden units; nrows = nb of input units, ncols = nb of hidden units

% patterns = P.testingset(:,1:2);
% targets = P.testingmatrix;
% weights = W(1).state;
% range = size of plot area around input space
% fps = frame per second

function V = matfileanalyzator_moviemaker_seplines(matfile, param)

range = param.range;
fps = param.fps;

load(matfile, 'Q', 'P');

patterns = P.testingset(:,1:2);
patterns = [patterns, ones(nrows(patterns),1)]; % bias column

targets = P.testingmatrix;
targets = flipit(targets);

outfile = [matfile(1:end-4), '_seplinemovie.avi'];

V = VideoWriter(outfile);
V.FrameRate = fps;
V.Quality = 100;
colors = {'b', 'r', 'k', 'y', 'c', 'm', 'g'};

open(V);
opengl software % This should solve the mirrored labels
scrsz = get(0,'ScreenSize');
x=0.9;
f = figure('Position',[1 1 scrsz(3)*x scrsz(4)*x]); % 1 1 scrsz(3) scrsz(4)

currFrame = getframe(f); %
for i = 1:5
    writeVideo(V, currFrame);
end

for i = 1:length(Q)    
    epoch = i-1;
    
    if isempty(Q(i).IH) == 0        
     
        plot (patterns(find(targets==0), 2), ...
            patterns(find(targets==0), 1), '.c', ...
            patterns(find(targets==1), 2), ...
            patterns(find(targets==1), 1), '.g', ...
            patterns(find(targets==2), 2), ...
            patterns(find(targets==2), 1), '.m')
        
        weights = Q(i).IH;
        colorNo = 0;
        
        hold all
        for unitNo = 1:ncols(weights)
            
            colorNo = colorNo+1;
            if colorNo>length(colors)
                colorNo = 1;
            end
            
            p = [weights(2, unitNo), weights(1, unitNo)]; % weights from the 2 inputs to one of the hiddens
            k = -weights(3, unitNo) / (p*p'); % weight from the bias to one of the hiddens
            l = sqrt(p*p');
            
            plot([p(1), p(1)]*k + [-p(2), p(2)]/l, ...
                [p(2), p(2)]*k + [p(1), -p(1)]/l, ...
                ['-', colors{colorNo}]);                        
            
            axis ([min(min(patterns))-range, max(max(patterns))+range, min(min(patterns))-range, max(max(patterns))+range], 'square');
            title(['Epoch: ', num2str(epoch)])
            drawnow;
            
        end
        
        hold off
        currFrame = getframe(f); %  cdata: [343x435x3 uint8]
        writeVideo(V, currFrame);
        
    end
    
end
for i = 1:5
    writeVideo(V, currFrame);
end

close(V)
close


% Coordinates of the two endpoints of the line:
%     x1 = p(1)*k - p(2)/l;
%     x2 = p(1)*k + p(2)/l;
%     y1 = p(2)*k + p(1)/l;
%     y2 = p(2)*k - p(1)/l;
%
% Uglier, but gives the same results:
%             w1 = weights(2, unitNo);
%             w2 = weights(1, unitNo);
%             b = weights(3, unitNo);
%             plot([0, w2], [-b/w2, ((-b/w2)-w1)],  '-r');

