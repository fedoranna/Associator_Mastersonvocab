function phonemelevel = phoneme_categories_4bit(activation, targetword, usedphonemes)
% usedphonemes = P.usedphonemes;


%% Categorize the output according to phonemes separately
% What is the uncertainty level of the phoneme?
% After binarization is it a legal phoneme?
% If yes, is it in the target word?
% If yes, is it at the right place?

phonemelevel = NaN(3, 4);
for i = 1:3 % for each phoneme in the word
    output = frameslider(activation, 19, i);
    uncertainty = binarizationfactor(output);
    
    answer = round(output);        
    if length(which_row(usedphonemes, answer)) > 0
        legality = 1;
    else legality = 0;
    end
    
    presence = 0;
    for j = 1:3
        if sum(answer == frameslider(targetword, 19, j)) == 19
            presence = presence +1;
        end
    end
    
    if sum(answer == frameslider(targetword, 19, i)) == 19
        location = 1;
    else location = 0;
    end    
    
    phonemelevel(i,1) = uncertainty; % certain: 0.1, uncertain: 0.2, 0.3, nophoneme: 0.4, 0.5
    phonemelevel(i,2) = legality;    % 1/0; is the answer a legal phoneme present in the trainingset?
    phonemelevel(i,3) = presence;    % 0, 1, 2, 3; How many times does the answer present in the targetword?
    phonemelevel(i,4) = location;    % 0/1; Is the location of the phoneme right within the word?    
end
    