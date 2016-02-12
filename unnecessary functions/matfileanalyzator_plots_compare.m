%% Parameters

function matfileanalyzator_plots_compare(matfile_basic, matfile_int, param)

%% Load

B = load(matfile_basic, 'S', 'P', 'T', 'R');
I = load(matfile_int, 'S', 'P', 'T', 'R');

if B.P.weightseed ~= I.P.weightseed
    'Seeds do not match!'
end

if length(B.T.epoch) == length(I.T.epoch)
    if B.T.epoch ~= I.T.epoch
        'Tested epochs do not match!'        
    end    
else
    if length(B.T.epoch) > length(I.T.epoch)
        B.T.epoch = B.T.epoch(1:length(I.T.epoch));
        B.T.scores = B.T.scores(1:length(I.T.epoch));
        B.T.error = B.T.error(1:length(I.T.epoch));
        B.S = B.S(1:length(I.T.epoch));
    else
        I.T.epoch = I.T.epoch(1:length(B.T.epoch));
        I.T.scores = I.T.scores(1:length(B.T.epoch));
        I.T.error = I.T.error(1:length(B.T.epoch));
        I.S = I.S(1:length(B.T.epoch));
    end
    
    if B.T.epoch ~= I.T.epoch
        'Tested epochs do not match!'        
    end
end

%% Create and save figure

figure
subplot(2,3,1)
plotmatrix(B.S(end).activationmatrix2, B.P.inputvalues, B.P.inputvalues);
set(gca, 'CLim', [0, 1])
title('Unit 2 without intervention')
xlabel('Input value 1')
ylabel('Input value 2')
colormap('Jet')
freezeColors

subplot(2,3,2)
plotmatrix(I.S(end).activationmatrix2, I.P.inputvalues, I.P.inputvalues);
set(gca, 'CLim', [0, 1])
title('Unit 2 with intervention')
xlabel('Input value 1')
ylabel('Input value 2')
colormap('Jet')
freezeColors

subplot(2,3,3)
if I.S(end).epoch < I.R.trainedepochs_before
    plotmatrix(I.P.trainingmatrix_before, I.P.inputvalues, I.P.inputvalues);
else
    plotmatrix(I.P.trainingmatrix, I.P.inputvalues, I.P.inputvalues);
end
set(gca, 'CLim', [0, 1])
title('Training + intervention items')
xlabel('Input value 1')
ylabel('Input value 2')
set(gca, 'CLim', [-2, I.P.size_O+2])
colormap('Gray')
freezeColors

% ColorSpec: magenta, cyan, green, red, blue
subplot(2,3,4:6)
hold all
s = plot(B.T.epoch, B.T.scores);
set(s, 'LineWidth',2, 'Color',[0 0 0], 'LineStyle', '--')
e =plot(I.T.epoch, I.T.scores);
set(e,'LineWidth',2, 'Color',[0 0 0])
if length(B.S) < length(I.S)
    plot(repmat(B.R.trainedepochs_before, 1, B.R.sizeof_testset+3), -1:B.R.sizeof_testset+1,  '-k', 'LineWidth',1);
    plot([0, B.T.epoch], repmat(B.R.sizeof_testset, 1, length(B.T.epoch)+1),  '-k', 'LineWidth',1);
    axis([0 B.T.epoch(end) 0 B.R.sizeof_testset+B.R.sizeof_testset*0.006])
else
    plot(repmat(I.R.trainedepochs_before, 1, I.R.sizeof_testset+3), -1:I.R.sizeof_testset+1,  '-k', 'LineWidth',1);
    plot([0, I.T.epoch], repmat(I.R.sizeof_testset, 1, length(I.T.epoch)+1),  '-k', 'LineWidth',1);
    axis([0 I.T.epoch(end) 0 I.R.sizeof_testset+I.R.sizeof_testset*0.006])
end
legend('Without intervention', 'With intervention', 'Location', 'SouthEast')
hold off
title('Performance')
xlabel('Epoch')
ylabel('Performance')

figurefile = [matfile_basic(1:end-4), '_', matfile_int(end-22:end-4), '.png']; %num2str(nframes), '_', num2str(fps), '_', num2str(reruns), '.avi'];
print('-dpng', figurefile);
close