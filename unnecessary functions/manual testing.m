% Manipulate the weights of the Categorizator manually, and then test it

W(1).state = [
    -0.2 -0.2;
    0.5 0.5];

W(2).state = [
    0 0 -15;
    0 0 0;
    0 0 0];

%%
for sweep = 1:nrows(P.testingset)
    
    input = P.testingset(sweep, 1:2);
    target = P.testingset(sweep, 3:end);
    
    L(1).state = input;
    L(2).state = P.transferfn(L(1).state * W(1).state + randomnoise(P.noise, [1, L(2).size]), P.T); 
    L(3).state = P.transferfn(L(2).state * W(2).state + randomnoise(P.noise, [1, L(3).size]), P.T); 
    
    scores(sweep) = is_correct(target, L(3).state, P.upper_TH, P.lower_TH);
    error = error + MSE(target, L(3).state); % accumulating SSE for this epoch
    
    activationmatrix1(sweep) = L(3).state(1);
    activationmatrix2(sweep) = L(3).state(2);
    if P.size_O == 3
        activationmatrix3(sweep) = L(3).state(3);
    end
    scorematrix(sweep) = is_correct(target, L(3).state, P.upper_TH, P.lower_TH);
    errormatrix(sweep) = MSE(target, L(3).state);

end
L(3).state(2)
is_correct(target(2), L(3).state(2), P.upper_TH, P.lower_TH)




