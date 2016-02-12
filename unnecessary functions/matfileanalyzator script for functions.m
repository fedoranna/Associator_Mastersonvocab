%% Parameters

clear
addpath(genpath('C:\Matlab_functions'));
folder = 'C:\Matlab_functions\RESULTS\Associator model_23\8. AT_conndens_mixed locations\'; % folder to save results
filename = '';
tol = 'all'; % starting from which file (No) counted from the end; 'all' if from beginning
ig = 1; % finished at which file (No) counted from the end
analyzatorfunction = @matfileanalyzator_performance_when; % name of the function
%analyzatorfunction = @matfileanalyzator_Ass_performance_at; % name of the function
param.range = 0.5;
param.fps = 24;   % 24 in movies
param.frames = 1: 10: 2000;
param.reruns = 1;
param.epoch = 900;
param.score = 90;
param.resize = 10; % This will be the new P.test_performance
param.weights = 1000;
param.mode = 'R';
param.layer2plot = '';
param.dim_2D = 1;
param.dim_3D = 0;
param.explained = 0;
param.activations = 0;
param.dimensions = {'semclass'};

% Batch

if isempty(filename)
    
    opengl software
    filenames = dir([folder, '*.mat']);
    if tol == 'all'
        tol=length(filenames);
    end
    
    O = cell(1, numel((length(filenames)-tol+1) : (length(filenames)-ig+1)));
    
    for i = (length(filenames)-tol+1) : (length(filenames)-ig+1)
        matfile = [folder, filenames(i).name];
        O{i} = analyzatorfunction(matfile, param);
    end
    
    % Transform O
    if 1==1
        M = NaN(numel(O), numel(O{1}));
        for i = 1:numel(O)
            for j = 1:numel(O{1})
                M(i,j) = O{i}(j);
            end
        end
    end
    M/100;
    M;
end

% Individual

if isempty(filename)==0
    matfile = [folder, filename, '.mat']
    analyzatorfunction(matfile, param)
end

%%

x = reshape(M, 3, 10);
x=x';
x(:,1) = age(x(:,1), 0);
x(:,2) = age(x(:,2), 500);
x(:,3) = age(x(:,3), 500);
x


