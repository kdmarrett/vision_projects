%Karl Marrett
%AMATH 482
%Homework 4 PCA
%Due Feb 26th 2015


obj = mmreader('cam1_1.mat');

vidFrames = read(obj);
numFrames = get(obj, 'numberOfFrames');

for k = 1 : numFrames
	mov(k).cdata = vidFrames(:,:,:,k);
	mov(k).colormap = [];
end

for j = 1:numFrames
	X = fram2im(mov(j));
	imshow(X); drawnow
end

break
% ARRANGE DATA
camData = 0;

dimensions = 3;
covCam = cov(camData);
[eigVec, eigVal] = eig(covCam);
[eigVec, eigVal] = eigs(covCam, dimensions);
