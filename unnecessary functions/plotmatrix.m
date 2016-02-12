function out = plotmatrix(matrix, xlabels, ylabels)
% ticks: how frequent are the ticks?

%% Imagesc

% ticklocs = 1:nrows(matrix);
% imagesc(matrix)
% set(gca, 'TickDir','out');
% set(gca, 'XAxisLocation', 'bottom');
% set(gca, 'XTick', ticklocs);
% set(gca, 'XTickLabel', xlabels);
% set(gca, 'YTick', ticklocs);
% set(gca, 'YTickLabel', ylabels);

%% Negyzetraccsal: pcolor

% plottingmatrix = [matrix; zeros(1, ncols(matrix))];
% plottingmatrix = [plottingmatrix, zeros(nrows(plottingmatrix), 1)];
% pcolor(plottingmatrix)
% 
% axis ij
% axis square

%% Negyzetracs nelkul

h=imagesc(matrix);
set(h,'alphadata',~isnan(matrix))
set(gca, 'XTick', []) 
set(gca, 'YTick', [])

colormap('Jet')
axis ij
axis square

%%
% ticks = 1;
% xticklocs = 1.5 : ticks : ncols(matrix)+1;
% set(gca, 'XTick', xticklocs);
% set(gca, 'XTickLabel', xlabels(xticklocs-0.5));
% 
% yticklocs = 1.5 : ticks : nrows(matrix)+1;
% set(gca, 'YTick', yticklocs);
% set(gca, 'YTickLabel', ylabels(yticklocs-0.5));

