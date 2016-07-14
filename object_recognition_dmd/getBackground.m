function [bkd, ind] = getBackground(omega)
	%returns the background mode 
	% chooses mode with value closest to 0,0
	[bkd, ind] = min(abs(real(omega)));
end
