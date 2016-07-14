function [dfsImage] = imagedfs(image, tau, D)
	% Takes a uint8 2 or 3 dimensional matrix and
	% an int strength (which parameterizes the width
	% of the filter in the spectral domain) and applies
	% gaussian filtering in the 2nd dimension
	% returning the filtered uint8 matrix back

	[x,y,z]=size(image);
	L = buildL(x,y);
	for k=1:z
		% convert to double place in vector form
		u = reshape(double(image(:,:,k)), x*y, 1);
		% evolve through diffusion/heat equation
		[t, usol] = ode113('dfsODE', tau, u, [], L, D);
		% place back into dfs image
		for l = 1:length(tau);
			% create an extra dimension l for each tau value
			dfsImage(:, :, k, l) = uint8(reshape(usol(l,:),x,y));
		end
	end
	
end

