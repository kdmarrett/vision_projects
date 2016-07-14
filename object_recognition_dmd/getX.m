function [X, m, n] = getX(rawInput, frames)
	% get the X matrix from video data rawInput passed
	% only take first 'frames' of video

	[m,n,l,o] = size(rawInput);
	assert(o >= frames, 'Video clip is too short for frames specified');
	temp = rawInput(:,:,:, 1:frames);
	for kk = 1:frames
		slice = rgb2gray(temp(:,:,:,kk));
		X(:,kk) = reshape(slice, m*n, 1);
	end
	X = double(X); %convert from uint8 image type to double
end
