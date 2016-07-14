% Karl Marrett
% AM482
% Due: Feb 5th
% HW 2 Gabor Transforms

close all; clear all;

% set default behaviors
amp = 1;  % toggle for amplitude(1) vs. power spectrums 
bandpass = 0; % toggle bandpass fitering of gabor transforms
bpWidth = 0; bpCenter = 0; %null values 
% bpWidth = 1000; bpCenter = 440; bandpass = 1;
filterType = 'step';  %default

%%%%%%% PART 1 %%%%%%%%%%%%

%%% handel sample %%%%%%
load handel
handel = y' / 2;
sampleFactor = 1;
handel = resample(handel, 1, sampleFactor);
Fs = Fs / sampleFactor;

% Raw time trace Handel
figure(1);
plot((1:length(handel))/Fs,handel);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Signal of Interest, v(n)');
set(gcf, 'visible', 'off');
saveas(1, 'handelTimeTrace', 'png');

% Compare Windowing Width (Gaussian Gabor filter)
bpWidth = 1000; bpCenter = 440; bandpass = 1;
iterations = 4;  % trial number
width = linspace(2, 14, iterations); % width of filter (s)
samples = 100; % split window samples evenly spaced

figure(2);
for tnum = 1:iterations
	[handelSpec, f, t_0, Nyquist, windowedDF] ... 
		= gabor(handel, width(tnum), samples, amp, ...
		 bandpass, bpWidth, bpCenter, filterType, Fs);
	subplot(2,2, tnum);
	pcolor(t_0, f, handelSpec), shading interp,
	title(sprintf('Window #: %d Width: %0.2f dF: %.2f', ... 
		samples, width(tnum), windowedDF));
	xlabel('Time (seconds)');
	ylabel('Frequency (Hertz)');
	ylim([0 Nyquist]);
    ylim([0 1500]);
	xlim([0 10]);
end
set(gcf, 'visible', 'off');
saveas(2,'compareWidth','png');

% Compare Sample number of windows (Gaussian Gabor filter)
bpWidth = 1000; bpCenter = 440; bandpass = 1;
iterations = 4;  % trial number
width = 8; % width of filter (s)
% exaggerated undersampling to oversampling
samples = round(linspace(2, 200, iterations)); % split window samples evenly spaced

figure(3);
for tnum = 1:iterations
	[handelSpec, f, t_0, Nyquist, windowedDF] ... 
		=gabor(handel, width, samples(tnum), amp, ...
		 bandpass, bpWidth, bpCenter, filterType, Fs);
	subplot(2,2, tnum);
	pcolor(t_0, f, handelSpec), shading interp
	title(sprintf('Window #: %0.1f width: %0.2f', ...
		 samples(tnum), width));
	xlabel('Time (seconds)');
	ylabel('Frequency (Hertz)');
	ylim([0 Nyquist]);
	xlim([0 11]);
end
set(gcf, 'visible', 'off');
saveas(3,'compareSample','png');

% Compare Filter Type 
bpWidth = 0; bpCenter = 0; %null values 
width = 4; % width of filter (s)
iterations = 3;  % trial number
samples = 20; % split window samples evenly spaced
filters = {'gauss', 'mexi', 'step'};

figure(4);
for tnum = 1:iterations
	[handelSpec, f, t_0, Nyquist, windowedDF]=gabor(handel, width, samples, ...
		 amp, bandpass, bpWidth, bpCenter, filters{tnum}, Fs);
	subplot(1,3, tnum);
	pcolor(t_0, f, handelSpec), shading interp,
	title(sprintf('Filter Type: %s', filters{tnum}));
	xlabel('Time (seconds)');
	ylabel('Frequency (Hertz)');
	ylim([440 600]);
	xlim([0 10]);
end
saveas(4,'compareFilters','png');

%%%%%%%% PART 2 %%%%%%%%%%%%%%%%%%%

[notes, names] = getNotes();
sampleFactor = 1;

%%% PIANO %%%%%

[piano, Fs] = wavread('music1'); 
recorder = resample(piano, 1, sampleFactor);
Fs = Fs / sampleFactor;
nPiano=length(piano);
filterType = 'none';
figure(5);
plot((0:(nPiano -1))/Fs, piano);
title('Mary had a little lamb time trace (piano)');
xlabel('Time (seconds)');
xlim([1.00 1.02]);
saveas(5, 'pianoTimbre', 'png');

width = .22; % width of filter (s)
samples = 10; % split window samples evenly spaced
bandpass = 0; % toggle bandpass on 
bpWidth = 200; % width of filter 
bpCenter = 280;  % center frequency to bandpass around
[pianoSpec, fPiano, t_0, Nyquist, windowedDF]=gabor(piano, width, ... 
	samples, amp, bandpass, bpWidth, bpCenter, filterType, Fs);

figure(6);
pcolor(t_0, fPiano, pianoSpec), shading interp, colormap(hot)
xlabel('Time (seconds)');
ylabel('Frequency (Hertz)');
title('Bandpass spectogram (piano)');
xlim([0 16]);
% ylim([220 370]);
ylim([0 1000]);
saveas(6,'pianoGaborBandpass','png');
[pianoScore, pianoPitches] = getScore(pianoSpec, f, notes, names);

% break 

%%% RECORDER %%%%%

[recorder, Fs] = wavread('music2');
recorder = resample(recorder, 1, sampleFactor);
Fs = Fs / sampleFactor;
nRecorder=length(recorder);

% Raw trace
figure(7);
plot((0:(nRecorder -1))/Fs, recorder);
title('Mary had a little lamb time trace (recorder)');
xlabel('Time (seconds)');

% filterType = 'gauss';
width = .22; % width of filter (s)
samples = 10; % split window samples evenly spaced
bandpass = 1; % toggle bandpass on 
bpWidth = 400; % width of Gaussian filter in frequencies
bpCenter = 440;  % center frequency to bandpass around
[recorderSpec, fRecorder, t_0, Nyquist, windowedDF]=gabor(recorder, width, ... 
	samples, amp, bandpass, bpWidth, bpCenter, filterType, Fs);

figure(8);
pcolor(t_0, fRecorder, recorderSpec), shading interp, colormap(hot)
xlabel('Time (seconds)');
ylabel('Frequency (Hertz)');
title('Bandpass Spectogram (recorder)');
% ylim([0 Nyquist]);
xlim([0 16]);
ylim([230 630]);
saveas(8,'recorderGabor','png');
[recorderScore, recorderPitches] = getScore(recorderSpec, f, notes, names);

% compare timbre
figure(9)
subplot(1,2,1)
plot(fPiano, pianoSpec);
title('Piano timbre in the frequency domain');
ylabel('Amplitude')
xlabel('Frequency (Hz)');
xlim([0 2000]);

subplot(1,2,2)
plot(fRecorder, recorderSpec);
title('Recorder timbre in the frequency domain');
ylabel('Amplitude')
xlabel('Frequency (Hz)');
xlim([0 2000]);
saveas(9, 'compareTimbre', 'png');
