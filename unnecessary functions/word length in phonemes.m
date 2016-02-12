%% Word length in phonemes
% copied from scoring template / data for logistic regression

L = [4, 7, 9, 6, 3, 4, 9, 7, 3, 7, 5, 6, 8, 7, 5, 4, 4, 5, 7, 7, 5, 2 ,5 ,7, 5, 5, 5, 5, 4, 9, 6, 6, 5, 5, 4, 9 ,8, 7, 6, 6, 7, 2, 7, 7, 7, 5, 3, 5, 5, 4, 2, 7, 5, 4, 5, 4, 6, 8, 8, 6, 4, 4, 6, 3, 6, 6, 5, 3, 4, 7, 3];

[min(L), max(L)]
[mean(L), median(L)]
hist(L, min(L):max(L))