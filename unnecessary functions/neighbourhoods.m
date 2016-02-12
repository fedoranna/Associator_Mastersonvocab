%% Parameters

P.directory = 'C';
P.version = 1;

% Initialization
P.layerinit = @zeros;
P.weightinit = @randn; % rand, randn (zeros does not work, because increment is always 0)
P.randmin = 0; % rand: the lower limit of randomly initialized weights; randn and zeros: has to be 0!!!
P.randmax = 0.1; % rand: the upper limit of randomly initialized weights; randn: the multiplier of the standard normal distribution
P.weightseed = 1; % 'noseed' or a number bw 0 and 2^31-2;
P.inputseed = 7; % 7: in the middle with 10x10 matrix

% Input
P.inputrange = [1, 10];
P.inputbin = 1;
P.patterngenerator = @patterngen_diag; % diag, islands
P.pattern_radius = 0;
P.pattern_neigh = 'o'; % the shape of the neighbourhood: +, x, *, o
P.pattern_param = 'left'; % number of islands; direction of diagonal ('left' or 'right')
P.selectionmethod = 'random'; % random, gui, preselected, check
P.selected = [100]; % percentage of items in the training set for gui and random; sorszam of items for preselected; no meaning for 'check'

% Size of layers
P.size_H = 10;

% Connection densities
P.dens_IH = 1;
P.dens_HO = 1;

% Training
P.transferfn = @transferfn_logsig; % transferfn_logsig for 0/1 targets; use tansig when target is -1/1; threshold does not work with backprop
P.delta = @delta_logsig; % use it according to the transferfn! logsig, logsig_CE, tansig
P.T = 1; % temperature for logsig and tansig transferfunctions, the threshold for threshold/step transferfn
P.normfn = @nochange; % nochange, normfn_bymatrixmax, _byrowmax, _bymatrixsum
P.permute = 0; % permute items before each epoch
P.learningrate = 0.1;
P.momentum = 0.3;
P.noise = 0; % maximum absolute value of random noise

% Evaluating
P.test_performance = 100;
P.upper_TH = 0.8; % threshold of activation for answer = 1
P.lower_TH = 0.2; % threshold of activation for answer = 0

% Stop conditions
P.intended_epochs = 100000;
P.beeps = 3; % Do you want a very annoying reminder when the run is over?

% Saving results
P.folder = [P.directory, ':\Matlab_functions\RESULTS\Categorizator model_', num2str(P.version), '\']; % folder to save results
P.print2screen = 100; % 0 for NO, anynumber for the period to print
P.save_matfile = 1; % save matfile
P.save_figure = 1; % save figure
P.save_2excel = 1;

'Parameter reading done'

%% Store

P.pattern_radius = 0;
P.pattern_neigh = 'o'; % the shape of the neighbourhood: +, x, *, o
[L, W, P, S] = InitializeCategorizator(P); % layers, weights, params, nonchanging params, errors
I0 = P.testingmatrix;

P.pattern_radius = 1;
P.pattern_neigh = '+'; % the shape of the neighbourhood: +, x, *, o
[L, W, P, S] = InitializeCategorizator(P); % layers, weights, params, nonchanging params, errors
I1a = P.testingmatrix;

P.pattern_neigh = 'x'; % the shape of the neighbourhood: +, x, *, o
[L, W, P, S] = InitializeCategorizator(P); % layers, weights, params, nonchanging params, errors
I1b = P.testingmatrix;

P.pattern_neigh = '*'; % the shape of the neighbourhood: +, x, *, o
[L, W, P, S] = InitializeCategorizator(P); % layers, weights, params, nonchanging params, errors
I1c = P.testingmatrix;

P.pattern_neigh = 'o'; % the shape of the neighbourhood: +, x, *, o
[L, W, P, S] = InitializeCategorizator(P); % layers, weights, params, nonchanging params, errors
I1d = P.testingmatrix;

P.pattern_radius = 2;
P.pattern_neigh = '+'; % the shape of the neighbourhood: +, x, *, o
[L, W, P, S] = InitializeCategorizator(P); % layers, weights, params, nonchanging params, errors
I2a = P.testingmatrix;

P.pattern_neigh = 'x'; % the shape of the neighbourhood: +, x, *, o
[L, W, P, S] = InitializeCategorizator(P); % layers, weights, params, nonchanging params, errors
I2b = P.testingmatrix;

P.pattern_neigh = '*'; % the shape of the neighbourhood: +, x, *, o
[L, W, P, S] = InitializeCategorizator(P); % layers, weights, params, nonchanging params, errors
I2c = P.testingmatrix;

P.pattern_neigh = 'o'; % the shape of the neighbourhood: +, x, *, o
[L, W, P, S] = InitializeCategorizator(P); % layers, weights, params, nonchanging params, errors
I2d = P.testingmatrix;

%% Plot

%Figure

figrow = 2;
figcol = 4;
i = 1;

% 1
subplot(figrow, figcol, i)
plotmatrix(I1a, P.inputvalues, P.inputvalues)
title('+')
xlabel('Input value 1')
ylabel('Input value 2')
i=i+1;

% 1
subplot(figrow, figcol, i)
plotmatrix(I1b, P.inputvalues, P.inputvalues)
title('x')
xlabel('Input value 1')
ylabel('Input value 2')
i=i+1;

% 1
subplot(figrow, figcol, i)
plotmatrix(I1c, P.inputvalues, P.inputvalues)
title('*')
xlabel('Input value 1')
ylabel('Input value 2')
i=i+1;

% 1
subplot(figrow, figcol, i)
plotmatrix(I1d, P.inputvalues, P.inputvalues)
title('o')
xlabel('Input value 1')
ylabel('Input value 2')
i=i+1;

subplot(figrow, figcol, i)
plotmatrix(I2a, P.inputvalues, P.inputvalues)
title('+')
xlabel('Input value 1')
ylabel('Input value 2')
i=i+1;

subplot(figrow, figcol, i)
plotmatrix(I2b, P.inputvalues, P.inputvalues)
title('x')
xlabel('Input value 1')
ylabel('Input value 2')
i=i+1;

subplot(figrow, figcol, i)
plotmatrix(I2c, P.inputvalues, P.inputvalues)
title('*')
xlabel('Input value 1')
ylabel('Input value 2')
i=i+1;

subplot(figrow, figcol, i)
plotmatrix(I2d, P.inputvalues, P.inputvalues)
title('o')
xlabel('Input value 1')
ylabel('Input value 2')
i=i+1;

