% Resizes matfiles by deleting or adding parts of/to variable S and T

function o = matfileanalyzator_resize(matfile, param)

resize=param.resize;
x=matfile;
load(matfile)

% if P.test_performance < resize && gcd(resize, P.test_performance) == resize
%     P.test_performance = resize;
%     for i = numel(S): -1: 1
%         if gcd(resize, S(i).epoch) == resize
%             % keep it
%         else
%             S(i) = [];
%             T.epoch(i) = [];
%             T.scores(i) = [];
%             T.error(i) = [];            
%         end
%     end
%     R.testedepochs = numel(T.scores);
%     save(x, 'L', 'P', 'Q', 'R', 'S', 'T', 'W', '-v7.3');
%     o = 'Size reduced'
% end
% 
% if P.test_performance < resize && gcd(resize, S(1).epoch) ~= resize
%     o = 'Size should be reduced by retesting, but this function cannot do that yet'
% end
% 
% if P.test_performance > resize 
%     o = 'Size should be increased by retesting, but this function cannot do that yet'
% end   
% 
% if P.test_performance == resize 
%     o = 'Size was already as requested'
% end 

%% Just for special cases where size of T and S are not equal

% o=1;
% for i = 1:numel(S)
%     T.epoch(i) = S(i).epoch;
%     T.scores(i) = sum(S(i).scores);
%     T.error(i) = S(i).error;
% end
% P.test_performance = resize;
R.testedepochs = length(T.scores);
save(x, 'L', 'P', 'Q', 'R', 'S', 'T', 'W', '-v7.3');

o=[T.epoch(1), S(1).epoch, P.test_performance, R.testedepochs]





