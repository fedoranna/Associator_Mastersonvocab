%% PCA and visualize representations
% makes PCA plots of all hidden layer activations during both production and comprehension on one plot
% colours the words according to different dimension (a separate figure each):
%   'frequency', 'denseness', 'atypicality', 'imag', 'semclass'
% Parameters should be fields of param:
% - weights: a number, the epoch when weights were saved and which should be used for the analysis; or [] - in this case the final weights will be used
% - param.dim_2D: 0 or 1 (whether to make a 2D plot
% - param.dim_3D: 0 or 1
% - param.explained: 0 or 1

function y = matfileanalyzator_PCA_allhiddens(matfile, param)

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

if param.dim_2D
    colours = {'r', 'b', 'g', 'k', 'y', 'c', 'm', 'r', 'b', 'g', 'k', 'y', 'c', 'm', 'r', 'b', 'g', 'k', 'y', 'c', 'm', 'r', 'b', 'g', 'k', 'y', 'c', 'm'};
    dimensions = param.dimensions; % {'frequency', 'denseness', 'atypicality', 'imag', 'semclass', 'semanticerrors'};
    
    for d = 1: length(dimensions)
        
        smaller = 0.9;
        f=figure('OuterPosition',[1 1 1920*smaller 1200*smaller]);
        
        if isfield(P, dimensions{d})
            dimension = getfield(P, dimensions{d});
        end
        if strcmp(dimensions{d}, 'semanticerrors')
            dimension = cell(2,1);
            all = 1:P.vocabsize;
            where = which_element(param.weights, P.test_errors_atepoch);
            dimension{1} = T.semanticerrors(where).targetword;          
            all(sort(dimension{1}, 'descend')) = [];
            dimension{2} = all;
        end
        
        for l = 1:6
            
            [scores, coeff, variances] = pca1(layers(l).act);
            
            subplot(2,3,l)
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
            title(layers(l).name)
            xlabel('1st Principal Component')
            ylabel('2nd Principal Component')
            
        end
        
        annotation('textarrow',[0.119176598049837 0.916576381365114],[0.52746975088968 0.526690391459075],'TextEdgeColor','none','String',{'production'});
        annotation('textarrow',[0.913326110509209 0.115384615384615],[0.501779359430605 0.500889679715303],'TextEdgeColor','none','String',{'comprehension'});
        annotation('textbox',[0.392115926327192 0.94661921708185 0.249812567713976 0.0444839857651243],'String',{['PCA with ', dimensions{d}]},'HorizontalAlignment','center','FontWeight','demi','FontSize',14,'LineStyle','none');
        
        set(gcf,'PaperPositionMode','auto')
        figurefile =  [P.folder, P.ID, '_PCA_hiddens_', dimensions{d}, num2str(weights), '.png'];
        print('-dpng', figurefile);
        close
    end
end

%% Percent explained
% dimension is irrelevant

if param.explained
    figure
    for l = 1:length(layers)
        
        [scores, coeff, variances] = pca1(layers(l).act);
        percent_explained = 100*variances/sum(variances);
        
        subplot(2,3,l)
        pareto(percent_explained)
        xlabel('Principal Component')
        ylabel('Variance Explained (%)')
        title(layers(l).name)
        
    end
end

%% PCA 3D

if param.dim_3D
    
    for d = 1: length(dimensions)
        
        %f=figure('OuterPosition',[1 1 1920*smaller 1200*smaller]);
        dimension = getfield(P, dimensions{d});
        
        for l = 1:length(layers)
            
            [scores, coeff, variances] = pca1(layers(l).act);
            
            subplot(2,3,l)
            felirat = [];
            
            colorvector = NaN(1, P.vocabsize);
            for i = 1:nrows(dimension)
                if length(dimension{i})>0
                    for j = 1:length(dimension{i})
                        colorvector(dimension{i}(j)) = i;
                    end
                    felirat = [felirat; {num2str(i)}];
                end
            end
            scatter3(scores(1, :),scores(2, :), scores(3, :), 10, colorvector, 'filled');
            
            grid on
            title(layers(l).name)
            xlabel('1st Principal Component')
            ylabel('2nd Principal Component')
            zlabel('3rd Principal Component')
            
        end
        
        annotation('textarrow',[0.119176598049837 0.916576381365114],[0.52746975088968 0.526690391459075],'TextEdgeColor','none','String',{'production'});
        annotation('textarrow',[0.913326110509209 0.115384615384615],[0.501779359430605 0.500889679715303],'TextEdgeColor','none','String',{'comprehension'});
        annotation('textbox',[0.392115926327192 0.94661921708185 0.249812567713976 0.0444839857651243],'String',{['PCA with ', dimensions{d}]},'HorizontalAlignment','center','FontWeight','demi','FontSize',14,'LineStyle','none');
        
    end
end

y = 1;
