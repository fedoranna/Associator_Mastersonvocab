% Draws separation line for each hidden unit in input space
% patterns: each row is a training item [y, x] values
% targets: targets for the output unit (not the hiddens); 1 row vector
% weights: weitghs from input units+bias to hidden units; nrows = nb of input units, ncols = nb of hidden units

% patterns = P.testingset(:,1:2);
% targets = P.testingmatrix;
% weights = W(1).state;
% range = size of plot area around input space
% fps = frame per second

% Coordinates of the line:
%     x1 = p(1)*k + -p(2)/l;
%     x2 = p(1)*k +  p(2)/l;
%     y1 = p(2)*k +  p(1)/l;
%     y2 = p(2)*k + -p(1)/l;

function draw_seplines(patterns, targets, weights, range)

patterns = [patterns, ones(nrows(patterns),1)]; % bias
targets = flipit(targets);

colors = {'b', 'r', 'k', 'y', 'c', 'm', 'g'};
colorNo = 0;

hold all
plot (patterns(find(targets==0), 2), ...
        patterns(find(targets==0), 1), '.c', ...
        patterns(find(targets==1), 2), ...
        patterns(find(targets==1), 1), '.g', ...
        patterns(find(targets==2), 2), ...
        patterns(find(targets==2), 1), '.m')

for unitNo = 1:ncols(weights)    
    
    colorNo = colorNo+1;
    if colorNo>length(colors)
        colorNo = 1;
    end
    
    p = [weights(2, unitNo), weights(1, unitNo)]; % weights from the 2 inputs to one of the hiddens
    k = -weights(3, unitNo) / (p*p'); % weight from the bias to one of the hiddens
    l = sqrt(p*p');
    
    plot([p(1), p(1)]*k + [-p(2), p(2)]/l, ...
        [p(2), p(2)]*k + [p(1), -p(1)]/l, ['-', colors{colorNo}], 'LineWidth',2);
    axis ([min(min(patterns))-range, max(max(patterns))+range, min(min(patterns))-range, max(max(patterns))+range], 'square');
    drawnow;

    %% Plotting the endpoints of the lines only
%     
%     x1 = p(1)*k + -p(2)/l;
%     x2 = p(1)*k +  p(2)/l;
%     y1 = p(2)*k +  p(1)/l;
%     y2 = p(2)*k + -p(1)/l;
% 
%     plot(x1, y1, 'o', 'MarkerFaceColor', 'r')
%     plot(x2, y2, 'o', 'MarkerFaceColor', 'b')
%         plot([p(1), p(1)]*k + [-p(2), p(2)]/l, ...
%         [p(2), p(2)]*k + [p(1), -p(1)]/l, '-k');
%     axis ([min(min(patterns))-range, max(max(patterns))+range, min(min(patterns))-range, max(max(patterns))+range], 'square');
%     drawnow;
%     
    %[x1, y1, x2, y2, weights']
    
end
hold off 

    
    