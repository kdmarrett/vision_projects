% Karl Marrett
% Dynamic Mode Decomposition for separating objects in video

close all;
addpath inexact_alm_rpca/
% don't reload mats each run
clearvars -except hand butterfly paint;
if (~exist('hand', 'var'))
	load hand.mat;
end
if (~exist('butterfly', 'var'))
	load butterfly.mat;
end
if (~exist('paint', 'var'))
	load paint.mat;
end

% names of raw video data
raw = {'hand', 'butterfly', 'paint'};
dat.hand = hand;
dat.butterfly = butterfly;
dat.paint = paint;

frm_rate = 30;
dt = 1 / frm_rate; %define timestep
frames = 100; % maximum frames to process
lambda = 0.0012;
predict = 1; % factor to predict future data given dmd modes
features = frames - 1; % rank/features of dmd
%[A_hat E_hat iter] = inexact_alm_rpca(D, lambda, tol, maxIter)

for k = 3:3 %(length(raw) - 1)
	runName = raw{k};
	[X, m, n] = getX(dat.(raw{k}), frames);
	%where u_dmd is your foreground dmd approximation
	% bkd_u_dmd is background
	tic
	[u_dmd, u_modes, bkd, phi, omega, mu, sigma, fgd_u_dmd,...
		bkd_u_dmd, r_dmd_fgdbkd] = dmd(X, dt, frames, features, predict);
	toc
	tic
	[A_hat, E_hat, iter] = inexact_alm_rpca(X, lambda);
	toc
	pca_reconstruct = A_hat + E_hat;
	[r_pca] = getR(X, pca_reconstruct);
	fprintf('Total R error of RPCA approx: %d', r_pca);
	[r_dmd] = getR(X, u_dmd);
	fprintf('Total R error of DMD approx: %d', r_dmd);

	% visualize
	runStart = (k - 1)*3;
	figure(runStart + 1)
	set(gcf, 'visible', 'off');
	plot(diag(sigma), 'ko','Linewidth', [2]);
	title(strcat({'Data from '}, runName,': Sigmas'));
	saveas(runStart + 1, strcat(runName, 'sig'), 'png');

	figure(runStart + 2)
	set(gcf, 'visible', 'off');
	plot(mu, 'ko','Linewidth', [2]);
	title(strcat({'Data from '}, runName,': Mu values'));
	saveas(runStart + 2, strcat(runName, 'mu'), 'png');

	figure(runStart + 3)
	set(gcf, 'visible', 'off');
	plot(omega, 'ko','Linewidth', [2]);
	title(strcat({'Data from '}, runName,': Omega Modes'));
	saveas(runStart + 3, strcat(runName, 'omega'), 'png');

	vid_reconstruct = get_img(u_dmd, m, n);
	vid_foreground = get_img(fgd_u_dmd, m, n);
	img_background = get_img(bkd_u_dmd, m, n);
	vid_pca_a = get_img(A_hat, m,n);
	vid_pca_e = get_img(E_hat, m,n);
	
	frameNo = 50;
	figure(runStart + 4)
	set(gcf, 'visible', 'off');
	imshow(img_background(:,:,frameNo));
	title(strcat({'Data from '}, runName,': Background Image Recovered'));
	saveas(runStart + 4, strcat(runName, 'bkd'), 'png');

	figure(runStart + 5)
	set(gcf, 'visible', 'off');
	imshow(vid_foreground(:,:,frameNo));
	title(strcat({'Data from '}, runName,': a foreground image'));
	saveas(runStart + 5, strcat(runName, 'fgd'), 'png');

	figure(runStart + 6)
	set(gcf, 'visible', 'off');
	imshow(vid_reconstruct(:,:,frameNo));
	title(strcat({'Data from '}, runName,': a fully reconstructed image'));
	saveas(runStart + 6, strcat(runName, 'full'), 'png');

	figure(runStart + 7)
	set(gcf, 'visible', 'off');
	imshow(vid_pca_a(:,:,frameNo));
	title(strcat({'Data from '}, runName,': rPCA A_Hat image'));
	saveas(runStart + 7, strcat(runName, 'ahat', int2str(lambda*10000)), 'png');

	figure(runStart + 8)
	set(gcf, 'visible', 'off');
	imshow(vid_pca_e(:,:,frameNo));
	title(strcat({'Data from '}, runName,': rPCA E_Hat image'));
	saveas(runStart + 8, strcat(runName, 'ehat', int2str(lambda*10000)), 'png');
end

