function dfs = dfsODE(t, u, ~, L, D)
	% handle for ODE function of diffusion
	dfs = D*L*u;
end