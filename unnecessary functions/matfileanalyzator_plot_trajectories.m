% Makes the usual figures

function figurefile = matfileanalyzator_plot_trajectories(matfile, param)

opengl software
load(matfile, 'P', 'T', 'S', 'R')

%% Plot

P.plot_errors         = 1;
P.plot_all            = 0;
P.plot_frequencies    = 0; % compare the effect of the word frequencies
P.plot_P_denseness    = 0; % compare the effect of the sparseness of phonological neighbourhoods
P.plot_S_atypicality  = 0;
P.plot_S_imageability = 0;

figtitle = ['Associator', num2str(P.version), '; ID: ', P.ID];
felirat = [];
colours = {'c', 'r', 'b', 'g', 'k', 'y', 'c', 'r', 'b', 'g', 'k', 'y', 'c', 'r', 'b', 'g', 'k', 'y', 'c', 'r', 'b', 'g', 'k', 'y',};
%linetype = {'-', '--', ':', '-.'};
x = P.test_performance : P.test_performance : P.test_performance*length(S);

hold all
if P.plot_errors
    plot(x, [S.error_SS], '-m');
    plot(x, [S.error_PP], '-c');
    plot(x, [S.error_SP], '-r');
    plot(x, [S.error_PS], '-b');
    felirat = [felirat; {'1-MSE(SS)'}; {'1-MSE(PP)'}; {'1-MSE(SP)'}; {'1-MSE(PS)'}];
end
if P.plot_all
    plot(x, T.SS_all, '--m', 'LineWidth', 1.5);
    plot(x, T.PP_all, '--c', 'LineWidth', 1.5);
    plot(x, T.SP_all, ':r', 'LineWidth', 1.5);
    plot(x, T.PS_all, ':b', 'LineWidth', 1.5);
    felirat = [felirat; {'vocab SS'}; {'vocab PP'}; {'vocab SP'}; {'vocab PS'}];
end
shown = [];
if P.plot_frequencies
    shown = [shown, '_freq'];
    for i = 1:nrows(P.frequency)
        if isempty(P.frequency{i})==0
            plot(x, T.SS_frequency(i,:), ['-',  colours{i}]);
            plot(x, T.PP_frequency(i,:), ['--', colours{i}]);
            plot(x, T.SP_frequency(i,:), [':',  colours{i}]);
            plot(x, T.PS_frequency(i,:), ['-.', colours{i}]);
            felirat = [felirat; {['SS, frequency ', num2str(i-1)]}; {['PP, frequency ', num2str(i-1)]}; {['SP, frequency ', num2str(i-1)]}; {['PS, frequency ', num2str(i-1)]}];
        end
    end
end
if P.plot_P_denseness
    shown = [shown, '_dens'];
    for i = 1:nrows(P.denseness)
        if isempty(P.denseness{i})==0
            plot(x, T.SS_denseness(i,:), ['-',  colours{i}]);
            plot(x, T.PP_denseness(i,:), ['--', colours{i}]);
            plot(x, T.SP_denseness(i,:), [':',  colours{i}]);
            plot(x, T.PS_denseness(i,:), ['-.', colours{i}]);
            felirat = [felirat; {['SS, denseness ', num2str(i)]}; {['PP, denseness ', num2str(i)]}; {['SP, denseness ', num2str(i)]}; {['PS, denseness ', num2str(i)]}];
        end
    end
end
if P.plot_S_atypicality
    shown = [shown, '_atyp'];
    for i = 1:nrows(P.atypicality)
        if isempty(P.atypicality{i})==0
            plot(x, T.SS_atypicality(i,:), ['-',  colours{i}]);
            plot(x, T.PP_atypicality(i,:), ['--', colours{i}]);
            plot(x, T.SP_atypicality(i,:), [':',  colours{i}]);
            plot(x, T.PS_atypicality(i,:), ['-.', colours{i}]);
            felirat = [felirat; {['SS, atypicality ', num2str(i)]}; {['PP, atypicality ', num2str(i)]}; {['SP, atypicality ', num2str(i)]}; {['PS, atypicality ', num2str(i)]}];
        end
    end
end
if P.plot_S_imageability
    shown = [shown, '_imag'];
    for i = 1:nrows(P.imag)
        if isempty(P.imag{i})==0
            plot(x, T.SS_imag(i,:), ['-',  colours{i}]);
            plot(x, T.PP_imag(i,:), ['--', colours{i}]);
            plot(x, T.SP_imag(i,:), [':',  colours{i}]);
            plot(x, T.PS_imag(i,:), ['-.', colours{i}]);
            felirat = [felirat; {['SS, imageability ', num2str(i)]}; {['PP, imageability ', num2str(i)]}; {['SP, imageability ', num2str(i)]}; {['PS, imageability ', num2str(i)]}];
        end
    end
end

if P.intervention
    plot(repmat(P.keptepochs, 1, P.vocabsize+3), -1:P.vocabsize+1,  '-k', 'LineWidth',1);
end

set(legend(felirat),'Location', 'NorthEastOutside');  %[0.6756 0.1897 0.2018 0.2778])
axis([-100 R.completed_epochs+100 95 P.vocabsize+1]);
set(gca,'TickDir','out');
xlabel('Number of epochs');
ylabel('Words');

%% Save

title(figtitle, 'Interpreter', 'none'); % kesobbi MatLabban %suptitle(figtitle);
figurefile = [P.folder, P.ID, shown, '_errors.png'];
print('-dpng', figurefile);
hold off
close

'Saving figure finished'

