function [accuracyP, classP ] = classifySVD(u, s, v, ...
	trainTrials, testTrials, mincols, threeDirs, features);

group = ones(trainTrials, 1);
group = [group; 2*group; 3*group];
temp = ones(testTrials, 1);
trueComparison = [ temp; 2*temp; 3*temp ];
trainM = [];
trainP = [];
testM = [];
testP = [];

featuresProj = 1:features; % modes to use
featuresMode = 1:features; % modes to use
weighted = s*v';
v = weighted';
startInd = 1;

% for each type get the corresponding components in u or v
% concatenate all types
for k = 1:length(threeDirs)
	% by projection vectors
	projections.(threeDirs{k}) = v(startInd:(startInd + mincols - 1), ...
		featuresProj);
	% of those components choose a subset for training
	trainP = [trainP; projections.(threeDirs{k})(1:trainTrials, :)]; 
	% use the rest for testing
	testP = [testP; ...
		projections.(threeDirs{k})(((trainTrials + 1):end), :)];

	% '' by mode vectors
	modes.(threeDirs{k}) = u(startInd:(startInd + mincols - 1), ...
		featuresMode);
	trainM = [trainM; projections.(threeDirs{k})(1:trainTrials, :)]; 
	testM = [testM; ...
		projections.(threeDirs{k})((trainTrials + 1):end, :)]; 

	startInd= startInd + mincols;
end

% % verify
% [m,n] = size(testP);
% assert(m == (length(featuresProj) * length(threeDirs)), 'improper test trials');
% [m,n] = size(testM);
% assert(m == (length(featuresMode) * length(threeDirs)), 'improper test trials');
% [m,n] = size(trainP);
% assert(m == (length(featuresProj) * length(threeDirs)), 'improper train trials');
% [m,n] = size(trainM);
% assert(m == (length(featuresMode) * length(threeDirs)), 'improper train trials');

% must have the same cols, rows are the trials
% classify by projections
[classP, errP] = classify(testP, trainP, group);
% classify by modes 
[classM, errM] = classify(testM, trainM, group);

% cross validation 
accuracyP = length(find(classP == trueComparison)) / trainTrials;
accuracyM = length(find(classM == trueComparison)) / trainTrials;
