% Author: Karl Marrett
% HW1 AMATH 482
% DUE: Jan 22

clear all; close all; clc;
load Testdata;  %loads Undata 
[row,col]=size(Undata);
slices = 20;
L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1); x=x2(1:n); y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1];
ks=fftshift(k);

% visualize k/ks space
figure(1)
subplot(2,1,1);
plot(1:length(k), k, 'k+');
xlabel('Fourier mode index');
ylabel('Fourier mode value');
title('Plot of nonshifted frequency modes (k)', 'fontsize', 70);
subplot(2,1,2);
plot(1:length(ks), ks, 'k-');
xlabel('Fourier mode index');
ylabel('Fourier mode value');
title('Plot of shifted frequency modes sdf(ks)', 'fontsize', 70);
saveas(1,'kPlot', 'png');
combinedFreq = zeros(n, n, n);

% create grids
[X, Y, Z] = meshgrid(x, y, z);
[Kx,Ky,Kz]=meshgrid(k,k,k); 

for j=1:slices % each time point
	raw(:, :, :, j)=reshape(Undata(j,:),n,n,n);
	% n-dim fft for each time slice
	rawFFT(:, :, :, j) = fftn(raw(:, :, :, j)); 
	 % sum FFT for each slice
	combinedFreq = combinedFreq + rawFFT(:, :, :, j);
end

sumFreq = abs(combinedFreq);
% max over all three dims
[maxVal, linearIndex] = max(sumFreq(:));
 % get index of max
[Kx_0, Ky_0, Kz_0] = ind2sub(size(sumFreq), linearIndex);
maxFreqModes = k([Kx_0, Ky_0 Kz_0]) % get value of max
normFreq = sumFreq/maxVal;  % normalize all values to 1 

% Visualize signature frequency
[Kxs,Kys,Kzs]=meshgrid(ks,ks,ks); % for plotting in shifted space
% iterate over some values for isosurface
% thresh = linspace(.5, .93, 6);
% for j = 1 : length(thresh)
%     pause(3); close all;
%     isosurface(Kxs, Kys, Kzs, fftshift(normFreq), thresh(j))
%     title(strcat('value: ', int2str(thresh(j))));
%     axis([-5 5 -5 5 -5 5]), grid on, rotate3d, drawnow
% end

figure(2)
isosurface(Kxs, Kys, Kzs, fftshift(normFreq),.62, 'k+'); 
axis([-5 5 -5 5 -5 5]), grid on, rotate3d, drawnow
title('Averaged frequency spectrum');
xlabel('Shifted k modes (x) axis');
ylabel('Shifted k modes (y) axis');
zlabel('Shifted k modes (z) axis');
saveas(2,'freqCluster', 'png');

% build a meshgrid gaussian filter
bandwidth = 1;
% centered at max frequency components
meshFilter = exp(-bandwidth * ((Kx-Kx(Kx_0, Ky_0, Kz_0)).^2 + ...
	(Ky-Ky(Kx_0, Ky_0, Kz_0)).^2 + (Kz-Kz(Kx_0, Ky_0, Kz_0)).^2));
	
% Filter out unwanted frequencies and recreate volume data
for j = 1:slices
	filteredFFT(:, :, :, j) = rawFFT(:, :, :, j) .* meshFilter ;
	%recreate in volume space must be positive
	filtered(:, :, :, j) = abs(ifftn(filteredFFT(:, :, :, j)));
	slice = filtered(:, :, :, j);
	% max of volume data gives marble location
	[M, linearIndex] = max(slice(:));
	% convert to matrix subscripts
	meshCoords = ind2sub(size(slice), linearIndex);
	marbleX(j) = X(meshCoords);
	marbleY(j) = Y(meshCoords);
	marbleZ(j) = Z(meshCoords);
end

figure(3);
plot3(marbleX, marbleY, marbleZ, 'Linewidth', 2);
rotate3d, grid on, axis tight
title('Marble spatial location'); xlabel('x axis'); ylabel('y axis');
zlabel('z axis');
saveas(3,'trajectory', 'png');

% find location at time index 
timeIndex = 20;
marbleLocation = [marbleX(timeIndex) marbleY(timeIndex) marbleZ(timeIndex)];
