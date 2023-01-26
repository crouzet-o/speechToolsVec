function [y,t] = mknoise(dur,fs);

% Synthesize white noise
%
%		duration:			dur (in ms)
%		sampling freq.:	fs (in Hz).
%		
% USAGE: mknoise(dur,fs);
%
% EXAMPLE: mknoise(1000,44100);
%
% Fs defaults to 16000.

if nargin<1,
	error('SYNTH_SIN takes at least 3 arguments. Type help synth_sin');
end

if exist('fs')==0,
	fs=16000;
end

t = (0:1/fs:(dur-1)/fs)'; % # of samples

rand('state',sum(clock));
y = (.8.*(2*rand(1,dur)-1))';

%plot(t/fs,y);
