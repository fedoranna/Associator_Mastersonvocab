% What is the smallest factor with which the activation can be binarized?
% activation: a matrix or a number
% factor: always a single number

function factor = binarizationfactor(activation)

exact = NaN(size(activation)); % the exact factor for each element
for i = 1:numel(activation)
    if activation(i) < 0.5
        exact(i) = activation(i);
    else
        exact(i) = 1-activation(i);
    end
end

% factor = 0; % the rounded highest factor
% while sum(exact<factor) < numel(activation)
%     factor = factor + 0.1;
% end

factor = max(exact);