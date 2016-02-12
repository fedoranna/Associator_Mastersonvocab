% Various things

clear
addpath(genpath('C:\Matlab_functions'));
folder = 'C:\Matlab_functions\RESULTS\Categorizator model_7\_symm\diag, 100%\'; % folder to save results
filename = '';
x = 'all';

%% Weight plots

if isempty(filename)
    
    filenames = dir([folder, '*.mat']);
    if x == 'all'
        x=length(filenames);
    end
    for i = (length(filenames)-x+1) : length(filenames)
        matfile = [folder, filenames(i).name]
        plotfile = [matfile(1:end-4), '-weights.png']
        figtitle = [matfile((end-22) : (end-4)), ' weights']
        
        load(matfile, 'W', 'P')        
        subplot(1,2,1)
        plotmatrix(W(1).state)
        title('W input-hidden')
        subplot(1,2,2)
        plotmatrix(W(2).state)
        title('W hidden-output')
        
        suptitle(figtitle)
        print('-dpng', plotfile);
        close
        
    end
    
end

if isempty(filename)==0
    
    matfile = [folder, filename, '.mat']
    load(matfile, 'W', 'P', 'L')
    
    subplot(1,2,1)
    plotmatrix(W(1).state)
    title('W1')
    subplot(1,2,2)
    plotmatrix(W(2).state)
    title('W2')
    x = [P.ID, '_weights'];
    suptitle(x)
    print('-dpng', [P.folder, x]);
    close
    
end

%%

% if isempty(filename)
%
%     filenames = dir([folder, '*.mat']);
%     for j = 1%:length(filenames)
%         matfile = [folder, filenames(j).name]
%         load(matfile)
%         A=W(1).state;
%         B=W(2).state;
%         M(j,:) = [max(max(A(2,:))), min(min(A(2,:))), max(max(B(:,1))), min(min(B(:,1)))];
%     end
%
% end
%
% if isempty(filename)==0
%     matfile = [folder, filename, '.mat']
%     load(matfile)
%     A=W(1).state;
%     B=W(2).state;
%     [max(max(A(2,:))), min(min(A(2,:))), max(max(B(:,1))), min(min(B(:,1)))]
% end
%
% %% Hidden layer
%
% sweeps = [100:-1:1];
% for i = 1:numel(sweeps)
%
%     sweep = sweeps(i);
%     input = P.testingset(sweep, 1:2);
%     target = P.testingset(sweep, 3:end);
%
%     L(1).state = input;
%     L(2).state = P.transferfn(L(1).state * W(1).state + randomnoise(P.noise, [1, L(2).size]), P.T);
%     L(3).state = P.transferfn(L(2).state * W(2).state + randomnoise(P.noise, [1, L(3).size]), P.T);
%
%     x = P.testingset(sweep,2)*10;
%     y = P.testingset(sweep,1)*10;
%     hova = (10-y)*10+x;
%     subplot(10,10,hova)
%     plotmatrix(L(2).state)
%     title(num2str([P.testingset(sweep,2),P.testingset(sweep,1)]));
%
%
%% Scores

% jobb = zeros(10,10);
% jobb(1:10, 6:10) = 1;
% bal = zeros(10,10);
% bal(1:10, 1:5) = 1;
%
% lower_TH = 0.3;
% upper_TH = 1-lower_TH;
%
% scores1 = zeros(10,10);
% scores2 = zeros(10,10);
% for i = 1:numel(bal)
%     scores1(i) = is_correct(jobb(i), S(200).activationmatrix1(i), upper_TH, lower_TH);
%     scores2(i) = is_correct(bal(i), S(200).activationmatrix3(i), upper_TH, lower_TH);
% end
% scores1
% scores2
% %% Plot weights
%
% subplot(1,2,1)
% plotmatrix(W(1).state)
% title('W1')
%
% subplot(1,2,2)
% plotmatrix(W(2).state)
% title('W2')
%
% x = [P.ID, '-weights'];
% suptitle(x)
% print('-dpng', [P.folder, x]);
%
%% Discriminability
%
% x=0.1:0.1:1;
%
% y = zeros(1,numel(x)-1);
% for i = 1:numel(y)
%     y(i) = x(i+1)/x(i);
% end
% y



