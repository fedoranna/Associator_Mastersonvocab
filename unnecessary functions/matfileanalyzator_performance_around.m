% averages from 9 data points

function O = matfileanalyzator_performance_around(matfile, param)

epoch = param.epoch;
load(matfile, 'T');
%%
if is_partof(T.epoch, epoch)
    sorszam = which_element(epoch, T.epoch);
    
   if numel(T.epoch) > sorszam + 3
       O = mean(T.scores((sorszam-4) : (sorszam+4)));
   else
       O = mean(T.scores((sorszam-8) : sorszam));
   end    
else
    for i = 1:numel(T.epoch)
        if T.epoch(i) > epoch
            sorszam = i;
            O = mean(T.scores((sorszam-4) : (sorszam+4)));
            'Approximate time'
            break
        end
    end
    if T.epoch(end) < epoch
        sorszam = numel(T.epoch);
        O = mean(T.scores((sorszam-8) : sorszam));
        
    end
end
T.epoch(sorszam);

