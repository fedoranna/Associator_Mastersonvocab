clear
addpath(genpath('C:\Matlab_functions'));

folder = 'C:\Matlab_functions\RESULTS\Categorizator model_7\4_intervention\Sc3_diag_T=0.5\';
basic = '2012-11-26-19-01-26';
intervention = '2012-11-27-18-46-36';
%2012-11-26-19-01-26_2012-11-27-18-46-36
%basic = '';
%intervention = '';

%analyzatorfunction = @matfileanalyzator_plots_compare;
analyzatorfunction = @matfileanalyzator_moviemaker_compare;

param.frames = 'all';
param.fps = 24;   % 24 in movies
param.reruns = 1;
param.individuals = 10;
param.conditions = 18;

%% Make just one comparison

if isempty(intervention) == 0
    
    matfile_basic = [folder, basic, '.mat'];
    matfile_int = [folder, intervention, '.mat'];
    opengl software 
    analyzatorfunction(matfile_basic, matfile_int, param);

end

%% Make comparisons from all files in the folder

if isempty(basic)
    filenames = dir([folder, '*.mat']);
    for i = 1:param.individuals
        matfile_basic = [folder, filenames(i).name];
        for j = 1: param.conditions
            matfile_int = [folder, filenames(param.individuals + (i-1)*18 + j).name];
            analyzatorfunction(matfile_basic, matfile_int, param);
        end
    end    
end
    
%% Make movies from one individual

% for i = 1:length(filenames)
%     if strcmp(filenames(i).name, matfile_basic(end-22:end))
%         TOL = i;
%     end
% end
% 
% for i = 1:2
%     i
%     moviemaker4_compare(matfile_basic, [folder, filenames(TOL+i).name], frames, fps, reruns);
% end

