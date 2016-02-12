function O = matfileanalyzator_performance_when(matfile, param)

load(matfile, 'T', 'P');
O = NaN;

%% For categorizator
% for i = 1:numel(T.scores)
%     if T.scores(i) > param.score
%         O = T.epoch(i);
%         break
%     end
% end

%% For Associator
for i = 1:numel(T.SP_all)
    if T.SP_all(i) > param.score
        O = i * P.test_performance;
        break
    end
end
