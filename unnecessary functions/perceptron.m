%% 2-layer perceptron
% simple network of 1 input and 1 output;
% works with threshold or logsig transfer function
% input values are discreet values
% target values are binary (0/1 or -1/1)

%% Parameters

%clear
addpath(genpath('C:\Matlab_functions'));

folder = 'C:\Users\afedor\Desktop\figs\';
timeout = 10000;
LR = 0.1;
bin = 0.2;
type = 'logsig'; % logsig or threshold
patternNo = 1;

batchlearning = 1;
permute = 0;

%% Start 4 simulations

sc = get(0, 'ScreenSize');
figure %('Position', [1 1 sc(3) sc(4)])
st = {[type, '; LR = ', num2str(LR)]; ['permute = ', num2str(permute)]; ['batch = ', num2str(batchlearning)]};
suptitle_withparams(st, 8)

epochs = zeros(1,4);
for pattern = patternNo
    
    %% Initialize
    
    W = 0; % initial weight
    B = 0; % initial bias for logsig and initial threshold for threshold
    temp = 1; % temperature
    offset = 0; % offset
    upperTH = 0.6;
    lowerTH = 0.4;
    
    inputs = bin : bin : 1;
    %inputs = [-0.4, -0.2, 0, 0.2, 0.4];
    
    if pattern == 1
        activeones = 2:length(inputs);
        %plottitle = 'All +, but left one';
    end
    if pattern == 2
        activeones = 1:length(inputs)-1;
        %plottitle = 'All +, but right one';
    end
    if pattern == 3
        activeones = 1;
        %plottitle = 'All -, but left one';
    end
    if pattern == 4
        activeones = length(inputs);
        %plottitle = 'All -, but right one';
    end
    
    if strcmp(type, 'logsig')
        targets = zeros(1,length(inputs));
        plotlegend = {'Scores', 'Weight', 'Bias'};
    end
    if strcmp(type, 'threshold')
        targets = zeros(1,length(inputs))-1;
        plotlegend = {'Scores', 'Weight', 'Bias'};
    end
    targets(activeones) = 1;
    plottitle = num2str(targets);
    
    'Initialization done';
    
    %% Train
    
    storage = zeros(12, timeout);
    for epoch = 1 : timeout
        
        if permute == 1
            neworder = randperm(length(targets));
            targets = targets(neworder);
            inputs = inputs(neworder);
        end
        
        for sweep = 1 : length(inputs)
            
            I = inputs(sweep);
            target = targets(sweep);
            
            if strcmp(type, 'logsig')
                
                O = transferfn_logsig(I*W + B, temp, offset);
                error = target-O;
                delta = O * (1-O) * error;
                %delta = delta_logsig_withT(O, target, 'output', temp, offset);
                incrW = LR * I * delta;
                incrB = LR * 1 * delta;
                
                storage(1,epoch) = storage(1,epoch) + error*error;
                storage(2,epoch) = storage(2,epoch) + delta;
                storage(3,epoch) = storage(3,epoch) + incrW;
                storage(4,epoch) = storage(4,epoch) + incrB;
                storage(5,epoch) = storage(5,epoch) + is_correct(target, O, upperTH, lowerTH);
                storage(7+sweep,epoch) = incrW;

            end
            
            [sweep, error, delta, incrW];
            
            if strcmp(type, 'threshold')
                
                O = transferfn_threshold(I*W, B);
                error = target-O;
                incrW = LR * I * error;
                incrB = -LR * error;
                
                storage(1,epoch) = storage(1,epoch) + error;
                storage(3,epoch) = storage(3,epoch) + incrW;
                storage(4,epoch) = storage(4,epoch) + incrB;
                storage(5,epoch) = storage(5,epoch) + (O==target); % score
                
            end
            
            if batchlearning == 0
                W = W + incrW;
                B = B + incrB;
            end
            
        end
        
        if batchlearning == 1
            W = W + storage(3, epoch);
            B = B + storage(4, epoch);
        end
        
        storage(6,epoch) = W;
        storage(7,epoch) = B;
        
        ['Epoch: ', num2str(epoch), '; Score: ', num2str(storage(5,epoch))];
        
        if storage(5, epoch) == length(inputs)
            storage(:, (epoch+1):end) = [];
            break
        end
        
    end
    'Training finished';
    
    epochs(pattern) = epoch;
    
    %% Plot
    
    %     storage rows:
    %     1. abs(error)
    %     2. abs(delta)
    %     3. incrW
    %     4. incrB
    %     5. scores (1:5: summed for the epoch)
    %     6. W after learning the epoch
    %     7. B or T after learning the epoch
    
    if 1==2
        subplot(2,2,pattern)
        hold all
        plot(storage(5,:), 'g-')
        plot(storage(6,:), 'r-')
        plot(storage(7,:), 'b-')
        legend(plotlegend, 'Location', 'East')
        xlabel('Epochs')
        %axis([0 1400 -6 6])
        %axis([0 2000 -6 6])
        title(plottitle)
        hold off
    end
    if 1==1
        hold all
        plot(storage(1,:))
        %plot(storage(2,:)./storage(1,:))
        xlabel('Epochs')
        ylabel('Error')
        %title(st)
        legend({'Scenario 1', 'Scenario 2'})
    end
    %storage(5,1:15)
    %storage(2,1:10)
    %storage(2,1:10)./storage(1,1:10)
    
    if pattern == 1
        sc1 = storage;
    end
    if pattern == 2
        sc2 = storage;
    end
    
end

filename = [type, '_batch', num2str(batchlearning), '_perm', num2str(permute)];
%print('-dpng', [folder, filename, '.png'])
close

epochs;
storage1=storage;
sum(storage(2,:));
%[storage(6, 1500), storage(7, 1500)]

%% More plotting

sc1_minority = sc1(7+1,:);
sc1_majority = sum(sc1((7+2):(7+5),:));

sc2_minority = sc2(7+5,:);
sc2_majority = sum(sc2((7+1):(7+4),:));

%%
hold all
plot(sc1_minority)
plot(abs(sc1_minority))
plot(sc1_majority)

plot(sc2_minority)
plot(abs(sc2_minority))
plot(sc2_majority)

plot(sc1_majority-sc1_minority)
plot(sc2_majority-sc2_minority)
legend('sc1', 'sc2')

hold all
 plot(sc1(3,:))
 plot(sc2(3,:))
 plot(sc1(4,:))
 plot(sc2(4,:))
 legend('Scenario 1, incr W', 'Scenario 2, incr W', 'Scenario 1, incr B', 'Scenario 2, incr B')
 filename = 'increments';
 print('-dpng', [folder, filename, '.png'])
 
 hold all
 plot(sc1(3,1:200))
 plot(sc2(3,1:200))
 plot(sc1(4,1:200))
 plot(sc2(4,1:200))
 legend('Scenario 1, incr W', 'Scenario 2, incr W', 'Scenario 1, incr B', 'Scenario 2, incr B')
 filename = 'increments at beginning';
 print('-dpng', [folder, filename, '.png'])
 plot(1:200, zeros(1,200), '-k')
 
hold all
 plot(abs(sc1(3,:)))
 plot(abs(sc2(3,:)))
 plot(abs(sc1(4,:)))
 plot(abs(sc2(4,:)))
 legend('Scenario 1, incr W', 'Scenario 2, incr W', 'Scenario 1, incr B', 'Scenario 2, incr B')
 filename = 'increments abs';
 print('-dpng', [folder, filename, '.png'])

 
 %% Test only
 
W =1;
B = -0.9*W; % B = -0.3*W for left pattern, B = -0.9*W for right pattern

I = 0.2 : 0.2 : 1;
b = [0 1 1 1 1];
j = [1 1 1 1 0];

N = I * W + 1 * B;
O = transferfn_logsig(N, 1, 0);

T = b;
act2bin(O, 0.5, 0.5)
T == act2bin(O, 0.5, 0.5);

%% More plotting

O = 0 : 0.01 : 1;
inputs = 0.2 : 0.2 : 1;
%inputs = -0.4 : 0.2 : 0.4;

hold all

felirat = [];
szumma = 0;

T = 1;
for i = 1:4
    I = inputs(i);
    delta = O .* (1-O) .* (T-O);
    incrW = 0.1 * I * delta;
    szumma = szumma + incrW;
    %plot(O, incrW, '-')
    felirat = [felirat, {['T=1, I=', num2str(I)]}];
end
T = 0;
i=5;
for i = 1:length(inputs)
    I = inputs(i);
    delta = O .* (1-O) .* (T-O);
    incrW = 0.1 * I * delta;
    szumma = szumma + incrW;
    
    plot(O, incrW, '-')
    felirat = [felirat, {['T=0, I=', num2str(I)]}];
end
legend(felirat)

ylabel('Increment of W')
title('Scenario 2')

plot(O, szumma)
legend('Scenario 1', 'Scenario 2')
ylabel('Sum of increments')
xlabel('Output')

% I = 1;
% delta = O .* (1-O) .* (T-O);
% incrW = 0.1 * I * delta;
% plot(O, abs(incrW))
% 
% I = -0.4;
% delta = O .* (1-O) .* (T-O);
% incrW = 0.1 * I * delta;
% plot(O, abs(incrW))
% 
% I = 0.4;
% delta = O .* (1-O) .* (T-O);
% incrW = 0.1 * I * delta;
% plot(O, abs(incrW))
% 
% legend('input = +0.2', 'input = +1.0', 'input = -0.4', 'input = +0.4')
% xlabel('Output')
% ylabel('Abs increment of W')
% title('target = 1')

% T = 1;
% delta = O .* (1-O) .* (T-O);
% incrW = 0.1 * I * delta;
% plot(O, abs(delta))

% legend('target = 0', 'target = 1')
% xlabel('Output')
% ylabel('Delta')
 

