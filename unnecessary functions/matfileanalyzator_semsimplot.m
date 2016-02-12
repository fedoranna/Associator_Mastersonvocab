% Creates plots to look at the semantic space - semantic similarity

function y = matfileanalyzator_semsimplot(matfile, param)

load(matfile, 'D', 'P')

%% Temperature plots to compare prototypes and meanings

% % Order prototypes and meanings
[cats, order] = sort(P.protcats);
sems = NaN(size(D.testingsems));
for i = 1:nrows(D.testingsems)
    sems(i,:) = D.testingsems(order(i),:);
end

% % Make averages from meanings
% ossz = zeros(size(P.prototypes));
% counts = zeros(P.nbof_prototypes,1);
% next = 1;
% count = 0;
% for i = 1:nrows(D.testingsems)
%     if i>1 && cats(i)>cats(i-1)
%         counts(next) = count;
%         count = 0;
%         next = next+1;        
%     end
%     ossz(next,:) = ossz(next,:) + sems(i,:);
%     count = count + 1;
% end
% counts(next) = count;
% 
% avg = ossz;
% for i = 1:nrows(ossz)
%     avg(i,:) = avg(i,:)/counts(i);
% end
% 
% % Average distance of avgerages and prototypes
% dist = NaN(1,P.nbof_prototypes);
% for i = 1:nrows(avg)
%     dist(i) = Eucledian_distance_normalized(avg(i,:), P.prototypes(i,:));
% end
% y=mean(dist);
% 
% subplot(2,1,1)
% imagesc(avg, [0,1])
% subplot(2,1,2)
% imagesc(P.prototypes, [0,1])
% %print('-dpng', [P.folder, P.ID, 'semanticspace.jpg']);
% close

%% PCA on meanings

collect = cell(numel(P.protcats));
for i = 1:numel(cats)
    collect{cats(i)} = [collect{cats(i),:}, i];
end
dimension = collect;
    
[scores, coeff, variances] = pca1(sems');
colours = {'r', 'b', 'g', 'k', 'y', 'c', 'm', 'r', 'b', 'g', 'k', 'y', 'c', 'm', 'r', 'b', 'g', 'k', 'y', 'c', 'm', 'r', 'b', 'g', 'k', 'y', 'c', 'm'};
felirat = [];
hold all
for i = 1:nrows(dimension)
    if length(dimension{i})>0
        plot(scores(1, dimension{i}),scores(2, dimension{i}), ['.',colours{i}]);
        felirat = [felirat; {num2str(i)}]; 
    end
end
hold off
set(legend(felirat), 'Location', 'EastOutside');
grid on
title('Semantic meanings PCA')
%title({'Semantic meaning representations'; ['nb=', num2str(numel(P.protcats)), ', mindist=', num2str(P.mindistance), ', looseness=', num2str(P.looseness)]})
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
print('-dpng', [P.folder, P.ID, '_semanticspacePCA.jpg']);
close

y=1;

