
%% Parameters

%felirat = [];
w = 6; % length of words (nb of phonemes per word)
f = 1; % length of phonemes (nb of features or units per phoneme)
vocabsize = 100;

%%%%%%%%%%%%% Nonchanging variables

% Word length in features or units
n = w*f;

% The maximum number of erroneous phonemes in a word so that the word is categorized as phonological error, not unrelated nonword
if floor(w/2) == w/2
    emax = w/2 - 1;
else
    emax = floor(w/2);
end

% The maximum number of erroneous units in a response with phonological error
kmax = emax*f;

%%%%%%%%%%%%%% Changing variables

errorprobs = 0.1 : 0.01 : 0.9;      
phonprobs = NaN(size(errorprobs));

hold all
for i = 1:numel(errorprobs); 
    
    p = errorprobs(i);  % p = per unit probability of error
    K = NaN(kmax, 1);
    E = ones(kmax, 1);
    
    for k = 1:kmax      % k = the nb of erroneous units in the word
        
        % The probability of k errors in the word (anywhere)
        K(k) = factorial(n) / (factorial(k) * factorial(n-k))   *   p^k   * (1-p)^(n-k);
        
        % The probability of all the errors being in e phoneme
        for e = 1:emax
            if e == 1
                E(k) = (1/w) ^ (k-1);
            end
        end
        
    end
    
    % The probability of phonological error
    phonprobs(i) = sum(K .* E);    
    
end
felirat = [felirat; {['Length of words = ', num2str(w)]}];

plot(errorprobs, phonprobs*vocabsize);
xlabel('Per unit or phoneme probability of error');
ylabel('Expected number of phonological errors');
set(legend(felirat));







