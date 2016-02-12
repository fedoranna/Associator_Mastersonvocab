% Mean squared error

function error = MSE(target, activation)
error = sum((target - activation) .^2) / length(activation);