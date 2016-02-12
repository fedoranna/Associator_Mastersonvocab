% Finds developmental phases and times for intervention
% when C=0.3 or H = 3 model learns right diagonal from corners

%%

function M = matfileanalyzator_phases_islandsAT(matfile, param)

%%
M = zeros(1, 13);
'Loading...'
load(matfile, 'T', 'P', 'R', 'S')

'Calculating...'
T.bluescores = zeros(1,length(T.scores));
T.redscores = zeros(1,length(T.scores));
T.greenscores = zeros(1,length(T.scores));

% Intervention and phase transition times
for i = 1:length(T.scores)
    
    bluescores = 0;
    redscores = 0;
    greenscores = 0;
        
    for j = 1:numel(P.testingmatrix)
        
%         if P.testingmatrix(j)==0 && S(i).scorematrix(j)==1
%             bluescores = bluescores + 1;
%         end
%         if P.testingmatrix(j)==2 && S(i).scorematrix(j)==1
%             redscores = redscores + 1;
%         end
%         if P.testingmatrix(j)==1 && S(i).scorematrix(j)==1
%             greenscores = greenscores + 1;
%         end
        
        if P.testingmatrix(j)==0 && S(i).activationmatrix1(j)>0.51
            bluescores = bluescores + 1;
        end
        if P.testingmatrix(j)==2 && S(i).activationmatrix3(j)>0.51
            redscores = redscores + 1;
        end
        
    end
    
    T.bluescores(i) = bluescores;
    T.redscores(i) = redscores;
    %T.greenscores(i) = greenscores;
end

x=0.1;
for i = length(T.scores) : -1 : 1
    if T.bluescores(i) > 1359*x &&  T.redscores(i) > 921*x
        M(1) = i;
    end
end
% Performance||
%subplot(4,2,1:2)
hold all
s=plot(T.epoch, T.scores/100);
set(s,'Color','black','LineWidth',2)
b=plot(T.epoch, T.bluescores/100);
set(b,'Color','blue','LineWidth',2)
r=plot(T.epoch, T.redscores/100);
set(r,'Color','red','LineWidth',2)
% g=plot(T.epoch, T.greenscores/100);
% set(g,'Color','green','LineWidth',2)

%plot(repmat(p1_2, 1, R.sizeof_testset+3), -1:R.sizeof_testset+1,  'green', 'LineWidth',1);
%plot(repmat(p2_3, 1, R.sizeof_testset+3), -1:R.sizeof_testset+1,  'green', 'LineWidth',1);

%plot([0, T.epoch], repmat(R.sizeof_testset/100, 1, length(T.epoch)+1),  '-k', 'LineWidth',1);
axis([0 T.epoch(end) 0 R.sizeof_testset/100+1])
hold off
xlabel('Epoch')
ylabel('Performance')

% % Activationpatterns
% subplot(4,2,3)
% plotmatrix(S(p1_2/P.test_performance).activationmatrix1, P.inputvalues, P.inputvalues);
% set(gca, 'CLim', [0, 1])
% title('Activation of Unit 1')
% xlabel('Input value 1')
% ylabel('Input value 2')
% 
% subplot(4,2,4)
% plotmatrix(S(p2_3/P.test_performance).activationmatrix1, P.inputvalues, P.inputvalues);
% set(gca, 'CLim', [0, 1])
% title('Activation of Unit 1')
% xlabel('Input value 1')
% ylabel('Input value 2')
% 
% subplot(4,2,5)
% plotmatrix(S(p1_2/P.test_performance).activationmatrix2, P.inputvalues, P.inputvalues);
% set(gca, 'CLim', [0, 1])
% title('Activation of Unit 2')
% xlabel('Input value 1')
% ylabel('Input value 2')
% 
% subplot(4,2,6)
% plotmatrix(S(p2_3/P.test_performance).activationmatrix2, P.inputvalues, P.inputvalues);
% set(gca, 'CLim', [0, 1])
% title('Activation of Unit 2')
% xlabel('Input value 1')
% ylabel('Input value 2')
% 
% subplot(4,2,7)
% plotmatrix(S(p1_2/P.test_performance).activationmatrix3, P.inputvalues, P.inputvalues);
% set(gca, 'CLim', [0, 1])
% title('Activation of Unit 3')
% xlabel('Input value 1')
% ylabel('Input value 2')
% 
% subplot(4,2,8)
% plotmatrix(S(p2_3/P.test_performance).activationmatrix3, P.inputvalues, P.inputvalues);
% set(gca, 'CLim', [0, 1])
% title('Activation of Unit 3')
% xlabel('Input value 1')
% ylabel('Input value 2')       
%         
% Save
'Saving...'
figurefile = [matfile(1:end-4), '_phases.png'];
print('-dpng', figurefile);
close

end

