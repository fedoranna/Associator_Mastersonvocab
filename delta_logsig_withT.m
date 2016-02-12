% Calculates delta according to Themis's code
% 2nd option is from http://www.csc.kth.se/utbildning/kth/kurser/DD2432/ann08/delta-eng.pdf
% ONLY FOR SIGMOID TRANSFER FUNCTIONS!!! 

% act = activation, i.e., transerfn(weighted sum)
% DorT = delta or target
% weights = weights or 'output'
% temperature = slope of sigmoid
% offset = middle of sigmoid

% the derivative of the sigmoid transferfunction is f*(1-f), i.e. act .* (1-act)
% delta = derivative * error * weights

function D = delta_logsig_withT(act, DorT, weights, temperature, offset)

if nargin < 4, temperature = 1.0; end
if nargin < 5, offset = 0.0; end

if ischar(weights) % for output layer

    % act = activation of outputlayer
    % DorT = target of outputlayer
   
    D = temperature * (act .* (1-act) + offset) .* (DorT-act); % offset was 0, temperature 1
    %D = (act - DorT) .* ((1 + act) .* (1 - act)) * 0.5;
    
else % for all other layers
    
    % act = activation of hidden layer
    % DorT = delta of outer layer
    % weights = weights from hidden layer to outerlayer
    
    D = temperature * (act .* (1-act) + offset) .* (DorT * weights');
    %D = (weights' * DorT) .* ((1 + act) .* (1 - act)) * 0.5;              
    
end


