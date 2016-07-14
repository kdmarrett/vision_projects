function [locations] = dynamicObjLoc(frames)
% Returns center locations of the major moving
% object in a frame

% Misc. Parameters
[rows,cols,~,minFrames] = size(frames);
tau=0.0005; % time of diffusion
D=0.0025; % diffusion coefficient
strength = .0004;
% square width of target paint can
pixSize = 250;
% crop image around these pixels 
cropBool = 0;
background = uint8(zeros(rows, cols));
minX = 290;
maxX = 450;
minY = 40; maxY = 450;
pausetime = 3;
thresh = 40;
binaryBool = 1;
baselineEnergy = 0;

locations = [];
for m = 2:(minFrames)
	% get gray time slice for processing
	slice = rgb2gray(frames(:,:,:,m));

	% crop around known locations of paint can
	if cropBool
		crop = background;
		crop(minX:maxX, minY:maxY) = slice(minX:maxX, minY:maxY);
	else 
		crop = slice;
	end 
	% build matrix of changed pixels
	changeFrame = uint8(crop - rgb2gray(frames(:,:,:, m -1)));
	changeFrame = changeFrame + baselineEnergy;

	% global gaussian filter
	changeFrame = imageflt(changeFrame, strength);
	tryIndex = 2;
	while (true)
		try
			lastLoc = locations(:, (m - tryIndex));
			tryIndex = tryIndex + 1;
		catch
			lastLoc = [cols / 2; rows / 2];
		end
		if (sum(lastLoc) ~= 0)
			break;
		end
	end
	% Diffuse local area of paint can 
	% if (m > 10)
	% 	imshow(changeFrame); title('before smootharea');pause(.4);
	% end
	changeFrame = smoothArea(changeFrame, lastLoc(1), lastLoc(2), ...
		pixSize, tau, D ); if binaryBool
		testafter = length(find(changeFrame) > thresh);
		if testafter
			binaryChange = im2bw(changeFrame,...
				 graythresh(changeFrame));
			% if (m > 10)
			% 	imshow(binaryChange); title('binary');pause(2)
			% end
			region = regionprops(binaryChange, 'Centroid',...
				'Area', 'PixelIdxList');
			[maxValue, index] = max([region.Area]);
			row = region(index).Centroid(1);
			col = region(index).Centroid(2);
			%centroids = cat(1, region(index).Centroid);
			%row = centroids(1, 1);
			%col = centroids(1, 2);
			%[row, col] = ind2sub(size(binaryChange), ... 
			%	mean(region(index).PixelIdxList));
			% Visualize
			% if (m > 10)
			% 	% imshow(binaryChange); 
			% 	hold on; 
			% 	temp = background;
			% 	temp(floor(row),floor(col)) = 255;
			% 	title('final decision');
			% 	plot(temp,'r.','MarkerSize',20);
			% 	pause(2);
			% 	hold off;
			% end
			% alternate
			% centroids = cat(1, region.Centroid);
			% xCentroids = centroids(:, 1);
			% yCentroids = centroids(:, 2);
			% Remove any NaN measururements
			% x = mean(xCentroids(~any(isnan(xCentroids))));
			% y = mean(yCentroids(~any(isnan(yCentroids))));
		else
			x = 0; y = 0;  % mark interpolated max later
		end
		% append locations horizontally by time slice
		locations(:, (m - 1)) = [ floor(row); floor(col) ];
	else
		% get subscript of max value
		[row,col] = ind2sub(size(changeFrame), ...
		find(changeFrame == max(max(changeFrame))));
		region = regionprops(changeFrame, 'WeightedCentroid');
		locations(:, (m - 1)) = [ row; col ];
	end	
	

	% Visualize
	% if (m > 10)
	% 	imshow(changeFrame); 
	% 	hold on; 
	% 	temp = background;
	% 	temp(locations(1, (m - 1)),locations(2, (m - 1))) = 255;
	% 	title('final decision');
	% 	plot(temp,'r.','MarkerSize',20);
	% 	pause(2);
	% 	hold off;
	% end
end

zeroCols = find(sum(locations) == 0);

for l = 1:length(zeroCols)
	try	
		locations(1, zeroCols) = (locations(1, zeroCols - 1) + ... 
			locations(1, zeroCols + 1)) /2;
		locations(2, zeroCols) = (locations(2, zeroCols - 1) + ... 
			locations(2, zeroCols + 1)) /2;
	catch
		try
			locations(1, zeroCols) = ... 
				(locations(1, zeroCols - 1)); 
			locations(2, zeroCols) = ... 
				(locations(2, zeroCols - 1)); 
		catch
			% dummy first point
			x = cols / 2;
			y = rows / 2; 
		end
	end
end

assert(length(find(sum(locations) == 0)) == 0, 'some zeros remain');
end
