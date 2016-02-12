function A = age(E, K)

% !!! Only works if intervention = 2*more training on one type of training!!!
% A = Number of full training cycles (training epochs of each type (SS, PP,
% SP, PS, intervention):)
% K = kept epochs (number of epochs before intervention started),
% E = number of all epochs (including normal learning and therapy)

if K==0
    A = E/4;
else
    A = K/4 + (E-K)/5;
end

