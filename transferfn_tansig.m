%% Sigmoid transfer function
% output is squashed between -1 and +1

function output = transferfn_tansig(weightedsum, temperature)
%output = 2 ./ (1 + exp(-2 * temperature * weightedsum))-1;   % as in MatLab NNT
output = (2.0 ./ (1 + exp(-temperature * weightedsum))) - 1; % as in Oh.Lee1995