function [dat, mincols] = getSpec(threeDirs, clipNum, printProcessing, ...
	oldmincols)
%ensure mincols accross different trials

clipLen = 3; % seconds
sampleFactor = 1;

filterType = 'gauss';
bandpass = 0;
bpWidth = 0; bpCenter = 0;
amp = 1;
width = 2000;
samples = 5;

previousNum = 9999;
for k = 1:length(threeDirs)
	cd (threeDirs{k}); % go to specified dir for song count
	filelist = dir('*.wav');
	cd ..;  % return to main dir
	songNum = length(filelist);
	previousNum = min([songNum, previousNum]);
	cols = 0;
	dat.(threeDirs{k}) = [];
	for song = 1:previousNum;
		if printProcessing
			fprintf(strcat('Processing song:\t',...
					filelist(song).name, '...\n'));
		end
		cd (threeDirs{k}); % go to specified dir for song
		[temp, fs] = wavread(filelist(song).name);
		cd ..;  % return to main dir
		% average both channels
		temp = mean(temp,2); % average two channels
		vec = temp;
		vec = resample(temp, 1, sampleFactor);
		clear temp;
		fs = fs / sampleFactor;
		len = length(vec); 
		% compute last possible clipping location in samples
		last = floor(len - 1.5 * (clipLen * fs)); 
		% store trainTrials random valid indexes to get clip from
		rnc = randi([1, last],1, clipNum); 
		for l = 1:clipNum
			soundVector = trimSoundVector(vec, fs, clipLen, rnc(l),1,1);
			windowLength = floor(length(soundVector) / samples);
			noverlap = floor(.6 * windowLength);
			[spec, f, t] = spectrogram(soundVector, windowLength,...
				noverlap, 'onesided', fs);
			% one col per trial
			spec = abs(spec);
			specCol = reshape(spec, prod(size(spec)), 1);
			% stack each by col
			dat.(threeDirs{k}) = [ dat.(threeDirs{k}), specCol ];
			cols = cols + 1;
		end
	end
	assert((cols == (previousNum * clipNum)), 'cols does not match');
end
mincols = previousNum * clipNum;
end
