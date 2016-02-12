% This second version follows Section 6 computing PCA through SVD.
% http://www.cs.stevens.edu/~mordohai/classes/cs559_s09/PCA_in_MATLAB.pdf

function [signals,PC,V] = pca2(data)
% PCA2: Perform PCA using SVD.
% data - MxN matrix of input data (M dimensions, N trials)
% signals - MxN matrix of projected data
% PC - each column is a PC
% V - Mx1 matrix of variances

[M,N] = size(data);
mn = mean(data,2); % subtract off the mean for each dimension
data = data - repmat(mn,1,N);

Y = data' / sqrt(N-1); % construct the matrix Y

[u,S,PC] = svd(Y); % SVD does it all

S = diag(S); % calculate the variances
V = S .* S;

signals = PC' * data; % project the original data