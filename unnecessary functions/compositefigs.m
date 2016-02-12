% Makes the usual figures

function figurefile = compositefigs(P, T, R)

opengl software

%%

smaller = 0.9;
f=figure('OuterPosition',[1 1 1920*smaller 1200*smaller]);
suptitle(['ID: ', P.ID])

subplot(2,2,1)
title('Developmental trajectories');
x = P.test_performance : P.test_performance : R.completed_epochs;
hold all
plot(x, T.SS_all, '--m', 'LineWidth', 1.5);
plot(x, T.PP_all, '--c', 'LineWidth', 1.5);
plot(x, T.SP_all, ':r', 'LineWidth', 1.5);
plot(x, T.PS_all, ':b', 'LineWidth', 1.5);
if P.intervention == 1
    plot(repmat(P.int_keptepochs, 1, P.vocabsize+3), -1:P.vocabsize+1,  '-k', 'LineWidth',1);
end
felirat3 = [{'Task SS'}; {'Task PP'}; {'Task SP'}; {'Task PS'}];
set(legend(felirat3),'Location', 'SouthEast');  %[0.6756 0.1897 0.2018 0.2778])
axis([0 R.completed_epochs+100 0 P.vocabsize+1]);
set(gca,'TickDir','out');
xlabel('Number of epochs');
ylabel('Number of known words');
hold off

subplot(2,2,2)
felirat4 = [{'Correct'}; {'Semantic errors'};{'Phonological errors'};{'Mixed errors'};{'Other error types'}];
bar( T.prodsavedat, T.mainerrortypes, 1, 'stacked')
set(gca,'YLim',[0 P.vocabsize])
set(legend(felirat4), 'Location', 'SouthEast')
set(gca,'TickDir','out');
xlabel('Number of epochs');
ylabel('Number of words');
errorfunc = func2str(P.errorcatfn);
title(['Errors based on ', errorfunc(18:end)]);

subplot(2,2,3)
title('Naming task accuracy')

% Percentage instead of count
frequency = T.SP_frequency;
imag = T.SP_imag;
for j = 1:nrows(P.frequency)
    frequency(j,:) =  (T.SP_frequency(j,:) / numel(P.frequency{j,:})) * 100;
end
for j = 1:nrows(P.imag)
    imag(j,:) =  (T.SP_imag(j,:) / numel(P.imag{j,:})) * 100;
end

hold all
felirat = [];
linetype = {'-', '--', ':', '-.'};
for i = 1:nrows(P.frequency)
    if isempty(P.frequency{i})==0
        plot(x, frequency(i,:), [linetype{i}, 'b']);
        felirat = [felirat; {['Frequency ', num2str(i)]}];
    end
end
for i = 1:nrows(P.imag)
    if isempty(P.imag{i})==0
        plot(x, imag(i,:), [linetype{i}, 'r']);
        felirat = [felirat; {['Imageability ', num2str(i)]}];
    end
end
if nrows(P.frequency)==2 && nrows(P.imag)==2
    felirat = [{'Low frequency'}; {'High frequency'};{'Low imageability'};{'High imageability'};];
end
if P.intervention == 1
    plot(repmat(P.int_keptepochs, 1, P.vocabsize+3), -1:P.vocabsize+1,  '-k', 'LineWidth',1);
end
set(legend(felirat),'Location', 'SouthEast');  %[0.6756 0.1897 0.2018 0.2778])
%axis([0 R.completed_epochs+100 0 P.vocabsize+1]);
axis([0 R.completed_epochs+100 0 101]); % if %
set(gca,'TickDir','out');
xlabel('Number of epochs');
ylabel('Score (%)');
hold off

subplot(2,2,4)
title('Naming task reaction time')
hold all
felirat = [];
for i = 1:nrows(P.frequency)
    if isempty(P.frequency{i})==0
        plot(P.test_RT(1:ncols(T.RT_SP_frequency)), T.RT_SP_frequency(i,:), [linetype{i}, 'b']);
        felirat = [felirat; {['Frequency ', num2str(i)]}];
    end
end
for i = 1:nrows(P.imag)
    if isempty(P.imag{i})==0
        plot(P.test_RT(1:ncols(T.RT_SP_imag)), T.RT_SP_imag(i,:), [linetype{i}, 'r']);
        felirat = [felirat; {['Imageability ', num2str(i)]}];
    end
end
if nrows(P.frequency)==2 && nrows(P.imag)==2
    felirat = [{'Low frequency'}; {'High frequency'};{'Low imageability'};{'High imageability'};];
end
if P.intervention == 1
    plot(repmat(P.int_keptepochs, 1, P.vocabsize+3), -1:P.vocabsize+1,  '-k', 'LineWidth',1);
end
set(gca,'TickDir','out');
axis([0, P.test_RT(ncols(T.RT_SP_imag)), 0, P.timeout])
xlabel('Number of epochs');
ylabel('Reaction time');
set(legend(felirat),'Location', 'NorthEast');
hold off

set(gcf,'PaperPositionMode','auto')
figurefile =  [P.folder, P.ID, '_composite.png'];
print('-dpng', figurefile);
close