%% Transforms the activation of a unit to 1/0

function output = act2bin(act, upper_threshold, lower_threshold)

output = NaN(size(act));

for i=1:numel(act)
    
    if act(i) >= upper_threshold
        output(i) = 1;
    end
    if act(i) <= lower_threshold
        output(i) = 0;
    end
    
end
