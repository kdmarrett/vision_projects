%Karl Marrett
%AMATH 482
%Homework 5 SVD
%Due March 12th 2015
%SVDScript.m

close all; clear all;

trials = 50;
clipNum = 1;
trainingFraction = .50;
features = 10;

createFigures = 1;
% printing bools
songProcessing = 0; 
printProcessing = 1;

% directories of music for each part
parts{1} = {'violin', 'neonindian', 'vitalic'};
parts{2} = {'sonicyouth', 'yolatengo', 'pixies'};
parts{3} = {'greg', 'shoegaze', 'RnB'};

mincols = 9999; % dummy value
for part = 1:length(parts)
	for i = 1:trials
		% three directories with which to classify contained wav files
		rng('shuffle');
		threeDirs = parts{part};
		[dat, mincols] = getSpec(threeDirs, clipNum, songProcessing, ...
			mincols);

		% Arrange data
		D = [];
		for k = 1:length(threeDirs)
			% concatenate categories horizontally 
			%mincols
			D = [D, dat.(threeDirs{k})(:, 1:mincols)];
		end

		% square V to be small direction not huge direction
		[u,s,v] = svd(D, 0); % reduced svd

		trainTrials = round(trainingFraction * mincols);
		testTrials = mincols - trainTrials;
		[accuracyP(i), classP ] =... 
			classifySVD(u, s, v, trainTrials, ...  
			testTrials, mincols, threeDirs, features);
	end

	if createFigures
		figure
		%set(gcf, 'visible','off');
		bar(classP);
		title(strcat('Classification Results: Part ', int2str(part)));
		xlabel('Clip to classify');
		ylabel('Decision variable');
		%saveas(gcf, strcat('part', int2str(part), 'class'),'png');

		figure
		%set(gcf, 'visible','off');
		plot(diag(s), 'ko');
		title(strcat('Singular Values: Part ', int2str(part)));
		xlabel('Number of features');
		ylabel('Value of feature');
		%saveas(gcf, strcat('part', int2str(part), 'sig'),'png');
	end

	if printProcessing
		fprintf('Success at Part %d\n', part);
		fprintf('Training trials = %d\n', trainTrials);
		fprintf('Testing trials = %d\n', testTrials);
		fprintf('Accuracy using projected vectors %0.2f\n', mean(accuracyP));
	end
end
