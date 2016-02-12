% Makes agematched figure from two simulations, usually TD and AT

clear
addpath(genpath('C:\Matlab_functions'));
folder = 'C:\Matlab_functions\RESULTS\Categorizator model_7\4_intervention\Sc1_diag_C=0.3\'; % folder to save results
filenameTD = '2012-11-19-17-16-21';
filenameAT = '2012-11-26-23-17-19';
timeout = 1500;
deficit = 'C = 0.3';

%%
matfileTD = [folder, filenameTD, '.mat'];
MTD = matfileanalyzator_phases_diag_TDAT(matfileTD, 'dummy');

matfileAT = [folder, filenameAT, '.mat'];
MAT = matfileanalyzator_phases_diag_TDAT(matfileAT, 'dummy');

'Saving separate figures done'
%% Plot

load(matfileTD, 'T', 'P', 'R')
seed_TD = P.weightseed;

subplot(2,1,1)
hold all
s=plot(T.epoch, T.scores, 'blue');
set(s,'Color','blue','LineWidth',2)
e=plot(T.epoch, T.error, 'green');
set(e,'Color','red','LineWidth',2)
for i = 5:7 % plot intervention times
    plot(repmat(MTD(i), 1, R.sizeof_testset+3), -1:R.sizeof_testset+1,  'green', 'LineWidth',1);
end

plot([0, T.epoch], repmat(R.sizeof_testset, 1, length(T.epoch)+1),  '-k', 'LineWidth',1);
axis([0 timeout 0 R.sizeof_testset+1])
hold off
xlabel('Epoch')
ylabel('Performance')
title('TD')

%%
load(matfileAT, 'T', 'P', 'R')
seed_AT = P.weightseed;
if seed_TD ~= seed_AT
    'WARNING! Seeds do not match!'
end

subplot(2,1,2)
hold all
s=plot(T.epoch, T.scores, 'blue');
set(s,'Color','blue','LineWidth',2)
e=plot(T.epoch, T.error, 'green');
set(e,'Color','red','LineWidth',2)
for i = 5:7 % plot intervention times
    plot(repmat(MAT(i), R.sizeof_testset+3), -1:R.sizeof_testset+1,  'green', 'LineWidth',1);
end

plot([0, T.epoch], repmat(R.sizeof_testset, 1, length(T.epoch)+1),  '-k', 'LineWidth',1);
axis([0 timeout 0 R.sizeof_testset+1])
hold off
xlabel('Epoch')
ylabel('Performance')
title(deficit)

%% Save
figurefile = [folder, filenameTD, '_', filenameAT, '_agematched.png'];
print('-dpng', figurefile);
close

'Saving common figure finished'


