function [fil] = stepFilter(width, t, t_0, sType, Fs);
	% width given in seconds
	% t time vector of n length
	% t_0 the center of the current window
	% Fs sampling frequency
	%  final
	fil = zeros(1, length(t));
	if strcmp(sType, 'time')
		scaledWidth = Fs*width;
		startInd = floor(t_0*Fs - (scaledWidth / 2));
		endInd = floor(t_0*Fs + (scaledWidth / 2) - 1);
	elseif strcmp(sType, 'fft')
		startInd = floor(t_0 - (width / 2));
		endInd = floor(t_0 + (width / 2) - 1);
	else
		sprintf('Error in type passed to stepFilter');
	end

	if (startInd < 1)
		startInd = 1;
	end
	if (endInd > length(t))
		endInd = length(t);
	end
	fil(startInd:endInd) = 1;
	assert(length(fil) == length(t), ...
	    sprintf('improper fil length: %d t is length: %d', length(fil), length(t)));
end
