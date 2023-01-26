function [y,t] = synth_sin(freq,depth,dur,fs,minima);

% Synthesize a sinewave
%
%											Relationship between amp and min!!!
% Synthesize a sinusoidal sound with:
%
%		frequency:			freq (in Hz)
%		modulation depth:	depth (between 0 and 2) -> depth = 2 => amp = 1
%		duration:			dur (in ms)
%		sampling freq.:		fs (in Hz).
%		minimum valu:		minima (ex. 0)
%		
% USAGE: synth_sin(freq,amp,dur,Fs);
%
% EXAMPLE: synth_sin(440,.5,1000,44100);
%
% Fs defaults to 16000.

%		amplitude:			amp (between 0 and 1)

if nargin<3,
	error('SYNTH_SIN takes at least 3 arguments. Type help synth_sin');
end

if exist('fs')==0,
	fs=16000;
end

%t = (0:1/fs:(dur-1)/fs)'; % # of samples
t = (0:1/fs:dur/1000)'; % time in ms 

y = (depth/2)*sin(2*pi*freq*t);

if exist('minima') ~= 0,
	y = y+(minima-min(y));
end

%plot(t/fs,y);
