function [notes, names] = getNotes()
	% returns a vector of frequencies of all pitches
	% across specified octaves and a corresponding 
	% list of names for each of those notes
	% Together they are used as a dictionary
	% for finding the score of a sound sample

oct = [55 110 220 440 880];
octName = {'A' 'Bb' 'B' 'C' 'Db' 'D' 'Eb' 'E' 'F' 'Gb'}; %encode by note name

for j = 1:length(oct)
	for k = 1:length(octName)
	    notes(k + (j - 1)*length(octName)) = oct(j).*2^((k - 1)/12);
	    if (k > 3)
		    names{k + (j - 1)*length(octName)} = strcat(octName{k}, int2str(j + 1));
		else
		    names{k + (j - 1)*length(octName)} = strcat(octName{k}, int2str(j));
		end
	end
end
