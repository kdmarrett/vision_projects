function [u_dmd, u_modes, bkd, phi, omega, mu, sigma, fgd_u_dmd, bkd_u_dmd, r_dmd] = ...
	dmd(X,dt,frames, features, predict);
	% return DMD of matrix X

	% boolean flag to subtract by modes or by final image
	byModes = 0;
	%create subsets
	% where X2 = AX1
	X1 = X(:,1:(end-1));
	X2 = X(:,2:end);
	%decompose the X1 matrix
	[u,sigma,v] = svd(X1,'econ');

	%build s (similarity matrix)
	s = u(:,1:features)'*X2*v(:,1:features) ...
		*diag(1./diag(sigma(:,1:features)));
	%find the eigen decomposition of s
	[ev, d] = eig(s);
	mu = diag(d); % eigen values of s matrix
	omega = log(mu)/(dt);
	% phi computes DMD modes to predict future state of system
	phi = u*ev;
	% save on memory
	clear v
	clear u
	% return the background mode and it's index
	[bkd, bkdInd] = getBackground(omega);
	y_0 = phi\X(:,1);
	fgd_omega = omega; fgd_omega(bkdInd) = [];
	bkd_omega = omega(bkdInd);
	bkd_y0 = y_0(bkdInd);
	fgd_y0 = y_0; fgd_y0(bkdInd) = [];
	bkd_phi = phi(:, bkdInd);
	fgd_phi = phi; fgd_phi(:, bkdInd) = [];
	for iter=1:frames
		% sum all modes to produce reconstruct
		u_modes(:, iter) = (y_0.*exp(omega*(dt*iter)));
		% sum all non-background modes to produce foreground reconstruct
		bkd_u_modes(:, iter) = (bkd_y0.*exp(bkd_omega*(dt*iter)));
		fgd_u_modes(:, iter) = (fgd_y0.*exp(fgd_omega*(dt*iter)));
		if (byModes)
			fgd_u_modes(:, iter) = fgd_u_modes(:, iter) - ...
				bkd_u_modes(:, iter);
		end
	end
	% save on memory
	u_dmd = uint8(phi*u_modes); 
	% fprintf('phi');
	% size(phi)
	% fprintf('umodes');
	% size(u_modes)

	% fprintf('bkdphi');
	% size(bkd_phi)
	% fprintf('bkdmodes');
	% size(bkd_u_modes)

	% fprintf('fphi');
	% size(fgd_phi)
	% fprintf('fumodes');
	% size(fgd_u_modes)

	bkd_u_dmd = uint8(bkd_phi*bkd_u_modes); % background 
	fgd_u_dmd = uint8(fgd_phi*fgd_u_modes);% foreground  
	if (~byModes)
		[row, col, fr] = size(fgd_u_dmd);
		r_dmd = zeros(1, fr);
		% subtract background from foreground
		for kk= 1:fr
			r_dmd(kk) = sum(u_dmd(:,kk) - (fgd_u_dmd(:,kk) + bkd_u_dmd(:,kk)));
			fgd_u_dmd(:,kk) = fgd_u_dmd(:,kk) - bkd_u_dmd(:,kk);
		end
	end

end
