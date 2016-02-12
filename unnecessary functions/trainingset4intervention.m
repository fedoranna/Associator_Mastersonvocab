function P = trainingset4intervention(P, S)
    
    unknownwords = [];
    for i = 1:P.vocabsize
        if S(P.keptepochs).test_PS(i) == 0
            unknownwords = [unknownwords, i];
        end
    end
    
    P.trainingphons = NaN(length(unknownwords), ncols(P.testingphons));
    P.trainingsems = NaN(length(unknownwords), ncols(P.testingsems));
    if P.interventiontype == 0 % unchanged
        P.trainingphons = P.testingphons;
        P.trainingsems = P.testingsems;
    end
    if P.interventiontype == 1 % only hard words
        for i = 1:length(unknownwords)
            P.trainingphons(i,:) = P.testingphons(unknownwords(i), :);
            P.trainingsems(i,:) = P.testingsems(unknownwords(i), :);
        end
    end;
    if P.interventiontype == 2 % hard words twice
        for i = 1:length(unknownwords)
            P.trainingphons(i,:) = P.testingphons(unknownwords(i), :);
            P.trainingsems(i,:) = P.testingsems(unknownwords(i), :);
        end
        P.trainingphons = [P.trainingphons; P.testingphons];
        P.trainingsems = [P.trainingsems; P.testingphons];
    end;
end