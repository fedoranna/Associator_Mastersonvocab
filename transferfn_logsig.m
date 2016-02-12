%% Sigmoid transfer function
% as logsig in NNT
% output is squashed between 0 and +1
% if temperature=1 this is commonly called "sigmoid"

function output = transferfn_logsig(weightedsum, temperature, offset)

if nargin < 2, temperature = 1.0; end
if nargin < 3, offset = 0.0; end

output = 1.0 ./ (1 + exp(-temperature * weightedsum + offset));

%output = 2.0 ./ (1 + exp(weightedsum)) - 1;
