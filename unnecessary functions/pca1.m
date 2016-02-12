% This first version follows Section 5 (of above tutorial) by examining the covariance of the data set.
% http://www.cs.stevens.edu/~mordohai/classes/cs559_s09/PCA_in_MATLAB.pdf

function [signals,PC,V] = pca1(data)
% PCA1: Perform PCA using covariance.
% data - MxN matrix of input data (M dimensions, N trials)
% signals - MxN matrix of projected data = scores
% PC - each column is a PC = coeff
% V - Mx1 matrix of variances

[M,N] = size(data);
mn = mean(data,2); % subtract off the mean for each dimension
data = data - repmat(mn,1,N);

covariance = 1 / (N-1) * data * data'; % calculate the covariance matrix
[PC, ME] = eig(covariance); % find the eigenvectors (PC) and matrix of eigenvalues (ME); covariance*PC = PC*ME
V = diag(ME); % extract diagonal of matrix as vector: these are the eigenvalues

[junk, rindices] = sort(V, 'descend'); % sort the variances in decreasing order
V = V(rindices);
PC = PC(:,rindices);

signals = PC' * data; % project the original data set