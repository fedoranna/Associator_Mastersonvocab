%% Is the output of a network correct?

function correctness = is_correct(target, activation, upper_TH, lower_TH)

answer = act2bin(activation, upper_TH, lower_TH);

if sum(answer == target) == length(target)
    correctness = 1;
else correctness = 0;
end
