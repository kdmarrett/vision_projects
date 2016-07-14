function [filImage] = imageflt(image, strength)
	% Takes a uint8 2 or 3 dimensional matrix and
	% an int strength (which parameterizes the width
	% of the filter in the spectral domain) and applies
	% gaussian filtering in the 2nd dimension
	% returning the filtered uint8 matrix back

	[x,y,z]=size(image);
	kx = 1:x; ky = 1:y;
	[Kx, Ky] = meshgrid(kx,ky);
	centerx = ceil(x/2);
	centery = ceil(y/2);
	% transposed Gaussian filter
	fil = (exp(-strength*(Kx - centerx).^2 - strength*(Ky - centery).^2))';
	for k=1:z
		imageFFT = fftshift(fft2(double(image(:,:,k))));
		temp = imageFFT.*fil;
		filImage(:, :, k) = uint8(abs(ifft2(ifftshift(temp))));
	end

end

