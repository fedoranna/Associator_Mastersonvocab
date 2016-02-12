% Makes the usual figures

function figurefile = matfileanalyzator_usualplots(matfile, param)

opengl software
load(matfile, 'P', 'S', 'R', 'T')
figure

figrow = 3;
figcol = 4;
i = 1;

% 1
subplot(figrow, figcol, i)
plotmatrix(P.testingmatrix, P.inputvalues, P.inputvalues)
set(gca, 'CLim', [-2, P.size_O+2])
colormap('Gray')
freezeColors
title('Target pattern')
xlabel('Input value 1')
ylabel('Input value 2')
i=i+1;

% 2
subplot(figrow, figcol, i)
plotmatrix(S(end).activationmatrix1, P.inputvalues, P.inputvalues)
set(gca, 'CLim', [0, 1])
freezeColors
title('Activations Unit 1')
xlabel('Input value 1')
ylabel('Input value 2')
i=i+1;

% 3
subplot(figrow, figcol, i)
plotmatrix(S(end).activationmatrix2, P.inputvalues, P.inputvalues)
set(gca, 'CLim', [0, 1])
freezeColors
xlabel('Input value 1')
ylabel('Input value 2')
title('Activations Unit 2')
i=i+1;
if P.size_O == 2
    i=i+1;
elseif P.size_O == 3
    % 4
    subplot(figrow, figcol, i)
    plotmatrix(S(end).activationmatrix3, P.inputvalues, P.inputvalues)
    set(gca, 'CLim', [0, 1])
    freezeColors
    title('Activations Unit 3')
    xlabel('Input value 1')
    ylabel('Input value 2')
    i=i+1;
end

% 5
subplot(figrow, figcol, i)
if P.int_when == 0
    plotmatrix(P.trainingmatrix, P.inputvalues, P.inputvalues)
    set(gca, 'CLim', [-2, P.size_O+2])
    colormap('Gray')
    freezeColors
    title('Training set')
elseif P.int_when > 0
    plotmatrix(P.trainingmatrix_before, P.inputvalues, P.inputvalues)
    set(gca, 'CLim', [-2, P.size_O+2])
    colormap('Gray')
    freezeColors
    title('Training set before int.')
end
xlabel('Input value 1')
ylabel('Input value 2')
i=i+1;

% 6
subplot(figrow, figcol, i)
if P.int_when == 0
    plotmatrix(S(R.testedepochs).scorematrix, P.inputvalues, P.inputvalues)
    set(gca, 'CLim', [0,1])
    colormap('Copper')
    freezeColors
    title('Scores')
elseif P.int_when > 0
    plotmatrix(S(R.testedepochs_before).scorematrix, P.inputvalues, P.inputvalues)
    set(gca, 'CLim', [0,1])
    colormap('Copper')
    freezeColors
    title('Scores before int.')
end
xlabel('Input value 1')
ylabel('Input value 2')
i=i+1;

% 7
if P.int_when > 0
    subplot(figrow, figcol, i)
    plotmatrix(P.trainingmatrix, P.inputvalues, P.inputvalues)
    set(gca, 'CLim', [-2, P.size_O+2])
    colormap('Gray')
    freezeColors
    title('Intervention training set')
    xlabel('Input value 1')
    ylabel('Input value 2')
    i=i+1;
    
    % 8
    subplot(figrow, figcol, i)
    plotmatrix(S(end).scorematrix, P.inputvalues, P.inputvalues)
    set(gca, 'CLim', [0, 1]);
    colormap('Copper')
    freezeColors
    title('Scores after int.')
    xlabel('Input value 1')
    ylabel('Input value 2')
    i=i+1;
    
elseif P.int_when == 0
    i=i+2;
end

% 9
subplot(figrow, figcol, i:figrow*figcol)
hold all
plot(T.epoch, T.scores)
plot(T.epoch, T.error)
plot(repmat(R.trainedepochs_before, 1, R.sizeof_testset+3), -1:R.sizeof_testset+1,  '-k', 'LineWidth',1);
plot([0, T.epoch], repmat(R.sizeof_testset, 1, length(T.epoch)+1),  '-k', 'LineWidth',1);
axis([0 T.epoch(end) 0 R.sizeof_testset+1])
hold off
title('Performance')
xlabel('Epoch')
ylabel('Performance')
i=i+1;

% Saving

figurefile = [matfile(1:end-4), '.png'];
print('-dpng', figurefile);
close
%%
end