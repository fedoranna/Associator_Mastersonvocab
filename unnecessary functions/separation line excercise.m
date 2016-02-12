% http://www.csc.kth.se/utbildning/kth/kurser/DD2432/ann08/delta-eng.pdf

%clear
addpath(genpath('C:\Matlab_functions'));

learningrate = 0.3;
perm = 0;
task = 'XOR'; % dist, AND, OR
%% Inputs

if strcmp(task, 'dist')
    classA(1,:) = randn(1,100) .* 0.5 + 1.0;
    classA(2,:) = randn(1,100) .* 0.5 + 0.5;
    classB(1,:) = randn(1,100) .* 0.5 - 1.0;
    classB(2,:) = randn(1,100) .* 0.5 + 0.0;
    patterns = [classA, classB];
    targets = [ones(1,ncols(classA)), ones(1,ncols(classB))-2];
end

if strcmp(task, 'AND')
    patterns = [
        1 1 0 0;
        1 0 1 0];
    targets = [
        1 0 0 0];
end

if strcmp(task, 'OR')
    patterns = [
        1 1 0 0;
        1 0 1 0];
    targets = [
        1 1 1 0];
end

if strcmp(task, 'XOR')
    patterns = [
        1 1 0 0;
        1 0 1 0];
    targets = [
        0 1 1 0];
end

%%
active = max(targets);
inactive = min(targets);

if perm == 1
    permute = randperm(ncols(patterns));
    patterns = patterns(:, permute);
    targets = targets(:, permute);
end
patterns = [patterns; ones(1,ncols(patterns))]; % bias

[insize, ndata] = size(patterns);
[outsize, ndata] = size(targets);

w = randn(1,3);
%%
for i = 1: 100
    
    outputs = transferfn_logsig(patterns' * w', 1, 0);
    
    delta = delta_logsig_withT(outputs, targets', 'output', 1, 0); %
    change = learningrate  * (patterns * delta);
    w = w+change';
    
    p = w(1,1:2);
    k = -w(1, insize) / (p*p');
    l = sqrt(p*p');
    plot (patterns(1, find(targets==active)), ...
        patterns(2, find(targets==active)), '*', ...
        patterns(1, find(targets==inactive)), ...
        patterns(2, find(targets==inactive)), '+', ...
        [p(1), p(1)]*k + [-p(2), p(2)]/l, ...
        [p(2), p(2)]*k + [p(1), -p(1)]/l, '-');
    axis ([-2, 2, -2, 2], 'square');
    drawnow;
    
    preciseness = binarizationfactor(outputs);
    answer = act2bin(outputs, 1-preciseness, preciseness);
    is_correct(targets', outputs, 1-preciseness, preciseness);
    score = sum(answer == targets');
    
    if score == ncols(patterns)
        break
    end
    
end
i

