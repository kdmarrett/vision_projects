function [fil] = gaussFilter(width, t, t_0, Fs);
	% uses a gaussian equation
	% width given in seconds
	% t time vector of n length
	% t_0 the center of the current window
	% Fs sampling frequency
	% final
	
	fil = zeros(1, length(t));
	% scale our time (second) variables to index into fil
	scaledWidth = Fs * width;
	startInd = floor(t_0*Fs - (scaledWidth / 2));
	endInd = floor(t_0*Fs + (scaledWidth / 2) - 1);
	% range is arbitrary
	temp = linspace(-5, 5, scaledWidth);
	m = exp(-(temp.^2));

	% assumes either the start or end index is over limit but not both
	% add on top of zeros filter
	if (startInd < 1)
		trimFrom = 1 + abs(startInd);
		startInd = 1;
		m = m(trimFrom:length(m));
		fil(startInd:(length(m) )) = m;
	elseif (endInd > length(t))
		% trim excess samples that fall over the index of fil
		excess = endInd - length(t);
		m = m(1:(length(m) - excess));
		fil(startInd:(startInd + length(m) - 1)) = m;
	else
		fil(startInd:(startInd + length(m) - 1)) = m;
	end
	assert(length(fil) == length(t), ...
	    sprintf('improper fil length: %d t is length: %d', length(fil), length(t)));
end
