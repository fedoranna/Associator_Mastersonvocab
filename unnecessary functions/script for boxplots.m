clear
addpath(genpath('C:\Matlab_functions'));
folder = 'C:\Matlab_functions\RESULTS\Categorizator model_7\4_intervention\'; % folder to save results
file = 'intervention results_at timeout and 2000';
filename = [folder, file, '.xlsx'];

%%
[num, text, raw] = xlsread(filename, 'diffs no headers');

sc1_TO = num(1:10,:);
sc2_TO = num(11:20,:);

sc = sc1_TO;
y = mean(sc,1);
e = std(sc,1);
figure

errorbar(y,e,'xr')



%% Transform data for SPSS box plots
subjects = [1673	6034	3933	7267	5692	978	2271	6882	9863	6525	3538	7690	8866	7100	6647	4117	8890	408	1133	1247	7830	3528	8675	2689	8994	2638	2485	156	3878	2441	197	443	8731	7143	887	6855	7257	6489	6034	8564	1673	6034	3933	7267	5692	978	2271	6882	9863	6525	3538	7690	8866	7100	6647	4117	8890	408	1133	1247	7830	3528	8675	2689	8994	2638	2485	156	3878	2441	197	443	8731	7143	887	6855	7257	6489	6034	8564];
scens = {'sc1_TO', 'sc2_TO', 'sc3_TO', 'sc4_TO', 'sc1_end', 'sc2_end', 'sc3_end', 'sc4_end'};

SU = NaN(1440, 1);
for i = 1: 1440
    which = ceil(i/18);
    SU(i) = subjects(which);
end

SC = cell(1440, 1);
for i = 1: 1440
    which = ceil(i/180);
    SC{i} = scens(which);
end

SC = [];
for i = 1: 1440
    which = ceil(i/180);
    SC = [SC,scens(which)];
end