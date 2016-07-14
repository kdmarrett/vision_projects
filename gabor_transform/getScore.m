function [score, pitches] = getScore(spec, f, notes, names) 

[~, maxIndex] = max(spec);  % get the freq index of the max at each sample
maxFreq = f(maxIndex);  % find frequency each index corresponds to
% round each maximum frequency to the frequency of a known note
pitches = roundtowardvec(maxFreq, notes, 'round');

% find the note name from the frequency
for j = 1:length(pitches)
	[ind] = find(notes == pitches(j));
	score{j} = names{ind};
end
