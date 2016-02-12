%% PCA and visualize representations
% makes PCA plots of SH, separately for all semantic class
% Parameters should be fields of param:
% - weights: a number, the epoch when weights were saved and which should be used for the analysis; or [] - in this case the final weights will be used

function y = matfileanalyzator_PCA_semclasses(matfile, param)

%% Load

weights = param.weights;

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
else
    weights = 'end';
end

%% Collect data

layers(1).name = 'SHprod';
layers(2).name = 'ARprod';
layers(3).name = 'PHprod';
layers(4).name = 'SHcomp';
layers(5).name = 'ALcomp';
layers(6).name = 'PHcomp';
layers(7).name = 'SO';
layers(8).name = 'PO';

layers(1).act = NaN(P.vocabsize, L(2).size);
layers(2).act = NaN(P.vocabsize, L(7).size);
layers(3).act = NaN(P.vocabsize, L(5).size);
layers(4).act = NaN(P.vocabsize, L(2).size);
layers(5).act = NaN(P.vocabsize, L(8).size);
layers(6).act = NaN(P.vocabsize, L(5).size);
layers(7).act = NaN(P.vocabsize, L(3).size);
layers(8).act = NaN(P.vocabsize, L(6).size);

modes = {'S','P','R', 'L'};
for j = 1:numel(modes)
    
    mode = modes{j};
    
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
        
        if mode == 'R'
            layers(1).act(sweep,:) = L(2).state;
            layers(2).act(sweep,:) = L(7).state;
            layers(3).act(sweep,:) = L(5).state;
        end
        if mode == 'L'
            layers(4).act(sweep,:) = L(2).state;
            layers(5).act(sweep,:) = L(8).state;
            layers(6).act(sweep,:) = L(5).state;
        end
        if mode == 'S'
            layers(7).act(sweep,:) = L(3).state;
        end
        if mode == 'P'
            layers(8).act(sweep,:) = L(6).state;
        end
    end
end

for i = 1:numel(layers)
    layers(i).act = layers(i).act';
end

%% PCA 2D

colours = {'r', 'b', 'g', 'k', 'y', 'c', 'm', 'r', 'b', 'g', 'k', 'y', 'c', 'm', 'r', 'b', 'g', 'k', 'y', 'c', 'm', 'r', 'b', 'g', 'k', 'y', 'c', 'm'};

smaller = 0.9;
f=figure('OuterPosition',[1 1 1920*smaller 1200*smaller]);
        
for c = 1:numel(P.semclass)
    
    words = P.semclass{c};
    activations = layers(1).act(:,words);
    [scores, coeff, variances] = pca1(activations);
    
    
    %hist(layers(1).act)
    
    subplot(2,3,c)
    felirat = [];
    hold all
    for i = 1:numel(words)
        plot(scores(1, i),scores(2, i), ['.', colours{i}], 'MarkerSize', 15);
        felirat = [felirat; {num2str(i)}];
    end
    hold off
    %set(legend(felirat));
    grid on
    title(['Semantic class No', num2str(c)])
    xlabel('1st Principal Component')
    ylabel('2nd Principal Component')
    
end

set(gcf,'PaperPositionMode','auto')
figurefile =  [P.folder, P.ID, '_PCA_semclasses_', num2str(weights), '.png'];
print('-dpng', figurefile);
close

y = 1;
