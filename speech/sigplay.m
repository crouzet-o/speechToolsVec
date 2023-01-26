function y = sigplay(sigfile,Fs);

% Plays a PCM RAW SOUND FILE at Fs Hz.
%
% USAGE : 	sigplay(sigfile,Fs);
% EXAMPLE : sigplay('sound.sig',44100)

wavplay(loadsig(sigfile),Fs);
