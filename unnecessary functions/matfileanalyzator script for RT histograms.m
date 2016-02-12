%% Draws a histogram from reaction times with saved weights at a certain epoch
% only uses T.RT_SP

clear all

% Parameters
folder = 'C:\Matlab_functions\RESULTS\Associator model_23\1. TD\';
filename = '2013-06-16-18-44-24';


% Run
matfile = [folder, filename, '.mat'];
load(matfile, 'L', 'W', 'P', 'T', 'D', 'R', 'Q')
%%
when = 0; % 0 if last saved, -1 if one before the last, etc.
threshold = 10^(-15); % asymptote threshold
W = Q(end-when).weights;
P.asymptote_TH = threshold;
RT_SP = NaN(1,100);

for sweep = 1:nrows(D.testingsems)
    
    input_sem = D.testingsems(sweep,:);
    input_phon = D.testingphons(sweep,:);
    target_SO = D.testingsems(sweep,:);
    target_PO = D.testingphons(sweep,:);
    
    L = ActivateAssociator22(L, W, P, 'R', input_sem);
    
    L_beforerecurrence = L;
    diffs = Inf;
    RT = 0;
    for i=1:P.timeout
        if sum(diffs) > P.asymptote_TH
            prevstate = L(6).state;
            RT = RT + 1;
            L = ActivateAssociator22(L, W, P, 'P', prevstate + randomnoise(P.noise(2), [1, L(4).size]));
            diffs = abs(prevstate - L(6).state);
            %sum(diffs);
        end
    end
    
    RT_SP(1, sweep) = RT;
    
end

[min(RT_SP), max(RT_SP)];
Q(end-when).epoch
hist(RT_SP, 1:100)

