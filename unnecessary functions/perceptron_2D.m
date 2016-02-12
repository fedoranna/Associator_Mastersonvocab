%% 2-layer perceptron
% simple network of 1 input and 1 output;
% works with threshold or logsig transfer function
% input values are discreet values
% target values are binary (0/1 or -1/1)

%% Parameters

clear
addpath(genpath('C:\Matlab_functions'));

folder = 'C:\Matlab_functions\RESULTS\Categorizator model_7\_symm\diag, perceptron\';
timeout = 10000;
LR = 0.1;
bin = 0.2;
patternNo = 1:4;

batchlearning = 1;
permute = 0;

%% Start 4 simulations

sc = get(0, 'ScreenSize');
figure %('Position', [1 1 sc(3) sc(4)])
st = {['LR = ', num2str(LR)]; ['permute = ', num2str(permute)]; ['batch = ', num2str(batchlearning)]};
suptitle_withparams(st, 8)

epochs = zeros(1,4);
for pattern = patternNo
    
    %% Initialize
    
    W1 = 0; % initial weight
    W2 = 0; % initial bias for logsig and initial threshold for threshold
    B = 0;
    temp = 1; % temperature
    offset = 0; % offset
    upperTH = 0.51;
    lowerTH = 0.49;
    goal = 25;
    
    inputvalues = bin : bin : 1;
    %inputvalues = [-0.5+bin/2 : bin : 0.5-bin/2];
    
    inputs = zeros(length(inputvalues)*length(inputvalues),2);
    k = 0;
    for j = 1:length(inputvalues)
        for i = 1:length(inputvalues)
            k = k+1;
            inputs(k, 1) = inputvalues(end-i+1); % y value
            inputs(k, 2) = inputvalues(j); % x value
        end
    end
    
    targets = zeros(length(inputvalues),length(inputvalues));
    
    diag_left = [1,7,13,19,25];
    lower_left = [2:5, 8:10, 14:15, 20];
    upper_right = [6,11:12,16:18,21:24];
    
    diag_right = [5,9,13,17,21];
    lower_right = [10, 14:15, 18:20, 22:25];
    upper_left = [1:4,6:8,11:12,16];
    
    if pattern == 3
        activeones = lower_left;
        patternname = 'bottom left triangle';
    end
    if pattern == 1
        activeones = upper_right;
        patternname = 'top right triangle';
    end
    if pattern == 4
        activeones = lower_right;
        patternname = 'bottom right triangle';
    end
    if pattern == 2
        activeones = upper_left;
        patternname = 'top left triangle';
    end
    if pattern == 5
        activeones = [lower_left, upper_right];
        patternname = 'left diagonal';
        end
    if pattern == 6
        activeones = [lower_right, upper_left];
        patternname = 'right diagonal';
    end
    
    targets(activeones) = 1;
    
    'Initialization done';
    
    %% Train
    
    storage = zeros(12, timeout);
    for epoch = 1 : timeout
        
        if permute == 1
            neworder = randperm(length(targets));
            targets = targets(neworder);
            inputs = inputs(neworder);
        end
        
        scores = NaN(numel(inputvalues), numel(inputvalues));
        for sweep = 1 : length(inputs)
            
            I = inputs(sweep, :);
            target = targets(sweep);
            
            O = transferfn_logsig(I(1)*W1 + I(2)*W2 + B, temp, offset); % with bias
            %O = transferfn_logsig(I(1)*W1 + I(2)*W2, temp, offset); % no bias
            
            error = target-O;
            delta = O * (1-O) * error;
            %delta = delta_logsig_withT(O, target, 'output', temp, offset);
            incrW1 = LR * I(1) * delta;
            incrW2 = LR * I(2) * delta;
            incrB = LR * 1 * delta;
            
            storage(1,epoch) = storage(1,epoch) + error*error;
            storage(2,epoch) = storage(2,epoch) + delta;
            storage(3,epoch) = storage(3,epoch) + incrW1;
            storage(4,epoch) = storage(4,epoch) + incrW2;
            storage(5,epoch) = storage(5,epoch) + incrB;
            storage(6,epoch) = storage(6,epoch) + is_correct(target, O, upperTH, lowerTH);
            scores(sweep) = O;
            
            if batchlearning == 0
                W1 = W1 + incrW1;
                W2 = W2 + incrW2;
                B = B + incrB;
            end
            
        end
        
        if batchlearning == 1
            W1 = W1 + storage(3, epoch);
            W2 = W2 + storage(4, epoch);
            B = B + storage(5, epoch);
        end
        
        storage(7,epoch) = W1;
        storage(8,epoch) = W2;
        storage(9,epoch) = B;
        
        ['Epoch: ', num2str(epoch), '; Score: ', num2str(storage(6,epoch))];
        
        if storage(6, epoch) >= goal
            storage(:, (epoch+1):end) = [];
            break
        end
        
    end
    'Training finished';
    
    ['Epoch: ', num2str(epoch), '; Score: ', num2str(storage(6,epoch))];
    act2bin(scores, upperTH, lowerTH);
    %scores
    
    epochs(pattern) = epoch;
    
    patternname
    [W1, W2, B]
    
    %% Plot
    
    %     storage rows:
    %     1. abs(error)
    %     2. abs(delta)
    %     3. incrW1
    %     4. incrW2
    %     5. incrB
    %     6. scores (1:5: summed for the epoch)
    %     7. W1 after learning the epoch
    %     8. W2 after learning the epoch
    %     9. B after learning the epoch
    
    if 1==1
        subplot(length(patternNo)/2,2,pattern)
        hold all
        plot(storage(6,:), 'g-')
        %plot(storage(1,:), 'r-')
        plot(storage(7,:), 'b-')
        plot(storage(8,:), 'b-')
        plot(storage(9,:), 'm-')
        legend({'performance', 'W1', 'W2', 'bias'}, 'Location', 'East')
        xlabel('Epochs')
        %axis([0 50 -25 25])
        %axis([0 10 -1 1])
        title(patternname)
        hold off
    end
    
    
    
    
end

filename = ['batch', num2str(batchlearning), '_perm', num2str(permute)];
%print('-dpng', [folder, filename, '.png'])
%close

epochs
storage1=storage;
sum(storage(2,:));
%[storage(6, 1500), storage(7, 1500)]

%% More plotting




