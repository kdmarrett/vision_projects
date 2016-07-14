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
	brightEnhance = 6;
	[x,y,z] = size(image);
	hWid = floor(pixSize / 2);
	lowX = centerX - hWid; highX = centerX + hWid;
	lowY = centerY - hWid; highY = centerY + hWid;

	% Cut patch out of image
	temp = image(lowX:highX, lowY:highY, :);
	% create higher dimensional copies for time slices
	for k = 1:length(tau)
		smoothImage(:,:,:, k) = image(:,:,:);
	end
	
	% Diffuse locally on that patch
	smoothTemp = imagedfs(temp, tau, D);
	[m,n,o,p] = size(smoothTemp);
	% trim out edges  % add energy of brightEnhance to compensate for diffusion
	trimTemp = smoothTemp(((1 + pixelTrimFactor):(m - pixelTrimFactor)), ...
	   ((1 + pixelTrimFactor):(n - pixelTrimFactor)), :, :) + brightEnhance;
	%place back into higher dimensional copies
	smoothImage((lowX + pixelTrimFactor):(highX - pixelTrimFactor), ...
		 (lowY + pixelTrimFactor):(highY - pixelTrimFactor), :, :) = trimTemp;
	
end
