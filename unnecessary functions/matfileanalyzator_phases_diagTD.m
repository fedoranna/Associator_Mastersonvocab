% Finds developmental phases and times for intervention
% when C=0.3 or H = 3 model learns right diagonal from corners

%%

function M = matfileanalyzator_phases_diagTD(matfile, param)

M = zeros(1, 13);
load(matfile, 'T', 'P', 'R', 'S')

% Intervention and phase transition times
for i = 1:length(T.scores)
    if T.scores(i+1) < T.scores(i)
        break
    end
end
p1_2 = i;

for i = p1_2:length(T.scores)
    if T.scores(i+1) > T.scores(i)
        break
    end
end
p1_2b = i;

for i = p1_2b:length(T.scores)
    if T.scores(i+1) < T.scores(i)
        break
    end
end
p2_3 = i;

for i = p2_3:length(T.scores)
    if S(i).activationmatrix2(1,1)<0.5
        break
    end
end
p3_4 = i;

for i = p3_4:length(T.scores)
    if S(i).activationmatrix2(end,1)>0.5
        break
    end
end
p4_5 = i;

for i = p4_5:length(T.scores)
    if sum(diag(flipit(S(i).activationmatrix2))>0.5) == nrows(S(i).activationmatrix2)
        break
    end
end
p5_6 = i;

% Collect data in M
M(5) = P.inputseed;
M(6) = P.trainingseed;
%M(7) = P.int_seed;
M(8) = P.weightseed;
M(9) = p1_2*P.test_performance;
M(10) = p2_3*P.test_performance;
M(11) = p3_4*P.test_performance;
M(12) = p4_5*P.test_performance;
M(13) = p5_6*P.test_performance;

% Round up intervention points to 10s
for i = numel(M)
    M(i) = round(M(i)/10)*10;
end

%% Plot
opengl software

% Performance
subplot(4,5,1:5)
hold all
s=plot(T.epoch, T.scores, 'blue');
set(s,'Color','blue','LineWidth',2)
e=plot(T.epoch, T.error, 'green');
set(e,'Color','red','LineWidth',2)
for i = 9:13
    plot(repmat(M(i), 1, R.sizeof_testset+3), -1:R.sizeof_testset+1,  'green', 'LineWidth',1);
end

plot([0, T.epoch], repmat(R.sizeof_testset, 1, length(T.epoch)+1),  '-k', 'LineWidth',1);
axis([0 T.epoch(end) 0 R.sizeof_testset+1])
hold off
xlabel('Epoch')
ylabel('Performance')
j=6;

% Activationpatterns

for i = 9:13
    subplot(4,5,j)
    plotmatrix(S(M(i)/P.test_performance).activationmatrix1, P.inputvalues, P.inputvalues);
    set(gca, 'CLim', [0, 1])
    title('Activation of Unit 1')
    xlabel('Input value 1')
    ylabel('Input value 2')
    j = j+1;
end

for i = 9:13
    subplot(4,5,j)
    plotmatrix(S(M(i)/P.test_performance).activationmatrix2, P.inputvalues, P.inputvalues);
    set(gca, 'CLim', [0, 1])
    title('Activation of Unit 1')
    xlabel('Input value 1')
    ylabel('Input value 2')
    j = j+1;
end

for i = 9:13
    subplot(4,5,j)
    plotmatrix(S(M(i)/P.test_performance).activationmatrix3, P.inputvalues, P.inputvalues);
    set(gca, 'CLim', [0, 1])
    title('Activation of Unit 1')
    xlabel('Input value 1')
    ylabel('Input value 2')
    j = j+1;
end

      
        
% Save
figurefile = [matfile(1:end-4), '_phases.png'];
print('-dpng', figurefile);
close

end

