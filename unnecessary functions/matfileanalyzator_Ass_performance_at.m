function O = matfileanalyzator_Ass_performance_at(matfile, param)

epoch = param.epoch;
load(matfile, 'T', 'P');
%%

which = epoch/P.test_performance;
O = T.SP_all(which);

