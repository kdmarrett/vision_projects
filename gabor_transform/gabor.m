function [spec, f, t_0, Nyquist, windowedDF]=gabor(soundVector, width, ... 
	samples, amp, bandpass, bpWidth, bpCenter, filterType, Fs);
	% width is scaled to seconds that the time trace will be windowed with
	% bandpass is a toggle to create a bandpass filter of the FFT at each window
	% bpwidth and bpCenter are scaled to the set of frequencies
	% bpCenter must be within the range of our single sided frequencies 'f'

	% round to next highest power of two for fft
	n = 2^nextpow2(length(soundVector));  % time points
	L = n / Fs; % length in seconds
	t_0 = linspace(0, L, samples);  
	if strcmp(filterType, 'none')
		t_0 = 1;
	end
	t = (0:(n - 1))/Fs; % time (s)
	widthSamples = width * Fs;
	windowedDF = Fs / widthSamples;  % frequency resolution after filter
	df = (Fs/n);
	Nyquist = Fs/2 - df; % max sampling frequency
	f_full = (0:(n -1))*df;
	f = f_full(1:(n/2)); % single sided
	specAmp = [];
	specPwr = [];

	% ensure soundVector length is n long
	temp = zeros(1,n);
	temp(1:length(soundVector)) = soundVector;
	soundVector = temp;

	% gaussian filter scaled to frequencies
	if bandpass
		bpFilter = stepFilter(floor(bpWidth / df), f_full, floor(bpCenter / df), 'fft', Fs);
	end

	for jj = 1:length(t_0)
		if strcmp(filterType, 'gauss')
			% gaussian filter scaled to time
			fil = gaussFilter(width, t, t_0(jj), Fs); 
		elseif strcmp(filterType, 'mexi')
			fil = mexiFilter(width, t, t_0(jj), Fs);
		elseif strcmp(filterType, 'step');
			fil = stepFilter(width, t, t_0(jj), 'time', Fs);
		elseif strcmp(filterType, 'none')
			fil = ones(1, n);
		end
		FFT = fft(fil.*soundVector, n);
		if bandpass
			FFT = FFT.*bpFilter;
		end
		doublePwr = abs(FFT(1:(n/2+1)).^2)/n;
		doubleAmp = abs(FFT(1:(n/2+1)));
		Pwr = 2 * doublePwr(1:(n/2)); % take single side double the energy to compensate
		Amp = 2 * doubleAmp(1:(n/2));
		specPwr = [specPwr; Pwr];
		specAmp = [specAmp; Amp];
	end

	if amp
		spec = specAmp.';
	else
		spec = specPwr.';
	end
end


