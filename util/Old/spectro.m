function signal = spectro(filename,Nfft,Fs);

% Computes the spectrogram of a 16 bit PCM Raw Sound File (sig file).
%
% USAGE: spectro('filename',Nfft,Fs);
% EXAMPLE: spectro('a1.sig',256,44100);
%
% Fs defaults to 16000, Nfft to 256. '.sig' is the default extension.

if nargin<1,
	error('SPECTRO takes at least one argument. Type help spectro');
end

if isempty(findstr(filename,'.')),
	filename=[filename,'.sig'];
end

if exist('Fs')==0,
	Fs=16000;
end

if exist('Nfft')==0,
	Nfft=256;
end

fid=fopen(filename,'r');
signal=fread(fid,'short');
figure;
specgram(signal,Nfft,Fs);
