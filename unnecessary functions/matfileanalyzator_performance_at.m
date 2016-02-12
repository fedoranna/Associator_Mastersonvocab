function O = matfileanalyzator_performance_at(matfile, param)

epoch = param.epoch;
load(matfile, 'T');
%%
if is_partof(T.epoch, epoch)
    sorszam = which_element(epoch, T.epoch);
    O = T.scores(sorszam);
else
    for i = 1:numel(T.epoch)
        if T.epoch(i) > epoch
            sorszam = i;
            O = T.scores(sorszam);
            'Approximate time'
            break
        end
    end
    if T.epoch(end) < epoch
        sorszam = numel(T.epoch);
        O = T.scores(sorszam);
        
    end
end
T.epoch(sorszam);

