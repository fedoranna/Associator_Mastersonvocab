% Makes 4 figures of one of the hidden layers, does not save them automatically
% - 2D PCA
% - 3D PCA
% - percent explained by components
% - hidden representations (activation temperature plot)
% Parameters should be fields of param:
% - weights: a number, the epoch when weights were saved and which should be used for the analysis; or '' - in this case the final weights will be used
% - mode: S, P, R or L
% - layer2plot: SH, PH, AR or AL
% - param.dim_2D: 0 or 1 (whether to make a 2D plot
% - param.dim_3D: 0 or 1
% - param.explained: 0 or 1
% - param.activations: 0 or 1

function y = matfileanalyzator_PCA_onehidden(matfile, param)

%% Load

weights = param.weights;
mode = param.mode;
layer2plot = param.layer2plot;

load(matfile, 'L', 'W', 'P', 'S', 'R', 'V', 'T', 'Q', 'D');

if isempty(param.weights) == 0
    W(1).state = Q(param.weights+1).SISH;
    W(2).state = Q(param.weights+1).SHSO;
    W(3).state = Q(param.weights+1).PIPH;
    W(4).state = Q(param.weights+1).PHPO;
    W(5).state = Q(param.weights+1).SHAR;
    W(6).state = Q(param.weights+1).ARPH;
    W(7).state = Q(param.weights+1).PHAL;
    W(8).state = Q(param.weights+1).ALSH;
end

%% Collect data

SH = NaN(P.vocabsize, L(2).size);
PH = NaN(P.vocabsize, L(5).size);
AR = NaN(P.vocabsize, L(7).size);
AL = NaN(P.vocabsize, L(8).size);
SO = NaN(P.vocabsize, L(3).size);

for sweep = 1: P.vocabsize
    
    for i = 1:8
        L(i).state = L(i).state*0;
    end
    
    input_sem = D.testingsems(sweep,:);
    input_phon = D.testingphons(sweep,:);
    if mode == 'S' || mode == 'R'
        input = input_sem;
    end
    if mode == 'P' || mode == 'L'
        input = input_phon;
    end
    
    L = ActivateAssociator22(L, W, P, mode, input);
    
    SH(sweep,:) = L(2).state;
    PH(sweep,:) = L(5).state;
    AR(sweep,:) = L(7).state;
    AL(sweep,:) = L(8).state;
    SO(sweep,:) = L(3).state;
    
end

SH = SH';
PH = PH';
AR = AR';
AL = AL';
SO = SO';

%% PCA 2D

if param.dim_2D
    
    if layer2plot == 'SH'
        act = SH;
    elseif layer2plot == 'PH'
        act = PH;
    elseif layer2plot == 'AR'
        act = AR;
    elseif layer2plot == 'SO'
        act = SO;
    end
    
    [scores, coeff, variances] = pca1(act);
    colours = {'r', 'b', 'g', 'k', 'y', 'c', 'r', 'b', 'g', 'k', 'y', 'c', 'r', 'b', 'g', 'k', 'y', 'c', 'r', 'b', 'g', 'k', 'y',};
    
    figure
    suptitle(['PCA on ', layer2plot])
    
    dimension = P.frequency;
    subplot(2,2,1)
    felirat = [];
    hold all
    for i = 1:nrows(dimension)
        if isempty(dimension{i})==0
            plot(scores(1, dimension{i}),scores(2, dimension{i}), ['.',colours{i}]);
            felirat = [felirat; {num2str(i)}];
        end
    end
    hold off
    set(legend(felirat));
    grid on
    title('Frequency')
    xlabel('1st Principal Component')
    ylabel('2nd Principal Component')
    
    dimension = P.denseness;
    subplot(2,2,2)
    felirat = [];
    hold all
    for i = 1:nrows(dimension)
        if isempty(dimension{i})==0
            plot(scores(1, dimension{i}),scores(2, dimension{i}), ['.',colours{i}]);
            felirat = [felirat; {num2str(i)}];
        end
    end
    hold off
    set(legend(felirat));
    grid on
    title('Denseness')
    xlabel('1st Principal Component')
    ylabel('2nd Principal Component')
    
    dimension = P.atypicality;
    subplot(2,2,3)
    felirat = [];
    hold all
    for i = 1:nrows(dimension)
        if isempty(dimension{i})==0
            plot(scores(1, dimension{i}),scores(2, dimension{i}), ['.',colours{i}]);
            felirat = [felirat; {num2str(i)}];
        end
    end
    hold off
    set(legend(felirat));
    grid on
    title('Atypicality')
    xlabel('1st Principal Component')
    ylabel('2nd Principal Component')
    
    dimension = P.imag;
    subplot(2,2,4)
    felirat = [];
    hold all
    for i = 1:nrows(dimension)
        if isempty(dimension{i})==0
            plot(scores(1, dimension{i}),scores(2, dimension{i}), ['.',colours{i}]);
            felirat = [felirat; {num2str(i)}];
        end
    end
    hold off
    set(legend(felirat));
    grid on
    title('Imageability')
    xlabel('1st Principal Component')
    ylabel('2nd Principal Component')
    
    % Semantic errors

    
end
%% PCA 3D

if param.dim_3D
    
    figure
    suptitle(['PCA on ', layer2plot])
    
    dimension = P.frequency;
    subplot(2,2,1)
    felirat = [];
    colorvector = NaN(1,P.vocabsize);
    for i = 1:nrows(dimension)
        if isempty(dimension{i})==0
            for j = 1:length(dimension{i})
                colorvector(dimension{i}(j)) = i;
            end
            felirat = [felirat; {num2str(i)}];
        end
    end
    scatter3(scores(1, :),scores(2, :), scores(3, :), 10, colorvector, 'filled');
    %set(legend(felirat));
    grid on
    title('Frequency')
    
    dimension = P.denseness;
    subplot(2,2,2)
    felirat = [];
    colorvector = NaN(1,P.vocabsize);
    for i = 1:nrows(dimension)
        if isempty(dimension{i})==0
            for j = 1:length(dimension{i})
                colorvector(dimension{i}(j)) = i;
            end
            felirat = [felirat; {num2str(i)}];
        end
    end
    scatter3(scores(1, :),scores(2, :), scores(3, :), 10, colorvector, 'filled');
    %set(legend(felirat));
    grid on
    title('Denseness')
    
    dimension = P.atypicality;
    subplot(2,2,3)
    felirat = [];
    colorvector = NaN(1,P.vocabsize);
    for i = 1:nrows(dimension)
        if isempty(dimension{i})==0
            for j = 1:length(dimension{i})
                colorvector(dimension{i}(j)) = i;
            end
            felirat = [felirat; {num2str(i)}];
        end
    end
    scatter3(scores(1, :),scores(2, :), scores(3, :), 10, colorvector, 'filled');
    %set(legend(felirat));
    grid on
    title('Atypicality')
    
    dimension = P.imag;
    subplot(2,2,4)
    felirat = [];
    colorvector = NaN(1,P.vocabsize);
    for i = 1:nrows(dimension)
        if isempty(dimension{i})==0
            for j = 1:length(dimension{i})
                colorvector(dimension{i}(j)) = i;
            end
            felirat = [felirat; {num2str(i)}];
        end
    end
    scatter3(scores(1, :),scores(2, :), scores(3, :), 10, colorvector, 'filled');
    %set(legend(felirat));
    grid on
    title('Imageability')
    
end

%% Percent exlpained

if param.explained
    figure
    percent_explained = 100*variances/sum(variances);
    pareto(percent_explained)
    xlabel('Principal Component')
    ylabel('Variance Explained (%)')
end

%% Activations

if param.activations
    figure
    colormap(Jet)
    suptitle('Activations')
    subplot(2, 2, 1), imagesc(SH)
    title('SH')
    subplot(2, 2, 2), imagesc(PH)
    title('PH')
    subplot(2, 2, 3), imagesc(AR)
    title('AR')
    subplot(2, 2, 4), imagesc(AL)
    title('AL')
    %colorbar('peer',gca,[0.925 0.2143 0.025 0.5381],'YTick', 0.5, 'YTickLabel','0.0','LineWidth',1);
end
%% Close
if 1==0
    close
    close
    close
end
y=1;
%% Notes
% suptitle(['Word: ', char(word)]); % suptitle
%
% subplot(2,1,1), imagesc([SH_sep; SH_ass]);
% title('Semantic representation');
% set(gca, 'YTick', [1, 2], 'YTickLabel', {'Sees', 'Listens'}, 'YGrid', 'off', 'DataAspectRatio', [1,1,1]);
% line([-1, 21], [1.5, 1.5], 'LineWidth',4,'Color',[.8 .8 .8]);
%
% subplot(2,1,2), imagesc([PH_sep; PH_ass]);
% title('Phonetic representation');
% set(gca, 'YTick', [1, 2], 'YTickLabel', {'Listens', 'Sees'}, 'YGrid', 'off', 'DataAspectRatio', [1,1,1]);
% line([-1, 21], [1.5, 1.5], 'LineWidth',4,'Color',[.8 .8 .8]);
%
% a=annotation('textbox', 'Position',[0.06171 0.4 0.2722 0.1881], 'FitBoxToText','on','VerticalAlignment', 'top','String', results);
% colorbar('peer',gca,[0.925 0.2143 0.025 0.5381],'LineWidth',1);
