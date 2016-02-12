% Calculates delta according to Michell: Machine learning, p98.
% ONLY FOR SIGMOID TRANSFER FUNCTIONS!!! 

% act = activation, i.e., transerfn(weighted sum)
% the derivative of the sigmoid transferfunction is f*(1-f), i.e. act .* (1-act)
% delta = derivative * error * weights

function D = delta_logsig(act, DorT, weights)

if nargin<3 % for output layer

    % act = activation of outputlayer
    % DorT = target of outputlayer
    
    D = act .* (1-act) .* (DorT-act);    
    %D = temperature * (act .* (1-act) + offset) .* (DorT-act); % offset was 0, temperature 1
    %D = (act - DorT) .* ((1 + act) .* (1 - act)) * 0.5;
    
else % for all other layers
    
    % act = activation of hidden layer
    % DorT = delta of outer layer
    % weights = weights from hidden layer to outerlayer
    
    D = act .* (1-act) .* (DorT * weights');    
    %D = (temperature * (act .* (1-act) + offset)) .* (DorT * weights');
    %D = (weights' * DorT) .* ((1 + act) .* (1 - act)) * 0.5;              
    
end

% 2nd option is from Themis's code: this is the same if temperature=1 and offset=0
% 3rd option is from http://www.csc.kth.se/utbildning/kth/kurser/DD2432/ann08/delta-eng.pdf
