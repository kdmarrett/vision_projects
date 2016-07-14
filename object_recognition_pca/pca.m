function [eigVec, eigVal, energy] = pca(input, rank)
%pca(input [, rank])} function written for this assignment for 
%taking the Principal Component Analysis of video data it can also
%return the PCA of only the first RANK vectors of the data


covMatrix = cov(input);
[eigVec, eigVal] = eig(covMatrix);

totalVar = sum(diag(eigVal));
[eigVec, eigVal] = eigs(covMatrix, rank);
eigVal = diag(eigVal);
newVar = sum((eigVal));
% percent of variance still retained
% with new rank
energy = newVar / totalVar;


