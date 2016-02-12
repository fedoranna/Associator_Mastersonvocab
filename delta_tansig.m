% Calculate delta according to Oh.Lee1995

function D = delta_tansig(act, DorT, weights)

if nargin<3

    % act = activation of outputlayer
    % DorT = target of outputlayer
    
    D = ((1-act) .* (1+act)) /2  .* (DorT-act);
    
else
    
    % act = activation of hidden layer
    % DorT = delta of outer layer
    % weights = weights from hidden layer to outerlayer
    
    D = ((1-act) .* (1+act)) /2 .* (DorT * weights');
    
end