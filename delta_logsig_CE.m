% Calculate delta according to Oh.Lee1995, cross-entropy

function D = delta_logsig_CE(act, DorT, weights)

if nargin<3

    % act = activation of outputlayer
    % DorT = target of outputlayer
    
    D = DorT-act;
    
else
    
    % act = activation of hidden layer
    % DorT = delta of outer layer
    % weights = weights from hidden layer to outerlayer
    
    D = act .* (1-act) .* (DorT * weights');
    %D = DorT * weights'; WRONG!
    
end

