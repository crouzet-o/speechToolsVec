function [signal,Fs] = loadsig(filename,Fs);

% Loads a 16 bit PCM Raw Sound File (sig file) into the workspace.
%
% USAGE: loadsig('filename',Fs);
% EXAMPLE: loadsig('a1.sig',44100);
%
% Fs defaults to 16000. '.sig' is the default extension.

if nargin<1,
	error('LOADSIG takes at least one argument. Type help loadsig');
end

if isempty(findstr(filename,'.')),
	filename=[filename,'.sig'];
end

if exist('Fs')==0,
	Fs=16000;
end

fid=fopen(filename,'r');
signal=fread(fid,'short');

%max=length(signal);
%t=1:max;
%plot(t/Fs,signal);
