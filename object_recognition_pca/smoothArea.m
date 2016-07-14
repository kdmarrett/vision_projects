function [smoothImage] = smoothArea(image, ...
	centerX, centerY, pixSize, tau, D)
% Takes a uint8 matrix image, center pixel
% location in x y coordinates and a pixel size
% of a local area of an image to clean
% Takes doubles tau and diffusion constant D
% for diffusion filtering
% cleans the specific area of the image and 
% returns the new matrix in unint8 format 

pixelTrimFactor = 5;
brightEnhance = 2;
[x,y,z] = size(image);
hWid = floor(pixSize / 2);
centerX = floor(centerX);
centerY = floor(centerY);
% must be ints:
lowX = centerX - hWid ;
highX = centerX + hWid;
lowY = centerY - hWid;
highY = centerY + hWid;

% handle bleed over
if lowX < 1
	bleedunderx = lowX - 1;
	lowX = 1;
	% fprintf('Warning: area under index');
end
if lowY < 1
	bleedundery = lowX - 1;
	lowY = 1;
	% fprintf('Warning: area under index');
end
if highX > x
	bleedoverx = highX - x;
	highX = x;
	% fprintf('Warning: area over index');
end
if highY > y
	bleedovery = highY - y;
	highY = y;
	% fprintf('Warning: area over index');
end
xspan = highX - lowX;
yspan = highY - lowY;

if ((highX < 10)  && (highY < 10))

	% Cut patch out of image
	temp = image(lowX:highX, lowY:highY, :);
	% create higher dimensional copies for time slices
	for k = 1:length(tau)
		smoothImage(:,:,:, k) = image(:,:,:);
	end

	% Diffuse locally on that patch
	smoothTemp = imagedfs(temp, tau, D);
	[m,n,o,p] = size(smoothTemp);
	% trim out edges  
	% add energy of brightEnhance to compensate for diffusion
	trimTemp = smoothTemp(((1 + pixelTrimFactor): ... 
		(m - pixelTrimFactor)), ((1 + pixelTrimFactor):(n - ...  
		pixelTrimFactor)), :, :) + brightEnhance;
	%place back into higher dimensional copies
	finalLowX = (lowX + pixelTrimFactor);
	finalLowY = (lowY + pixelTrimFactor);
	xspan = xspan - 2* pixelTrimFactor;
	yspan = yspan - 2* pixelTrimFactor;
	smoothImage(finalLowX :(finalLowX + xspan), ...
	 finalLowY:(finalLowY + yspan), :, :) = trimTemp;
	% old version
	% smoothImage((lowX + pixelTrimFactor):(highX - pixelTrimFactor), ...
	% (lowY + pixelTrimFactor):(highY - pixelTrimFactor), :, :) = trimTemp;
else
	smoothImage = image;
end

end
