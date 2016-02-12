% Finds developmental phases and times for intervention
% when model learns right diagonal from corners with bias and permutation
% can be used for TD and AT models with diag and TD models with islands

%%

function M = matfileanalyzator_phases_diag_TDAT(matfile, param)

M = zeros(1, 7);
load(matfile, 'T', 'P', 'R', 'S')

% Intervention and phase transition times

final = mean(T.scores((end-5):end));

for i = 1:length(T.scores)
    if T.scores(i) > max(T.scores(1:5))
        break
    end
end
p1_2 = i-1;

for i = p1_2:length(T.scores)
    if T.scores(i) > max(T.scores)*0.9
        break
    end
end
p2_3 = i-1;

for i = p2_3:length(T.scores)
    if T.scores(i) > final-final*0.01 && T.scores(i) < final+final*0.01
        break
    end
end
p3_4 = i-1;

int1 = round(p1_2/2);
int2 = p1_2 + round((p2_3-p1_2)/2);
int3 = p2_3 + round((p3_4-p2_3)/2);

% Collect data in M
M(1) = P.weightseed;
M(2) = p1_2*P.test_performance;
M(3) = p2_3*P.test_performance;
M(4) = p3_4*P.test_performance;
M(5) = int1*P.test_performance;
M(6) = int2*P.test_performance;
M(7) = int3*P.test_performance;

toplot = [2:4];
%% Plot

opengl software

% Performance
subplot(4,numel(toplot),1:numel(toplot))
hold all
s=plot(T.epoch, T.scores);
set(s,'Color','blue','LineWidth',2)
e=plot(T.epoch, T.error);
set(e,'Color','red','LineWidth',2)
for i = toplot
    plot(repmat(M(i), 1, R.sizeof_testset+3), -1:R.sizeof_testset+1,  'green', 'LineWidth',1);
end

plot([0, T.epoch], repmat(R.sizeof_testset, 1, length(T.epoch)+1),  '-k', 'LineWidth',1);
axis([0 T.epoch(end) 0 R.sizeof_testset+1])
hold off
xlabel('Epoch')
ylabel('Performance')
j=numel(toplot)+1;

% Activationpatterns

for i = toplot
    subplot(4,numel(toplot),j)
    plotmatrix(S(M(i)/P.test_performance).activationmatrix1, P.inputvalues, P.inputvalues);
    set(gca, 'CLim', [0, 1])
    title('Activation of Unit 1')
    %xlabel('Input value 1')
    %ylabel('Input value 2')
    j = j+1;
end

for i = toplot
    subplot(4,numel(toplot),j)
    plotmatrix(S(M(i)/P.test_performance).activationmatrix2, P.inputvalues, P.inputvalues);
    set(gca, 'CLim', [0, 1])
    title('Activation of Unit 2')
    %xlabel('Input value 1')
    %ylabel('Input value 2')
    j = j+1;
end

for i = toplot
    subplot(4,numel(toplot),j)
    plotmatrix(S(M(i)/P.test_performance).activationmatrix3, P.inputvalues, P.inputvalues);
    set(gca, 'CLim', [0, 1])
    title('Activation of Unit 3')
    %xlabel('Input value 1')
    %ylabel('Input value 2')
    j = j+1;
end      
        
% Save
figurefile = [matfile(1:end-4), '_phases.png'];
print('-dpng', figurefile);
%close
end


