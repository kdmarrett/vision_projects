close all; clear all

strength = .0005;
strengths = [.1 .01 .001 .0001];

% load dereks
num = 4;
for j=1:num
	name{j} = strcat('derek',int2str(j));
	im.raw{j} = imread(name{j}, 'jpg');
end

% Filter first (two) image(s) with gaussian
% low pass filter globally
for j=1:1
	im.Flt{j} = imageflt(im.raw{j}, strength);
end

% color
figure(1)
% set(gcf, 'visible', 'off');
imshow(im.Flt{1}, []);
title('Color-Image Derek1 Linearly Filtered Globally');
saveas(1,'derek1F','png')

break 
strengths = [.1 .01 .001 .0001];
% b/w
figure(2)
% set(gcf, 'visible', 'off');
for j = 1:length(strengths)
	subplot(2,2,j);
	im.Flt2{j} = imageflt(im.raw{2}, strengths(j));
	imshow(im.Flt2{j});
	title(sprintf('Linearly Filtered strength: %0.4f', strengths(j)));
end
saveas(2,'derek2F','png');

% Diffuse first im globally
tau=[0 0.006 0.1 1]; % time of diffusion
D=0.0005; % diffusion coefficient

for j=1:1
	im.Dfs{j} = imagedfs(im.raw{j}, tau, D);
end

% color
figure(3)
% set(gcf, 'visible', 'off');
for j=1:length(tau)
	subplot(2,2,j);
	imshow(im.Dfs{1}(:,:,:,j));
	title(sprintf('Image Diffused D = %0.4f, t = %0.3f', D, tau(j)));
end
saveas(3,'derek1D','png');

% b/w
% figure(4)
% set(gcf, 'visible', 'off');
% for j = 1:length(tau)
% 	subplot(2,2,j);
% 	imshow(im.Dfs{2}(:,:,:, j));
% 	drawnow; pause(3);
% 	% saveas(2,'derek2D','png');
% end

%%%%%%%%% Part II local diffusion %%%%%%%%%%%

tau=[0 0.002 0.004 1]; % time of diffusion
D=0.0025; % diffusion coefficient

% center pixel no. of rash location 
% estimated with gimp
centery = 172;
centerx = 150;
% square width of affected region
pixSize = 34;

% Diffuse local area of rash for last two images
for j=1:2
	im.dfsL{j} = smoothArea(im.raw{j + 2}, ...
		 centerx, centery, pixSize, tau, D);
end

figure(5)
subplot(2,2,1)
imshow(im.raw{3})
title('Original color image of Derek with rash')
subplot(2,2,3)
imshow(im.raw{4})
title('Original bw image of Derek with rash')

%color retouched
subplot(2,2,2)
imshow(im.dfsL{1}(:,:,:,length(tau)));
title('Color image with local diffusion')

% b/w
subplot(2,2,4)
imshow(im.dfsL{2}(:,:,:,length(tau)));
title('BW image with local diffusion')
saveas(5,'derekLD','png');
