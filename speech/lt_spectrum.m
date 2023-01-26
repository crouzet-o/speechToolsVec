function [M,F] = lt_spectra(signal,N_band,Fs,output,onset,offset);

% Compute (and plot) the long-term spectrum of a signal
%
% USAGE : [Magnitude,Frequency] = lt_spectrum(signal,N_band,Fs,output,onset,offset);
%
% PARAMETERS :	signal : a Matlab matrix
%					N_band = Number of frequency bands (default: 128).
%					Fs = sampling frequency
%					output = 'none' (default) or 'graph'
%					onset, offset : as # of sample
%
% EXAMPLE : [M,F] = lt_spectra(signal,256,16000,1500,3000);


if nargin < 1,
	error('Type help lt_spectra to get USAGE');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIGNAL's Long-Term Spectrum computation (Magnitude vs. Frequency)

if exist('N_band') == 0
	N_band = 128;
end

if exist('Fs') == 0
	Fs = 44100;
end

if exist('onset') == 0
	onset = 1;
end

if exist('offset') == 0
	offset = length(signal);
end

target = signal(onset:offset);

[M,F] = spectrum(target,N_band,[],[],Fs);

if strcmp(output,'graph'),
	%stem(F,M(:,1));
	stem(F,M(:,1),'.k');
	%axis([0 1500 0 45000000]);
	title('Enveloppe Spectrale');
	xlabel('Frequence (Hz)');
	ylabel('Amplitude');
end
