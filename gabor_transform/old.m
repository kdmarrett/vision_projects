close all; clear all;
load handel
handel = y' / 2;
%k = (2*pi/L)*[0:n/2-1 -n/2:-1];
figure(1);
plot((1:length(handel))/Fs,handel);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Signal of Interest, v(n)');
saveas(1, 'HandelTimeTrace', 'eps');

% Gaussian Gabor filter
width = .22; % width of filter (s)
samples = 40; % split window samples evenly spaced
t_0 = linspace(0, L, samples);
t = (1:length(handel))/Fs; % convert to (s)
handelSpec = [];
for j = 1:length(t_0)
	g = exp(-width*(t - t_0(j)).^2);
	handelFFT = fft(g.*handel, n);
	handelPwr = abs(handelFFT(1:(n/2+1)).^2)/n;
	handelSpec = [handelSpec; handelPwr];
end

figure(2);
pcolor(t_0, f, handelSpec.'), shading interp, colormap(hot)
ylim([250 600]);
saveas(2,'GaussianGabor','eps');

% break
%%%%%%%% PART 2 %%%%%%%%%%%%%%%%%%%

figure(3);
[piano, Fs] = wavread('music1'); 
n=length(piano);
L = n/Fs;
plot((1:n)/Fs, piano);

width = .22; % width of filter (s)
samples = 40; % split window samples evenly spaced

t_0 = linspace(0, L, samples);
t = (1:n)/Fs; % convert to (s)
pianoSpec = [];
for j = 1:length(t_0)
	g = exp(-width*(t - t_0(j)).^2);
	pianoFFT = fft(g.*piano, n);
	pianoPwr = abs(pianoFFT(1:(n/2+1)).^2)/n;
	pianoSpec = [pianoSpec; pianoPwr];
end

figure(4);
f = (0:(n/2))*(Fs/n);
pcolor(t_0, f, pianoSpec.'), shading interp, colormap(hot)
ylim([250 600]);
saveas(2,'GaussianGabor','eps');

figure(5);
[recorder, Fs] = wavread('music2');
n=length(recorder);
L = n/Fs;
plot((1:n)/Fs, recorder);
width = .22; % width of filter (s)
samples = 40; % split window samples evenly spaced
t_0 = linspace(0, L, samples);
t = (1:length(handel))/Fs; % convert to (s)
handelSpec = [];
for j = 1:length(t_0)
	g = exp(-width*(t - t_0(j)).^2);
	handelFFT = fft(g.*handel, n);
	handelPwr = abs(handelFFT(1:(n/2+1)).^2)/n;
	handelSpec = [handelSpec; handelPwr];
end

figure(6);
f = (0:(n/2))*(Fs/n);
pcolor(t_0, f, handelSpec.'), shading interp, colormap(hot)
ylim([250 600]);
saveas(2,'GaussianGabor','eps');
