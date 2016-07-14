%Karl Marrett
%AMATH 482
%Homework 4 PCA
%Due Feb 26th 2015

close all; clear all;

cams = 3; % tot 3
caseno = 1; % tot 4
framesAnalyzed = 225;
minFrames = framesAnalyzed + 1;
smoothSpan = .1;

% LOAD/ARRANGE DATA
% files named by camera recorded from '_' case number
for k = 1 : caseno
	case_specifier = strcat('case', int2str(k));
	camData.(case_specifier) = [];
	for l = 1 : cams 
		file_specifier = strcat(int2str(l), '_', int2str(k));
		name = strcat('cam', file_specifier, '.mat');
		vid = load(name);
		frameField = strcat('vidFrames', file_specifier);
		% ensure constant number of frames
		vidDat = vid.(frameField)(:,:,:, 1:(minFrames));
		% [a,b,c,frames] = size(vidDat);
		% assert(frames == minFrames, 'Mismatched frame numbers');
		
		% Get x;y pixel location of moving objection
		locations = dynamicObjLoc(vidDat);
		% locations = smooth(locations(1, :), locations(2, :), 'rloess');
		% save data stacking cameras vertically
		camData.(case_specifier) = ...   
			[camData.(case_specifier); locations];
	end

% colorscheme = {'bo', 'ro', 'go'};
% for k = 1: cams
% figure(k)
% 	plot(1:length(camData.case4(1*k,:)), camData.case4(2*k,:), ...
% 		colorscheme{k});
% 	title(strcat('Case 4 ', 'Camera: ', int2str(k)));
% saveas(gcf, strcat('case4cam', int2str(k)), 'png');
% end


% plot(camData.case1(1, :), camData.case1(2, :), 'ro');
% plot(1:length(camData.case1(1,:)), camData.case1(1,:), 'bo');

% figure(1)
% subplot(2,2,1)
% % red
% imshow(camData.case1(:,:,1,1));
% subplot(2,2,2)
% % green
% imshow(camData.case1(:,:,1,1));
% subplot(2,2,3)
% % blue
% imshow(camData.case1(:,:,1,1));
% subplot(2,2,4)
% % grayed
% imshow(rgb2gray(camData.case1(:,:,:,1)));
% saveas(1, 'colors', 'png');

[eigVec, eigVal, energy] = pca(camData.(case_specifier), 1);
energy
figure(k)
%bar(eigVal/sum(eigVal));
%title(strcat('Eigen Values for Case ', int2str(k)));
%saveas(k, strcat('eigvals', int2str(k), 'full'), 'png');

end
