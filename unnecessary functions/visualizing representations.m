%% Check representations one-by-one

%load 'F:\Matlab_functions\RESULTS\Associator model_2\17-Jun-2011-15-34-48.mat' %
sweep = 17;

words = {'bad', 'ber', 'bir', 'bor', 'gar', 'gin', 'god', 'gun', 'ped', 'piw', 'pow', 'pur', 'sad', 'sew', 'sod', 'sun', 'tan', 'tar', 'tid', 'ton'};
word = words(sweep);

SI_sep = repr1(sweep).sep{3,1}{1};
SH_sep = repr1(sweep).sep{2,1}{1};
SO_sep = repr1(sweep).sep{1,1}{1};
PI_sep = repr1(sweep).sep{3,2}{1};
PH_sep = repr1(sweep).sep{2,2}{1};
PO_sep = repr1(sweep).sep{1,2}{1};

SI_ass = repr2(sweep).ass{3,1}{1};
SH_ass = repr2(sweep).ass{2,1}{1};
SO_ass = repr2(sweep).ass{1,1}{1};
PI_ass = repr2(sweep).ass{3,2}{1};
PH_ass = repr2(sweep).ass{2,2}{1};
PO_ass = repr2(sweep).ass{1,2}{1};

SS = isequal(SI_sep, act2bin(SO_sep, P.sep_upper_TH, P.sep_lower_TH));
PP = isequal(PI_sep, act2bin(PO_sep, P.sep_upper_TH, P.sep_lower_TH));
PS = isequal(SI_ass, act2bin(SO_ass, P.ass_upper_TH, P.ass_lower_TH));
SP = isequal(PI_ass, act2bin(PO_ass, P.ass_upper_TH, P.ass_lower_TH));

results = {
    ['PJ test (SS): ', num2str(SS)]
    ['BPVS (PS): ', num2str(PS)]
    ['CNRep (PP): ', num2str(PP)]
    ['Picture Naming (SP): ', num2str(SP)]};

% Plot

%colormap(hot);
clf

%suptitle(['Word: ', char(word)]); % suptitle does not work in new MatLab

subplot(2,1,1), imagesc([SH_sep; SH_ass]);
title('Semantic representation');
set(gca, 'YTick', [1, 2], 'YTickLabel', {'Sees', 'Listens'}, 'YGrid', 'off', 'DataAspectRatio', [1,1,1]);
line([-1, 21], [1.5, 1.5], 'LineWidth',4,'Color',[.8 .8 .8]);

subplot(2,1,2), imagesc([PH_sep; PH_ass]);
title('Phonetic representation');
set(gca, 'YTick', [1, 2], 'YTickLabel', {'Listens', 'Sees'}, 'YGrid', 'off', 'DataAspectRatio', [1,1,1]);
line([-1, 21], [1.5, 1.5], 'LineWidth',4,'Color',[.8 .8 .8]);

a=annotation('textbox', 'Position',[0.06171 0.4 0.2722 0.1881], 'FitBoxToText','on','VerticalAlignment', 'top','String', results);
colorbar('peer',gca,[0.925 0.2143 0.025 0.5381],'LineWidth',1);

