function [stoppingreason, epochs] = StoppingreasonAssociator10(P, S, W, epoch)

stoppingreason = [];
epochs = 0;

% Did the network learn all words?
if (sum(S(epoch).test_SS) + sum(S(epoch).test_PP) + sum(S(epoch).test_SP) + sum(S(epoch).test_PS) == 4 * P.vocabsize)
    stoppingreason = 'Network learned all words.';
    epochs = epoch;
end

% Is the error small enough?
if (S(epoch).error_SO + S(epoch).error_PO) < P.error_threshold
    stoppingreason = 'Error is small enough.';
    epochs = epoch;
end

% Did weights converge?
convergence = zeros(1,length(P.weightnames));
for i=1:length(P.weightnames)
    if sum(sum(abs(W(i).change))) < P.convergence_threshold * numel(W(i).state);
        convergence(i) = 1;
    end
end
if sum(convergence) == length(P.weightnames)
    stoppingreason = 'All weights converged.';
    epochs = epoch;
end

% Did training stop because the number of epochs reached the preset number?
if epoch == P.intended_epochs
    stoppingreason = 'The number of epochs reached the preset number.';
    epochs = epoch;
end

