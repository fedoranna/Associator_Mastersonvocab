function x = matfileanalyzator_distanceofprototypes(matfile, param)

load(matfile, 'P')

%%
distance = [];
for i = 1:P.nbof_prototypes
        for j = (i+1):P.nbof_prototypes
            distance = [distance, Eucledian_distance(P.prototypes(i,:), P.prototypes(j,:))];
        end
end
x = mean(distance);


