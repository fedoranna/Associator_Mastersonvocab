function D = trainingset4intervention_23(oldD, S, P)

    unknownwords = [];
    for i = 1:P.vocabsize
        if S(P.int_keptepochs/P.test_performance).test_SP(i) == 0
            unknownwords = [unknownwords, i];
        end
    end
    
    if P.int_interventiontype == 0 % unchanged
        D = oldD;
    end
    
    if P.int_interventiontype == 1 % only hard words
        D.testingphons = oldD.testingphons;
        D.testingsems = oldD.testingsems;
        for i = 1:length(unknownwords)
            D.trainingphons(i,:) = D.testingphons(unknownwords(i), :);
            D.trainingsems(i,:) = D.testingsems(unknownwords(i), :);
        end
    end;
    
    if P.int_interventiontype == 2 % hard words twice
        D.testingphons = oldD.testingphons;
        D.testingsems = oldD.testingsems;
        for i = 1:length(unknownwords)
            D.trainingphons(i,:) = D.testingphons(unknownwords(i), :);
            D.trainingsems(i,:) = D.testingsems(unknownwords(i), :);
        end
        D.trainingphons = [oldD.trainingphons; D.trainingphons];
        D.trainingsems = [oldD.trainingsems; D.trainingsems];
        
        neworder = randperm(nrows(D.trainingsems));
        phons = D.trainingphons;
        sems = D.trainingsems;
        for i = 1:nrows(D.trainingsems)
            D.trainingphons(i, :) = phons(neworder(i), :);
            D.trainingsems(i, :) = sems(neworder(i), :);
        end
    end;
    
end