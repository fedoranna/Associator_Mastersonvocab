P.test_RT = [P.test_RT, R.completed_epochs];

%% do RT in TestAssociator

for sweep = 1:nrows(P.testingsems)
    
    input_sem = P.testingsems(sweep,:);
    input_phon = P.testingphons(sweep,:);
    target_SO = P.testingsems(sweep,:);
    target_PO = P.testingphons(sweep,:); 
    
    %Task S->S
    
    L = propagate_activation(L, W, P, 'S', input_sem);
    
    if P.recurrence == 1 | is_partof(trainedepochs, P.test_RT) == 1
        L_beforerecurrence = L;
        diffs = Inf;
        RT = 0;
        for i=1:100
            if sum(diffs) > P.asymptote_TH
                prevstate = L(3).state;
                RT = RT + 1;
                L = propagate_activation(L, W, P, 'S', prevstate + randomnoise(P.noise(1), [1, L(1).size]));
                diffs = abs(prevstate - L(3).state);
            end
        end
    
        if is_partof(trainedepochs, P.test_RT) == 1
            sorszam = which_element(trainedepochs, P.test_RT);
            R.RT_SS(sorszam, sweep) = RT;
        end
    end
end
%%

x = R.RT_SS(end,:)
hist(x)

y = [];
for i=1:nrows(R.RT_SS)
    y = [y, sum(R.RT_SS(i,:)==100)];
end

convergers_RT = x;
nonconvergers = [];
convergers = [];
for i = length(x):-1:1
    if x(i) == 10000
        convergers_RT(i) = [];
        nonconvergers = [nonconvergers, i];
    else convergers = [convergers, i];
    end
end
hist(convergers_RT)

NCaoa=[V(nonconvergers).AoA];
for i = length(NCaoa):-1:1
    if isnan(NCaoa(i))
        NCaoa(i)=[];
    end
end
mean(NCaoa) % 944
std(NCaoa) % 292
hist(NCaoa)

Caoa=[V(convergers).AoA];
for i = length(Caoa):-1:1
    if isnan(Caoa(i))
        Caoa(i)=[];
    end
end
mean(Caoa) % 902
std(Caoa) % 366
hist(Caoa)

nonconvergers
% nonconvergers =   73    41    38    35    17    12    10     2
% 75    48    40    26    16