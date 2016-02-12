% Makes the usual figures

function figurefile = matfileanalyzator_errorcat(matfile, param)

opengl software
load(matfile, 'P', 'T', 'S', 'R', 'D')

%% Categorize errors

% Which error categorizations do you want to use?
rounded = 1;
closest = 1;
recurrent = 1;

if isfield(T, 'production')
    
    % Delete empty rows
    for i = nrows(T.production) : -1 : 1
        if  isempty(T.production{i,1})
            T.production(i,:) = [];
        end
    end
    
    % Creates field in T: errortypes, mainerrortypes, mainerrorperc
    if rounded == 1
        T_rounded = CategorizeErrors_rounded(T, D, P);
    end
    if closest == 1
        T_closest = CategorizeErrors_closest(T, D, P);
        %T_closest = CategorizeErrors_closest_nophon(T, D, P);
    end
    if recurrent == 1
        T_recurrent = CategorizeErrors_recurrent(T, D, P);
    end
    
else
    T.production = [];
    T.errortypes = NaN(1,12);
    T.mainerrortypes = NaN(1,4);
    T.errorperc = NaN(1,4);
end

felirat1 = [
    {'OTHER / no response'};                      % 1.
    {'OTHER / thingy'};                           % 2.
    {'uncertainty is low'};                       % 3.
    {'CORRECT'};                                  % 4.
    {'CORRECT/small phonemic error'};             % 5.
    {'MIXED'};                                    % 6.
    {'SEM'};                                      % 7.
    {'PHON / phonologically related word'};       % 8.
    {'OTHER / unrelated word'};                   % 9.
    {'PHON / phonologically related non-word'};   % 10.
    {'OTHER / unrelated non-word'};               % 11.
    {'phonotactically legal'}];                   % 12.

felirat2 = [{'Semantic errors'};{'Phonological errors'};{'Mixed errors'};{'Other error types'}];
felirat3 = [{'Task SS'}; {'Task PP'}; {'Task SP'}; {'Task PS'}];
felirat4 = [{'Correct'}; {'Semantic errors'};{'Phonological errors'};{'Mixed errors'};{'Other error types'}];
categories_2plot = [4,5, 7, 10, 6, 1, 2, 11, 5];

%% Plot

scrsz = get(0,'ScreenSize');
figure('Position',[1 1 scrsz(3) scrsz(4)])
%figure('PaperSize',[200,300]);
set(gcf,'PaperPositionMode','auto')

suptitle(['ID: ', P.ID])
shape1 = 2;
shape2 = 2;
n = 1;

% subplot(shape1,shape2,n)
% n = n+1;
% bar( [1,2], zeros(2,length(categories_2plot)), 1, 'stacked')
% set(legend(felirat1(categories_2plot)),'Location', 'South');

subplot(shape1,shape2,n)
n = n+1;
title('Developmental trajectories');
x = P.test_performance : P.test_performance : R.completed_epochs;
hold all
plot(x, T.SS_all, '--m', 'LineWidth', 1.5);
plot(x, T.PP_all, '--c', 'LineWidth', 1.5);
plot(x, T.SP_all, ':r', 'LineWidth', 1.5);
plot(x, T.PS_all, ':b', 'LineWidth', 1.5);
if P.intervention == 1
    plot(repmat(P.keptepochs, 1, P.vocabsize+3), -1:P.vocabsize+1,  '-k', 'LineWidth',1);
end
set(legend(felirat3),'Location', 'SouthEast');  %[0.6756 0.1897 0.2018 0.2778])
axis([0 R.completed_epochs+100 0 P.vocabsize+1]);
set(gca,'TickDir','out');
xlabel('Number of epochs');
ylabel('Score');
hold off

if rounded == 1
    subplot(shape1,shape2,n)
    n = n+1;
    T = T_rounded;
    %bar( T.prodsavedat, T.errortypes(:,categories_2plot), 1, 'stacked')
    bar( T.prodsavedat, T.mainerrortypes, 1, 'stacked')
    set(legend(felirat4), 'Location', 'SouthEast')
    set(gca,'TickDir','out');
    xlabel('Number of epochs');
    ylabel('Number of words');
    title('Errors based on rounded');    
    
%     subplot(shape1,shape2,n)
%     n = n+1;
%     bar(T.prodsavedat, T.mainerrorperc, 'stacked')
%     set(gca,'TickDir','out');
%     title('Main error types');
%     set(legend(felirat2),'Location', 'SouthEast')
%     xlabel('Number of epochs');
%     ylabel('Percentage of errors');
%     axis([0, max(T.prodsavedat), 0, 100])
end

if closest == 1
    subplot(shape1,shape2,n)
    n = n+1;
    T = T_closest;
    %bar( T.prodsavedat, T.errortypes(:,categories_2plot), 1, 'stacked')
    bar( T.prodsavedat, T.mainerrortypes, 1, 'stacked')
    set(legend(felirat4),'Location', 'SouthEast')
    set(gca,'TickDir','out');
    xlabel('Number of epochs');
    ylabel('Number of words');
    title('Errors based on closest');
    
%     subplot(shape1,shape2,n)
%     n = n+1;
%     bar(T.prodsavedat, T.mainerrorperc, 'stacked')
%     set(gca,'TickDir','out');
%     title('Main error types');
%     set(legend(felirat2),'Location', 'SouthEast')
%     xlabel('Number of epochs');
%     ylabel('Percentage of errors')
%     axis([0, max(T.prodsavedat), 0, 100])
end

if  recurrent == 1
    subplot(shape1,shape2,n)
    n = n+1;
    T = T_recurrent;
    %bar( T.prodsavedat, T.errortypes(:,categories_2plot), 1, 'stacked')
    bar( T.prodsavedat, T.mainerrortypes, 1, 'stacked')
    set(legend(felirat4),'Location', 'SouthEast')
    set(gca,'TickDir','out');
    xlabel('Number of epochs');
    ylabel('Number of words');
    title('Errors based on recurrent');
    
%     subplot(shape1,shape2,n)
%     n = n+1;
%     bar(T.prodsavedat, T.mainerrorperc, 'stacked')
%     set(gca,'TickDir','out');
%     title('Main error types');
%     set(legend(felirat2),'Location', 'SouthEast')
%     xlabel('Number of epochs');
%     ylabel('Percentage of errors');
%     axis([0, max(T.prodsavedat), 0, 100])
end

figurefile =  [P.folder, P.ID, '_error_recats.png'];
print('-dpng', figurefile);
close