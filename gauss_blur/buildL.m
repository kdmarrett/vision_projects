function [L] = buildL(nx, ny)
	% Build the L operator for diffusion
	% equation of 2-d matrix
	% return L

	x=linspace(0,1,nx); 
	y=linspace(0,1,ny); 
	dx=x(2)-x(1); 
	dy=y(2)-y(1);
	ones_x=ones(nx,1); 
	ones_y=ones(ny,1);
	Dx=(spdiags([ones_x -2*ones_x ones_x],[-1 0 1],nx,nx))/dx^2;
	Dy=(spdiags([ones_y -2*ones_y ones_y],[-1 0 1],ny,ny))/dy^2;
	Iy=eye(ny);  % identity matrix of size ny
	Ix=eye(nx);
	L=kron(Iy,Dx)+kron(Dy,Ix);
end
