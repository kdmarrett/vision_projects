function [r] = getR(original, constructed)
	% return the difference between the two matrices

	[m,n] = size(constructed);
	[o,p] = size(original);

	for k = 1:n
		temp = double(original(:,k)) - double(constructed(:,k));
	end

	r = sum(sum(temp));
end

