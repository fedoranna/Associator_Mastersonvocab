P.directory = 'C';
addpath(genpath([P.directory, ':\Matlab_functions']));


x = -10:0.1:10;
T = [0.5; 1];
felirat = num2str(T);

hold all
for i = 1:numel(T)
    y = transferfn_logsig(x, T(i));
    plot(x,y)
end

set(legend(felirat),'Location', 'NorthEastOutside');