%% How correct is the output?

function error = how_correct(target, activation)

error = sum(abs(target-activation));

end
