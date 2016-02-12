function matfileanalyzator_hiddenactivation_figures(matfile, param)

load(matfile, 'L', 'W', 'P')

% Calculate

scores = NaN(1, P.nbof_items);
error = 0;
activationmatrix1 = zeros(numel(P.inputvalues));
activationmatrix2 = zeros(numel(P.inputvalues));
activationmatrix3 = zeros(numel(P.inputvalues));
activationmatrix4 = zeros(numel(P.inputvalues));
activationmatrix5 = zeros(numel(P.inputvalues));
scorematrix = zeros(numel(P.inputvalues));
errormatrix = zeros(numel(P.inputvalues));

for sweep = 1:nrows(P.testingset)
    
    % Activations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    input = P.testingset(sweep, 1:2);
    L(1).state = input;
    L(2).state = P.transferfn([L(1).state, P.bias] * W(1).state + randomnoise(P.noise, [1, L(2).size]), P.T, P.offset);
    L(3).state = P.transferfn([L(2).state, P.bias] * W(2).state + randomnoise(P.noise, [1, L(3).size]), P.T, P.offset);
    
    % Performance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    target = P.testingset(sweep, 3:end);
    scores(sweep) = is_correct(target(2), L(3).state(2), P.upper_TH, P.lower_TH);
    error = error + MSE(target, L(3).state); % accumulating SSE for this epoch
    
    activationmatrix1(sweep) = L(3).state(1);
    activationmatrix2(sweep) = L(3).state(2);
    activationmatrix3(sweep) = L(3).state(3);
    activationmatrix4(sweep) = L(2).state(1);
    activationmatrix5(sweep) = L(2).state(2);
    
    scorematrix(sweep) = is_correct(target, L(3).state, P.upper_TH, P.lower_TH);
    errormatrix(sweep) = MSE(target, L(3).state);
    
end

% Plot

subplot(2,2,1)
draw_seplines(P.testingset, P.testingmatrix, W(1).state, 0)

% subplot(2,2,2)
% plotmatrix(flipit(scorematrix), P.inputvalues, P.inputvalues)
% set(gca, 'CLim', [0,1])
% colormap('Copper')
% freezeColors
% title(['Scores: ', num2str(sum(sum(scorematrix))/100)])

subplot(2,2,2)
plotmatrix(flipit(activationmatrix3), P.inputvalues, P.inputvalues)
set(gca, 'CLim', [0, 1])
freezeColors
title('Activations O3')
xlabel('Input value 1')
ylabel('Input value 2')

subplot(2,2,3)
plotmatrix(flipit(activationmatrix4), P.inputvalues, P.inputvalues)
set(gca, 'CLim', [0, 1])
freezeColors
title('Activations H1')
xlabel('Input value 1')
ylabel('Input value 2')

subplot(2,2,4)
plotmatrix(flipit(activationmatrix5), P.inputvalues, P.inputvalues)
set(gca, 'CLim', [0, 1])
freezeColors
title('Activations H2')
xlabel('Input value 1')
ylabel('Input value 2')

print('-dpng', [matfile(1:end-4), '_hidden activations.png']);
close

