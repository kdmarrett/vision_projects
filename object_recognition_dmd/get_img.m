function [vid] = get_img(input, m, n)
% returns the reshaped image or video data 
% converting back to an image matrix of type uint8

[~, frames] = size(input);
for k = 1:frames
	vid(:,:,k) = uint8(reshape(input(:,k), m, n));
end
