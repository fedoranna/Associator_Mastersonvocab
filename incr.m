%% Calculates weight change (increment) according to Michell: Machine learning, p98.
% weightchange to be applyed to weights from innerlayer to outerlayer

function weightchange = incr(learningrate, act_innerlayer, delta_outerlayer)

weightchange = learningrate * (act_innerlayer' * delta_outerlayer);
