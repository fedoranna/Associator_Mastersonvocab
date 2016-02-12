% Finds developmental phases and times for intervention
% when C=0.3 or H = 3 model learns right diagonal from corners

%%

function M = matfileanalyzator_phases_diagAT(matfile, param)

M = zeros(1, 10);
load(matfile, 'T', 'P', 'R', 'S')

% Intervention and phase transition times
for i = 1:length(T.scores)
    if T.scores(i) ~= T.scores(i+1)
        break
    end
end
p1_2 = T.epoch(i);
I1 = p1_2/2;

a = min(T.scores) + (max(T.scores)-min(T.scores))/2;
b = max(T.scores)*0.97;
for i = length(T.scores) :-1: 1
    if T.scores(i) > a
        I2 = T.epoch(i);
    end
    if T.scores(i) > b
        p2_3 = T.epoch(i);
        I3 = p2_3;
    end
end

I4 = I3*1.5;

% Collect data in M
M(1) = I1;
M(2) = I2;
M(3) = I3;
M(4) = I4;
M(5) = P.inputseed;
M(6) = P.trainingseed;
%M(7) = P.int_seed;
M(8) = P.weightseed;
M(9) = p1_2;
M(10) = p2_3;

% Round up intervention points to 10s
for i = numel(M)
    M(i) = round(M(i)/10)*10;
end

% Plot
opengl software

% Performance
subplot(4,2,1:2)
hold all
s=plot(T.epoch, T.scores, 'blue');
set(s,'Color','blue','LineWidth',2)
e=plot(T.epoch, T.error, 'green');
set(e,'Color','red','LineWidth',2)
plot(repmat(p1_2, 1, R.sizeof_testset+3), -1:R.sizeof_testset+1,  'green', 'LineWidth',1);
plot(repmat(p2_3, 1, R.sizeof_testset+3), -1:R.sizeof_testset+1,  'green', 'LineWidth',1);

plot([0, T.epoch], repmat(R.sizeof_testset, 1, length(T.epoch)+1),  '-k', 'LineWidth',1);
axis([0 T.epoch(end) 0 R.sizeof_testset+1])
hold off
xlabel('Epoch')
ylabel('Performance')

% Activationpatterns
subplot(4,2,3)
plotmatrix(S(p1_2/P.test_performance).activationmatrix1, P.inputvalues, P.inputvalues);
set(gca, 'CLim', [0, 1])
title('Activation of Unit 1')
xlabel('Input value 1')
ylabel('Input value 2')

subplot(4,2,4)
plotmatrix(S(p2_3/P.test_performance).activationmatrix1, P.inputvalues, P.inputvalues);
set(gca, 'CLim', [0, 1])
title('Activation of Unit 1')
xlabel('Input value 1')
ylabel('Input value 2')

subplot(4,2,5)
plotmatrix(S(p1_2/P.test_performance).activationmatrix2, P.inputvalues, P.inputvalues);
set(gca, 'CLim', [0, 1])
title('Activation of Unit 2')
xlabel('Input value 1')
ylabel('Input value 2')

subplot(4,2,6)
plotmatrix(S(p2_3/P.test_performance).activationmatrix2, P.inputvalues, P.inputvalues);
set(gca, 'CLim', [0, 1])
title('Activation of Unit 2')
xlabel('Input value 1')
ylabel('Input value 2')

subplot(4,2,7)
plotmatrix(S(p1_2/P.test_performance).activationmatrix3, P.inputvalues, P.inputvalues);
set(gca, 'CLim', [0, 1])
title('Activation of Unit 3')
xlabel('Input value 1')
ylabel('Input value 2')

subplot(4,2,8)
plotmatrix(S(p2_3/P.test_performance).activationmatrix3, P.inputvalues, P.inputvalues);
set(gca, 'CLim', [0, 1])
title('Activation of Unit 3')
xlabel('Input value 1')
ylabel('Input value 2')       
        
% Save
figurefile = [matfile(1:end-4), '_phases.png'];
print('-dpng', figurefile);
close

end

