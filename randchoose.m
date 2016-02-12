%% Randomly chooses k samples from the population without replacement

% same as randsample in Statistics Toolbox
% population: vector containing anything
% k must be = < numel(population)
% if k=numel(population), then it is a random permutation of the elements of the population

%%
function chosen = randchoose(population, k)

neworder = randperm(length(population));
rearranged = population;
for i = 1:length(population)
    rearranged(i) = population(neworder(i));
end
chosen = rearranged(1:k);