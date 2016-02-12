function O = matfileanalyzator_Assoc_savetoexcel(matfile, param)

load(matfile, 'P', 'R', 'T');

where = nrows(xlsread(P.resultsfile))+1;
tosave = {
    P.ID,
    % Main results
    R.vocab_SS,
    R.vocab_PP,
    R.vocab_SP,
    R.vocab_PS,
    R.completed_epochs,
    R.completed_S_epochs,
    R.completed_P_epochs,
    R.completed_R_epochs,
    R.completed_L_epochs,
    R.runningtime_min,
    % Intervention
    P.intervention,
    P.type,
    % Seeds
    P.weightseed,
    P.semanticseed,
    P.phoneticseed,
    % Input
    P.vocabsize,
    P.performance_threshold,
    func2str(P.phoneticsgenerator),
    func2str(P.semanticsgenerator),
    P.prop,
    P.freq,
    P.Ssize,
    P.Sact,
    P.nbof_prototypes,
    P.mindistance,
    P.looseness,
    P.semdist_withinclasses,
    P.semdist_betweenclasses,
    P.Sact_avg,
    P.Psize,
    P.Pact_avg,
    % Architecture
    P.size_SH,
    P.size_PH,
    P.size_AR,
    P.size_AL,
    P.dens_SISH;
    P.dens_SHSO;
    P.dens_PIPH;
    P.dens_PHPO;
    P.dens_SHAR;
    P.dens_ARPH;
    P.dens_PHAL;
    P.dens_ALSH;
    P.usebias,
    P.biasvalue,
    % Learning
    P.trainingtype,
    P.recurrence,
    P.timeout,
    func2str(P.errorcatfn),
    P.retest,
    func2str(P.transferfn),
    func2str(P.delta),
    num2str(P.temperatures),
    num2str(P.learningrates),
    num2str(P.momentums),
    num2str(P.noise),
    num2str(P.upper_TH),
    num2str(P.lower_TH),
    func2str(P.weightinit),
    P.randmax,
    max(T.mainerrortypes(:,2))
    };

% Save summary of results to an excel file
xlswrite(P.resultsfile, tosave', 'results', ['A', num2str(where)]);
O = 1;
