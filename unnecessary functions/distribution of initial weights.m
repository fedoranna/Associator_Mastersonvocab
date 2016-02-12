% Distribution of initial weights
%% old simulations

mini=0;
maxi=0.1;
weights = mini + (maxi-mini).*rand(1,1000000);
sum(weights<0.0001)

bins = -1:0.01:1; 
hist(weights,bins)

%% randn folder

mini=-0.05;
maxi=0.05;
weights = mini + (maxi-mini).*randn(1,1000000);
sum(weights<0.0001)

bins = -1:0.01:1;
hist(weights,bins)

%% new simulations

mini=-0.05;
maxi=0.05;
weights = mini + (maxi-mini).*rand(1,1000000);
sum(weights<0.0001)

bins = -1:0.01:1; 
hist(weights,bins)

%% Themis

weights = 0.05 .* randn(1,1000000);
sum(weights<0.0001)

bins = -3:0.01:3; 
hist(weights,bins)


